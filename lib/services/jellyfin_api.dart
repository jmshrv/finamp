import 'dart:io' show Platform;

import 'package:android_id/android_id.dart';
import 'package:chopper/chopper.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:finamp/services/http_aggregate_logging_interceptor.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../models/jellyfin_models.dart';
import 'finamp_user_helper.dart';
import 'jellyfin_api_helper.dart';

part 'jellyfin_api.chopper.dart';

const String defaultFields =
    "parentId,indexNumber,songCount,childCount,providerIds,genres,tags,Etag,albumPrimaryImageTag,parentPrimaryImageItemId";

@ChopperApi()
abstract class JellyfinApi extends ChopperService {
  @FactoryConverter(
    request: JsonConverter.requestFactory,
    response: JsonConverter.responseFactory,
  )
  @Get(path: "/Users/Public")
  Future<dynamic> getPublicUsers();

  @FactoryConverter(
    request: JsonConverter.requestFactory,
    response: JsonConverter.responseFactory,
  )
  @Post(path: "/Users/AuthenticateByName")
  Future<dynamic> authenticateViaName(
      @Body() Map<String, String> usernameAndPassword);

  @FactoryConverter(
    request: JsonConverter.requestFactory,
    response: JsonConverter.responseFactory,
  )
  @Get(path: "/Items/{id}/Images/Primary")
  Future<dynamic> getAlbumPrimaryImage({
    @Path() required String id,
    @Query() String format = "webp",
  });

  @FactoryConverter(
    request: JsonConverter.requestFactory,
    response: JsonConverter.responseFactory,
  )
  @Get(path: "/Users/{id}/Views")
  Future<dynamic> getViews(@Path() String id);

  @FactoryConverter(
    request: JsonConverter.requestFactory,
    response: JsonConverter.responseFactory,
  )
  @Get(path: "/Users/{userId}/Items")
  Future<dynamic> getItems({
    /// The user id supplied as query parameter.
    @Path() required String userId,

    /// Optional. If specified, results will be filtered based on the item type.
    /// This allows multiple, comma delimeted.
    @Query("IncludeItemTypes") String? includeItemTypes,

    /// Specify this to localize the search to a specific item or folder. Omit
    /// to use the root.
    @Query("ParentId") String? parentId,

    /// Optional. If specified, results will be filtered to include only those
    /// containing the specified album artist id.
    @Query("AlbumArtistIds") String? albumArtistIds,

    /// Optional. If specified, results will be filtered to include only those
    /// containing the specified artist id.
    @Query("ArtistIds") String? artistIds,

    /// Optional. If specified, results will be filtered to include only those
    /// containing the specified album id.
    @Query("AlbumIds") String? albumIds,

    @Query("ids") String? ids,

    /// When searching within folders, this determines whether or not the search
    /// will be recursive. true/false.
    @Query("Recursive") bool? recursive,

    /// Optional. Specify one or more sort orders, comma delimited. Options:
    /// Album, AlbumArtist, Artist, Budget, CommunityRating, CriticRating,
    /// DateCreated, DatePlayed, PlayCount, PremiereDate, ProductionYear,
    /// SortName, Random, Revenue, Runtime.
    @Query("SortBy") String? sortBy,

    /// Items Enum: "Ascending" "Descending"
    /// Sort Order - Ascending,Descending.
    @Query("SortOrder") String? sortOrder,

    /// Items Enum: "AirTime" "CanDelete" "CanDownload" "ChannelInfo" "Chapters"
    /// "ChildCount" "CumulativeRunTimeTicks" "CustomRating" "DateCreated"
    /// "DateLastMediaAdded" "DisplayPreferencesId" "Etag" "ExternalUrls"
    /// "Genres" "HomePageUrl" "ItemCounts" "MediaSourceCount" "MediaSources"
    /// "OriginalTitle" "Overview" "ParentId" "Path" "People" "PlayAccess"
    /// "ProductionLocations" "ProviderIds" "PrimaryImageAspectRatio"
    /// "RecursiveItemCount" "Settings" "ScreenshotImageTags"
    /// "SeriesPrimaryImage" "SeriesStudio" "SortName" "SpecialEpisodeNumbers"
    /// "Studios" "BasicSyncInfo" "SyncInfo" "Taglines" "Tags" "RemoteTrailers"
    /// "MediaStreams" "SeasonUserData" "ServiceName" "ThemeSongIds"
    /// "ThemeVideoIds" "ExternalEtag" "PresentationUniqueKey"
    /// "InheritedParentalRatingValue" "ExternalSeriesId"
    /// "SeriesPresentationUniqueKey" "DateLastRefreshed" "DateLastSaved"
    /// "RefreshState" "ChannelImage" "EnableMediaSourceDisplay" "Width"
    /// "Height" "ExtraIds" "LocalTrailerCount" "IsHD" "SpecialFeatureCount"
    @Query("Fields") String? fields = defaultFields,

    /// Optional. Filter based on a search term.
    @Query("SearchTerm") String? searchTerm,

    /// Optional. If specified, results will be filtered based on genre id. This
    /// allows multiple, pipe delimited.
    @Query("GenreIds") String? genreIds,

    /// Items Enum: "IsFolder" "IsNotFolder" "IsUnplayed" "IsPlayed"
    /// "IsFavorite" "IsResumable" "Likes" "Dislikes" "IsFavoriteOrLikes"
    /// Optional. Specify additional filters to apply. This allows multiple,
    /// comma delimited. Options: IsFolder, IsNotFolder, IsUnplayed, IsPlayed,
    /// IsFavorite, IsResumable, Likes, Dislikes.
    @Query("Filters") String? filters,

    /// Optional. The record index to start at. All items with a lower index
    /// will be dropped from the results.
    @Query("StartIndex") int? startIndex,

    /// Optional. The maximum number of records to return.
    @Query("Limit") int? limit,
  });

