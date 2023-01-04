// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jellyfin_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$JellyfinApi extends JellyfinApi {
  _$JellyfinApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = JellyfinApi;

  @override
  Future<dynamic> getPublicUsers() {
    final String $url = '/Users/Public';
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send(
      $request,
      requestConverter: JsonConverter.requestFactory,
      responseConverter: JsonConverter.responseFactory,
    );
  }

  @override
  Future<dynamic> authenticateViaName(Map<String, String> usernameAndPassword) {
    final String $url = '/Users/AuthenticateByName';
    final $body = usernameAndPassword;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send(
      $request,
      requestConverter: JsonConverter.requestFactory,
      responseConverter: JsonConverter.responseFactory,
    );
  }

  @override
  Future<dynamic> getAlbumPrimaryImage({
    required String id,
    String format = "webp",
  }) {
    final String $url = '/Items/${id}/Images/Primary';
    final Map<String, dynamic> $params = <String, dynamic>{'format': format};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send(
      $request,
      requestConverter: JsonConverter.requestFactory,
      responseConverter: JsonConverter.responseFactory,
    );
  }

  @override
  Future<dynamic> getViews(String id) {
    final String $url = '/Users/${id}/Views';
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send(
      $request,
      requestConverter: JsonConverter.requestFactory,
      responseConverter: JsonConverter.responseFactory,
    );
  }

  @override
  Future<dynamic> getItems({
    required String userId,
    String? includeItemTypes,
    String? parentId,
    String? albumArtistIds,
    String? artistIds,
    String? albumIds,
    bool? recursive,
    String? sortBy,
    String? sortOrder,
    String? fields = defaultFields,
    String? searchTerm,
    String? genreIds,
    String? filters,
    int? startIndex,
    int? limit,
  }) {
    final String $url = '/Users/${userId}/Items';
    final Map<String, dynamic> $params = <String, dynamic>{
      'IncludeItemTypes': includeItemTypes,
      'ParentId': parentId,
      'AlbumArtistIds': albumArtistIds,
      'ArtistIds': artistIds,
      'AlbumIds': albumIds,
      'Recursive': recursive,
      'SortBy': sortBy,
      'SortOrder': sortOrder,
      'Fields': fields,
      'SearchTerm': searchTerm,
      'GenreIds': genreIds,
      'Filters': filters,
      'StartIndex': startIndex,
      'Limit': limit,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send(
      $request,
      requestConverter: JsonConverter.requestFactory,
      responseConverter: JsonConverter.responseFactory,
    );
  }

  @override
  Future<dynamic> getInstantMix({
    required String id,
    required String userId,
    required int limit,
  }) {
    final String $url = '/Items/${id}/InstantMix';
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'limit': limit,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send(
      $request,
      requestConverter: JsonConverter.requestFactory,
      responseConverter: JsonConverter.responseFactory,
    );
  }

  @override
  Future<dynamic> getItemById({
    required String userId,
    required String itemId,
  }) {
    final String $url = '/Users/${userId}/Items/${itemId}';
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send(
      $request,
      requestConverter: JsonConverter.requestFactory,
      responseConverter: JsonConverter.responseFactory,
    );
  }

  @override
  Future<dynamic> getPlaybackInfo({
    required String id,
    required String userId,
  }) {
    final String $url = '/Items/${id}/PlaybackInfo';
    final Map<String, dynamic> $params = <String, dynamic>{'userId': userId};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send(
      $request,
      requestConverter: JsonConverter.requestFactory,
      responseConverter: JsonConverter.responseFactory,
    );
  }

  @override
  Future<dynamic> updateItem({
    required String itemId,
    required BaseItemDto newItem,
  }) {
    final String $url = '/Items/${itemId}';
    final $body = newItem;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send(
      $request,
      requestConverter: JsonConverter.requestFactory,
    );
  }

  @override
  Future<dynamic> startPlayback(PlaybackProgressInfo playbackProgressInfo) {
    final String $url = '/Sessions/Playing';
    final $body = playbackProgressInfo;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send(
      $request,
      requestConverter: JsonConverter.requestFactory,
    );
  }

  @override
  Future<dynamic> playbackStatusUpdate(
      PlaybackProgressInfo playbackProgressInfo) {
    final String $url = '/Sessions/Playing/Progress';
    final $body = playbackProgressInfo;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send(
      $request,
      requestConverter: JsonConverter.requestFactory,
    );
  }

  @override
  Future<dynamic> playbackStatusStopped(
      PlaybackProgressInfo playbackProgressInfo) {
    final String $url = '/Sessions/Playing/Stopped';
    final $body = playbackProgressInfo;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send(
      $request,
      requestConverter: JsonConverter.requestFactory,
    );
  }

  @override
  Future<dynamic> getPlaylistItems({
    required String playlistId,
    required String userId,
    String? includeItemTypes,
    String? parentId,
    bool? recursive,
    String? fields = defaultFields,
  }) {
    final String $url = '/Playlists/${playlistId}/Items';
    final Map<String, dynamic> $params = <String, dynamic>{
      'UserId': userId,
      'IncludeItemTypes': includeItemTypes,
      'ParentId': parentId,
      'Recursive': recursive,
      'Fields': fields,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send(
      $request,
      requestConverter: JsonConverter.requestFactory,
      responseConverter: JsonConverter.responseFactory,
    );
  }

  @override
  Future<dynamic> createNewPlaylist({required NewPlaylist newPlaylist}) {
    final String $url = '/Playlists';
    final $body = newPlaylist;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send(
      $request,
      requestConverter: JsonConverter.requestFactory,
      responseConverter: JsonConverter.responseFactory,
    );
  }

  @override
  Future<Response<dynamic>> addItemsToPlaylist({
    required String playlistId,
    String? ids,
    String? userId,
  }) {
    final String $url = '/Playlists/${playlistId}/Items';
    final Map<String, dynamic> $params = <String, dynamic>{
      'ids': ids,
      'userId': userId,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>(
      $request,
      requestConverter: JsonConverter.requestFactory,
    );
  }

  @override
  Future<dynamic> getAlbumArtists({
    String? includeItemTypes,
    String? parentId,
    bool? recursive,
    String? sortBy,
    String? sortOrder,
    String? fields = defaultFields,
    String? searchTerm,
    bool enableUserData = true,
    String? filters,
    int? startIndex,
    int? limit,
    required String userId,
  }) {
    final String $url = '/Artists/AlbumArtists';
    final Map<String, dynamic> $params = <String, dynamic>{
      'IncludeItemTypes': includeItemTypes,
      'ParentId': parentId,
      'Recursive': recursive,
      'SortBy': sortBy,
      'SortOrder': sortOrder,
      'Fields': fields,
      'SearchTerm': searchTerm,
      'EnableUserData': enableUserData,
      'Filters': filters,
      'StartIndex': startIndex,
      'Limit': limit,
      'UserId': userId,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send(
      $request,
      requestConverter: JsonConverter.requestFactory,
      responseConverter: JsonConverter.responseFactory,
    );
  }

  @override
  Future<dynamic> getGenres({
    String? includeItemTypes,
    String? parentId,
    String? fields = defaultFields,
    String? searchTerm,
    int? startIndex,
    int? limit,
  }) {
    final String $url = '/Genres';
    final Map<String, dynamic> $params = <String, dynamic>{
      'IncludeItemTypes': includeItemTypes,
      'ParentId': parentId,
      'Fields': fields,
      'SearchTerm': searchTerm,
      'StartIndex': startIndex,
      'Limit': limit,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send(
      $request,
      requestConverter: JsonConverter.requestFactory,
      responseConverter: JsonConverter.responseFactory,
    );
  }

  @override
  Future<dynamic> addFavourite({
    required String userId,
    required String itemId,
  }) {
    final String $url = '/Users/${userId}/FavoriteItems/${itemId}';
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send(
      $request,
      requestConverter: JsonConverter.requestFactory,
      responseConverter: JsonConverter.responseFactory,
    );
  }

  @override
  Future<dynamic> removeFavourite({
    required String userId,
    required String itemId,
  }) {
    final String $url = '/Users/${userId}/FavoriteItems/${itemId}';
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send(
      $request,
      requestConverter: JsonConverter.requestFactory,
      responseConverter: JsonConverter.responseFactory,
    );
  }

  @override
  Future<dynamic> logout() {
    final String $url = '/Sessions/Logout';
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send(
      $request,
      requestConverter: JsonConverter.requestFactory,
    );
  }
}
