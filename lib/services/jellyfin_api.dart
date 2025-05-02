import 'dart:async';
import 'dart:io' show HttpClient, Platform;

import 'package:app_set_id/app_set_id.dart';
import 'package:chopper/chopper.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/http_aggregate_logging_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:http/io_client.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import '../models/jellyfin_models.dart';
import 'finamp_user_helper.dart';
import 'jellyfin_api_helper.dart';

part 'jellyfin_api.chopper.dart';

const String defaultFields =
    "ChildCount,DateCreated,DateLastMediaAdded,Etag,Genres,ParentId,ProviderIds,Tags";

@ChopperApi()
abstract class JellyfinApi extends ChopperService {
  @FactoryConverter(
    request: JsonConverter.requestFactory,
    response: JsonConverter.responseFactory,
  )
  @Get(path: "/System/Info/Public")
  Future<dynamic> getPublicServerInfo();

  @FactoryConverter(
    request: JsonConverter.requestFactory,
    response: JsonConverter.responseFactory,
  )
  @Get(path: "/Users/Public")
  Future<dynamic> getPublicUsers();

  @FactoryConverter(
    request: JsonConverter.requestFactory,
    response: JsonConverter.responseFactory,
  )
  @Get(path: "/QuickConnect/Enabled")
  Future<dynamic> getQuickConnectState();

  @FactoryConverter(
    request: JsonConverter.requestFactory,
    response: JsonConverter.responseFactory,
  )
  @Get(path: "/QuickConnect/Initiate")
  Future<dynamic> initiateQuickConnect();

  @FactoryConverter(
    request: JsonConverter.requestFactory,
    response: JsonConverter.responseFactory,
  )
  @Get(path: "/QuickConnect/Connect")
  Future<dynamic> updateQuickConnect({
    @Query("Secret") required String secret,
  });

  @FactoryConverter(
    request: JsonConverter.requestFactory,
    response: JsonConverter.responseFactory,
  )
  @Post(path: "/Users/AuthenticateWithQuickConnect")
  Future<dynamic> authenticateWithQuickConnect(
      @Body() Map<String, String> quickConnectInfo);

  @FactoryConverter(
    request: JsonConverter.requestFactory,
    response: JsonConverter.responseFactory,
  )
  @Post(path: "/Users/AuthenticateByName")
  Future<dynamic> authenticateViaName(
      @Body() Map<String, String> usernameAndPassword);

  @FactoryConverter(
    request: JsonConverter.requestFactory,
    response: JsonConverter.responseFactory,
  )
  @Get(path: "/Items/{id}/Images/Primary")
  Future<dynamic> getAlbumPrimaryImage({
    @Path() required BaseItemId id,
    @Query() String format = "webp",
  });

  @FactoryConverter(
    request: JsonConverter.requestFactory,
    response: JsonConverter.responseFactory,
  )
  @Get(path: "/Users/{id}/Views")
  Future<dynamic> getViews(@Path() String id);

  @FactoryConverter(
    request: JsonConverter.requestFactory,
    response: JsonConverter.responseFactory,
  )
  @Delete(path: "/Items/{id}")
  Future<dynamic> deleteItem(@Path() BaseItemId id);

