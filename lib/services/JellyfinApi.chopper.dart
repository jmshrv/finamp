// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'JellyfinApi.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$JellyfinApi extends JellyfinApi {
  _$JellyfinApi([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = JellyfinApi;

  @override
  Future<dynamic> getPublicUsers() {
    final $url = '/Users/Public';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send($request);
  }

  @override
  Future<dynamic> authenticateViaName(Map<String, String> usernameAndPassword) {
    final $url = '/Users/AuthenticateByName';
    final $body = usernameAndPassword;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send($request);
  }

  @override
  Future<dynamic> getAlbumPrimaryImage({String id, String format}) {
    final $url = '/Items/$id/Images/Primary';
    final $params = <String, dynamic>{'format': format};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send($request);
  }

  @override
  Future<dynamic> getViews(String id) {
    final $url = '/Users/$id/Views';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send($request);
  }

  @override
  Future<dynamic> getItems(
      {String userId,
      String includeItemTypes,
      String parentId,
      bool recursive,
      String sortBy}) {
    final $url = '/Users/$userId/Items';
    final $params = <String, dynamic>{
      'IncludeItemTypes': includeItemTypes,
      'ParentId': parentId,
      'Recursive': recursive,
      'SortBy': sortBy
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send($request);
  }
}