  @FactoryConverter(
    request: JsonConverter.requestFactory,
    response: JsonConverter.responseFactory,
  )
  @Get(path: "/Items/{id}/InstantMix")
  Future<dynamic> getInstantMix({
    @Path() required String id,
    @Query() required String userId,
    @Query() required int limit,
  });

  @FactoryConverter(
    request: JsonConverter.requestFactory,
    response: JsonConverter.responseFactory,
  )
  @Get(path: "/Users/{userId}/Items/{itemId}")
  Future<dynamic> getItemById({
    /// User id.
    @Path() required String userId,

    /// Item id.
    @Path() required String itemId,
  });

  @FactoryConverter(
    request: JsonConverter.requestFactory,
    response: JsonConverter.responseFactory,
  )
  @Get(path: "/Items/{id}/PlaybackInfo")
  Future<dynamic> getPlaybackInfo({
    @Path() required String id,
    @Query() required String userId,
  });

  @FactoryConverter(
    request: JsonConverter.requestFactory,
  )
  @Post(path: "/Items/{itemId}")
  Future<dynamic> updateItem({
    /// The item id.
    @Path() required String itemId,
    @Body() required BaseItemDto newItem,
  });

  @FactoryConverter(request: JsonConverter.requestFactory)
  @Post(path: "/Sessions/Playing")
  Future<dynamic> startPlayback(
      @Body() PlaybackProgressInfo playbackProgressInfo);

  @FactoryConverter(request: JsonConverter.requestFactory)
  @Post(path: "/Sessions/Playing/Progress")
  Future<dynamic> playbackStatusUpdate(
      @Body() PlaybackProgressInfo playbackProgressInfo);

  @FactoryConverter(request: JsonConverter.requestFactory)
  @Post(path: "/Sessions/Playing/Stopped")
  Future<dynamic> playbackStatusStopped(
      @Body() PlaybackProgressInfo playbackProgressInfo);

  @FactoryConverter(
    request: JsonConverter.requestFactory,
    response: JsonConverter.responseFactory,
  )
  @Get(path: "/Playlists/{playlistId}/Items")
  Future<dynamic> getPlaylistItems({
    @Path() required String playlistId,
    @Query("UserId") required String userId,
    @Query("IncludeItemTypes") String? includeItemTypes,
    @Query("ParentId") String? parentId,
    @Query("Recursive") bool? recursive,
    @Query("Fields") String? fields = defaultFields,
  });

  /// Creates a new playlist.
  @FactoryConverter(
    request: JsonConverter.requestFactory,
    response: JsonConverter.responseFactory,
  )
  @Post(path: "/Playlists")
  Future<dynamic> createNewPlaylist({
    /// The create playlist payload.
    @Body() required NewPlaylist newPlaylist,
  });