  @FactoryConverter(
    request: JsonConverter.requestFactory,
    response: JsonConverter.responseFactory,
  )
  @Get(path: "/Users/{userId}/Items")
  Future<dynamic> getItems({
    /// The user id supplied as query parameter.
    @Path() required String userId,

    /// Optional. If specified, results will be filtered based on the item type.
    /// This allows multiple, comma delimeted.
    @Query("IncludeItemTypes") String? includeItemTypes,

    /// Specify this to localize the search to a specific item or folder. Omit
    /// to use the root.
    @Query("ParentId") BaseItemId? parentId,

    /// Optional. If specified, results will be filtered to include only those
    /// containing the specified album artist id.
    @Query("AlbumArtistIds") String? albumArtistIds,

    /// Optional. If specified, results will be filtered to include only those
    /// containing the specified artist id.
    @Query("ArtistIds") String? artistIds,

    /// Optional. If specified, results will be filtered to include only those
    /// containing the specified contributing artist id.
    @Query("contributingArtistIds") String? contributingArtistIds,

    /// Optional. If specified, results will be filtered to include only those
    /// containing the specified album id.
    @Query("AlbumIds") String? albumIds,

    /// Optional. If specified, results will be filtered to include only those
    /// containing the specified genre id.
    @Query("GenreIds") String? genreIds,
    @Query("ids") String? ids,

    /// When searching within folders, this determines whether or not the search
    /// will be recursive. true/false.
    @Query("Recursive") bool? recursive,

    /// Optional. Specify one or more sort orders, comma delimited. Options:
    /// Album, AlbumArtist, Artist, Budget, CommunityRating, CriticRating,
    /// DateCreated, DatePlayed, PlayCount, PremiereDate, ProductionYear,
    /// SortName, Random, Revenue, Runtime.
    @Query("SortBy") String? sortBy,

    /// Items Enum: "Ascending" "Descending"
    /// Sort Order - Ascending,Descending.
    @Query("SortOrder") String? sortOrder,

    /// Items Enum: "AirTime" "CanDelete" "CanDownload" "ChannelInfo" "Chapters"
    /// "ChildCount" "CumulativeRunTimeTicks" "CustomRating" "DateCreated"
    /// "DateLastMediaAdded" "DisplayPreferencesId" "Etag" "ExternalUrls"
    /// "Genres" "HomePageUrl" "ItemCounts" "MediaSourceCount" "MediaSources"
    /// "OriginalTitle" "Overview" "ParentId" "Path" "People" "PlayAccess"
    /// "ProductionLocations" "ProviderIds" "PrimaryImageAspectRatio"
    /// "RecursiveItemCount" "Settings" "ScreenshotImageTags"
    /// "SeriesPrimaryImage" "SeriesStudio" "SortName" "SpecialEpisodeNumbers"
    /// "Studios" "BasicSyncInfo" "SyncInfo" "Taglines" "Tags" "RemoteTrailers"
    /// "MediaStreams" "SeasonUserData" "ServiceName" "ThemeSongIds"
    /// "ThemeVideoIds" "ExternalEtag" "PresentationUniqueKey"
    /// "InheritedParentalRatingValue" "ExternalSeriesId"
    /// "SeriesPresentationUniqueKey" "DateLastRefreshed" "DateLastSaved"
    /// "RefreshState" "ChannelImage" "EnableMediaSourceDisplay" "Width"
    /// "Height" "ExtraIds" "LocalTrailerCount" "IsHD" "SpecialFeatureCount"
    @Query("Fields") String? fields = defaultFields,

    /// Optional. Filter based on a search term.
    @Query("SearchTerm") String? searchTerm,

    /// Items Enum: "IsFolder" "IsNotFolder" "IsUnplayed" "IsPlayed"
    /// "IsFavorite" "IsResumable" "Likes" "Dislikes" "IsFavoriteOrLikes"
    /// Optional. Specify additional filters to apply. This allows multiple,
    /// comma delimited. Options: IsFolder, IsNotFolder, IsUnplayed, IsPlayed,
    /// IsFavorite, IsResumable, Likes, Dislikes.
    @Query("Filters") String? filters,

    /// Optional. The record index to start at. All items with a lower index
    /// will be dropped from the results.
    @Query("StartIndex") int? startIndex,

    /// Optional. The maximum number of records to return.
    @Query("Limit") int? limit,

    /// Optional. Controls if multi-disc should be returned as separate albums (true) or as a single album (false).
    @Query("CollapseBoxSetItems") bool? collapseMultiDiscAlbums,
  });

