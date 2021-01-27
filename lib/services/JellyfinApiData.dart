import 'dart:convert';
import 'dart:io' show Platform;

import 'package:chopper/chopper.dart';
import 'package:device_info/device_info.dart';
import 'package:finamp/models/JellyfinModels.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'JellyfinApi.dart';

class JellyfinApiData {
  JellyfinApi jellyfinApi = JellyfinApi.create();
  AuthenticationResult _currentUser;
  BaseItemDto _view;
  String _baseUrl;

  /// Loads the current user from SharedPreferences if loaded for the first time or from this class if it exists. Returns null if there is no user.
  Future<AuthenticationResult> getCurrentUser() async {
    if (_currentUser != null) {
      print("Getting user from memory");
      return _currentUser;
    }

    print("Getting user from SharedPreferences");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String currentUserJson = sharedPreferences.getString("currentUser");

    if (currentUserJson == null) {
      print("User didn't exist in SharedPreferences, returning null");
      return null;
    }

    // We set _currentUser in this class to the value loaded from SharedPreferences because loading it every time we need it (which is on every API request) is very inefficient.
    _currentUser = AuthenticationResult.fromJson(jsonDecode(currentUserJson));
    return _currentUser;
  }

  /// Saves a new user to SharedPreferences and sets the variable in this class.
  Future<void> saveUser(AuthenticationResult newUser) async {
    print("Saving new user");
    _currentUser = newUser;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("currentUser", jsonEncode(newUser));
  }

  /// Gets the chosen view. Usually the user's music view.
  Future<BaseItemDto> getView() async {
    if (_view != null) {
      print("Getting view from memory");
      return _view;
    }

    print("Getting view from SharedPreferences");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String viewJson = sharedPreferences.getString("view");

    if (viewJson == null) {
      return null;
    }

    _view = BaseItemDto.fromJson(jsonDecode(viewJson));
    return _view;
  }

  Future<void> saveView(BaseItemDto newView) async {
    print("Saving view");
    _view = newView;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("view", jsonEncode(newView));
  }

  Future<List<BaseItemDto>> getItems(
      {@required BaseItemDto parentItem,
      String includeItemTypes,
      String sortBy}) async {
    AuthenticationResult currentUser = await getCurrentUser();
    Response response = await jellyfinApi.getItems(
        userId: currentUser.user.id,
        parentId: parentItem.id,
        includeItemTypes: includeItemTypes,
        recursive: true,
        sortBy: sortBy);

    if (response.isSuccessful) {
      return (QueryResult_BaseItemDto.fromJson(response.body).items);
    } else {
      return Future.error(response.error);
    }
  }

  Future<String> getBaseUrl() async {
    if (_baseUrl != null) {
      print("Getting baseUrl from memory");
      return _baseUrl;
    }

    print("Getting baseUrl from SharedPreferences");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _baseUrl = sharedPreferences.getString("baseUrl");
    return _baseUrl;
  }

  Future<void> saveBaseUrl(String protocol, String address) async {
    // Formats the protocol and the address like a proper URL
    String newBaseUrl = "$protocol://$address";
    _baseUrl = newBaseUrl;

    print("Saving baseUrl to SharedPreferences");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("baseUrl", newBaseUrl);
  }

  /// Authenticates a user and saves the login details
  Future<void> authenticateViaName(
      {@required String username, String password}) async {
    Response response;

    // Some users won't have a password.
    if (password == null) {
      response = await jellyfinApi.authenticateViaName({"Username": username});
    } else {
      response = await jellyfinApi
          .authenticateViaName({"Username": username, "Pw": password});
    }

    if (response.isSuccessful) {
      AuthenticationResult newUser =
          AuthenticationResult.fromJson(response.body);
      await saveUser(newUser);
    } else {
      return Future.error(response.error);
    }
  }

  /// Gets all the user's views with the type "music".
  Future<List<BaseItemDto>> getMusicViews() async {
    Response response = await jellyfinApi.getViews(_currentUser.user.id);

    if (response.isSuccessful) {
      // This converts the list of items into a usable list of BaseItemDtos.
      List<BaseItemDto> viewList = [];
      for (final i in response.body["Items"]) {
        if (i["CollectionType"] == "music") {
          viewList.add(BaseItemDto.fromJson(i));
        }
      }
      return viewList;
    } else {
      return Future.error(response.error);
    }
  }

  /// Gets the playback info for an item, such as format and bitrate. Usually, I'd require a BaseItemDto as an argument
  /// but since this will be run inside of [MusicPlayerBackgroundTask], I've just set the raw id as an argument.
  Future<List<MediaSourceInfo>> getPlaybackInfo(String itemId) async {
    AuthenticationResult currentUser = await getCurrentUser();
    Response response = await jellyfinApi.getPlaybackInfo(
        id: itemId, userId: currentUser.user.id);

    if (response.isSuccessful) {
      // getPlaybackInfo returns a PlaybackInfoResponse. We only need the List<MediaSourceInfo> in it so we convert it here and
      // return that List<MediaSourceInfo>.
      final PlaybackInfoResponse decodedResponse =
          PlaybackInfoResponse.fromJson(response.body);
      return decodedResponse.mediaSources;
    } else {
      return Future.error(response.error);
    }
  }

  /// Tells the Jellyfin server that playback has started
  Future<Response> reportPlaybackStart(
      PlaybackProgressInfo playbackProgressInfo) async {
    Response response = await jellyfinApi.startPlayback(playbackProgressInfo);

    if (response.isSuccessful) {
      return response;
    } else {
      return Future.error(response.error);
    }
  }

  /// Updates player progress so that Jellyfin can track what we're listening to
  Future<Response> updatePlaybackProgress(
      PlaybackProgressInfo playbackProgressInfo) async {
    Response response =
        await jellyfinApi.playbackStatusUpdate(playbackProgressInfo);

    if (response.isSuccessful) {
      return response;
    } else {
      return Future.error(response.error);
    }
  }

  /// Tells Jellyfin that we've stopped listening to music (called when the audio service is stopped)
  Future<Response> stopPlaybackProgress(
      PlaybackProgressInfo playbackProgressInfo) async {
    Response response =
        await jellyfinApi.playbackStatusStopped(playbackProgressInfo);

    if (response.isSuccessful) {
      return response;
    } else {
      return Future.error(response.error);
    }
  }

  /// Creates the X-Emby-Authorization header
  Future<String> getAuthHeader() async {
    AuthenticationResult currentUser = await getCurrentUser();

    String authHeader = "MediaBrowser ";

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

  /// Creates the X-Emby-Token header
  Future<String> getTokenHeader() async {
    AuthenticationResult currentUser = await getCurrentUser();

    if (currentUser == null) {
      return null;
    } else {
      return currentUser.accessToken;
    }
  }

  /// Returns the baseUrl straight from the variable.
  ///
  /// This should NOT be used unless absolutely necessary.
  /// This is only used in AlbumImage since the alternative
  /// was making every AlbumImage stateful, which was a performance issue.
  String get baseUrlFromVariable => _baseUrl;
}
