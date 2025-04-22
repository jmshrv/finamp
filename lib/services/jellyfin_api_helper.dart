import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:chopper/chopper.dart';
import 'package:finamp/components/global_snackbar.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

import '../models/finamp_models.dart';
import '../models/jellyfin_models.dart';
import 'downloads_service.dart';
import 'downloads_service_backend.dart';
import 'finamp_settings_helper.dart';
import 'finamp_user_helper.dart';
import 'jellyfin_api.dart' as jellyfin_api;

class JellyfinApiHelper {
  final jellyfinApi = jellyfin_api.JellyfinApi.create(true);
  final _jellyfinApiHelperLogger = Logger("JellyfinApiHelper");

  // Stores the ids of the artists that the user selected to mix
  List<BaseItemDto> selectedMixArtists = [];

  // Stores the ids of albums that the user selected to mix
  List<BaseItemDto> selectedMixAlbums = [];

  // Stores the ids of genres that the user selected to mix
  List<BaseItemDto> selectedMixGenres = [];

  Uri? baseUrlTemp;

  final String defaultFields = jellyfin_api.defaultFields;

  final _finampUserHelper = GetIt.instance<FinampUserHelper>();

  JellyfinApiHelper() {
    ReceivePort startupPort = ReceivePort();
    var rootToken = RootIsolateToken.instance!;
    Isolate.spawn(
        _processRequestsBackground, (startupPort.sendPort, rootToken));
    Future.sync(() async {
      _workerIsolatePort = await startupPort.first as SendPort?;
    });
  }

  SendPort? _workerIsolatePort;

  /// This should only be run in a worker isolate
  /// Sets up singletons and listens for work.
  static Future<void> _processRequestsBackground(
      (SendPort, RootIsolateToken) input) async {
    BackgroundIsolateBinaryMessenger.ensureInitialized(input.$2);
    ReceivePort requestPort = ReceivePort();
    input.$1.send(requestPort.sendPort);
    final dir = (Platform.isAndroid || Platform.isIOS)
        ? await getApplicationDocumentsDirectory()
        : await getApplicationSupportDirectory();
    final isar = await Isar.open(
      [DownloadItemSchema, IsarTaskDataSchema, FinampUserSchema],
      directory: dir.path,
      name: isarDatabaseName,
    );
    GetIt.instance.registerSingleton(isar);
    GetIt.instance.registerSingleton(FinampUserHelper());
    // TODO get logging working in background isolate
    await GetIt.instance<FinampUserHelper>().setAuthHeader();
    jellyfin_api.JellyfinApi backgroundApi =
        jellyfin_api.JellyfinApi.create(false);
    await for (var request in requestPort) {
      var (func, outputPort) = request as (
        Future<dynamic> Function(jellyfin_api.JellyfinApi),
        SendPort
      );
      try {
        var output = await func(backgroundApi);
        outputPort.send(output);
      } catch (e) {
        outputPort.send(e);
      }
    }
  }

  /// Runs the given function in a background isolate, supplying a valid API instance.
  Future<T> runInIsolate<T>(
      Future<T> Function(jellyfin_api.JellyfinApi) func) async {
    if (_workerIsolatePort == null) {
      return func(jellyfinApi);
    }
    ReceivePort port = ReceivePort();
    try {
      _workerIsolatePort!.send((func, port.sendPort));
    } catch (e) {
      GlobalSnackbar.error(e);
    }
    dynamic output = await port.first;
    if (output is T) {
      return output;
    }
    GlobalSnackbar.error(output);
    throw output as Object;
  }

  Future<List<BaseItemDto>?> getItems({
    BaseItemDto? parentItem,
    String? includeItemTypes,
    String? sortBy,
    String? sortOrder,
    String? searchTerm,
    List<BaseItemId>? itemIds,
    String? filters,
    String? fields,
    bool? recursive,
    ArtistType? artistType,
    BaseItemDto? genreFilter,
    bool? isFavorite,

    /// The record index to start at. All items with a lower index will be
    /// dropped from the results.
    int? startIndex,

    /// The maximum number of records to return.
    int? limit,
  }) async {
    final response = await _fetchGetItemsResponse(
      parentItem: parentItem,
      includeItemTypes: includeItemTypes,
      sortBy: sortBy,
      sortOrder: sortOrder,
      searchTerm: searchTerm,
      itemIds: itemIds,
      filters: filters,
      fields:fields,
      recursive: recursive,
      artistType: artistType,
      genreFilter: genreFilter,
      isFavorite: isFavorite,
      startIndex: startIndex,
      limit: limit,
    );
    return QueryResult_BaseItemDto.fromJson(response as Map<String, dynamic>)
      .items;
  }

