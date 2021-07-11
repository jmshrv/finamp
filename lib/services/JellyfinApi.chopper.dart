// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'JellyfinApi.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$JellyfinApi extends JellyfinApi {
  _$JellyfinApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = JellyfinApi;

  @override
  Future<dynamic> getPublicUsers() {
    final $url = '/Users/Public';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send($request,
        requestConverter: JsonConverter.requestFactory,
        responseConverter: JsonConverter.responseFactory);
  }

  @override
  Future<dynamic> authenticateViaName(Map<String, String> usernameAndPassword) {
    final $url = '/Users/AuthenticateByName';
    final $body = usernameAndPassword;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send($request,
        requestConverter: JsonConverter.requestFactory,
        responseConverter: JsonConverter.responseFactory);
  }

  @override
  Future<dynamic> getAlbumPrimaryImage(
      {required String id, String format = "webp"}) {
    final $url = '/Items/$id/Images/Primary';
    final $params = <String, dynamic>{'format': format};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send($request,
        requestConverter: JsonConverter.requestFactory,
        responseConverter: JsonConverter.responseFactory);
  }

  @override
  Future<dynamic> getViews(String id) {
    final $url = '/Users/$id/Views';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send($request,
        requestConverter: JsonConverter.requestFactory,
        responseConverter: JsonConverter.responseFactory);
  }

  @override
  Future<dynamic> getItems(
      {required String userId,
      String? includeItemTypes,
      String? parentId,
      String? albumArtistIds,
      bool? recursive,
      String? sortBy,
      String? sortOrder,
      String? fields = defaultFields,
      String? searchTerm,
      String? genreIds,
      String? filters,
      int? startIndex,
      int? limit}) {
    final $url = '/Users/$userId/Items';
    final $params = <String, dynamic>{
      'IncludeItemTypes': includeItemTypes,
      'ParentId': parentId,
      'AlbumArtistIds': albumArtistIds,
      'Recursive': recursive,
      'SortBy': sortBy,
      'SortOrder': sortOrder,
      'Fields': fields,
      'SearchTerm': searchTerm,
      'GenreIds': genreIds,
      'Filters': filters,
      'StartIndex': startIndex,
      'Limit': limit
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send($request,
        requestConverter: JsonConverter.requestFactory,
        responseConverter: JsonConverter.responseFactory);
  }

  @override
  Future<dynamic> getItemById(
      {required String userId, required String itemId}) {
    final $url = '/Users/$userId/Items/$itemId';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send($request,
        requestConverter: JsonConverter.requestFactory,
        responseConverter: JsonConverter.responseFactory);
  }

  @override
  Future<dynamic> getPlaybackInfo(
      {required String id, required String userId}) {
    final $url = '/Items/$id/PlaybackInfo';
    final $params = <String, dynamic>{'userId': userId};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send($request,
        requestConverter: JsonConverter.requestFactory,
        responseConverter: JsonConverter.responseFactory);
  }

  @override
  Future<dynamic> updateItem(
      {required String itemId, required BaseItemDto newItem}) {
    final $url = '/Items/$itemId';
    final $body = newItem;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send($request,
        requestConverter: JsonConverter.requestFactory);
  }

  @override
  Future<dynamic> startPlayback(PlaybackProgressInfo playbackProgressInfo) {
    final $url = '/Sessions/Playing';
    final $body = playbackProgressInfo;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send($request,
        requestConverter: JsonConverter.requestFactory);
  }

  @override
  Future<dynamic> playbackStatusUpdate(
      PlaybackProgressInfo playbackProgressInfo) {
    final $url = '/Sessions/Playing/Progress';
    final $body = playbackProgressInfo;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send($request,
        requestConverter: JsonConverter.requestFactory);
  }

  @override
  Future<dynamic> playbackStatusStopped(
      PlaybackProgressInfo playbackProgressInfo) {
    final $url = '/Sessions/Playing/Stopped';
    final $body = playbackProgressInfo;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send($request,
        requestConverter: JsonConverter.requestFactory);
  }

  @override
  Future<dynamic> getPlaylistItems(
      {required String playlistId,
      required String userId,
      String? includeItemTypes,
      String? parentId,
      bool? recursive,
      String? fields = defaultFields}) {
    final $url = '/Playlists/$playlistId/Items';
    final $params = <String, dynamic>{
      'UserId': userId,
      'IncludeItemTypes': includeItemTypes,
      'ParentId': parentId,
      'Recursive': recursive,
      'Fields': fields
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send($request,
        requestConverter: JsonConverter.requestFactory,
        responseConverter: JsonConverter.responseFactory);
  }

  @override
  Future<dynamic> createNewPlaylist({required NewPlaylist newPlaylist}) {
    final $url = '/Playlists';
    final $body = newPlaylist;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send($request,
        requestConverter: JsonConverter.requestFactory,
        responseConverter: JsonConverter.responseFactory);
  }

  @override
  Future<Response<dynamic>> addItemsToPlaylist(
      {required String playlistId, String? ids, String? userId}) {
    final $url = '/Playlists/$playlistId/Items';
    final $params = <String, dynamic>{'ids': ids, 'userId': userId};
    final $request = Request('POST', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request,
        requestConverter: JsonConverter.requestFactory);
  }

  @override
  Future<dynamic> getAlbumArtists(
      {String? includeItemTypes,
      String? parentId,
      bool? recursive,
      String? sortBy,
      String? sortOrder,
      String? fields = defaultFields,
      String? searchTerm,
      bool enableUserData = true,
      String? filters,
      int? startIndex,
      int? limit}) {
    final $url = '/Artists/AlbumArtists';
    final $params = <String, dynamic>{
      'IncludeItemTypes': includeItemTypes,
      'ParentId': parentId,
      'Recursive': recursive,
      'SortBy': sortBy,
      'SortOrder': sortOrder,
      'Fields': fields,
      'searchTerm': searchTerm,
      'enableUserData': enableUserData,
      'Filters': filters,
      'StartIndex': startIndex,
      'Limit': limit
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send($request,
        requestConverter: JsonConverter.requestFactory,
        responseConverter: JsonConverter.responseFactory);
  }

  @override
  Future<dynamic> getGenres(
      {String? includeItemTypes,
      String? parentId,
      String? fields = defaultFields,
      String? searchTerm,
      int? startIndex,
      int? limit}) {
    final $url = '/Genres';
    final $params = <String, dynamic>{
      'IncludeItemTypes': includeItemTypes,
      'ParentId': parentId,
      'Fields': fields,
      'SearchTerm': searchTerm,
      'StartIndex': startIndex,
      'Limit': limit
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send($request,
        requestConverter: JsonConverter.requestFactory,
        responseConverter: JsonConverter.responseFactory);
  }

  @override
  Future<dynamic> addFavourite(
      {required String userId, required String itemId}) {
    final $url = '/Users/$userId/FavoriteItems/$itemId';
    final $request = Request('POST', $url, client.baseUrl);
    return client.send($request,
        requestConverter: JsonConverter.requestFactory,
        responseConverter: JsonConverter.responseFactory);
  }

  @override
  Future<dynamic> removeFavourite(
      {required String userId, required String itemId}) {
    final $url = '/Users/$userId/FavoriteItems/$itemId';
    final $request = Request('DELETE', $url, client.baseUrl);
    return client.send($request,
        requestConverter: JsonConverter.requestFactory,
        responseConverter: JsonConverter.responseFactory);
  }

  @override
  Future<dynamic> logout() {
    final $url = '/Sessions/Logout';
    final $request = Request('POST', $url, client.baseUrl);
    return client.send($request,
        requestConverter: JsonConverter.requestFactory);
  }
}