  /// Adds items to a playlist.
  @FactoryConverter(request: JsonConverter.requestFactory)
  @Post(path: "/Playlists/{playlistId}/Items", optionalBody: true)
  Future<Response> addItemsToPlaylist({
    /// The playlist id.
    @Path() required String playlistId,

    /// Item id, comma delimited.
    @Query() String? ids,

    /// The userId.
    @Query() String? userId,
  });

  /// Remove items from a playlist.
  @FactoryConverter(request: JsonConverter.requestFactory)
  @Delete(path: "/Playlists/{playlistId}/Items", optionalBody: true)
  Future<Response> removeItemsFromPlaylist({
    /// The playlist id.
    @Path() required String playlistId,

    /// Item id, comma delimited.
    @Query() String? entryIds,
  });

  @FactoryConverter(
    request: JsonConverter.requestFactory,
    response: JsonConverter.responseFactory,
  )
  @Get(path: "/Artists/AlbumArtists")
  Future<dynamic> getAlbumArtists({
    @Query("IncludeItemTypes") String? includeItemTypes,
    @Query("ParentId") String? parentId,
    @Query("Recursive") bool? recursive,

    /// Optional. Specify one or more sort orders, comma delimited. Options:
    /// Album, AlbumArtist, Artist, Budget, CommunityRating, CriticRating,
    /// DateCreated, DatePlayed, PlayCount, PremiereDate, ProductionYear,
    /// SortName, Random, Revenue, Runtime.
    @Query("SortBy") String? sortBy,

    /// Items Enum: "Ascending" "Descending"
    /// Sort Order - Ascending,Descending.
    @Query("SortOrder") String? sortOrder,
    @Query("Fields") String? fields = defaultFields,
    @Query("SearchTerm") String? searchTerm,
    @Query("EnableUserData") bool enableUserData = true,

    /// Items Enum: "IsFolder" "IsNotFolder" "IsUnplayed" "IsPlayed"
    /// "IsFavorite" "IsResumable" "Likes" "Dislikes" "IsFavoriteOrLikes"
    /// Optional. Specify additional filters to apply.
    @Query("Filters") String? filters,

    /// Optional. The record index to start at. All items with a lower index
    /// will be dropped from the results.
    @Query("StartIndex") int? startIndex,

    /// Optional. The maximum number of records to return.
    @Query("Limit") int? limit,

    /// User id. Technically nullable in the Jellyfin API docs, but getting
    /// favourited artists will break if this is not given.
    @Query("UserId") required String userId,
  });

  /// Gets all genres from a given item, folder, or the entire library.
  @FactoryConverter(
    request: JsonConverter.requestFactory,
    response: JsonConverter.responseFactory,
  )
  @Get(path: "/Genres")
  Future<dynamic> getGenres({
    /// Optional. If specified, results will be filtered based on the item type.
    /// This allows multiple, comma delimeted.
    @Query("IncludeItemTypes") String? includeItemTypes,

    /// Specify this to localize the search to a specific item or folder. Omit
    /// to use the root.
    @Query("ParentId") String? parentId,

    /// Items Enum: "AirTime" "CanDelete" "CanDownload" "ChannelInfo" "Chapters"
    /// "ChildCount" "CumulativeRunTimeTicks" "CustomRating" "DateCreated"
    /// "DateLastMediaAdded" "DisplayPreferencesId" "Etag" "ExternalUrls"
    /// "Genres" "HomePageUrl" "ItemCounts" "MediaSourceCount" "MediaSources"
    /// "OriginalTitle" "Overview" "ParentId" "Path" "People" "PlayAccess"
    /// "ProductionLocations" "ProviderIds" "PrimaryImageAspectRatio"
    /// "RecursiveItemCount" "Settings" "ScreenshotImageTags"
    /// "SeriesPrimaryImage" "SeriesStudio" "SortName" "SpecialEpisodeNumbers"
    /// "Studios" "BasicSyncInfo" "SyncInfo" "Taglines" "Tags" "RemoteTrailers"
    /// "MediaStreams" "SeasonUserData" "ServiceName" "ThemeSongIds"
    /// "ThemeVideoIds" "ExternalEtag" "PresentationUniqueKey"
    /// "InheritedParentalRatingValue" "ExternalSeriesId"
    /// "SeriesPresentationUniqueKey" "DateLastRefreshed" "DateLastSaved"
    /// "RefreshState" "ChannelImage" "EnableMediaSourceDisplay" "Width"
    /// "Height" "ExtraIds" "LocalTrailerCount" "IsHD" "SpecialFeatureCount"
    @Query("Fields") String? fields = defaultFields,

    /// Optional. Filter based on a search term.
    @Query("SearchTerm") String? searchTerm,

    /// Optional. The record index to start at. All items with a lower index
    /// will be dropped from the results.
    @Query("StartIndex") int? startIndex,

    /// Optional. The maximum number of records to return.
    @Query("Limit") int? limit,
  });