  @FactoryConverter(
    request: JsonConverter.requestFactory,
    response: JsonConverter.responseFactory,
  )
  @Get(path: "/Users/{userId}/Items/Latest")
  Future<dynamic> getLatestItems({
    /// The user id supplied as query parameter.
    @Path() required String userId,

    /// Optional. If specified, results will be filtered based on the item type.
    /// This allows multiple, comma delimeted.
    @Query("IncludeItemTypes") String? includeItemTypes,

    /// Specify this to localize the search to a specific item or folder. Omit
    /// to use the root.
    @Query("ParentId") BaseItemId? parentId,

    /// Items Enum: "AirTime" "CanDelete" "CanDownload" "ChannelInfo" "Chapters"
    /// "ChildCount" "CumulativeRunTimeTicks" "CustomRating" "DateCreated"
    /// "DateLastMediaAdded" "DisplayPreferencesId" "Etag" "ExternalUrls"
    /// "Genres" "HomePageUrl" "ItemCounts" "MediaSourceCount" "MediaSources"
    /// "OriginalTitle" "Overview" "ParentId" "Path" "People" "PlayAccess"
    /// "ProductionLocations" "ProviderIds" "PrimaryImageAspectRatio"
    /// "RecursiveItemCount" "Settings" "ScreenshotImageTags"
    /// "SeriesPrimaryImage" "SeriesStudio" "SortName" "SpecialEpisodeNumbers"
    /// "Studios" "BasicSyncInfo" "SyncInfo" "Taglines" "Tags" "RemoteTrailers"
    /// "MediaStreams" "SeasonUserData" "ServiceName" "ThemeSongIds"
    /// "ThemeVideoIds" "ExternalEtag" "PresentationUniqueKey"
    /// "InheritedParentalRatingValue" "ExternalSeriesId"
    /// "SeriesPresentationUniqueKey" "DateLastRefreshed" "DateLastSaved"
    /// "RefreshState" "ChannelImage" "EnableMediaSourceDisplay" "Width"
    /// "Height" "ExtraIds" "LocalTrailerCount" "IsHD" "SpecialFeatureCount"
    @Query("Fields") String? fields = defaultFields,

    /// Optional. The maximum number of records to return.
    @Query("Limit") int? limit,

    /// Optional. Whether or not to group items into a parent container.
    @Query("GroupItems") bool? groupItems,
  });

  @FactoryConverter(
    request: JsonConverter.requestFactory,
    response: JsonConverter.responseFactory,
  )
  @Get(path: "/Items/{id}/InstantMix")
  Future<dynamic> getInstantMix({
    @Path() required BaseItemId id,
    @Query() required String userId,
    @Query() required int limit,
  });

  @FactoryConverter(
    request: JsonConverter.requestFactory,
    response: JsonConverter.responseFactory,
  )
  @Get(path: "/Users/{userId}/Items/{itemId}")
  Future<dynamic> getItemById({
    /// User id.
    @Path() required String userId,

    /// Item id.
    @Path() required BaseItemId itemId,
  });

  @FactoryConverter(
    request: JsonConverter.requestFactory,
    response: JsonConverter.responseFactory,
  )
  @Get(path: "/Items/{id}/PlaybackInfo")
  Future<dynamic> getPlaybackInfo({
    @Path() required BaseItemId id,
    @Query() required String userId,
  });

  @FactoryConverter(
    request: JsonConverter.requestFactory,
  )
  @Post(path: "/Items/{itemId}")
  Future<dynamic> updateItem({
    /// The item id.
    @Path() required BaseItemId itemId,
    @Body() required BaseItemDto newItem,
  });

  @FactoryConverter(request: JsonConverter.requestFactory)
  @Post(path: "/Sessions/Capabilities", optionalBody: true)
  Future<dynamic> updateCapabilities({
    @Query() required String playableMediaTypes,
    @Query() required String supportedCommands,
    @Query() required bool supportsMediaControl,
    @Query() required bool supportsPersistentIdentifier,
  });


  @FactoryConverter(request: JsonConverter.requestFactory)
  @Post(path: "/Sessions/Capabilities/Full")
  Future<dynamic> updateCapabilitiesFull(
    // @Query() required String id,
    @Body() ClientCapabilities clientCapabilities,
  );

  @FactoryConverter(request: JsonConverter.requestFactory)
  @Post(path: "/Sessions/Playing")
  Future<dynamic> startPlayback(
      @Body() PlaybackProgressInfo playbackProgressInfo);

  @FactoryConverter(request: JsonConverter.requestFactory)
  @Post(path: "/Sessions/Playing/Progress")
  Future<dynamic> playbackStatusUpdate(
      @Body() PlaybackProgressInfo playbackProgressInfo);

