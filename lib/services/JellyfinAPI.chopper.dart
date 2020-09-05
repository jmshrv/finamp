// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'JellyfinAPI.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$JellyfinAPIService extends JellyfinAPIService {
  _$JellyfinAPIService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = JellyfinAPIService;

  @override
  Future<List<UserDto>> getPublicUsers() {
    final $url = '/Users/Public';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<UserDto, UserDto>($request);
  }
}