  Future<QueryResult_BaseItemDto> getItemsWithTotalRecordCount({
    BaseItemDto? parentItem,
    String? includeItemTypes,
    String? sortBy,
    String? sortOrder,
    String? searchTerm,
    List<BaseItemId>? itemIds,
    String? filters,
    String? fields,
    bool? recursive,
    ArtistType? artistType,
    BaseItemDto? genreFilter,
    bool? isFavorite,
    int? startIndex,
    int? limit,
  }) async {
    final response = await _fetchGetItemsResponse(
      parentItem: parentItem,
      includeItemTypes: includeItemTypes,
      sortBy: sortBy,
      sortOrder: sortOrder,
      searchTerm: searchTerm,
      itemIds: itemIds,
      filters: filters,
      fields: fields,
      recursive: recursive,
      artistType: artistType,
      genreFilter: genreFilter,
      isFavorite: isFavorite,
      startIndex: startIndex,
      limit: limit,
    );
    return QueryResult_BaseItemDto.fromJson(response as Map<String, dynamic>);
  }

  Future<dynamic> _fetchGetItemsResponse ({
    BaseItemDto? parentItem,
    String? includeItemTypes,
    String? sortBy,
    String? sortOrder,
    String? searchTerm,
    List<BaseItemId>? itemIds,
    String? filters,
    String? fields,
    bool? recursive,
    ArtistType? artistType,
    BaseItemDto? genreFilter,
    bool? isFavorite,
    int? startIndex,
    int? limit,
  }) async {
    final currentUserId = _finampUserHelper.currentUser?.id;
    if (currentUserId == null) {
      // When logging out, this request causes errors since currentUser is
      // required sometimes. We just return an fake api response that is empty,
      // since this error usually happens because the listeners on MusicScreenTabView
      // update milliseconds before the page is popped.
      // This shouldn't happen in normal use.
      return {
        'startIndex': 0,
        'totalRecordCount': 0,
        'items': [],
      };
    }
    assert(!FinampSettingsHelper.finampSettings.isOffline);
    assert(itemIds == null || parentItem == null);
    fields ??=
        defaultFields; // explicitly set the default fields, if we pass `null` to [JellyfinAPI.getItems] it will **not** apply the default fields, since the argument *is* provided.
    recursive ??= true;

    if (parentItem != null) {
      _jellyfinApiHelperLogger.fine("Getting children of ${parentItem.name}");
    } else if (itemIds != null) {
      _jellyfinApiHelperLogger.fine("Getting items with ids $itemIds");
    } else {
      _jellyfinApiHelperLogger.fine("Getting items.");
    }

    return runInIsolate((api) async {
      dynamic response;

      // We send a different request for playlists so that we get them back in the
      // right order. Doing this in the same function makes sense since they both
      // return the same thing. It also means we can easily share album widgets
      // with playlists.
      if (parentItem?.type == "Playlist") {
        response = await api.getPlaylistItems(
          playlistId: parentItem!.id,
          userId: currentUserId,
          parentId: parentItem.id,
          includeItemTypes: includeItemTypes,
          recursive: recursive,
          fields: fields,
        );
      } else if (includeItemTypes == "MusicArtist") {
        // For artists, we need to use different endpoints
        if (artistType == ArtistType.albumartist) {
          // Album Artists
          response = await api.getAlbumArtists(
            parentId: parentItem?.id,
            recursive: recursive,
            sortBy: sortBy,
            sortOrder: sortOrder,
            searchTerm: searchTerm,
            filters: filters,
            genreIds: genreFilter?.id.raw,
            startIndex: startIndex,
            limit: limit,
            userId: currentUserId,
            fields: fields,
            isFavorite: isFavorite,
          );
        } else {
          //artistType == ArtistType.artist
          // Performing Artists
          response = await api.getArtists(
            parentId: parentItem?.id,
            sortBy: sortBy,
            sortOrder: sortOrder,
            searchTerm: searchTerm,
            filters: filters,
            genreIds: genreFilter?.id.raw,
            startIndex: startIndex,
            limit: limit,
            fields: fields,
            isFavorite: isFavorite,
          );
        }
      } else if (parentItem?.type == "MusicArtist") {
        // For getting the children of artists, we need to use
        // artistIDs or albumArtistIds instead of parentId
        if (artistType == ArtistType.albumartist || artistType == null) {
          // Albums of Album Artists
          response = await api.getItems(
            userId: currentUserId,
            albumArtistIds: parentItem?.id.raw,
            includeItemTypes: includeItemTypes,
            recursive: recursive,
            sortBy: sortBy,
            sortOrder: sortOrder,
            searchTerm: searchTerm,
            filters: filters,
            genreIds: genreFilter?.id.raw,
            startIndex: startIndex,
            limit: limit,
            fields: fields,
            isFavorite: isFavorite,
          );
        } else {
          //artistType == ArtistType.artist
          // Performing Artists
          response = await api.getItems(
            userId: currentUserId,
            artistIds: parentItem?.id.raw,
            includeItemTypes: includeItemTypes,
            recursive: recursive,
            sortBy: sortBy,
            sortOrder: sortOrder,
            searchTerm: searchTerm,
            filters: filters,
            genreIds: genreFilter?.id.raw,
            startIndex: startIndex,
            limit: limit,
            fields: fields,
            isFavorite: isFavorite,
          );
        }
      } else if (includeItemTypes == "MusicGenre") {
        response = await api.getGenres(
          parentId: parentItem?.id,
          // includeItemTypes: includeItemTypes,
          searchTerm: searchTerm,
          startIndex: startIndex,
          limit: limit,
          fields: fields,
        );
      } else if (parentItem?.type == "MusicGenre") {
        response = await api.getItems(
          userId: currentUserId,
          genreIds: parentItem?.id.raw,
          includeItemTypes: includeItemTypes,
          recursive: recursive,
          sortBy: sortBy,
          sortOrder: sortOrder,
          searchTerm: searchTerm,
          filters: filters,
          startIndex: startIndex,
          limit: limit,
          fields: fields,
          isFavorite: isFavorite,
        );
      } else {
        // This will be run when getting albums, tracks in albums, and stuff like
        // that.
        response = await api.getItems(
          userId: currentUserId,
          parentId: parentItem?.id,
          includeItemTypes: includeItemTypes,
          recursive: recursive,
          sortBy: sortBy,
          sortOrder: sortOrder,
          searchTerm: searchTerm,
          filters: filters,
          genreIds: genreFilter?.id.raw,
          startIndex: startIndex,
          limit: limit,
          ids: itemIds?.join(","),
          fields: fields,
          isFavorite: isFavorite,
        );
      }
      return response;
    });
  }