  @FactoryConverter(request: JsonConverter.requestFactory)
  @Post(path: "/Sessions/Playing/Stopped")
  Future<dynamic> playbackStatusStopped(
      @Body() PlaybackProgressInfo playbackProgressInfo);

  @FactoryConverter(
    request: JsonConverter.requestFactory,
    response: JsonConverter.responseFactory,
  )
  @Get(path: "/Playlists/{playlistId}/Items")
  Future<dynamic> getPlaylistItems({
    @Path() required BaseItemId playlistId,
    @Query("UserId") required String userId,
    @Query("IncludeItemTypes") String? includeItemTypes,
    @Query("ParentId") BaseItemId? parentId,
    @Query("Recursive") bool? recursive,
    @Query("Fields") String? fields = defaultFields,
  });

  /// Creates a new playlist.
  @FactoryConverter(
    request: JsonConverter.requestFactory,
    response: JsonConverter.responseFactory,
  )
  @Post(path: "/Playlists")
  Future<dynamic> createNewPlaylist({
    /// The create playlist payload.
    @Body() required NewPlaylist newPlaylist,
  });

  /// Adds items to a playlist.
  @FactoryConverter(request: JsonConverter.requestFactory)
  @Post(path: "/Playlists/{playlistId}/Items", optionalBody: true)
  Future<Response> addItemsToPlaylist({
    /// The playlist id.
    @Path() required BaseItemId playlistId,

    /// Item id, comma delimited.
    @Query() String? ids,

    /// The userId.
    @Query() String? userId,
  });

  /// Remove items from a playlist.
  @FactoryConverter(request: JsonConverter.requestFactory)
  @Delete(path: "/Playlists/{playlistId}/Items", optionalBody: true)
  Future<Response> removeItemsFromPlaylist({
    /// The playlist id.
    @Path() required BaseItemId playlistId,

    /// Item id, comma delimited.
    @Query() String? entryIds,
  });

  @FactoryConverter(
    request: JsonConverter.requestFactory,
    response: JsonConverter.responseFactory,
  )
  @Get(path: "/Artists")
  Future<dynamic> getArtists({
    /// Specify this to localize the search to a specific item or folder. Omit
    /// to use the root.
    @Query("ParentId") BaseItemId? parentId,

    /// Optional. Specify one or more sort orders, comma delimited. Options:
    /// Album, AlbumArtist, Artist, Budget, CommunityRating, CriticRating,
    /// DateCreated, DatePlayed, PlayCount, PremiereDate, ProductionYear,
    /// SortName, Random, Revenue, Runtime.
    @Query("SortBy") String? sortBy,

    /// Items Enum: "Ascending" "Descending"
    /// Sort Order - Ascending,Descending.
    @Query("SortOrder") String? sortOrder,

    /// Items Enum: "AirTime" "CanDelete" "CanDownload" "ChannelInfo" "Chapters"
    /// "ChildCount" "CumulativeRunTimeTicks" "CustomRating" "DateCreated"
    /// "DateLastMediaAdded" "DisplayPreferencesId" "Etag" "ExternalUrls"
    /// "Genres" "HomePageUrl" "ItemCounts" "MediaSourceCount" "MediaSources"
    /// "OriginalTitle" "Overview" "ParentId" "Path" "People" "PlayAccess"
    /// "ProductionLocations" "ProviderIds" "PrimaryImageAspectRatio"
    /// "RecursiveItemCount" "Settings" "ScreenshotImageTags"
    /// "SeriesPrimaryImage" "SeriesStudio" "SortName" "SpecialEpisodeNumbers"
    /// "Studios" "BasicSyncInfo" "SyncInfo" "Taglines" "Tags" "RemoteTrailers"
    /// "MediaStreams" "SeasonUserData" "ServiceName" "ThemeSongIds"
    /// "ThemeVideoIds" "ExternalEtag" "PresentationUniqueKey"
    /// "InheritedParentalRatingValue" "ExternalSeriesId"
    /// "SeriesPresentationUniqueKey" "DateLastRefreshed" "DateLastSaved"
    /// "RefreshState" "ChannelImage" "EnableMediaSourceDisplay" "Width"
    /// "Height" "ExtraIds" "LocalTrailerCount" "IsHD" "SpecialFeatureCount"
    @Query("Fields") String? fields = defaultFields,

    /// Optional. Filter based on a search term.
    @Query("SearchTerm") String? searchTerm,

    /// Items Enum: "IsFolder" "IsNotFolder" "IsUnplayed" "IsPlayed"
    /// "IsFavorite" "IsResumable" "Likes" "Dislikes" "IsFavoriteOrLikes"
    /// Optional. Specify additional filters to apply. This allows multiple,
    /// comma delimited. Options: IsFolder, IsNotFolder, IsUnplayed, IsPlayed,
    /// IsFavorite, IsResumable, Likes, Dislikes.
    @Query("Filters") String? filters,

    /// Optional. The record index to start at. All items with a lower index
    /// will be dropped from the results.
    @Query("StartIndex") int? startIndex,

    /// Optional. The maximum number of records to return.
    @Query("Limit") int? limit,

    /// Optional. If enabled, only favorite artists will be returned.
    @Query("IsFavorite") bool? isFavorite,
  });

