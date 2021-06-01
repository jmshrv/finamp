import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:chopper/chopper.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../models/JellyfinModels.dart';
import 'JellyfinApiData.dart';

part 'JellyfinApi.chopper.dart';

const String defaultFields = "parentId,indexNumber,songCount,childCount";

@ChopperApi()
abstract class JellyfinApi extends ChopperService {
  @Get(path: "/Users/Public")
  Future<dynamic> getPublicUsers();

  @Post(path: "/Users/AuthenticateByName")
  Future<dynamic> authenticateViaName(
      @Body() Map<String, String> usernameAndPassword);

  @Get(path: "/Items/{id}/Images/Primary")
  Future<dynamic> getAlbumPrimaryImage(
      {@Path() String id, @Query() String format});

  @Get(path: "/Users/{id}/Views")
  Future<dynamic> getViews(@Path() String id);

  @Get(path: "/Users/{userId}/Items")
  Future<dynamic> getItems({
    @Path() String userId,
    @Query("IncludeItemTypes") String includeItemTypes,
    @Query("ParentId") String parentId,
    @Query("AlbumArtistIds") String albumArtistIds,
    @Query("Recursive") bool recursive,
    @Query("SortBy") String sortBy,
    @Query("Fields") String fields = defaultFields,
    @Query("searchTerm") String searchTerm,
  });

  @Get(path: "/Items/{id}/PlaybackInfo")
  Future<dynamic> getPlaybackInfo({@Path() String id, @Query() String userId});

  @Post(path: "/Sessions/Playing")
  Future<dynamic> startPlayback(
      @Body() PlaybackProgressInfo playbackProgressInfo);

  @Post(path: "/Sessions/Playing/Progress")
  Future<dynamic> playbackStatusUpdate(
      @Body() PlaybackProgressInfo playbackProgressInfo);

  @Post(path: "/Sessions/Playing/Stopped")
  Future<dynamic> playbackStatusStopped(
      @Body() PlaybackProgressInfo playbackProgressInfo);

  @Get(path: "/Playlists/{playlistId}/Items")
  Future<dynamic> getPlaylistItems(
      {@Path() @required String playlistId,
      @Query("UserId") @required String userId,
      @Query("IncludeItemTypes") String includeItemTypes,
      @required @Query("ParentId") String parentId,
      @Query("Recursive") bool recursive,
      @Query("SortBy") String sortBy,
      @Query("Fields") String fields = defaultFields});

  @Get(path: "/Artists/AlbumArtists")
  Future<dynamic> getAlbumArtists({
    @Query("IncludeItemTypes") String includeItemTypes,
    @required @Query("ParentId") String parentId,
    @Query("Recursive") bool recursive,
    @Query("SortBy") String sortBy,
    @Query("Fields") String fields = "parentId,indexNumber,songCount",
    @Query("searchTerm") String searchTerm,
  });

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
          JellyfinApiData jellyfinApiData = GetIt.instance<JellyfinApiData>();

          String authHeader = await getAuthHeader();
          String tokenHeader = getTokenHeader();

          // If baseUrlTemp is null, use the baseUrl of the current user.
          // If baseUrlTemp is set, we're setting up a new user and should use it instead.
          String baseUrl = jellyfinApiData.baseUrlTemp == null
              ? jellyfinApiData.currentUser.baseUrl
              : jellyfinApiData.baseUrlTemp;

          // tokenHeader will be null if the user isn't logged in.
          // If we send a null tokenHeader while logging in, the login will always fail.
          if (tokenHeader == null) {
            return request.copyWith(
              baseUrl: baseUrl,
              headers: {
                "Content-Type": "application/json",
                "X-Emby-Authorization": authHeader,
              },
            );
          } else {
            return request.copyWith(
              baseUrl: baseUrl,
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
  return await jellyfinApiData.getAuthHeader();
}

/// Creates the X-Emby-Token header
String getTokenHeader() {
  // TODO: Why do we have two "get token header" functions?
  JellyfinApiData jellyfinApiData = GetIt.instance<JellyfinApiData>();

  if (jellyfinApiData.currentUser == null) {
    return null;
  } else {
    return jellyfinApiData.currentUser.userDetails.accessToken;
  }
}