  Future<List<BaseItemDto>?> getArtists({
    BaseItemDto? parentItem,
    String? sortBy,
    String? sortOrder,
    String? searchTerm,
    String? filters,
    String? fields,

    /// The record index to start at. All items with a lower index will be
    /// dropped from the results.
    int? startIndex,

    /// The maximum number of records to return.
    int? limit,
  }) async {
    final currentUserId = _finampUserHelper.currentUser?.id;
    if (currentUserId == null) {
      // When logging out, this request causes errors since currentUser is
      // required sometimes. We just return an empty list since this error
      // usually happens because the listeners on MusicScreenTabView update
      // milliseconds before the page is popped. This shouldn't happen in normal
      // use.
      return [];
    }
    assert(!FinampSettingsHelper.finampSettings.isOffline);
    fields ??=
        defaultFields; // explicitly set the default fields, if we pass `null` to [JellyfinAPI.getItems] it will **not** apply the default fields, since the argument *is* provided.

    if (parentItem != null) {
      _jellyfinApiHelperLogger
          .fine("Getting artists which are children of ${parentItem.name}");
    } else {
      _jellyfinApiHelperLogger.fine("Getting artists.");
    }

    return runInIsolate((api) async {
      dynamic response;

      response = await api.getArtists(
        parentId: parentItem?.id,
        searchTerm: searchTerm,
        fields: fields,
        sortBy: sortBy,
        sortOrder: sortOrder,
        filters: filters,
        startIndex: startIndex,
        limit: limit,
      );

      return QueryResult_BaseItemDto.fromJson(response as Map<String, dynamic>)
          .items;
    });
  }

  Future<dynamic> deleteItem(BaseItemId itemId) async {
    return await jellyfinApi.deleteItem(itemId);
  }

