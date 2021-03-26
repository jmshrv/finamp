import 'dart:convert';
import 'dart:io' show Platform;

import 'package:chopper/chopper.dart';
import 'package:device_info/device_info.dart';
import 'package:finamp/models/JellyfinModels.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'JellyfinApi.dart';
import '../models/FinampModels.dart';

class JellyfinApiData {
  JellyfinApi jellyfinApi = JellyfinApi.create();
  Box<FinampUser> _finampUserBox = Hive.box("FinampUsers");
  Box<String> _currentUserIdBox = Hive.box("CurrentUserId");

  String baseUrlTemp;

  /// Checks if there are any saved users.
  bool get isUsersEmpty => _finampUserBox.isEmpty;

  /// Loads the FinampUser with the id from CurrentUserId. Returns null if no user exists.
  FinampUser get currentUser =>
      _finampUserBox.get(_currentUserIdBox.get("CurrentUserId"));

  /// Saves a new user to the Hive box and sets the CurrentUserId.
  Future<void> saveUser(FinampUser newUser) async {
    print("Saving new user");
    await Future.wait([
      _finampUserBox.put(newUser.userDetails.user.id, newUser),
      _currentUserIdBox.put("CurrentUserId", newUser.userDetails.user.id),
    ]);
  }

  /// Saves the view for the given userId.
  Future<void> saveView(BaseItemDto newView, String userId) async {
    print("Saving view");

    FinampUser userTemp = _finampUserBox.get(userId);

    if (userTemp == null)
      return Future.error("Could not find user with id $userId");

    currentUser.view = newView;
    await _finampUserBox.put(userId, userTemp);
  }

  Future<List<BaseItemDto>> getItems(
      {@required BaseItemDto parentItem,
      String includeItemTypes,
      String sortBy,
      String searchTerm}) async {
    Response response;

    // We send a different request for playlists so that we get them back in the right order.
    // Doing this in the same function makes sense since they both return the same thing.
    // It also means we can easily share album widgets with playlists.
    if (parentItem.type == "Playlist") {
      response = await jellyfinApi.getPlaylistItems(
          playlistId: parentItem.id,
          userId: currentUser.userDetails.user.id,
          parentId: parentItem.id,
          includeItemTypes: includeItemTypes,
          recursive: true,
          sortBy: sortBy);
    } else if (includeItemTypes == "MusicArtist") {
      // For artists, we need to use a different endpoint
      response = await jellyfinApi.getArtists(
        parentId: parentItem.id,
        recursive: true,
        sortBy: sortBy,
      );
    } else if (parentItem.type == "MusicArtist") {
      // For getting the children of artists, we need to use albumArtistIds instead of parentId
      response = await jellyfinApi.getItems(
          userId: currentUser.userDetails.user.id,
          albumArtistIds: parentItem.id,
          includeItemTypes: includeItemTypes,
          recursive: true,
          sortBy: sortBy,
          searchTerm: searchTerm);
    } else {
      // This will be run when getting albums, songs in albums, and stuff like that.
      response = await jellyfinApi.getItems(
          userId: currentUser.userDetails.user.id,
          parentId: parentItem.id,
          includeItemTypes: includeItemTypes,
          recursive: true,
          sortBy: sortBy,
          searchTerm: searchTerm);
    }

    if (response.isSuccessful) {
      return (QueryResult_BaseItemDto.fromJson(response.body).items);
    } else {
      return Future.error(response.error);
    }
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
      AuthenticationResult newUserAuthenticationResult =
          AuthenticationResult.fromJson(response.body);

      FinampUser newUser = FinampUser(
        baseUrl: baseUrlTemp,
        userDetails: newUserAuthenticationResult,
        view: null,
      );

      await saveUser(newUser);
    } else {
      return Future.error(response.error);
    }
  }

  /// Gets all the user's views with the type "music".
  Future<List<BaseItemDto>> getMusicViews() async {
    Response response =
        await jellyfinApi.getViews(currentUser.userDetails.user.id);

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
    Response response = await jellyfinApi.getPlaybackInfo(
        id: itemId, userId: currentUser.userDetails.user.id);

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
    String authHeader = "MediaBrowser ";

    if (currentUser != null) {
      authHeader = authHeader + 'UserId="${currentUser.userDetails.user.id}", ';
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
    if (currentUser == null) {
      return null;
    } else {
      return currentUser.userDetails.accessToken;
    }
  }
}