  @FactoryConverter(
    request: JsonConverter.requestFactory,
    response: JsonConverter.responseFactory,
  )
  @Get(path: "/Artists/AlbumArtists")
  Future<dynamic> getAlbumArtists({
    @Query("IncludeItemTypes") String? includeItemTypes,
    @Query("ParentId") BaseItemId? parentId,
    @Query("Recursive") bool? recursive,

    /// Optional. Specify one or more sort orders, comma delimited. Options:
    /// Album, AlbumArtist, Artist, Budget, CommunityRating, CriticRating,
    /// DateCreated, DatePlayed, PlayCount, PremiereDate, ProductionYear,
    /// SortName, Random, Revenue, Runtime.
    @Query("SortBy") String? sortBy,

    /// Items Enum: "Ascending" "Descending"
    /// Sort Order - Ascending,Descending.
    @Query("SortOrder") String? sortOrder,
    @Query("Fields") String? fields = defaultFields,
    @Query("SearchTerm") String? searchTerm,
    @Query("EnableUserData") bool enableUserData = true,

    /// Items Enum: "IsFolder" "IsNotFolder" "IsUnplayed" "IsPlayed"
    /// "IsFavorite" "IsResumable" "Likes" "Dislikes" "IsFavoriteOrLikes"
    /// Optional. Specify additional filters to apply.
    @Query("Filters") String? filters,

    /// Optional. The record index to start at. All items with a lower index
    /// will be dropped from the results.
    @Query("StartIndex") int? startIndex,

    /// Optional. The maximum number of records to return.
    @Query("Limit") int? limit,

    /// User id. Technically nullable in the Jellyfin API docs, but getting
    /// favourited artists will break if this is not given.
    @Query("UserId") required String userId,
  });

