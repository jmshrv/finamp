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
  Future<List<UserDto>> getPublicUsers() {
    final $url = '/Users/Public';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<UserDto, UserDto>($request);
  }

  @override
  Future<AuthenticationResult> authenticateViaName(
      Map<String, String> usernameAndPassword) {
    final $url = '/Users/AuthenticateByName';
    final $body = usernameAndPassword;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send($request);
  }

  @override
  Future<QueryResult_BaseItemDto> getViews(String id) {
    final $url = '/Users/$id/Views';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send($request);
  }

  @override
  Future<QueryResult_BaseItemDto> getAlbums(String id, String view) {
    final $url =
        '/Users/$id/Items?Recursive=true&IncludeItemTypes=MusicAlbum&ParentId=$view&SortBy=SortName&SortOrder=Ascending';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send($request);
  }
}
