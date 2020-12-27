import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:chopper/chopper.dart';
import 'package:device_info/device_info.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/JellyfinModels.dart';
import 'JellyfinApiData.dart';

part 'JellyfinApi.chopper.dart';

@ChopperApi()
abstract class JellyfinApi extends ChopperService {
  // @Get(path: "/Users/Public")
  // Future<List<UserDto>> getPublicUsers();

  @Get(path: "/Users/Public")
  Future<dynamic> getPublicUsers();

  // @Post(path: "/Users/AuthenticateByName")
  // Future<AuthenticationResult> authenticateViaName(
  //     @Body() Map<String, String> usernameAndPassword);

  @Post(path: "/Users/AuthenticateByName")
  Future<dynamic> authenticateViaName(
      @Body() Map<String, String> usernameAndPassword);

  @Get(path: "/Items/{id}/Images/Primary")
  Future<dynamic> getAlbumPrimaryImage(
      {@Path() String id, @Query() String format});

  // @Get(path: "/Users/{id}/Views")
  // Future<QueryResult_BaseItemDto> getViews(@Path() String id);

  @Get(path: "/Users/{id}/Views")
  Future<dynamic> getViews(@Path() String id);

  @Get(path: "/Users/{userId}/Items")
  Future<dynamic> getItems(
      {@Path() String userId,
      @Query("IncludeItemTypes") String includeItemTypes,
      @required @Query("ParentId") String parentId,
      @Query("Recursive") bool recursive,
      @Query("SortBy") String sortBy,
      @Query("Fields") String fields = "parentId,indexNumber,songCount"});

  @Get(path: "/Items/{id}/PlaybackInfo")
  Future<dynamic> getPlaybackInfo({@Path() String id, @Query() String userId});

  static JellyfinApi create() {
    final client = ChopperClient(
      // The first part of the URL is now here
      services: [
        // The generated implementation
        _$JellyfinApi(),
      ],
      // Converts data to & from JSON and adds the application/json header.
      converter: JsonConverter(),
      interceptors: [
        /// Gets baseUrl from SharedPreferences.
        (Request request) async {
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          String authHeader = await getAuthHeader();
          String tokenHeader = await getTokenHeader();

          // tokenHeader will be null if the user isn't logged in.
          // If we send a null tokenHeader while logging in, the login will always fail.
          if (tokenHeader == null) {
            return request.copyWith(
              baseUrl: sharedPreferences.getString('baseUrl'),
              headers: {
                "Content-Type": "application/json",
                "X-Emby-Authorization": authHeader,
              },
            );
          } else {
            return request.copyWith(
              baseUrl: sharedPreferences.getString('baseUrl'),
              headers: {
                "Content-Type": "application/json",
                "X-Emby-Authorization": authHeader,
                "X-Emby-Token": tokenHeader,
              },
            );
          }
        },

        /// Adds X-Emby-Authentication header
        // (Request request) async {
        //   return request.copyWith(
        //       headers: {"X-Emby-Authentication": await getAuthHeader()});
        // },
        HttpLoggingInterceptor(),
      ],
    );

    // The generated class with the ChopperClient passed in
    return _$JellyfinApi(client);
  }
}

/// Creates the X-Emby-Authorization header
Future<String> getAuthHeader() async {
  JellyfinApiData jellyfinApiData = GetIt.instance<JellyfinApiData>();
  AuthenticationResult currentUser = await jellyfinApiData.getCurrentUser();

  String authHeader = "MediaBrowser ";

  if (currentUser != null) {
    authHeader = authHeader + 'UserId="${currentUser.user.id}", ';
  }

  authHeader = authHeader + 'Client="Finamp", ';
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
    authHeader = authHeader + 'Device="${androidDeviceInfo.model}", ';
    authHeader = authHeader + 'DeviceId="${androidDeviceInfo.androidId}", ';
  } else if (Platform.isIOS) {
    IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
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

/// Creates the X-Emby-Token header
Future<String> getTokenHeader() async {
  JellyfinApiData jellyfinApiData = GetIt.instance<JellyfinApiData>();
  AuthenticationResult currentUser = await jellyfinApiData.getCurrentUser();

  if (currentUser == null) {
    return null;
  } else {
    return currentUser.accessToken;
  }
}
