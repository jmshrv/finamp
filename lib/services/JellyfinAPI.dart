import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';

part 'JellyfinAPI.g.dart';

class JellyfinAPI {
  String address;
  String protocol;

  UserDto currentUser;

  String authHeader;

  /// Creates the X-Emby-Authorization header
  Future<String> getAuthHeader() async {
    String authHeader = "MediaBrowser ";
    // authHeader = authHeader + "MediaBrowser ";

    if (currentUser != null) {
      authHeader = authHeader + 'UserId="${currentUser.id}", ';
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

  /// Retrieves a list of public users.
  Future<List<UserDto>> publicUsers() async {
    http.Response response = await http.get(
      "$protocol://$address/Users/Public",
      headers: {"Content-Type": "application/json"},
    );

    List<dynamic> publicUserListJson = jsonDecode(response.body);

    List<UserDto> publicUserList = [];
    for (var publicUserJson in publicUserListJson) {
      publicUserList.add(UserDto.fromJson(publicUserJson));
    }

    return publicUserList;
  }

  /// Gets the profile picture of the given user. If the user doesn't have a profile picture, a "person" icon is returned.
  Widget getProfilePicture(
      {@required UserDto user,
      int maxWidth,
      int maxHeight,
      String format = "png"}) {
    if (user.primaryImageTag == null) {
      return Icon(
        Icons.person,
      );
    } else {
      // Ink.image is used here so that it renders properly with an Inkwell (used on login screen)
      return Ink.image(
        image: NetworkImage(
          "$protocol://$address/Users/${user.id}/Images/Primary",
          headers: {
            "MaxWidth": maxWidth.toString(),
            "MaxHeight": maxHeight.toString(),
            "Format":
                format // Jellyfin likes to return WebP, which caused images to take ages to come from my low-powered server.
          },
        ),
        fit: BoxFit.cover,
      );
    }
  }

  /// Authenticates the user via their username
  Future authenticateViaName(
      {@required String username, String password}) async {
    http.Response response;

    // Accounts that don't have passwords don't need the password value in the body
    if (password == null) {
      response = await http.post(
          "$protocol://$address/Users/AuthenticateByName",
          headers: {"X-Emby-Authorization": await getAuthHeader()},
          body: {"Username": username});
    } else {
      response = await http.post(
          "$protocol://$address/Users/AuthenticateByName",
          headers: {"X-Emby-Authorization": await getAuthHeader()},
          body: {"Username": username, "Pw": password});
    }

    if (response.statusCode == 401) {
      throw ("Incorrect username or password (${response.statusCode})");
    } else if (response.statusCode != 200) {
      throw ("Login returned status code ${response.statusCode}: ${response.body}");
    }

    AuthenticationResult authenticationResult =
        AuthenticationResult.fromJson(jsonDecode(response.body));

    currentUser = authenticationResult.user;
  }
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class UserDto {
  UserDto(
      this.name,
      this.serverId,
      this.serverName,
      this.connectUserName,
      this.connectLinkType,
      this.id,
      this.primaryImageTag,
      this.hasPassword,
      this.hasConfiguredPassword,
      this.hasConfiguredEasyPassword,
      this.enableAutoLogin,
      this.lastActivityDate,
      this.configuration,
      this.policy,
      this.primaryImageAspectRatio);

  String name;
  String serverId;
  String serverName;
  String connectUserName;
  String connectLinkType;
  String id;
  String primaryImageTag;
  bool hasPassword;
  bool hasConfiguredPassword;
  bool hasConfiguredEasyPassword;
  bool enableAutoLogin;
  String lastLoginDate;
  String lastActivityDate;
  UserConfiguration configuration;
  UserPolicy policy;
  double primaryImageAspectRatio;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class UserConfiguration {
  UserConfiguration(
      this.audioLanguagePreference,
      this.playDefaultAudioTrack,
      this.subtitleLanguagePreference,
      this.displayMissingEpisodes,
      this.groupedFolders,
      this.subtitleMode,
      this.displayCollectionsView,
      this.enableLocalPassword,
      this.orderedViews,
      this.latestItemsExcludes,
      this.myMediaExcludes,
      this.hidePlayedInLatest,
      this.rememberAudioSelections,
      this.rememberSubtitleSelections,
      this.enableNextEpisodeAutoPlay);

  String audioLanguagePreference;
  bool playDefaultAudioTrack;
  String subtitleLanguagePreference;
  bool displayMissingEpisodes;
  List<String> groupedFolders;
  String subtitleMode;
  bool displayCollectionsView;
  bool enableLocalPassword;
  List<String> orderedViews;
  List<String> latestItemsExcludes;
  List<String> myMediaExcludes;
  bool hidePlayedInLatest;
  bool rememberAudioSelections;
  bool rememberSubtitleSelections;
  bool enableNextEpisodeAutoPlay;

  factory UserConfiguration.fromJson(Map<String, dynamic> json) =>
      _$UserConfigurationFromJson(json);
  Map<String, dynamic> toJson() => _$UserConfigurationToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class UserPolicy {
  UserPolicy(
      this.isAdministrator,
      this.isHidden,
      this.isHiddenRemotely,
      this.isDisabled,
      this.maxParentalRating,
      this.blockedTags,
      this.enableUserPreferenceAccess,
      this.accessSchedules,
      this.blockUnratedItems,
      this.enableRemoteControlOfOtherUsers,
      this.enableSharedDeviceControl,
      this.enableRemoteAccess,
      this.enableLiveTvManagement,
      this.enableLiveTvAccess,
      this.enableMediaPlayback,
      this.enableAudioPlaybackTranscoding,
      this.enableVideoPlaybackTranscoding,
      this.enablePlaybackRemuxing,
      this.enableContentDeletion,
      this.enableContentDeletionFromFolders,
      this.enableContentDownloading,
      this.enableSubtitleDownloading,
      this.enableSubtitleManagement,
      this.enableSyncTranscoding,
      this.enableMediaConversion,
      this.enabledDevices,
      this.enableAllDevices,
      this.enabledChannels,
      this.enableAllChannels,
      this.enabledFolders,
      this.enableAllFolders,
      this.invalidLoginAttemptCount,
      this.enablePublicSharing,
      this.blockedMediaFolders,
      this.blockedChannels,
      this.remoteClientBitrateLimit,
      this.authenticationProviderId,
      this.excludedSubFolders,
      this.disablePremiumFeatures);

  bool isAdministrator;
  bool isHidden;
  bool isHiddenRemotely;
  bool isDisabled;
  int maxParentalRating;
  List<String> blockedTags;
  bool enableUserPreferenceAccess;
  List<AccessSchedule> accessSchedules;
  List<String> blockUnratedItems;
  bool enableRemoteControlOfOtherUsers;
  bool enableSharedDeviceControl;
  bool enableRemoteAccess;
  bool enableLiveTvManagement;
  bool enableLiveTvAccess;
  bool enableMediaPlayback;
  bool enableAudioPlaybackTranscoding;
  bool enableVideoPlaybackTranscoding;
  bool enablePlaybackRemuxing;
  bool enableContentDeletion;
  List<String> enableContentDeletionFromFolders;
  bool enableContentDownloading;
  bool enableSubtitleDownloading;
  bool enableSubtitleManagement;
  bool enableSyncTranscoding;
  bool enableMediaConversion;
  List<String> enabledDevices;
  bool enableAllDevices;
  List<String> enabledChannels;
  bool enableAllChannels;
  List<String> enabledFolders;
  bool enableAllFolders;
  int invalidLoginAttemptCount;
  bool enablePublicSharing;
  List<String> blockedMediaFolders;
  List<String> blockedChannels;
  int remoteClientBitrateLimit;
  String authenticationProviderId;
  List<String> excludedSubFolders;
  bool disablePremiumFeatures;

  factory UserPolicy.fromJson(Map<String, dynamic> json) =>
      _$UserPolicyFromJson(json);
  Map<String, dynamic> toJson() => _$UserPolicyToJson(this);
}

@JsonSerializable()
class AccessSchedule {
  AccessSchedule(this.dayOfWeek, this.startHour, this.endHour);

  String dayOfWeek;
  double startHour;
  double endHour;

  factory AccessSchedule.fromJson(Map<String, dynamic> json) =>
      _$AccessScheduleFromJson(json);
  Map<String, dynamic> toJson() => _$AccessScheduleToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class AuthenticationResult {
  AuthenticationResult(
      this.user, this.sessionInfo, this.accessToken, this.serverId);

  UserDto user;
  SessionInfo sessionInfo;
  String accessToken;
  String serverId;

  factory AuthenticationResult.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationResultFromJson(json);
  Map<String, dynamic> toJson() => _$AuthenticationResultToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class SessionInfo {
  SessionInfo(
      this.playState,
      this.additionalUsers,
      this.capabilities,
      this.remoteEndPoint,
      this.playableMediaTypes,
      this.playlistItemId,
      this.id,
      this.serverId,
      this.userId,
      this.userName,
      this.userPrimaryImageTag,
      this.client,
      this.lastActivityDate,
      this.deviceName,
      this.deviceType,
      this.nowPlayingItem,
      this.deviceId,
      this.appIconUrl,
      this.supportedCommands,
      this.supportsRemoteControl);

  PlayerStateInfo playState;
  List<SessionUserInfo> additionalUsers;
  ClientCapabilities capabilities;
  String remoteEndPoint;
  List<String> playableMediaTypes;
  String playlistItemId;
  String id;
  String serverId;
  String userId;
  String userName;
  String userPrimaryImageTag;
  String client;
  String lastActivityDate;
  String deviceName;
  String deviceType;
  BaseItemDto nowPlayingItem;
  String deviceId;
  String appIconUrl;
  List<String> supportedCommands;
  TranscodingInfo transcodingInfo;
  bool supportsRemoteControl;

  factory SessionInfo.fromJson(Map<String, dynamic> json) =>
      _$SessionInfoFromJson(json);
  Map<String, dynamic> toJson() => _$SessionInfoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class TranscodingInfo {
  TranscodingInfo(
      this.audioCodec,
      this.videoCodec,
      this.container,
      this.isVideoDirect,
      this.isAudioDirect,
      this.bitrate,
      this.framerate,
      this.completionPercentage,
      this.transcodingPositionTicks,
      this.transcodingStartPositionTicks,
      this.width,
      this.height,
      this.audioChannels,
      this.transcodeReasons,
      this.currentCpuUsage,
      this.averageCpuUsage,
      this.cpuHistory,
      this.currentThrottle,
      this.videoDecoder,
      this.videoDecoderIsHardware,
      this.videoDecoderMediaType,
      this.videoDecoderHwAccel,
      this.videoEncoder,
      this.videoEncoderIsHardware,
      this.videoEncoderMediaType,
      this.videoEncoderHwAccel);

  String audioCodec;
  String videoCodec;
  String container;
  bool isVideoDirect;
  bool isAudioDirect;
  int bitrate;
  double framerate;
  double completionPercentage;
  double transcodingPositionTicks;
  double transcodingStartPositionTicks;
  int width;
  int height;
  int audioChannels;
  List<String> transcodeReasons;
  double currentCpuUsage;
  double averageCpuUsage;
  List<Map<String, double>> cpuHistory;
  int currentThrottle;
  String videoDecoder;
  bool videoDecoderIsHardware;
  String videoDecoderMediaType;
  String videoDecoderHwAccel;
  String videoEncoder;
  bool videoEncoderIsHardware;
  String videoEncoderMediaType;
  String videoEncoderHwAccel;

  factory TranscodingInfo.fromJson(Map<String, dynamic> json) =>
      _$TranscodingInfoFromJson(json);
  Map<String, dynamic> toJson() => _$TranscodingInfoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class PlayerStateInfo {
  PlayerStateInfo(
      this.positionTicks,
      this.canSeek,
      this.isPaused,
      this.isMuted,
      this.volumeLevel,
      this.audioStreamIndex,
      this.subtitleStreamIndex,
      this.mediaSourceId,
      this.playMethod,
      this.repeatMode);

  int positionTicks;
  bool canSeek;
  bool isPaused;
  bool isMuted;
  int volumeLevel;
  int audioStreamIndex;
  int subtitleStreamIndex;
  String mediaSourceId;
  String playMethod;
  String repeatMode;

  factory PlayerStateInfo.fromJson(Map<String, dynamic> json) =>
      _$PlayerStateInfoFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerStateInfoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class SessionUserInfo {
  SessionUserInfo(this.userId, this.userName, this.userInternalId);

  String userId;
  String userName;
  int userInternalId;

  factory SessionUserInfo.fromJson(Map<String, dynamic> json) =>
      _$SessionUserInfoFromJson(json);
  Map<String, dynamic> toJson() => _$SessionUserInfoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class ClientCapabilities {
  ClientCapabilities(
      this.playableMediaTypes,
      this.supportedCommands,
      this.supportsMediaControl,
      this.pushToken,
      this.pushTokenType,
      this.supportsPersistentIdentifier,
      this.supportsSync,
      this.deviceProfile,
      this.iconUrl,
      this.appId);

  List<String> playableMediaTypes;
  List<String> supportedCommands;
  bool supportsMediaControl;
  String pushToken;
  String pushTokenType;
  bool supportsPersistentIdentifier;
  bool supportsSync;
  DeviceProfile deviceProfile;
  String iconUrl;
  String appId;

  factory ClientCapabilities.fromJson(Map<String, dynamic> json) =>
      _$ClientCapabilitiesFromJson(json);
  Map<String, dynamic> toJson() => _$ClientCapabilitiesToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class DeviceProfile {
  DeviceProfile(
      this.name,
      this.id,
      this.identification,
      this.friendlyName,
      this.manufacturer,
      this.manufacturerUrl,
      this.modelName,
      this.modelDescription,
      this.modelNumber,
      this.modelUrl,
      this.serialNumber,
      this.enableAlbumArtInDidl,
      this.enableSingleAlbumArtLimit,
      this.enableSingleSubtitleLimit,
      this.supportedMediaTypes,
      this.userId,
      this.albumArtPn,
      this.maxAlbumArtWidth,
      this.maxAlbumArtHeight,
      this.maxIconWidth,
      this.maxIconHeight,
      this.maxStreamingBitrate,
      this.maxStaticBitrate,
      this.musicStreamingTranscodingBitrate,
      this.maxStaticMusicBitrate,
      this.sonyAggregationFlags,
      this.protocolInfo,
      this.timelineOffsetSeconds,
      this.requiresPlainVideoItems,
      this.requiresPlainFolders,
      this.enableMSMediaReceiverRegistrar,
      this.ignoreTranscodeByteRangeRequests,
      this.xmlRootAttributes,
      this.directPlayProfiles,
      this.transcodingProfiles,
      this.containerProfiles,
      this.codecProfiles,
      this.responseProfiles,
      this.subtitleProfiles);

  String name;
  String id;
  DeviceIdentification identification;
  String friendlyName;
  String manufacturer;
  String manufacturerUrl;
  String modelName;
  String modelDescription;
  String modelNumber;
  String modelUrl;
  String serialNumber;
  bool enableAlbumArtInDidl;
  bool enableSingleAlbumArtLimit;
  bool enableSingleSubtitleLimit;
  String supportedMediaTypes;
  String userId;
  String albumArtPn;
  int maxAlbumArtWidth;
  int maxAlbumArtHeight;
  int maxIconWidth;
  int maxIconHeight;
  int maxStreamingBitrate;
  int maxStaticBitrate;
  int musicStreamingTranscodingBitrate;
  int maxStaticMusicBitrate;
  String sonyAggregationFlags;
  String protocolInfo;
  int timelineOffsetSeconds;
  bool requiresPlainVideoItems;
  bool requiresPlainFolders;
  bool enableMSMediaReceiverRegistrar;
  bool ignoreTranscodeByteRangeRequests;
  List<XmlAttribute> xmlRootAttributes;
  List<DirectPlayProfile> directPlayProfiles;
  List<TranscodingProfile> transcodingProfiles;
  List<ContainerProfile> containerProfiles;
  List<CodecProfile> codecProfiles;
  List<ResponseProfile> responseProfiles;
  List<SubtitleProfile> subtitleProfiles;

  factory DeviceProfile.fromJson(Map<String, dynamic> json) =>
      _$DeviceProfileFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceProfileToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class DeviceIdentification {
  DeviceIdentification(
      this.friendlyName,
      this.modelNumber,
      this.serialNumber,
      this.modelName,
      this.modelDescription,
      this.deviceDescription,
      this.modelUrl,
      this.manufacturer,
      this.manufacturerUrl,
      this.headers);

  String friendlyName;
  String modelNumber;
  String serialNumber;
  String modelName;
  String modelDescription;
  String deviceDescription;
  String modelUrl;
  String manufacturer;
  String manufacturerUrl;
  List<HttpHeaderInfo> headers;

  factory DeviceIdentification.fromJson(Map<String, dynamic> json) =>
      _$DeviceIdentificationFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceIdentificationToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class HttpHeaderInfo {
  HttpHeaderInfo(this.name, this.value, this.match);

  String name;
  String value;
  String match;

  factory HttpHeaderInfo.fromJson(Map<String, dynamic> json) =>
      _$HttpHeaderInfoFromJson(json);
  Map<String, dynamic> toJson() => _$HttpHeaderInfoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class XmlAttribute {
  XmlAttribute(this.name, this.value);

  String name;
  String value;

  factory XmlAttribute.fromJson(Map<String, dynamic> json) =>
      _$XmlAttributeFromJson(json);
  Map<String, dynamic> toJson() => _$XmlAttributeToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class DirectPlayProfile {
  DirectPlayProfile(
      this.container, this.audioCodec, this.videoCodec, this.type);

  String container;
  String audioCodec;
  String videoCodec;
  String type;

  factory DirectPlayProfile.fromJson(Map<String, dynamic> json) =>
      _$DirectPlayProfileFromJson(json);
  Map<String, dynamic> toJson() => _$DirectPlayProfileToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class TranscodingProfile {
  TranscodingProfile(
      this.container,
      this.type,
      this.videoCodec,
      this.audioCodec,
      this.protocol,
      this.estimateContentLength,
      this.enableMpegtsM2TsMode,
      this.transcodeSeekInfo,
      this.copyTimestamps,
      this.context,
      this.maxAudioChannels,
      this.minSegments,
      this.segmentLength,
      this.breakOnNonKeyFrames,
      this.manifestSubtitles);

  String container;
  String type;
  String videoCodec;
  String audioCodec;
  String protocol;
  bool estimateContentLength;
  bool enableMpegtsM2TsMode;
  String transcodeSeekInfo;
  bool copyTimestamps;
  String context;
  String maxAudioChannels;
  int minSegments;
  int segmentLength;
  bool breakOnNonKeyFrames;
  String manifestSubtitles;

  factory TranscodingProfile.fromJson(Map<String, dynamic> json) =>
      _$TranscodingProfileFromJson(json);
  Map<String, dynamic> toJson() => _$TranscodingProfileToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class ContainerProfile {
  ContainerProfile(this.type, this.conditions, this.container);

  String type;
  List<ProfileCondition> conditions;
  String container;

  factory ContainerProfile.fromJson(Map<String, dynamic> json) =>
      _$ContainerProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ContainerProfileToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class ProfileCondition {
  ProfileCondition(this.condition, this.property, this.value, this.isRequired);

  String condition;
  String property;
  String value;
  bool isRequired;

  factory ProfileCondition.fromJson(Map<String, dynamic> json) =>
      _$ProfileConditionFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileConditionToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class CodecProfile {
  CodecProfile(this.type, this.conditions, this.applyConditions, this.codec,
      this.container);

  String type;
  List<ProfileCondition> conditions;
  List<ProfileCondition> applyConditions;
  String codec;
  String container;

  factory CodecProfile.fromJson(Map<String, dynamic> json) =>
      _$CodecProfileFromJson(json);
  Map<String, dynamic> toJson() => _$CodecProfileToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class ResponseProfile {
  ResponseProfile(this.container, this.audioCodec, this.videoCodec, this.type,
      this.orgPn, this.mimeType, this.conditions);

  String container;
  String audioCodec;
  String videoCodec;
  String type;
  String orgPn;
  String mimeType;
  List<ProfileCondition> conditions;

  factory ResponseProfile.fromJson(Map<String, dynamic> json) =>
      _$ResponseProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseProfileToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class SubtitleProfile {
  SubtitleProfile(
      this.format, this.method, this.didlMode, this.language, this.container);

  String format;
  String method;
  String didlMode;
  String language;
  String container;

  factory SubtitleProfile.fromJson(Map<String, dynamic> json) =>
      _$SubtitleProfileFromJson(json);
  Map<String, dynamic> toJson() => _$SubtitleProfileToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class BaseItemDto {
  BaseItemDto(
      this.name,
      this.originalTitle,
      this.serverId,
      this.id,
      this.etag,
      this.playlistItemId,
      this.dateCreated,
      this.extraType,
      this.airsBeforeSeasonNumber,
      this.airsAfterSeasonNumber,
      this.airsBeforeEpisodeNumber,
      this.displaySpecialsWithSeasons,
      this.canDelete,
      this.canDownload,
      this.hasSubtitles,
      this.supportsResume,
      this.preferredMetadataLanguage,
      this.preferredMetadataCountryCode,
      this.supportsSync,
      this.container,
      this.sortName,
      this.forcedSortName,
      this.video3DFormat,
      this.premiereDate,
      this.externalUrls,
      this.mediaSources,
      this.criticRating,
      this.gameSystemId,
      this.gameSystem,
      this.productionLocations,
      this.path,
      this.officialRating,
      this.customRating,
      this.channelId,
      this.channelName,
      this.overview,
      this.taglines,
      this.genres,
      this.communityRating,
      this.runTimeTicks,
      this.playAccess,
      this.aspectRatio,
      this.productionYear,
      this.number,
      this.channelNumber,
      this.indexNumber,
      this.indexNumberEnd,
      this.parentIndexNumber,
      this.remoteTrailers,
      this.providerIds,
      this.isFolder,
      this.parentId,
      this.type,
      this.people,
      this.studios,
      this.genreItems,
      this.parentLogoItemId,
      this.parentBackdropItemId,
      this.parentBackdropImageTags,
      this.localTrailerCount,
      this.userData,
      this.recursiveItemCount,
      this.childCount,
      this.seriesName,
      this.seriesId,
      this.seasonId,
      this.specialFeatureCount,
      this.displayPreferencesId,
      this.status,
      this.airTime,
      this.airDays,
      this.tags,
      this.primaryImageAspectRatio,
      this.artists,
      this.artistItems,
      this.album,
      this.collectionType,
      this.displayOrder,
      this.albumId,
      this.albumPrimaryImageTag,
      this.seriesPrimaryImageTag,
      this.albumArtist,
      this.albumArtists,
      this.seasonName,
      this.mediaStreams,
      this.partCount,
      this.imageTags,
      this.backdropImageTags,
      this.parentLogoImageTag,
      this.parentArtItemId,
      this.parentArtImageTag,
      this.seriesThumbImageTag,
      this.seriesStudio,
      this.parentThumbItemId,
      this.parentThumbImageTag,
      this.parentPrimaryImageItemId,
      this.parentPrimaryImageTag,
      this.chapters,
      this.locationType,
      this.mediaType,
      this.endDate,
      this.lockedFields,
      this.lockData,
      this.width,
      this.height,
      this.cameraMake,
      this.cameraModel,
      this.software,
      this.exposureTime,
      this.focalLength,
      this.imageOrientation,
      this.aperture,
      this.shutterSpeed,
      this.latitude,
      this.longitude,
      this.altitude,
      this.isoSpeedRating,
      this.seriesTimerId,
      this.channelPrimaryImageTag,
      this.startDate,
      this.completionPercentage,
      this.isRepeat,
      this.isNew,
      this.episodeTitle,
      this.isMovie,
      this.isSports,
      this.isSeries,
      this.isLive,
      this.isNews,
      this.isKids,
      this.isPremiere,
      this.timerId,
      this.currentProgram,
      this.movieCount,
      this.seriesCount,
      this.albumCount,
      this.songCount,
      this.musicVideoCount);

  String name;
  String originalTitle;
  String serverId;
  String id;
  String etag;
  String playlistItemId;
  String dateCreated;
  String extraType;
  int airsBeforeSeasonNumber;
  int airsAfterSeasonNumber;
  int airsBeforeEpisodeNumber;
  bool displaySpecialsWithSeasons;
  bool canDelete;
  bool canDownload;
  bool hasSubtitles;
  bool supportsResume;
  String preferredMetadataLanguage;
  String preferredMetadataCountryCode;
  bool supportsSync;
  String container;
  String sortName;
  String forcedSortName;
  String video3DFormat;
  String premiereDate;
  List<ExternalUrl> externalUrls;
  List<MediaSourceInfo> mediaSources;
  double criticRating;
  int gameSystemId;
  String gameSystem;
  List<String> productionLocations;
  String path;
  String officialRating;
  String customRating;
  String channelId;
  String channelName;
  String overview;
  List<String> taglines;
  List<String> genres;
  double communityRating;
  int runTimeTicks;
  String playAccess;
  String aspectRatio;
  int productionYear;
  String number;
  String channelNumber;
  int indexNumber;
  int indexNumberEnd;
  int parentIndexNumber;
  List<MediaUrl> remoteTrailers;
  Map<dynamic, String> providerIds;
  bool isFolder;
  String parentId;
  String type;
  List<BaseItemPerson> people;
  List<NameLongIdPair> studios;
  List<NameLongIdPair> genreItems;
  String parentLogoItemId;
  String parentBackdropItemId;
  List<String> parentBackdropImageTags;
  int localTrailerCount;
  UserItemDataDto userData;
  int recursiveItemCount;
  int childCount;
  String seriesName;
  String seriesId;
  String seasonId;
  int specialFeatureCount;
  String displayPreferencesId;
  String status;
  String airTime;
  List<String> airDays;
  List<String> tags;
  double primaryImageAspectRatio;
  List<String> artists;
  List<NameIdPair> artistItems;
  String album;
  String collectionType;
  String displayOrder;
  String albumId;
  String albumPrimaryImageTag;
  String seriesPrimaryImageTag;
  String albumArtist;
  List<NameIdPair> albumArtists;
  String seasonName;
  List<MediaStream> mediaStreams;
  int partCount;
  Map<dynamic, String> imageTags;
  List<String> backdropImageTags;
  String parentLogoImageTag;
  String parentArtItemId;
  String parentArtImageTag;
  String seriesThumbImageTag;
  String seriesStudio;
  String parentThumbItemId;
  String parentThumbImageTag;
  String parentPrimaryImageItemId;
  String parentPrimaryImageTag;
  List<ChapterInfo> chapters;
  String locationType;
  String mediaType;
  String endDate;
  List<String> lockedFields;
  bool lockData;
  int width;
  int height;
  String cameraMake;
  String cameraModel;
  String software;
  double exposureTime;
  double focalLength;
  String imageOrientation;
  double aperture;
  double shutterSpeed;
  double latitude;
  double longitude;
  double altitude;
  int isoSpeedRating;
  String seriesTimerId;
  String channelPrimaryImageTag;
  String startDate;
  double completionPercentage;
  bool isRepeat;
  bool isNew;
  String episodeTitle;
  bool isMovie;
  bool isSports;
  bool isSeries;
  bool isLive;
  bool isNews;
  bool isKids;
  bool isPremiere;
  String timerId;
  dynamic currentProgram;
  int movieCount;
  int seriesCount;
  int albumCount;
  int songCount;
  int musicVideoCount;

  factory BaseItemDto.fromJson(Map<String, dynamic> json) =>
      _$BaseItemDtoFromJson(json);
  Map<String, dynamic> toJson() => _$BaseItemDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class ExternalUrl {
  ExternalUrl(this.name, this.url);

  String name;
  String url;

  factory ExternalUrl.fromJson(Map<String, dynamic> json) =>
      _$ExternalUrlFromJson(json);
  Map<String, dynamic> toJson() => _$ExternalUrlToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class MediaSourceInfo {
  MediaSourceInfo(
      this.protocol,
      this.id,
      this.path,
      this.encoderPath,
      this.encoderProtocol,
      this.type,
      this.container,
      this.size,
      this.name,
      this.isRemote,
      this.runTimeTicks,
      this.supportsTranscoding,
      this.supportsDirectStream,
      this.supportsDirectPlay,
      this.isInfiniteStream,
      this.requiresOpening,
      this.openToken,
      this.requiresClosing,
      this.liveStreamId,
      this.bufferMs,
      this.requiresLooping,
      this.supportsProbing,
      this.video3DFormat,
      this.mediaStreams,
      this.formats,
      this.bitrate,
      this.timestamp,
      this.requiredHttpHeaders,
      this.transcodingUrl,
      this.transcodingSubProtocol,
      this.transcodingContainer,
      this.analyzeDurationMs,
      this.readAtNativeFramerate,
      this.defaultAudioStreamIndex,
      this.defaultSubtitleStreamIndex);

  String protocol;
  String id;
  String path;
  String encoderPath;
  String encoderProtocol;
  String type;
  String container;
  int size;
  String name;
  bool isRemote;
  int runTimeTicks;
  bool supportsTranscoding;
  bool supportsDirectStream;
  bool supportsDirectPlay;
  bool isInfiniteStream;
  bool requiresOpening;
  String openToken;
  bool requiresClosing;
  String liveStreamId;
  int bufferMs;
  bool requiresLooping;
  bool supportsProbing;
  String video3DFormat;
  List<MediaStream> mediaStreams;
  List<String> formats;
  int bitrate;
  String timestamp;
  Map<dynamic, String> requiredHttpHeaders;
  String transcodingUrl;
  String transcodingSubProtocol;
  String transcodingContainer;
  int analyzeDurationMs;
  bool readAtNativeFramerate;
  int defaultAudioStreamIndex;
  int defaultSubtitleStreamIndex;

  factory MediaSourceInfo.fromJson(Map<String, dynamic> json) =>
      _$MediaSourceInfoFromJson(json);
  Map<String, dynamic> toJson() => _$MediaSourceInfoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class MediaStream {
  MediaStream(
      this.codec,
      this.codecTag,
      this.language,
      this.colorTransfer,
      this.colorPrimaries,
      this.colorSpace,
      this.comment,
      this.timeBase,
      this.codecTimeBase,
      this.title,
      this.extradata,
      this.videoRange,
      this.displayTitle,
      this.displayLanguage,
      this.nalLengthSize,
      this.isInterlaced,
      this.isAVC,
      this.channelLayout,
      this.bitRate,
      this.bitDepth,
      this.refFrames,
      this.packetLength,
      this.channels,
      this.sampleRate,
      this.isDefault,
      this.isForced,
      this.height,
      this.width,
      this.averageFrameRate,
      this.realFrameRate,
      this.profile,
      this.type,
      this.aspectRatio,
      this.index,
      this.score,
      this.isExternal,
      this.deliveryMethod,
      this.deliveryUrl,
      this.isExternalUrl,
      this.isTextSubtitleStream,
      this.supportsExternalStream,
      this.path,
      this.pixelFormat,
      this.level,
      this.isAnamorphic);

  String codec;
  String codecTag;
  String language;
  String colorTransfer;
  String colorPrimaries;
  String colorSpace;
  String comment;
  String timeBase;
  String codecTimeBase;
  String title;
  String extradata;
  String videoRange;
  String displayTitle;
  String displayLanguage;
  String nalLengthSize;
  bool isInterlaced;
  bool isAVC;
  String channelLayout;
  int bitRate;
  int bitDepth;
  int refFrames;
  int packetLength;
  int channels;
  int sampleRate;
  bool isDefault;
  bool isForced;
  int height;
  int width;
  double averageFrameRate;
  double realFrameRate;
  String profile;
  String type;
  String aspectRatio;
  int index;
  int score;
  bool isExternal;
  String deliveryMethod;
  String deliveryUrl;
  bool isExternalUrl;
  bool isTextSubtitleStream;
  bool supportsExternalStream;
  String path;
  String pixelFormat;
  double level;
  bool isAnamorphic;

  factory MediaStream.fromJson(Map<String, dynamic> json) =>
      _$MediaStreamFromJson(json);
  Map<String, dynamic> toJson() => _$MediaStreamToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class MediaUrl {
  MediaUrl(this.url, this.name);

  String url;
  String name;

  factory MediaUrl.fromJson(Map<String, dynamic> json) =>
      _$MediaUrlFromJson(json);
  Map<String, dynamic> toJson() => _$MediaUrlToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class BaseItemPerson {
  BaseItemPerson(
      this.name, this.id, this.role, this.type, this.primaryImageTag);

  String name;
  String id;
  String role;
  String type;
  String primaryImageTag;

  factory BaseItemPerson.fromJson(Map<String, dynamic> json) =>
      _$BaseItemPersonFromJson(json);
  Map<String, dynamic> toJson() => _$BaseItemPersonToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class NameLongIdPair {
  NameLongIdPair(this.name, this.id);

  String name;
  int id;

  factory NameLongIdPair.fromJson(Map<String, dynamic> json) =>
      _$NameLongIdPairFromJson(json);
  Map<String, dynamic> toJson() => _$NameLongIdPairToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class UserItemDataDto {
  UserItemDataDto(
      this.rating,
      this.playedPercentage,
      this.unplayedItemCount,
      this.playbackPositionTicks,
      this.playCount,
      this.isFavorite,
      this.likes,
      this.lastPlayedDate,
      this.played,
      this.key,
      this.itemId);

  double rating;
  double playedPercentage;
  int unplayedItemCount;
  int playbackPositionTicks;
  int playCount;
  bool isFavorite;
  bool likes;
  String lastPlayedDate;
  bool played;
  String key;
  String itemId;

  factory UserItemDataDto.fromJson(Map<String, dynamic> json) =>
      _$UserItemDataDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UserItemDataDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class NameIdPair {
  NameIdPair(this.name, this.id);

  String name;
  String id;

  factory NameIdPair.fromJson(Map<String, dynamic> json) =>
      _$NameIdPairFromJson(json);
  Map<String, dynamic> toJson() => _$NameIdPairToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class ChapterInfo {
  ChapterInfo(this.startPositionTicks, this.name, this.imageTag);

  int startPositionTicks;
  String name;
  String imageTag;

  factory ChapterInfo.fromJson(Map<String, dynamic> json) =>
      _$ChapterInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ChapterInfoToJson(this);
}