  /// Marks an item as a favorite.
  @FactoryConverter(
    request: JsonConverter.requestFactory,
    response: JsonConverter.responseFactory,
  )
  @Post(path: "/Users/{userId}/FavoriteItems/{itemId}", optionalBody: true)
  Future<dynamic> addFavourite({
    /// User id.
    @Path() required String userId,

    /// Item id.
    @Path() required String itemId,
  });

  /// Unmarks item as a favorite.
  @FactoryConverter(
    request: JsonConverter.requestFactory,
    response: JsonConverter.responseFactory,
  )
  @Delete(path: "/Users/{userId}/FavoriteItems/{itemId}")
  Future<dynamic> removeFavourite({
    /// User id.
    @Path() required String userId,

    /// Item id.
    @Path() required String itemId,
  });

  /// Reports that a session has ended.
  @FactoryConverter(
    request: JsonConverter.requestFactory,
  )
  @Post(path: "/Sessions/Logout", optionalBody: true)
  Future<dynamic> logout();

  static JellyfinApi create() {
    final chopperHttpLogLevel = Level
        .body; //TODO allow changing the log level in settings (and a debug config file?)

    final client = ChopperClient(
      // The first part of the URL is now here
      services: [
        // The generated implementation
        _$JellyfinApi(),
      ],
      // Converts data to & from JSON and adds the application/json header.
      // converter: JsonConverter(),
      interceptors: [
        /// Gets baseUrl from SharedPreferences.
        (Request request) async {
          final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
          final finampUserHelper = GetIt.instance<FinampUserHelper>();

          String authHeader = await getAuthHeader();
          String? tokenHeader = jellyfinApiHelper.getTokenHeader();

          // If baseUrlTemp is null, use the baseUrl of the current user.
          // If baseUrlTemp is set, we're setting up a new user and should use it instead.
          Uri baseUri = jellyfinApiHelper.baseUrlTemp ??
              Uri.parse(finampUserHelper.currentUser!.baseUrl);

          // Add the request path on to the baseUrl
          baseUri = baseUri.replace(
              pathSegments:
                  baseUri.pathSegments.followedBy(request.uri.pathSegments));

          // tokenHeader will be null if the user isn't logged in.
          // If we send a null tokenHeader while logging in, the login will always fail.
          if (tokenHeader == null) {
            return request.copyWith(
              uri: baseUri,
              headers: {
                "Content-Type": "application/json",
                "X-Emby-Authorization": authHeader,
              },
            );
          } else {
            return request.copyWith(
              uri: baseUri,
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
        HttpAggregateLoggingInterceptor(level: chopperHttpLogLevel),
      ],
    );

    // The generated class with the ChopperClient passed in
    return _$JellyfinApi(client);
  }
}

/// Creates the X-Emby-Authorization header
Future<String> getAuthHeader() async {
  final notAsciiRegex = RegExp(r'[^\x00-\x7F]+');

  final finampUserHelper = GetIt.instance<FinampUserHelper>();

  String authHeader = "MediaBrowser ";

  if (finampUserHelper.currentUser != null) {
    authHeader = '${authHeader}UserId="${finampUserHelper.currentUser!.id}", ';
  }

  authHeader = '${authHeader}Client="Finamp", ';
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
    authHeader = '${authHeader}Device="${androidDeviceInfo.model}", ';
    final androidId = await const AndroidId().getId();
    authHeader = '${authHeader}DeviceId="$androidId", ';
  } else if (Platform.isIOS) {
    IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
    authHeader = '${authHeader}Device="${iosDeviceInfo.name}", ';
    authHeader =
        '${authHeader}DeviceId="${iosDeviceInfo.identifierForVendor}", ';
  } else {
    throw "getAuthHeader() only supports Android and iOS";
  }

  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  authHeader = '${authHeader}Version="${packageInfo.version}"';

  // In some cases non-ASCII characters can end up in the header, usually via
  // iOS device name
  return authHeader.replaceAll(notAsciiRegex, "_");
}