  /// Gets all genres from a given item, folder, or the entire library.
  @FactoryConverter(
    request: JsonConverter.requestFactory,
    response: JsonConverter.responseFactory,
  )
  @Get(path: "/Genres")
  Future<dynamic> getGenres({
    /// Optional. If specified, results will be filtered based on the item type.
    /// This allows multiple, comma delimeted.
    @Query("IncludeItemTypes") String? includeItemTypes,

    /// Specify this to localize the search to a specific item or folder. Omit
    /// to use the root.
    @Query("ParentId") BaseItemId? parentId,

    /// Items Enum: "AirTime" "CanDelete" "CanDownload" "ChannelInfo" "Chapters"
    /// "ChildCount" "CumulativeRunTimeTicks" "CustomRating" "DateCreated"
    /// "DateLastMediaAdded" "DisplayPreferencesId" "Etag" "ExternalUrls"
    /// "Genres" "HomePageUrl" "ItemCounts" "MediaSourceCount" "MediaSources"
    /// "OriginalTitle" "Overview" "ParentId" "Path" "People" "PlayAccess"
    /// "ProductionLocations" "ProviderIds" "PrimaryImageAspectRatio"
    /// "RecursiveItemCount" "Settings" "ScreenshotImageTags"
    /// "SeriesPrimaryImage" "SeriesStudio" "SortName" "SpecialEpisodeNumbers"
    /// "Studios" "BasicSyncInfo" "SyncInfo" "Taglines" "Tags" "RemoteTrailers"
    /// "MediaStreams" "SeasonUserData" "ServiceName" "ThemeSongIds"
    /// "ThemeVideoIds" "ExternalEtag" "PresentationUniqueKey"
    /// "InheritedParentalRatingValue" "ExternalSeriesId"
    /// "SeriesPresentationUniqueKey" "DateLastRefreshed" "DateLastSaved"
    /// "RefreshState" "ChannelImage" "EnableMediaSourceDisplay" "Width"
    /// "Height" "ExtraIds" "LocalTrailerCount" "IsHD" "SpecialFeatureCount"
    @Query("Fields") String? fields = defaultFields,

    /// Optional. Filter based on a search term.
    @Query("SearchTerm") String? searchTerm,

    /// Optional. The record index to start at. All items with a lower index
    /// will be dropped from the results.
    @Query("StartIndex") int? startIndex,

    /// Optional. The maximum number of records to return.
    @Query("Limit") int? limit,
  });

  /// Marks an item as a favorite.
  @FactoryConverter(
    request: JsonConverter.requestFactory,
    response: JsonConverter.responseFactory,
  )
  @Post(path: "/Users/{userId}/FavoriteItems/{itemId}", optionalBody: true)
  Future<dynamic> addFavourite({
    /// User id.
    @Path() required String userId,

    /// Item id.
    @Path() required BaseItemId itemId,
  });

  /// Unmarks item as a favorite.
  @FactoryConverter(
    request: JsonConverter.requestFactory,
    response: JsonConverter.responseFactory,
  )
  @Delete(path: "/Users/{userId}/FavoriteItems/{itemId}")
  Future<dynamic> removeFavourite({
    /// User id.
    @Path() required String userId,

    /// Item id.
    @Path() required BaseItemId itemId,
  });

  /// Requests lyrics for a track.
  @FactoryConverter(
    request: JsonConverter.requestFactory,
    response: JsonConverter.responseFactory,
  )
  @Get(path: "/Audio/{itemId}/Lyrics")
  Future<dynamic> getLyrics({
    /// The item id.
    @Path() required BaseItemId itemId,
  });

  /// Reports that a session has ended.
  @FactoryConverter(
    request: JsonConverter.requestFactory,
  )
  @Post(path: "/Sessions/Logout", optionalBody: true)
  Future<Response<dynamic>> logout();

  @Get(path: "/System/Endpoint", optionalBody: true)
  Future<Response<dynamic>> pingServer();

  static JellyfinApi create(bool inForeground) {
    final chopperHttpLogLevel = Level
        .body; //TODO allow changing the log level in settings (and a debug config file?)

    final client = ChopperClient(
      client: http.IOClient(HttpClient()
            ..connectionTimeout = const Duration(
                seconds:
                    10) // if we don't get a response by then, it's probably not worth it to wait any longer. this prevents the server connection test from taking too long
          ),
      // The first part of the URL is now here
      services: [
        // The generated implementation
        _$JellyfinApi(),
      ],
      // Converts data to & from JSON and adds the application/json header.
      // converter: JsonConverter(),
      interceptors: [
        /// Gets baseUrl from SharedPreferences.
        JellyfinInterceptor(inForeground),
        HttpAggregateLoggingInterceptor(level: chopperHttpLogLevel),
      ],
    );

    // The generated class with the ChopperClient passed in
    return _$JellyfinApi(client);
  }
}

class JellyfinInterceptor implements Interceptor {
  JellyfinInterceptor(this.inForeground);