  Future<List<BaseItemDto>?> getLatestItems({
    BaseItemDto? parentItem,
    String? includeItemTypes,
    int? limit,
    String? fields,
  }) async {
    assert(!FinampSettingsHelper.finampSettings.isOffline);

    fields ??= defaultFields;

    var response = await jellyfinApi.getLatestItems(
      userId: _finampUserHelper.currentUser!.id,
      parentId: parentItem?.id,
      includeItemTypes: includeItemTypes,
      limit: limit,
      fields: fields,
    );

    return (response as List<dynamic>)
        .map((e) => BaseItemDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Fetch the public server info from the server.
  /// Can be used to check if the server is online / the URL is correct.
  Future<PublicSystemInfoResult?> loadServerPublicInfo() async {
    // Some users won't have a password.
    if (baseUrlTemp == null) {
      return null;
    }

    var response = await jellyfinApi.getPublicServerInfo();

    PublicSystemInfoResult publicSystemInfoResult =
        PublicSystemInfoResult.fromJson(response as Map<String, dynamic>);

    return publicSystemInfoResult;
  }

  /// Fetch the public server info from a given URL.
  /// Can be used to check if the server is online / the URL is correct.
  /// Since we're potentially looking multiple servers, while the user is entering another base URL, we use a custom http client for this request.
  Future<PublicSystemInfoResult?> loadCustomServerPublicInfo(
      Uri customServerUrl) async {
    final requestUrl = customServerUrl.replace(path: "/System/Info/Public");
    final httpClient = ChopperClient()
        .httpClient; // http? where we're going, we don't need http
    final response = await httpClient.get(requestUrl);
    final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      PublicSystemInfoResult publicSystemInfoResult =
          PublicSystemInfoResult.fromJson(responseJson);

      return publicSystemInfoResult;
    } else {
      return Future.error(response);
    }
  }

  /// Fetch all public users from the server.
  Future<PublicUsersResponse> loadPublicUsers() async {
    // Some users won't have a password.
    if (baseUrlTemp == null) {
      return PublicUsersResponse(users: []);
    }

    var response = await jellyfinApi.getPublicUsers();

    PublicUsersResponse publicUsersResult = PublicUsersResponse(
      users: (response as List<dynamic>)
          .map((userJson) => UserDto.fromJson(userJson as Map<String, dynamic>))
          .toList(),
    );

    return publicUsersResult;
  }

  /// Check if server has Quick Connect enabled.
  Future<bool> checkQuickConnect() async {
    var response = await jellyfinApi.getQuickConnectState();
    return response as bool;
  }

  /// Initiate a Quick Connect request.
  Future<QuickConnectState> initiateQuickConnect() async {
    var response = await jellyfinApi.initiateQuickConnect();

    QuickConnectState quickConnectState =
        QuickConnectState.fromJson(response as Map<String, dynamic>);

    return quickConnectState;
  }

  /// Update the Quick Connect state.
  Future<QuickConnectState?> updateQuickConnect(
      QuickConnectState quickConnectState) async {
    var response = await jellyfinApi.updateQuickConnect(
        secret: quickConnectState.secret ?? "");

    QuickConnectState newQuickConnectState =
        QuickConnectState.fromJson(response as Map<String, dynamic>);

    return newQuickConnectState;
  }

  /// Authenticates a user using Quick Connect and saves the login details
  Future<void> authenticateWithQuickConnect(
      QuickConnectState quickConnectState) async {
    var response = await jellyfinApi.authenticateWithQuickConnect(
        {"Secret": quickConnectState.secret ?? ""});

    AuthenticationResult newUserAuthenticationResult =
        AuthenticationResult.fromJson(response as Map<String, dynamic>);

    FinampUser newUser = FinampUser(
      id: newUserAuthenticationResult.user!.id,
      baseUrl: baseUrlTemp!.toString(),
      accessToken: newUserAuthenticationResult.accessToken!,
      serverId: newUserAuthenticationResult.serverId!,
      views: {},
    );

    await _finampUserHelper.saveUser(newUser);
  }

  /// Authenticates a user and saves the login details
  Future<void> authenticateViaName({
    required String username,
    String? password,
  }) async {
    dynamic response;

    // Some users won't have a password.
    if (password == null) {
      response = await jellyfinApi.authenticateViaName({"Username": username});
    } else {
      response = await jellyfinApi
          .authenticateViaName({"Username": username, "Pw": password});
    }

    AuthenticationResult newUserAuthenticationResult =
        AuthenticationResult.fromJson(response as Map<String, dynamic>);

    FinampUser newUser = FinampUser(
      id: newUserAuthenticationResult.user!.id,
      baseUrl: baseUrlTemp!.toString(),
      accessToken: newUserAuthenticationResult.accessToken!,
      serverId: newUserAuthenticationResult.serverId!,
      views: {},
    );

    await _finampUserHelper.saveUser(newUser);
  }

  /// Gets all the user's views.
  Future<List<BaseItemDto>> getViews() async {
    var response =
        await jellyfinApi.getViews(_finampUserHelper.currentUser!.id);

    return QueryResult_BaseItemDto.fromJson(response as Map<String, dynamic>)
        .items!;
  }

  /// Gets the playback info for an item, such as format and bitrate. Usually, I'd require a BaseItemDto as an argument
  /// but since this will be run inside of [MusicPlayerBackgroundTask], I've just set the raw id as an argument.
  Future<List<MediaSourceInfo>?> getPlaybackInfo(BaseItemId itemId) async {
    assert(!FinampSettingsHelper.finampSettings.isOffline);
    var response = await jellyfinApi.getPlaybackInfo(
      id: itemId,
      userId: _finampUserHelper.currentUser!.id,
    );

    // getPlaybackInfo returns a PlaybackInfoResponse. We only need the List<MediaSourceInfo> in it so we convert it here and
    // return that List<MediaSourceInfo>.
    final PlaybackInfoResponse decodedResponse =
        PlaybackInfoResponse.fromJson(response as Map<String, dynamic>);
    return decodedResponse.mediaSources;
  }

  /// Starts an instant mix using the data from the item provided.
  Future<List<BaseItemDto>?> getInstantMix(BaseItemDto? parentItem) async {
    var response = await jellyfinApi.getInstantMix(
        id: parentItem!.id,
        userId: _finampUserHelper.currentUser!.id,
        limit: 200);

    return (QueryResult_BaseItemDto.fromJson(response as Map<String, dynamic>)
        .items);
  }

  /// Updates capabilities for this client.
  Future<void> updateCapabilities(ClientCapabilities capabilities) async {
    await jellyfinApi.updateCapabilities(
      playableMediaTypes: capabilities.playableMediaTypes?.join(",") ?? "",
      supportedCommands: capabilities.supportedCommands?.join(",") ?? "",
      supportsMediaControl: capabilities.supportsMediaControl ?? false,
      supportsPersistentIdentifier:
          capabilities.supportsPersistentIdentifier ?? false,
    );
  }

  /// Updates capabilities for this client.
  Future<void> updateCapabilitiesFull(ClientCapabilities capabilities) async {
    await jellyfinApi.updateCapabilitiesFull(capabilities);
  }

  /// Tells the Jellyfin server that playback has started
  Future<void> reportPlaybackStart(
      PlaybackProgressInfo playbackProgressInfo) async {
    final response = await jellyfinApi.startPlayback(playbackProgressInfo);
    if (response.toString().isNotEmpty) {
      throw response as Object;
    }
  }

  /// Updates player progress so that Jellyfin can track what we're listening to
  Future<void> updatePlaybackProgress(
      PlaybackProgressInfo playbackProgressInfo) async {
    final response =
        await jellyfinApi.playbackStatusUpdate(playbackProgressInfo);
    if (response.toString().isNotEmpty) {
      throw response as Object;
    }
  }

  /// Tells Jellyfin that we've stopped listening to music (called when the audio service is stopped)
  Future<void> stopPlaybackProgress(
      PlaybackProgressInfo playbackProgressInfo) async {
    final response =
        await jellyfinApi.playbackStatusStopped(playbackProgressInfo);
    if (response.toString().isNotEmpty) {
      throw response as Object;
    }
  }

  /// Gets an item from a user's library.
  Future<BaseItemDto> getItemById(BaseItemId itemId) async {
    assert(!FinampSettingsHelper.finampSettings.isOffline);
    final response = await jellyfinApi.getItemById(
      userId: _finampUserHelper.currentUser!.id,
      itemId: itemId,
    );

    return (BaseItemDto.fromJson(response as Map<String, dynamic>));
  }

  Future<Map<BaseItemId, BaseItemDto>>? _getItemByIdBatchedFuture;
  final Set<BaseItemId> _getItemByIdBatchedRequests = {};

  /// Gets an item from a user's library, batching with other request coming in around the same time.
  Future<BaseItemDto?> getItemByIdBatched(BaseItemId itemId,
      [String? fields]) async {
    assert(!FinampSettingsHelper.finampSettings.isOffline);
    fields ??=
        defaultFields; // explicitly set the default fields, if we pass `null` to [JellyfinAPI.getItems] it will **not** apply the default fields, since the argument *is* provided.
    _getItemByIdBatchedRequests.add(itemId);
    _getItemByIdBatchedFuture ??=
        Future.delayed(const Duration(milliseconds: 250), () async {
      _getItemByIdBatchedFuture = null;
      var ids = _getItemByIdBatchedRequests.take(200).toList();
      _getItemByIdBatchedRequests.removeAll(ids);
      var items = await getItems(itemIds: ids, fields: fields) ?? [];
      return Map.fromIterable(items, key: (e) => (e as BaseItemDto).id);
    });
    return _getItemByIdBatchedFuture!.then((value) => value[itemId]);
  }

  /// Creates a new playlist.
  Future<NewPlaylistResponse> createNewPlaylist(NewPlaylist newPlaylist) async {
    final response = await jellyfinApi.createNewPlaylist(
      newPlaylist: newPlaylist,
    );

    return NewPlaylistResponse.fromJson(response as Map<String, dynamic>);
  }

  /// Adds items to a playlist.
  Future<void> addItemstoPlaylist({
    /// The playlist id.
    required BaseItemId playlistId,

    /// Item ids to add.
    List<BaseItemId>? ids,
  }) async {
    await jellyfinApi.addItemsToPlaylist(
      playlistId: playlistId,
      ids: ids?.join(","),
    );
  }

  /// Remove items to a playlist.
  Future<void> removeItemsFromPlaylist({
    /// The playlist id.
    required BaseItemId playlistId,

    /// Item ids to add.
    List<String>? entryIds,
  }) async {
    final response = await jellyfinApi.removeItemsFromPlaylist(
      playlistId: playlistId,
      entryIds: entryIds?.join(","),
    );
    if (response.statusCode == 403) {
      _jellyfinApiHelperLogger.warning(
          "Failed to remove items from playlist due to insufficient permissions. Status code: ${response.statusCode}");
      throw "You do not have permission to remove items from this playlist. Status code: ${response.statusCode}";
    } else if (response.error != null) {
      if (response.error == "") {
        throw "An unknown error occurred while removing items from the playlist. Status code: ${response.statusCode}";
      }
      throw "${response.error}. Status code: ${response.statusCode}";
    }
  }

  /// Updates an item.
  Future<void> updateItem({
    /// The item id.
    required BaseItemId itemId,

    /// What to update the item with. You should give a BaseItemDto with only
    /// changed values.
    required BaseItemDto newItem,
  }) async {
    final response =
        await jellyfinApi.updateItem(itemId: itemId, newItem: newItem);
    if (response.toString().isNotEmpty) {
      throw response as Object;
    }
  }

  /// Marks an item as a favorite.
  Future<UserItemDataDto> addFavourite(BaseItemId itemId) async {
    assert(!FinampSettingsHelper.finampSettings.isOffline);
    final response = await jellyfinApi.addFavourite(
        userId: _finampUserHelper.currentUser!.id, itemId: itemId);

    final downloadsService = GetIt.instance<DownloadsService>();
    unawaited(downloadsService.resync(
        DownloadStub.fromFinampCollection(
            FinampCollection(type: FinampCollectionType.favorites)),
        null,
        keepSlow: true));
    return UserItemDataDto.fromJson(response as Map<String, dynamic>);
  }

  /// Unmarks item as a favorite.
  Future<UserItemDataDto> removeFavourite(BaseItemId itemId) async {
    assert(!FinampSettingsHelper.finampSettings.isOffline);
    final response = await jellyfinApi.removeFavourite(
        userId: _finampUserHelper.currentUser!.id, itemId: itemId);

    final downloadsService = GetIt.instance<DownloadsService>();
    unawaited(downloadsService.resync(
        DownloadStub.fromFinampCollection(
            FinampCollection(type: FinampCollectionType.favorites)),
        null,
        keepSlow: true));
    return UserItemDataDto.fromJson(response as Map<String, dynamic>);
  }

  void addArtistToMixBuilderList(BaseItemDto item) {
    selectedMixArtists.add(item);
  }

  void removeArtistFromMixBuilderList(BaseItemDto item) {
    selectedMixArtists.remove(item);
  }

  void clearArtistMixBuilderList() {
    selectedMixArtists.clear();
  }

  void addAlbumToMixBuilderList(BaseItemDto item) {
    selectedMixAlbums.add(item);
  }

  void removeAlbumFromMixBuilderList(BaseItemDto item) {
    selectedMixAlbums.remove(item);
  }

  void clearAlbumMixBuilderList() {
    selectedMixAlbums.clear();
  }

  void addGenreToMixBuilderList(BaseItemDto item) {
    selectedMixGenres.add(item);
  }

  void removeGenreFromMixBuilderList(BaseItemDto item) {
    selectedMixGenres.remove(item);
  }

  void clearGenreMixBuilderList() {
    selectedMixGenres.clear();
  }

  Future<List<BaseItemDto>?> getArtistMix(List<BaseItemId> artistIds) async {
    final response = await jellyfinApi.getItems(
        userId: _finampUserHelper.currentUser!.id,
        artistIds: artistIds.join(","),
        filters: "IsNotFolder",
        recursive: true,
        sortBy: "Random",
        limit: 300,
        fields: "Chapters");

    return (QueryResult_BaseItemDto.fromJson(response as Map<String, dynamic>)
        .items);
  }

  Future<List<BaseItemDto>?> getAlbumMix(List<BaseItemId> albumIds) async {
    final response = await jellyfinApi.getItems(
        userId: _finampUserHelper.currentUser!.id,
        albumIds: albumIds.join(","),
        filters: "IsNotFolder",
        recursive: true,
        sortBy: "Random",
        limit: 300,
        fields: "Chapters");

    return (QueryResult_BaseItemDto.fromJson(response as Map<String, dynamic>)
        .items);
  }

  Future<List<BaseItemDto>?> getGenreMix(List<BaseItemId> genreIds) async {
    final response = await jellyfinApi.getItems(
        userId: _finampUserHelper.currentUser!.id,
        genreIds: genreIds.join(","),
        filters: "IsNotFolder",
        recursive: true,
        sortBy: "Random",
        limit: 300,
        fields: "Chapters");

    return (QueryResult_BaseItemDto.fromJson(response as Map<String, dynamic>)
        .items);
  }

  /// Gets the lyrics for an item.
  Future<LyricDto> getLyrics({
    required BaseItemId itemId,
  }) async {
    final response = await jellyfinApi.getLyrics(
      itemId: itemId,
    );

    return LyricDto.fromJson(response as Map<String, dynamic>);
  }

  /// Removes the current user from the DB and revokes the token on Jellyfin
  Future<void> logoutCurrentUser() async {
    Response<dynamic>? response;

    // We put this in a try-catch loop that basically ignores errors so that the
    // user can still log out during scenarios like wrong IP, no internet etc.

    try {
      response = await jellyfinApi
          .logout()
          // This is required for logout ontimeout method to be correct type
          .then((e) => e as Response<dynamic>?)
          .timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          _jellyfinApiHelperLogger.warning(
              "Logout request timed out. Logging out anyway, but be aware that Jellyfin may have not got the signal.");
          return null;
        },
      );
    } catch (e) {
      _jellyfinApiHelperLogger.warning(
          "Jellyfin logout failed with error $e. Logging out anyway, but be aware that Jellyfin may have not got the signal.",
          e);
    } finally {
      // If the logout response wasn't successful, warn the user in the logs.
      // We continue anyway since this will mostly be for when the client becomes
      // unauthorised, which will return 401.
      if (response?.isSuccessful == false) {
        _jellyfinApiHelperLogger.warning(
            "Jellyfin logout returned ${response!.statusCode}. Logging out anyway, but be aware that Jellyfin may still consider this device logged in.");
      }

      // If we're unauthorised, the logout command will fail but we're already
      // basically logged out so we shouldn't fail.
      _finampUserHelper.removeUser(_finampUserHelper.currentUser!.id);
      _jellyfinApiHelperLogger.warning("User has completed logout.");
    }
  }

  /// Returns the correct image URL for the given item, or null if there is no
  /// image. Uses [getImageId] to get the actual id. [maxWidth] and [maxHeight]
  /// can be specified to return a smaller image. [quality] can be modified to
  /// get a higher/lower quality image.
  Uri? getImageUrl({
    required BaseItemDto item,
    int? maxWidth,
    int? maxHeight,
    int? quality = 90,
    String? format = "jpg",
  }) {
    if (item.imageId == null) {
      return null;
    }

    final parsedBaseUrl = Uri.parse(_finampUserHelper.currentUser!.baseUrl);
    List<String> builtPath = List<String>.from(parsedBaseUrl.pathSegments);
    builtPath.addAll([
      "Items",
      item.imageId!,
      "Images",
      "Primary",
    ]);
    return Uri(
        host: parsedBaseUrl.host,
        port: parsedBaseUrl.port,
        scheme: parsedBaseUrl.scheme,
        userInfo: parsedBaseUrl.userInfo,
        pathSegments: builtPath,
        queryParameters: {
          if (format != null) "format": format,
          if (quality != null) "quality": quality.toString(),
          if (maxWidth != null) "MaxWidth": maxWidth.toString(),
          if (maxHeight != null) "MaxHeight": maxHeight.toString(),
        });
  }

  Uri? getUserImageUrl({
    required Uri baseUrl,
    required UserDto user,
    int? maxWidth,
    int? maxHeight,
    int? quality = 90,
    String? format = "jpg",
  }) {
    if (user.primaryImageTag == null) {
      return null;
    }

    List<String> builtPath = List<String>.from(baseUrl.pathSegments);
    builtPath.addAll([
      "Users",
      user.id,
      "Images",
      "Primary",
    ]);
    return Uri(
        host: baseUrl.host,
        port: baseUrl.port,
        scheme: baseUrl.scheme,
        userInfo: baseUrl.userInfo,
        pathSegments: builtPath,
        queryParameters: {
          if (format != null) "format": format,
          if (quality != null) "quality": quality.toString(),
          if (maxWidth != null) "MaxWidth": maxWidth.toString(),
          if (maxHeight != null) "MaxHeight": maxHeight.toString(),
        });
  }

  /// Returns the correct URL for the given item.
  Uri getTrackDownloadUrl({
    required BaseItemDto item,
    required DownloadProfile? transcodingProfile,
  }) {
    Uri uri = Uri.parse(_finampUserHelper.currentUser!.baseUrl);

    if (transcodingProfile != null &&
        transcodingProfile.codec != FinampTranscodingCodec.original) {
      // uri.queryParameters is unmodifiable, so we copy the contents into a new
      // map
      final queryParameters = Map.of(uri.queryParameters);

      // iOS/macOS doesn't support OPUS (except in CAF, which doesn't work from
      // Jellyfin). Once https://github.com/jellyfin/jellyfin/pull/9192 lands,
      // we could use M4A/AAC.

      assert(transcodingProfile.codec.container != null,
          "Missing container for codec while trying to download transcoded track!");

      queryParameters.addAll({
        "transcodingContainer": transcodingProfile.codec.container!,
        "audioCodec": transcodingProfile.codec.name,
        "audioBitRate": transcodingProfile.stereoBitrate.toString(),
      });

      uri = uri.replace(
        pathSegments:
            uri.pathSegments.followedBy(["Audio", item.id.raw, "Universal"]),
        queryParameters: queryParameters,
      );
    } else {
      uri = uri.replace(
        pathSegments:
            uri.pathSegments.followedBy(["Items", item.id.raw, "File"]),
      );
    }

    return uri;
  }

  late final ProviderFamily<bool, BaseItemDto> canDeleteFromServerProvider =
      ProviderFamily((ref, BaseItemDto item) {
    bool offline = ref.watch(finampSettingsProvider.isOffline);
    if (offline) {
      return false;
    }
    var itemType = BaseItemDtoType.fromItem(item);
    var isPlaylist = itemType == BaseItemDtoType.playlist;
    bool deleteEnabled =
        ref.watch(finampSettingsProvider.allowDeleteFromServer);

    // always check if a playlist is deletable
    if (!deleteEnabled && !isPlaylist) {
      return false;
    }

    // do not bother checking server for item types known to not be deletable
    if (![
      BaseItemDtoType.album,
      BaseItemDtoType.playlist,
      BaseItemDtoType.track
    ].contains(itemType)) {
      return false;
    }
    bool? serverReturn =
        ref.watch(_canDeleteFromServerAsyncProvider(item.id)).value;
    if (serverReturn == null) {
      // fallback to allowing deletion even if the response is invalid, since the user might still be able to delete
      // worst case would be getting an error message when trying to delete
      return item.canDelete ?? true;
    } else {
      return serverReturn;
    }
  });

  late final AutoDisposeFutureProviderFamily<bool?, BaseItemId>
      _canDeleteFromServerAsyncProvider =
      AutoDisposeFutureProviderFamily((ref, BaseItemId id) {
    return getItemById(id).then((response) {
      return response.canDelete;
    }).catchError((_) {
      return false;
    });
  });
}
