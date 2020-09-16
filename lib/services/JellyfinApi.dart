import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:chopper/chopper.dart';
import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/JellyfinModels.dart';

part 'JellyfinApi.chopper.dart';

@ChopperApi()
abstract class JellyfinApi extends ChopperService {
  AuthenticationResult currentUser;

  /// Creates the X-Emby-Authorization header
  Future<String> getAuthHeader() async {
    String authHeader = "Jellyfin ";
    // authHeader = authHeader + "MediaBrowser ";

    if (currentUser != null) {
      authHeader = authHeader + 'UserId="${currentUser.user.id}", ';
    }

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      authHeader = authHeader + 'Client="Android", ';
      authHeader = authHeader + 'Device="${androidDeviceInfo.model}", ';
      authHeader = authHeader + 'DeviceId="${androidDeviceInfo.androidId}", ';
    } else if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      authHeader = authHeader + 'Client="iOS", ';
      authHeader = authHeader + 'Device="${iosDeviceInfo.utsname.machine}", ';
      authHeader =
          authHeader + 'DeviceId="${iosDeviceInfo.identifierForVendor}", ';
    } else {
      throw "getAuthHeader() only supports Android and iOS";
    }

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    authHeader = authHeader + 'Version="${packageInfo.version}"';
    return authHeader;
  }

  @Get(path: "/Users/Public")
  Future<List<UserDto>> getPublicUsers();

  @Post(path: "/Users/AuthenticateByName")
  Future<AuthenticationResult> authenticateViaName(
      @Body() Map<String, String> usernameAndPassword);

  // TODO: Implement
  Widget getProfilePicture() => Icon(Icons.person);

  // TODO: Implement
  Widget getAlbumPrimaryImage() => Icon(Icons.album);

  @Get(path: "/Users/{id}/Views")
  Future<QueryResult_BaseItemDto> getViews(@Path() String id);

  @Get(
      path:
          "/Users/{id}/Items?Recursive=true&IncludeItemTypes=MusicAlbum&ParentId={view}&SortBy=SortName&SortOrder=Ascending")
  Future<QueryResult_BaseItemDto> getAlbums(
      @Path() String id, @Path() String view);

  static JellyfinApi create() {
    final client = ChopperClient(
      // The first part of the URL is now here
      services: [
        // The generated implementation
        _$JellyfinApi(),
      ],
      // Converts data to & from JSON and adds the application/json header.
      converter: JsonSerializableConverter({
        Resource: Resource.fromJsonFactory,
      }),
      interceptors: [
        HttpLoggingInterceptor(),

        /// Gets baseUrl from SharedPreferences.
        (Request request) async {
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          return sharedPreferences.containsKey('baseUrl')
              ? request.copyWith(
                  baseUrl: sharedPreferences.getString('baseUrl'))
              : request;
        },

        /// Adds X-Emby-Authentication header
        (Request request) async {
          return request.copyWith(
              headers: {"X-Emby-Authentication": await getAuthHeader()});
        }
      ],
    );

    // The generated class with the ChopperClient passed in
    return _$JellyfinApi(client);
  }
}

// This is the json_serializable converter shit that I really don't understand and just copied from Chopper's GitHub
typedef T JsonFactory<T>(Map<String, dynamic> json);

class JsonSerializableConverter extends JsonConverter {
  final Map<Type, JsonFactory> factories;

  JsonSerializableConverter(this.factories);

  T _decodeMap<T>(Map<String, dynamic> values) {
    /// Get jsonFactory using Type parameters
    /// if not found or invalid, throw error or return null
    final jsonFactory = factories[T];
    if (jsonFactory == null || jsonFactory is! JsonFactory<T>) {
      /// throw serializer not found error;
      return null;
    }

    return jsonFactory(values);
  }

  List<T> _decodeList<T>(List values) =>
      values.where((v) => v != null).map<T>((v) => _decode<T>(v)).toList();

  dynamic _decode<T>(entity) {
    if (entity is Iterable) return _decodeList<T>(entity);

    if (entity is Map) return _decodeMap<T>(entity);

    return entity;
  }

  @override
  Response<ResultType> convertResponse<ResultType, Item>(Response response) {
    // use [JsonConverter] to decode json
    final jsonRes = super.convertResponse(response);

    return jsonRes.copyWith<ResultType>(body: _decode<Item>(jsonRes.body));
  }

  @override
  // all objects should implements toJson method
  Request convertRequest(Request request) => super.convertRequest(request);
}