  final bool inForeground;

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
      Chain<BodyType> chain) async {
    return await chain.proceed(updateRequest(chain.request));
  }

  Request updateRequest(Request request) {
    final finampUserHelper = GetIt.instance<FinampUserHelper>();
    Uri? baseUrlTemp;
    if (inForeground) {
      final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
      baseUrlTemp = jellyfinApiHelper.baseUrlTemp;
    }

    String authHeader = finampUserHelper.authorizationHeader;

    // If baseUrlTemp is null, use the baseUrl of the current user.
    // If baseUrlTemp is set, we're setting up a new user and should use it instead.
    Uri baseUri =
        baseUrlTemp ?? Uri.parse(finampUserHelper.currentUser!.baseURL);

    // Add the request path on to the baseUrl
    baseUri = baseUri.replace(
        pathSegments:
            baseUri.pathSegments.followedBy(request.uri.pathSegments));

    return request.copyWith(
      uri: baseUri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": authHeader,
      },
    );
  }
}

/// Interceptor for just the local address
class JellyfinSpecificInterceptor implements Interceptor {
  JellyfinSpecificInterceptor(this.url);

  final String url;
  
  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
      Chain<BodyType> chain) async {
    return await chain.proceed(updateRequest(chain.request));
  }

  Request updateRequest(Request request) {
    final finampUserHelper = GetIt.instance<FinampUserHelper>();

    Uri baseUri = Uri.parse(url);
    baseUri = baseUri.replace(
        pathSegments:
            baseUri.pathSegments.followedBy(request.uri.pathSegments));

    return request.copyWith(
      uri: baseUri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": finampUserHelper.authorizationHeader,
      },
    );
  }
}

/// Creates the X-Emby-Authorization header
Future<String> getAuthHeader() async {
  final notAsciiRegex = RegExp(r'[^\x00-\x7F]+');

  final finampUserHelper = GetIt.instance<FinampUserHelper>();

  String authHeader = "MediaBrowser ";

  if (finampUserHelper.currentUser != null) {
    authHeader = '${authHeader}UserId="${finampUserHelper.currentUser!.id}", ';
  }

  if (finampUserHelper.currentUser?.accessToken != null) {
    authHeader =
        '${authHeader}Token="${finampUserHelper.currentUser!.accessToken}", ';
  }

  authHeader = '${authHeader}Client="Finamp", ';

  final deviceInfo = await getDeviceInfo();
  authHeader =
      '${authHeader}Device="${deviceInfo.name}",DeviceId="${deviceInfo.id}", ';

  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  authHeader = '${authHeader}Version="${packageInfo.version}"';

  // In some cases non-ASCII characters can end up in the header, usually via
  // iOS device name
  return authHeader.replaceAll(notAsciiRegex, "_");
}

// return type for deviceInfo

Future<DeviceInfo> getDeviceInfo() async {
  DeviceInfo info;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String idExtension = kDebugMode
      ? "debug"
      : kProfileMode
          ? "profile"
          : "";
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
    final appSetId = await AppSetId().getIdentifier();
    info = DeviceInfo(
      name: androidDeviceInfo.model,
      id: "$appSetId-$idExtension",
    );
  } else if (Platform.isIOS) {
    IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
    final appSetId = await AppSetId().getIdentifier();
    info = DeviceInfo(
      name: iosDeviceInfo.name,
      id: "$appSetId-$idExtension",
    );
  } else if (Platform.isWindows) {
    WindowsDeviceInfo windowsDeviceInfo = await deviceInfo.windowsInfo;
    final windowsId = windowsDeviceInfo.deviceId;
    info = DeviceInfo(
      name: windowsDeviceInfo.computerName,
      id: "$windowsId-$idExtension",
    );
  } else if (Platform.isLinux) {
    LinuxDeviceInfo linuxDeviceInfo = await deviceInfo.linuxInfo;
    final linuxId = linuxDeviceInfo.machineId;
    info = DeviceInfo(
      name: linuxDeviceInfo.name,
      id: "$linuxId-$idExtension",
    );
  } else if (Platform.isMacOS) {
    MacOsDeviceInfo macOsDeviceInfo = await deviceInfo.macOsInfo;
    final macId = macOsDeviceInfo.systemGUID;
    info = DeviceInfo(
      name: macOsDeviceInfo.computerName,
      id: "$macId-$idExtension",
    );
  } else {
    throw Exception("Unsupported platform");
  }
  return info;
}
