/// This file contains classes returned by Jellyfin. Some values may not be
/// exactly right as there may not be an easy way to convert the values into
/// Dart objects. In most cases, these values will be strings. Enums are also
/// represented as strings. This could probably be changed, but it would cause
/// compatibility problems. Value descriptions are copied directly from
/// Jellyfin's API documentation (https://api.jellyfin.org)
///
/// These classes should be correct with Jellyfin 10.7.5

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'JellyfinModels.g.dart';

@JsonSerializable(
  fieldRename: FieldRename.pascal,
  explicitToJson: true,
  anyMap: true,
)
@HiveType(typeId: 9)
class UserDto {
  UserDto({
    this.name,
    this.serverId,
    this.serverName,
    required this.id,
    this.primaryImageTag,
    required this.hasPassword,
    required this.hasConfiguredPassword,
    required this.hasConfiguredEasyPassword,
    this.enableAutoLogin,
    this.lastLoginDate,
    this.lastActivityDate,
    this.configuration,
    this.policy,
    this.primaryImageAspectRatio,
  });

  /// Gets or sets the name.
  @HiveField(0)
  String? name;

  /// Gets or sets the server identifier.
  @HiveField(1)
  String? serverId;

  /// Gets or sets the name of the server. This is not used by the server and is
  /// for client-side usage only.
  @HiveField(2)
  String? serverName;

  /// Gets or sets the id.
  @HiveField(3)
  String id;

  /// Gets or sets the primary image tag.
  @HiveField(4)
  String? primaryImageTag;

  /// Gets or sets a value indicating whether this instance has password.
  @HiveField(5)
  bool hasPassword;

  /// Gets or sets a value indicating whether this instance has configured
  /// password.
  @HiveField(6)
  bool hasConfiguredPassword;

  /// Gets or sets a value indicating whether this instance has configured easy
  /// password.
  @HiveField(7)
  bool hasConfiguredEasyPassword;

  /// Gets or sets whether async login is enabled or not.
  @HiveField(8)
  bool? enableAutoLogin;

  /// Gets or sets the last login date.
  @HiveField(9)
  String? lastLoginDate;

  /// Gets or sets the last activity date.
  @HiveField(10)
  String? lastActivityDate;

  /// Gets or sets the configuration.
  @HiveField(11)
  UserConfiguration? configuration;

  /// Gets or sets the policy.
  @HiveField(12)
  UserPolicy? policy;

  /// Gets or sets the primary image aspect ratio.
  @HiveField(13)
  double? primaryImageAspectRatio;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}

@JsonSerializable(
  fieldRename: FieldRename.pascal,
  explicitToJson: true,
  anyMap: true,
)
@HiveType(typeId: 11)
class UserConfiguration {
  UserConfiguration({
    this.audioLanguagePreference,
    required this.playDefaultAudioTrack,
    this.subtitleLanguagePreference,
    required this.displayMissingEpisodes,
    this.groupedFolders,
    required this.subtitleMode,
    required this.displayCollectionsView,
    required this.enableLocalPassword,
    this.orderedViews,
    this.latestItemsExcludes,
    this.myMediaExcludes,
    required this.hidePlayedInLatest,
    required this.rememberAudioSelections,
    required this.rememberSubtitleSelections,
    required this.enableNextEpisodeAutoPlay,
  });

  /// Gets or sets the audio language preference.
  @HiveField(0)
  String? audioLanguagePreference;

  /// Gets or sets a value indicating whether [play default audio track].
  @HiveField(1)
  bool playDefaultAudioTrack;

  /// Gets or sets the subtitle language preference.
  @HiveField(2)
  String? subtitleLanguagePreference;

  @HiveField(3)
  bool displayMissingEpisodes;

  @HiveField(4)
  List<String>? groupedFolders;

  /// Enum: "Default" "Always" "OnlyForced" "None" "Smart" An enum representing
  /// a subtitle playback mode.
  @HiveField(5)
  String subtitleMode;

  @HiveField(6)
  bool displayCollectionsView;

  @HiveField(7)
  bool enableLocalPassword;

  @HiveField(8)
  List<String>? orderedViews;

  @HiveField(9)
  List<String>? latestItemsExcludes;

  @HiveField(10)
  List<String>? myMediaExcludes;

  @HiveField(11)
  bool hidePlayedInLatest;

  @HiveField(12)
  bool rememberAudioSelections;

  @HiveField(13)
  bool rememberSubtitleSelections;

  @HiveField(14)
  bool enableNextEpisodeAutoPlay;

  factory UserConfiguration.fromJson(Map<String, dynamic> json) =>
      _$UserConfigurationFromJson(json);
  Map<String, dynamic> toJson() => _$UserConfigurationToJson(this);
}

@JsonSerializable(
  fieldRename: FieldRename.pascal,
  explicitToJson: true,
  anyMap: true,
)
@HiveType(typeId: 12)
class UserPolicy {
  UserPolicy({
    required this.isAdministrator,
    required this.isHidden,
    required this.isDisabled,
    this.maxParentalRating,
    this.blockedTags,
    required this.enableUserPreferenceAccess,
    this.accessSchedules,
    this.blockUnratedItems,
    required this.enableRemoteControlOfOtherUsers,
    required this.enableSharedDeviceControl,
    required this.enableRemoteAccess,
    required this.enableLiveTvManagement,
    required this.enableLiveTvAccess,
    required this.enableMediaPlayback,
    required this.enableAudioPlaybackTranscoding,
    required this.enableVideoPlaybackTranscoding,
    required this.enablePlaybackRemuxing,
    required this.forceRemoteSourceTranscoding,
    required this.enableContentDeletion,
    required this.enableContentDeletionFromFolders,
    required this.enableContentDownloading,
    required this.enableSyncTranscoding,
    required this.enableMediaConversion,
    this.enabledDevices,
    required this.enableAllDevices,
    this.enabledChannels,
    required this.enableAllChannels,
    this.enabledFolders,
    required this.enableAllFolders,
    required this.invalidLoginAttemptCount,
    required this.loginAttemptsBeforeLockout,
    required this.maxActiveSessions,
    required this.enablePublicSharing,
    this.blockedMediaFolders,
    this.blockedChannels,
    required this.remoteClientBitrateLimit,
    this.authenticationProviderId,
    this.passwordResetProviderId,
    required this.syncPlayAccess,
  });

  /// Gets or sets a value indicating whether this instance is administrator.
  @HiveField(0)
  bool isAdministrator;

  /// Gets or sets a value indicating whether this instance is hidden.
  @HiveField(1)
  bool isHidden;

  /// Gets or sets a value indicating whether this instance is disabled.
  @HiveField(2)
  bool isDisabled;

  /// Gets or sets the max parental rating.
  @HiveField(3)
  int? maxParentalRating;

  @HiveField(4)
  List<String>? blockedTags;

  @HiveField(5)
  bool enableUserPreferenceAccess;

  @HiveField(6)
  List<AccessSchedule>? accessSchedules;

  /// Items Enum: "Movie" "Trailer" "Series" "Music" "Book" "LiveTvChannel"
  /// "LiveTvProgram" "ChannelContent" "Other"
  @HiveField(7)
  List<String>? blockUnratedItems;

  @HiveField(8)
  bool enableRemoteControlOfOtherUsers;

  @HiveField(9)
  bool enableSharedDeviceControl;

  @HiveField(10)
  bool enableRemoteAccess;

  @HiveField(11)
  bool enableLiveTvManagement;

  @HiveField(12)
  bool enableLiveTvAccess;

  @HiveField(13)
  bool enableMediaPlayback;

  @HiveField(14)
  bool enableAudioPlaybackTranscoding;

  @HiveField(15)
  bool enableVideoPlaybackTranscoding;

  @HiveField(16)
  bool enablePlaybackRemuxing;

  @HiveField(17)
  bool enableContentDeletion;

  @HiveField(18)
  List<String>? enableContentDeletionFromFolders;

  @HiveField(19)
  bool enableContentDownloading;

  /// Gets or sets a value indicating whether [enable synchronize].
  @HiveField(20)
  bool enableSyncTranscoding;

  @HiveField(21)
  bool enableMediaConversion;

  @HiveField(22)
  List<String>? enabledDevices;

  @HiveField(23)
  bool enableAllDevices;

  @HiveField(24)
  List<String>? enabledChannels;

  @HiveField(25)
  bool enableAllChannels;

  @HiveField(26)
  List<String>? enabledFolders;

  @HiveField(27)
  bool enableAllFolders;

  @HiveField(28)
  int invalidLoginAttemptCount;

  @HiveField(29)
  bool enablePublicSharing;

  @HiveField(30)
  List<String>? blockedMediaFolders;

  @HiveField(31)
  List<String>? blockedChannels;

  @HiveField(32)
  int remoteClientBitrateLimit;

  @HiveField(33)
  String? authenticationProviderId;

  // Below fields were added during null safety migration (0.5.0)

  @HiveField(34)
  bool? forceRemoteSourceTranscoding;

  @HiveField(35)
  int? loginAttemptsBeforeLockout;

  @HiveField(36)
  int? maxActiveSessions;

  @HiveField(37)
  String? passwordResetProviderId;

  /// Enum: "CreateAndJoinGroups" "JoinGroups" "None"
  /// Enum SyncPlayUserAccessType.
  @HiveField(38)
  String syncPlayAccess;

  factory UserPolicy.fromJson(Map<String, dynamic> json) =>
      _$UserPolicyFromJson(json);
  Map<String, dynamic> toJson() => _$UserPolicyToJson(this);
}

@JsonSerializable(
  fieldRename: FieldRename.pascal,
  explicitToJson: true,
  anyMap: true,
)
@HiveType(typeId: 13)
class AccessSchedule {
  AccessSchedule({
    required this.id,
    required this.userId,
    required this.dayOfWeek,
    required this.startHour,
    required this.endHour,
  });

  /// Enum: "Sunday" "Monday" "Tuesday" "Wednesday" "Thursday" "Friday"
  /// "Saturday" "Everyday" "Weekday" "Weekend" Gets or sets the day of week.
  @HiveField(0)
  String dayOfWeek;

  /// Gets or sets the start hour.
  @HiveField(1)
  double startHour;

  /// Gets or sets the end hour.
  @HiveField(2)
  double endHour;

  // Below fields were added during null safety migration (0.5.0)

  /// Gets or sets the id of this instance.
  @HiveField(3)
  int id;

  /// Gets or sets the id of the associated user.
  @HiveField(4)
  String userId;

  factory AccessSchedule.fromJson(Map<String, dynamic> json) =>
      _$AccessScheduleFromJson(json);
  Map<String, dynamic> toJson() => _$AccessScheduleToJson(this);
}

@JsonSerializable(
  fieldRename: FieldRename.pascal,
  explicitToJson: true,
  anyMap: true,
)
@HiveType(typeId: 7)
class AuthenticationResult {
  AuthenticationResult({
    this.user,
    this.sessionInfo,
    this.accessToken,
    this.serverId,
  });

  @HiveField(0)
  UserDto? user;

  @HiveField(1)
  SessionInfo? sessionInfo;

  @HiveField(2)
  String? accessToken;

  @HiveField(3)
  String? serverId;

  factory AuthenticationResult.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationResultFromJson(json);
  Map<String, dynamic> toJson() => _$AuthenticationResultToJson(this);
}

@JsonSerializable(
  fieldRename: FieldRename.pascal,
  explicitToJson: true,
  anyMap: true,
)
@HiveType(typeId: 10)
class SessionInfo {
  SessionInfo({
    this.playState,
    this.additionalUsers,
    this.capabilities,
    this.remoteEndPoint,
    this.playableMediaTypes,
    this.playlistItemId,
    this.id,
    this.serverId,
    required this.userId,
    this.userName,
    this.userPrimaryImageTag,
    this.client,
    required this.lastActivityDate,
    this.deviceName,
    this.deviceType,
    this.nowPlayingItem,
    this.deviceId,
    this.supportedCommands,
    this.transcodingInfo,
    required this.supportsRemoteControl,
    required this.lastPlaybackCheckIn,
    this.fullNowPlayingItem,
    this.nowViewingItem,
    this.applicationVersion,
    required this.isActive,
    required this.supportsMediaControl,
    this.nowPlayingQueue,
    required this.hasCustomDeviceName,
  });

  @HiveField(0)
  PlayerStateInfo? playState;

  @HiveField(1)
  List<SessionUserInfo>? additionalUsers;

  @HiveField(2)
  ClientCapabilities? capabilities;

  /// Gets or sets the remote end point.
  @HiveField(3)
  String? remoteEndPoint;

  /// Gets or sets the playable media types.
  @HiveField(4)
  List<String>? playableMediaTypes;

  @HiveField(5)
  String? playlistItemId;

  /// Gets or sets the id.
  @HiveField(6)
  String? id;

  @HiveField(7)
  String? serverId;

  /// Gets or sets the user id.
  @HiveField(8)
  String userId;

  /// Gets or sets the username.
  @HiveField(9)
  String? userName;

  @HiveField(10)
  String? userPrimaryImageTag;

  /// Gets or sets the type of the client.
  @HiveField(11)
  String? client;

  /// Gets or sets the last activity date.
  @HiveField(12)
  String lastActivityDate;

  /// Gets or sets the name of the device.
  @HiveField(13)
  String? deviceName;

  /// Gets or sets the type of the device.
  @HiveField(14)
  String? deviceType;

  /// Gets or sets the now playing item.
  @HiveField(15)
  BaseItemDto? nowPlayingItem;

  /// Gets or sets the device id.
  @HiveField(16)
  String? deviceId;

  /// Items Enum: "MoveUp" "MoveDown" "MoveLeft" "MoveRight" "PageUp" "PageDown"
  /// "PreviousLetter" "NextLetter" "ToggleOsd" "ToggleContextMenu" "Select"
  /// "Back" "TakeScreenshot" "SendKey" "SendString" "GoHome" "GoToSettings"
  /// "VolumeUp" "VolumeDown" "Mute" "Unmute" "ToggleMute" "SetVolume"
  /// "SetAudioStreamIndex" "SetSubtitleStreamIndex" "ToggleFullscreen"
  /// "DisplayContent" "GoToSearch" "DisplayMessage" "SetRepeatMode" "ChannelUp"
  /// "ChannelDown" "Guide" "ToggleStats" "PlayMediaSource" "PlayTrailers"
  /// "SetShuffleQueue" "PlayState" "PlayNext" "ToggleOsdMenu" "Play" Gets or
  /// sets the supported commands.
  @HiveField(17)
  List<String>? supportedCommands;

  @HiveField(18)
  TranscodingInfo? transcodingInfo;

  @HiveField(19)
  bool supportsRemoteControl;

  // Below fields were added during null safety migration (0.5.0)

  /// Gets or sets the last playback check in.
  @HiveField(20)
  String? lastPlaybackCheckIn;

  @HiveField(21)
  BaseItem? fullNowPlayingItem;

  @HiveField(22)
  BaseItemDto? nowViewingItem;

  /// Gets or sets the application version.
  @HiveField(23)
  String? applicationVersion;

  /// Gets a value indicating whether this instance is active.
  @HiveField(24)
  bool isActive;

  @HiveField(25)
  bool supportsMediaControl;

  @HiveField(26)
  List<QueueItem>? nowPlayingQueue;

  @HiveField(27)
  bool hasCustomDeviceName;

  factory SessionInfo.fromJson(Map<String, dynamic> json) =>
      _$SessionInfoFromJson(json);
  Map<String, dynamic> toJson() => _$SessionInfoToJson(this);
}

@JsonSerializable(
  fieldRename: FieldRename.pascal,
  explicitToJson: true,
  anyMap: true,
)
class TranscodingInfo {
  TranscodingInfo({
    this.audioCodec,
    this.videoCodec,
    this.container,
    required this.isVideoDirect,
    required this.isAudioDirect,
    this.bitrate,
    this.framerate,
    this.completionPercentage,
    this.width,
    this.height,
    this.audioChannels,
    this.transcodeReasons,
  });

  String? audioCodec;

  String? videoCodec;

  String? container;

  bool isVideoDirect;

  bool isAudioDirect;

  int? bitrate;

  double? framerate;

  double? completionPercentage;

  int? width;

  int? height;

  int? audioChannels;

  /// Items Enum: "ContainerNotSupported" "VideoCodecNotSupported"
  /// "AudioCodecNotSupported" "ContainerBitrateExceedsLimit"
  /// "AudioBitrateNotSupported" "AudioChannelsNotSupported"
  /// "VideoResolutionNotSupported" "UnknownVideoStreamInfo"
  /// "UnknownAudioStreamInfo" "AudioProfileNotSupported"
  /// "AudioSampleRateNotSupported" "AnamorphicVideoNotSupported"
  /// "InterlacedVideoNotSupported" "SecondaryAudioNotSupported"
  /// "RefFramesNotSupported" "VideoBitDepthNotSupported"
  /// "VideoBitrateNotSupported" "VideoFramerateNotSupported"
  /// "VideoLevelNotSupported" "VideoProfileNotSupported"
  /// "AudioBitDepthNotSupported" "SubtitleCodecNotSupported" "DirectPlayError"
  List<String>? transcodeReasons;

  factory TranscodingInfo.fromJson(Map<String, dynamic> json) =>
      _$TranscodingInfoFromJson(json);
  Map<String, dynamic> toJson() => _$TranscodingInfoToJson(this);
}

@JsonSerializable(
  fieldRename: FieldRename.pascal,
  explicitToJson: true,
  anyMap: true,
)
@HiveType(typeId: 14)
class PlayerStateInfo {
  PlayerStateInfo({
    this.positionTicks,
    required this.canSeek,
    required this.isPaused,
    required this.isMuted,
    this.volumeLevel,
    this.audioStreamIndex,
    this.subtitleStreamIndex,
    this.mediaSourceId,
    this.playMethod,
    this.repeatMode,
  });

  /// Gets or sets the now playing position ticks.
  @HiveField(0)
  int? positionTicks;

  /// Gets or sets a value indicating whether this instance can seek.
  @HiveField(1)
  bool canSeek;

  /// Gets or sets a value indicating whether this instance is paused.
  @HiveField(2)
  bool isPaused;

  /// Gets or sets a value indicating whether this instance is muted.
  @HiveField(3)
  bool isMuted;

  /// Gets or sets the volume level.
  @HiveField(4)
  int? volumeLevel;

  /// Gets or sets the index of the now playing audio stream.
  @HiveField(5)
  int? audioStreamIndex;

  /// Gets or sets the index of the now playing subtitle stream.
  @HiveField(6)
  int? subtitleStreamIndex;

  /// Gets or sets the now playing media version identifier.
  @HiveField(7)
  String? mediaSourceId;

  /// Enum: "Transcode" "DirectStream" "DirectPlay" Gets or sets the play
  /// method.
  @HiveField(8)
  String? playMethod;

  /// Enum: "RepeatNone" "RepeatAll" "RepeatOne" Gets or sets the repeat mode.
  @HiveField(9)
  String? repeatMode;

  factory PlayerStateInfo.fromJson(Map<String, dynamic> json) =>
      _$PlayerStateInfoFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerStateInfoToJson(this);
}

@JsonSerializable(
  fieldRename: FieldRename.pascal,
  explicitToJson: true,
  anyMap: true,
)
@HiveType(typeId: 15)
class SessionUserInfo {
  SessionUserInfo({
    required this.userId,
    this.userName,
  });

  /// Gets or sets the user identifier.
  @HiveField(0)
  String userId;

  /// Gets or sets the name of the user.
  @HiveField(1)
  String? userName;

  factory SessionUserInfo.fromJson(Map<String, dynamic> json) =>
      _$SessionUserInfoFromJson(json);
  Map<String, dynamic> toJson() => _$SessionUserInfoToJson(this);
}

@JsonSerializable(
  fieldRename: FieldRename.pascal,
  explicitToJson: true,
  anyMap: true,
)
@HiveType(typeId: 16)
class ClientCapabilities {
  ClientCapabilities({
    this.playableMediaTypes,
    this.supportedCommands,
    required this.supportsMediaControl,
    required this.supportsPersistentIdentifier,
    required this.supportsSync,
    this.deviceProfile,
    this.iconUrl,
    required this.supportsContentUploading,
    this.messageCallbackUrl,
    this.appStoreUrl,
  });

  @HiveField(0)
  List<String>? playableMediaTypes;

  /// Items Enum: "MoveUp" "MoveDown" "MoveLeft" "MoveRight" "PageUp" "PageDown"
  /// "PreviousLetter" "NextLetter" "ToggleOsd" "ToggleContextMenu" "Select"
  /// "Back" "TakeScreenshot" "SendKey" "SendString" "GoHome" "GoToSettings"
  /// "VolumeUp" "VolumeDown" "Mute" "Unmute" "ToggleMute" "SetVolume"
  /// "SetAudioStreamIndex" "SetSubtitleStreamIndex" "ToggleFullscreen"
  /// "DisplayContent" "GoToSearch" "DisplayMessage" "SetRepeatMode" "ChannelUp"
  /// "ChannelDown" "Guide" "ToggleStats" "PlayMediaSource" "PlayTrailers"
  /// "SetShuffleQueue" "PlayState" "PlayNext" "ToggleOsdMenu" "Play"
  @HiveField(1)
  List<String>? supportedCommands;

  @HiveField(2)
  bool supportsMediaControl;

  @HiveField(3)
  bool supportsPersistentIdentifier;

  @HiveField(4)
  bool supportsSync;

  /// Defines the MediaBrowser.Model.Dlna.DeviceProfile.
  @HiveField(5)
  DeviceProfile? deviceProfile;

  @HiveField(6)
  String? iconUrl;

  // Below fields were added during null safety migration (0.5.0)

  @HiveField(7)
  bool supportsContentUploading;

  @HiveField(8)
  String? messageCallbackUrl;

  @HiveField(9)
  String? appStoreUrl;

  factory ClientCapabilities.fromJson(Map<String, dynamic> json) =>
      _$ClientCapabilitiesFromJson(json);
  Map<String, dynamic> toJson() => _$ClientCapabilitiesToJson(this);
}

@JsonSerializable(
  fieldRename: FieldRename.pascal,
  explicitToJson: true,
  anyMap: true,
)
@HiveType(typeId: 17)
class DeviceProfile {
  DeviceProfile({
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
    required this.enableAlbumArtInDidl,
    required this.enableSingleAlbumArtLimit,
    required this.enableSingleSubtitleLimit,
    this.supportedMediaTypes,
    this.userId,
    this.albumArtPn,
    required this.maxAlbumArtWidth,
    required this.maxAlbumArtHeight,
    this.maxIconWidth,
    this.maxIconHeight,
    this.maxStreamingBitrate,
    this.maxStaticBitrate,
    this.musicStreamingTranscodingBitrate,
    this.maxStaticMusicBitrate,
    this.sonyAggregationFlags,
    this.protocolInfo,
    required this.timelineOffsetSeconds,
    required this.requiresPlainVideoItems,
    required this.requiresPlainFolders,
    required this.enableMSMediaReceiverRegistrar,
    required this.ignoreTranscodeByteRangeRequests,
    this.xmlRootAttributes,
    this.directPlayProfiles,
    this.transcodingProfiles,
    this.containerProfiles,
    this.codecProfiles,
    this.responseProfiles,
    this.subtitleProfiles,
  });

  /// Gets or sets the Name.
  @HiveField(0)
  String? name;

  /// Gets or sets the Id.
  @HiveField(1)
  String? id;

  /// Gets or sets the Identification.
  @HiveField(2)
  DeviceIdentification? identification;

  /// Gets or sets the FriendlyName.
  @HiveField(3)
  String? friendlyName;

  /// Gets or sets the Manufacturer.
  @HiveField(4)
  String? manufacturer;

  /// Gets or sets the ManufacturerUrl.
  @HiveField(5)
  String? manufacturerUrl;

  /// Gets or sets the ModelName.
  @HiveField(6)
  String? modelName;

  /// Gets or sets the ModelDescription.
  @HiveField(7)
  String? modelDescription;

  /// Gets or sets the ModelNumber.
  @HiveField(8)
  String? modelNumber;

  /// Gets or sets the ModelUrl.
  @HiveField(9)
  String? modelUrl;

  /// Gets or sets the SerialNumber.
  @HiveField(10)
  String? serialNumber;

  /// Gets or sets a value indicating whether EnableAlbumArtInDidl.
  @HiveField(11)
  bool enableAlbumArtInDidl;

  /// Gets or sets a value indicating whether EnableSingleAlbumArtLimit.
  @HiveField(12)
  bool enableSingleAlbumArtLimit;

  /// Gets or sets a value indicating whether EnableSingleSubtitleLimit.
  @HiveField(13)
  bool enableSingleSubtitleLimit;

  /// Gets or sets the SupportedMediaTypes.
  @HiveField(14)
  String? supportedMediaTypes;

  /// Gets or sets the UserId.
  @HiveField(15)
  String? userId;

  /// Gets or sets the AlbumArtPn.
  @HiveField(16)
  String? albumArtPn;

  /// Gets or sets the MaxAlbumArtWidth.
  @HiveField(17)
  int maxAlbumArtWidth;

  /// Gets or sets the MaxAlbumArtHeight.
  @HiveField(18)
  int maxAlbumArtHeight;

  /// Gets or sets the MaxIconWidth.
  @HiveField(19)
  int? maxIconWidth;

  /// Gets or sets the MaxIconHeight.
  @HiveField(20)
  int? maxIconHeight;

  /// Gets or sets the MaxStreamingBitrate.
  @HiveField(21)
  int? maxStreamingBitrate;

  /// Gets or sets the MaxStaticBitrate.
  @HiveField(22)
  int? maxStaticBitrate;

  /// Gets or sets the MusicStreamingTranscodingBitrate.
  @HiveField(23)
  int? musicStreamingTranscodingBitrate;

  /// Gets or sets the MaxStaticMusicBitrate.
  @HiveField(24)
  int? maxStaticMusicBitrate;

  /// Gets or sets the content of the aggregationFlags element in the
  /// urn:schemas-sonycom:av namespace.
  @HiveField(25)
  String? sonyAggregationFlags;

  /// Gets or sets the ProtocolInfo.
  @HiveField(26)
  String? protocolInfo;

  /// Gets or sets the TimelineOffsetSeconds.
  @HiveField(27)
  int timelineOffsetSeconds;

  /// Gets or sets a value indicating whether RequiresPlainVideoItems.
  @HiveField(28)
  bool requiresPlainVideoItems;

  /// Gets or sets a value indicating whether RequiresPlainFolders.
  @HiveField(29)
  bool requiresPlainFolders;

  /// Gets or sets a value indicating whether EnableMSMediaReceiverRegistrar.
  @HiveField(30)
  bool enableMSMediaReceiverRegistrar;

  /// Gets or sets a value indicating whether IgnoreTranscodeByteRangeRequests.
  @HiveField(31)
  bool ignoreTranscodeByteRangeRequests;

  /// Gets or sets the XmlRootAttributes.
  @HiveField(32)
  List<XmlAttribute>? xmlRootAttributes;

  /// Gets or sets the direct play profiles.
  @HiveField(33)
  List<DirectPlayProfile>? directPlayProfiles;

  /// Gets or sets the transcoding profiles.
  @HiveField(34)
  List<TranscodingProfile>? transcodingProfiles;

  /// Gets or sets the ContainerProfiles.
  @HiveField(35)
  List<ContainerProfile>? containerProfiles;

  /// Gets or sets the CodecProfiles.
  @HiveField(36)
  List<CodecProfile>? codecProfiles;

  /// Gets or sets the ResponseProfiles.
  @HiveField(37)
  List<ResponseProfile>? responseProfiles;

  /// Gets or sets the SubtitleProfiles.
  @HiveField(38)
  List<SubtitleProfile>? subtitleProfiles;

  factory DeviceProfile.fromJson(Map<String, dynamic> json) =>
      _$DeviceProfileFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceProfileToJson(this);
}

@JsonSerializable(
  fieldRename: FieldRename.pascal,
  explicitToJson: true,
  anyMap: true,
)
@HiveType(typeId: 18)
class DeviceIdentification {
  DeviceIdentification({
    this.friendlyName,
    this.modelNumber,
    this.serialNumber,
    this.modelName,
    this.modelDescription,
    this.modelUrl,
    this.manufacturer,
    this.manufacturerUrl,
    this.headers,
  });

  /// Gets or sets the name of the friendly.
  @HiveField(0)
  String? friendlyName;

  /// Gets or sets the model number.
  @HiveField(1)
  String? modelNumber;

  /// Gets or sets the serial number.
  @HiveField(2)
  String? serialNumber;

  /// Gets or sets the name of the model.
  @HiveField(3)
  String? modelName;

  /// Gets or sets the model description.
  @HiveField(4)
  String? modelDescription;

  /// Gets or sets the model URL.
  @HiveField(5)
  String? modelUrl;

  /// Gets or sets the manufacturer.
  @HiveField(6)
  String? manufacturer;

  /// Gets or sets the manufacturer URL.
  @HiveField(7)
  String? manufacturerUrl;

  /// Gets or sets the headers.
  @HiveField(8)
  List<HttpHeaderInfo>? headers;

  factory DeviceIdentification.fromJson(Map<String, dynamic> json) =>
      _$DeviceIdentificationFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceIdentificationToJson(this);
}

@JsonSerializable(
  fieldRename: FieldRename.pascal,
  explicitToJson: true,
  anyMap: true,
)
@HiveType(typeId: 19)
class HttpHeaderInfo {
  HttpHeaderInfo({
    this.name,
    this.value,
    required this.match,
  });

  @HiveField(0)
  String? name;

  @HiveField(1)
  String? value;

  /// Enum: "Equals" "Regex" "Substring"
  @HiveField(2)
  String match;

  factory HttpHeaderInfo.fromJson(Map<String, dynamic> json) =>
      _$HttpHeaderInfoFromJson(json);
  Map<String, dynamic> toJson() => _$HttpHeaderInfoToJson(this);
}

@JsonSerializable(
  fieldRename: FieldRename.pascal,
  explicitToJson: true,
  anyMap: true,
)
@HiveType(typeId: 20)
class XmlAttribute {
  XmlAttribute({
    this.name,
    this.value,
  });

  @HiveField(0)
  String? name;

  @HiveField(1)
  String? value;

  factory XmlAttribute.fromJson(Map<String, dynamic> json) =>
      _$XmlAttributeFromJson(json);
  Map<String, dynamic> toJson() => _$XmlAttributeToJson(this);
}

@JsonSerializable(
  fieldRename: FieldRename.pascal,
  explicitToJson: true,
  anyMap: true,
)
@HiveType(typeId: 21)
class DirectPlayProfile {
  DirectPlayProfile({
    this.container,
    this.audioCodec,
    this.videoCodec,
    required this.type,
  });

  @HiveField(0)
  String? container;

  @HiveField(1)
  String? audioCodec;

  @HiveField(2)
  String? videoCodec;

  /// Enum: "Audio" "Video" "Photo"
  @HiveField(3)
  String type;

  factory DirectPlayProfile.fromJson(Map<String, dynamic> json) =>
      _$DirectPlayProfileFromJson(json);
  Map<String, dynamic> toJson() => _$DirectPlayProfileToJson(this);
}

@JsonSerializable(
  fieldRename: FieldRename.pascal,
  explicitToJson: true,
  anyMap: true,
)
@HiveType(typeId: 22)
class TranscodingProfile {
  TranscodingProfile({
    this.container,
    required this.type,
    this.videoCodec,
    this.audioCodec,
    this.protocol,
    required this.estimateContentLength,
    required this.enableMpegtsM2TsMode,
    required this.transcodeSeekInfo,
    required this.copyTimestamps,
    required this.context,
    required this.maxAudioChannels,
    required this.minSegments,
    required this.segmentLength,
    required this.breakOnNonKeyFrames,
    required this.enableSubtitlesInManifest,
  });

  @HiveField(0)
  String? container;

  /// Enum: "Audio" "Video" "Photo"
  @HiveField(1)
  String type;

  @HiveField(2)
  String? videoCodec;

  @HiveField(3)
  String? audioCodec;

  @HiveField(4)
  String? protocol;

  @HiveField(5)
  bool estimateContentLength;

  @HiveField(6)
  bool enableMpegtsM2TsMode;

  /// Enum: "Auto" "Bytes"
  @HiveField(7)
  String transcodeSeekInfo;

  @HiveField(8)
  bool copyTimestamps;

  /// Enum: "Streaming" "Static"
  @HiveField(9)
  String context;

  @HiveField(10)
  String? maxAudioChannels;

  @HiveField(11)
  int minSegments;

  @HiveField(12)
  int segmentLength;

  @HiveField(13)
  bool breakOnNonKeyFrames;

  // Below fields were added during null safety migration (0.5.0)

  @HiveField(14)
  bool enableSubtitlesInManifest;

  factory TranscodingProfile.fromJson(Map<String, dynamic> json) =>
      _$TranscodingProfileFromJson(json);
  Map<String, dynamic> toJson() => _$TranscodingProfileToJson(this);
}

@JsonSerializable(
  fieldRename: FieldRename.pascal,
  explicitToJson: true,
  anyMap: true,
)
@HiveType(typeId: 23)
class ContainerProfile {
  ContainerProfile({
    required this.type,
    this.conditions,
    this.container,
  });

  /// Enum: "Audio" "Video" "Photo"
  @HiveField(0)
  String type;

  @HiveField(1)
  List<ProfileCondition>? conditions;

  @HiveField(2)
  String? container;

  factory ContainerProfile.fromJson(Map<String, dynamic> json) =>
      _$ContainerProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ContainerProfileToJson(this);
}

@JsonSerializable(
  fieldRename: FieldRename.pascal,
  explicitToJson: true,
  anyMap: true,
)
@HiveType(typeId: 24)
class ProfileCondition {
  ProfileCondition({
    required this.condition,
    required this.property,
    this.value,
    required this.isRequired,
  });

  /// Enum: "Equals" "NotEquals" "LessThanEqual" "GreaterThanEqual" "EqualsAny"
  @HiveField(0)
  String condition;

  /// Enum: "AudioChannels" "AudioBitrate" "AudioProfile" "Width" "Height"
  /// "Has64BitOffsets" "PacketLength" "VideoBitDepth" "VideoBitrate"
  /// "VideoFramerate" "VideoLevel" "VideoProfile" "VideoTimestamp"
  /// "IsAnamorphic" "RefFrames" "NumAudioStreams" "NumVideoStreams"
  /// "IsSecondaryAudio" "VideoCodecTag" "IsAvc" "IsInterlaced"
  /// "AudioSampleRate" "AudioBitDepth"
  @HiveField(1)
  String property;

  @HiveField(2)
  String? value;

  @HiveField(3)
  bool isRequired;

  factory ProfileCondition.fromJson(Map<String, dynamic> json) =>
      _$ProfileConditionFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileConditionToJson(this);
}

@JsonSerializable(
  fieldRename: FieldRename.pascal,
  explicitToJson: true,
  anyMap: true,
)
@HiveType(typeId: 25)
class CodecProfile {
  CodecProfile({
    required this.type,
    this.conditions,
    this.applyConditions,
    this.codec,
    this.container,
  });

  /// Enum: "Video" "VideoAudio" "Audio"
  @HiveField(0)
  String type;

  @HiveField(1)
  List<ProfileCondition>? conditions;

  @HiveField(2)
  List<ProfileCondition>? applyConditions;

  @HiveField(3)
  String? codec;

  @HiveField(4)
  String? container;

  factory CodecProfile.fromJson(Map<String, dynamic> json) =>
      _$CodecProfileFromJson(json);
  Map<String, dynamic> toJson() => _$CodecProfileToJson(this);
}

@JsonSerializable(
  fieldRename: FieldRename.pascal,
  explicitToJson: true,
  anyMap: true,
)
@HiveType(typeId: 26)
class ResponseProfile {
  ResponseProfile({
    this.container,
    this.audioCodec,
    this.videoCodec,
    required this.type,
    this.orgPn,
    this.mimeType,
    this.conditions,
  });

  @HiveField(0)
  String? container;

  @HiveField(1)
  String? audioCodec;

  @HiveField(2)
  String? videoCodec;

  /// Enum: "Audio" "Video" "Photo"
  @HiveField(3)
  String type;

  @HiveField(4)
  String? orgPn;

  @HiveField(5)
  String? mimeType;

  @HiveField(6)
  List<ProfileCondition>? conditions;

  factory ResponseProfile.fromJson(Map<String, dynamic> json) =>
      _$ResponseProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseProfileToJson(this);
}

@JsonSerializable(
  fieldRename: FieldRename.pascal,
  explicitToJson: true,
  anyMap: true,
)
@HiveType(typeId: 27)
class SubtitleProfile {
  SubtitleProfile({
    this.format,
    required this.method,
    this.didlMode,
    this.language,
    this.container,
  });

  @HiveField(0)
  String? format;

  /// Enum: "Encode" "Embed" "External" "Hls"
  @HiveField(1)
  String method;

  @HiveField(2)
  String? didlMode;

  @HiveField(3)
  String? language;

  @HiveField(4)
  String? container;

  factory SubtitleProfile.fromJson(Map<String, dynamic> json) =>
      _$SubtitleProfileFromJson(json);
  Map<String, dynamic> toJson() => _$SubtitleProfileToJson(this);
}

@JsonSerializable(
  fieldRename: FieldRename.pascal,
  explicitToJson: true,
  anyMap: true,
)
@HiveType(typeId: 0)
class BaseItemDto {
  BaseItemDto({
    this.name,
    this.originalTitle,
    this.serverId,
    required this.id,
    this.etag,
    this.playlistItemId,
    this.dateCreated,
    this.extraType,
    this.airsBeforeSeasonNumber,
    this.airsAfterSeasonNumber,
    this.airsBeforeEpisodeNumber,
    this.canDelete,
    this.canDownload,
    this.hasSubtitles,
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
    this.musicVideoCount,
    this.sourceType,
    this.dateLastMediaAdded,
    this.enableMediaSourceDisplay,
    this.cumulativeRunTimeTicks,
    this.isPlaceHolder,
    this.isHD,
    this.videoType,
    this.mediaSourceCount,
    this.screenshotImageTags,
    this.imageBlurHashes,
    this.isoType,
    this.trailerCount,
    this.programCount,
    this.episodeCount,
    this.artistCount,
    this.programId,
    this.channelType,
    this.audio,
  });

  /// Gets or sets the name.
  @HiveField(0)
  String? name;

  @HiveField(1)
  String? originalTitle;

  /// Gets or sets the server identifier.
  @HiveField(2)
  String? serverId;

  /// Gets or sets the id.
  @HiveField(3)
  String id;

  /// Gets or sets the etag.
  @HiveField(4)
  String? etag;

  /// Gets or sets the playlist item identifier.
  @HiveField(5)
  String? playlistItemId;

  /// Gets or sets the date created.
  @HiveField(6)
  String? dateCreated;

  @HiveField(7)
  String? extraType;

  @HiveField(8)
  int? airsBeforeSeasonNumber;

  @HiveField(9)
  int? airsAfterSeasonNumber;

  @HiveField(10)
  int? airsBeforeEpisodeNumber;

  @HiveField(11)
  bool? canDelete;

  @HiveField(12)
  bool? canDownload;

  @HiveField(13)
  bool? hasSubtitles;

  @HiveField(14)
  String? preferredMetadataLanguage;

  @HiveField(15)
  String? preferredMetadataCountryCode;

  /// Gets or sets a value indicating whether [supports synchronize].
  @HiveField(16)
  bool? supportsSync;

  @HiveField(17)
  String? container;

  /// Gets or sets the name of the sort.
  @HiveField(18)
  String? sortName;

  @HiveField(19)
  String? forcedSortName;

  /// Enum: "HalfSideBySide" "FullSideBySide" "FullTopAndBottom"
  /// "HalfTopAndBottom" "MVC"
  /// Gets or sets the video3 D format.
  @HiveField(20)
  String? video3DFormat;

  /// Gets or sets the premiere date.
  @HiveField(21)
  String? premiereDate;

  /// Gets or sets the external urls.
  @HiveField(22)
  List<ExternalUrl>? externalUrls;

  /// Gets or sets the media versions.
  @HiveField(23)
  List<MediaSourceInfo>? mediaSources;

  /// Gets or sets the critic rating.
  @HiveField(24)
  double? criticRating;

  @HiveField(25)
  List<String>? productionLocations;

  /// Gets or sets the path.
  @HiveField(26)
  String? path;

  /// Gets or sets the official rating.
  @HiveField(27)
  String? officialRating;

  /// Gets or sets the custom rating.
  @HiveField(28)
  String? customRating;

  /// Gets or sets the channel identifier.
  @HiveField(29)
  String? channelId;

  @HiveField(30)
  String? channelName;

  /// Gets or sets the overview.
  @HiveField(31)
  String? overview;

  /// Gets or sets the taglines.
  @HiveField(32)
  List<String>? taglines;

  /// Gets or sets the genres.
  @HiveField(33)
  List<String>? genres;

  /// Gets or sets the community rating.
  @HiveField(34)
  double? communityRating;

  /// Gets or sets the run time ticks.
  @HiveField(35)
  int? runTimeTicks;

  /// Enum: "Full" "None"
  /// Gets or sets the play access.
  @HiveField(36)
  String? playAccess;

  /// Gets or sets the aspect ratio.
  @HiveField(37)
  String? aspectRatio;

  /// Gets or sets the production year.
  @HiveField(38)
  int? productionYear;

  /// Gets or sets the number.
  @HiveField(39)
  String? number;

  @HiveField(40)
  String? channelNumber;

  /// Gets or sets the index number.
  @HiveField(41)
  int? indexNumber;

  /// Gets or sets the index number end.
  @HiveField(42)
  int? indexNumberEnd;

  /// Gets or sets the parent index number.
  @HiveField(43)
  int? parentIndexNumber;

  /// Gets or sets the trailer urls.
  @HiveField(44)
  List<MediaUrl>? remoteTrailers;

  /// Gets or sets the provider ids.
  @HiveField(45)
  Map<String, dynamic>? providerIds;

  /// Gets or sets a value indicating whether this instance is folder.
  @HiveField(46)
  bool? isFolder;

  /// Gets or sets the parent id.
  @HiveField(47)
  String? parentId;

  /// Gets or sets the type.
  @HiveField(48)
  String? type;

  /// Gets or sets the people.
  @HiveField(49)
  List<BaseItemPerson>? people;

  /// Gets or sets the studios.
  @HiveField(50)
  List<NameLongIdPair>? studios;

  @HiveField(51)
  List<NameLongIdPair>? genreItems;

  /// If the item does not have a logo, this will hold the Id of the Parent that
  /// has one.
  @HiveField(52)
  String? parentLogoItemId;

  /// If the item does not have any backdrops, this will hold the Id of the
  /// Parent that has one.
  @HiveField(53)
  String? parentBackdropItemId;

  /// Gets or sets the parent backdrop image tags.
  @HiveField(54)
  List<String>? parentBackdropImageTags;

  /// Gets or sets the local trailer count.
  @HiveField(55)
  int? localTrailerCount;

  /// User data for this item based on the user it's being requested for.
  @HiveField(56)
  UserItemDataDto? userData;

  /// Gets or sets the recursive item count.
  @HiveField(57)
  int? recursiveItemCount;

  /// Gets or sets the child count.
  @HiveField(58)
  int? childCount;

  /// Gets or sets the name of the series.
  @HiveField(59)
  String? seriesName;

  /// Gets or sets the series id.
  @HiveField(60)
  String? seriesId;

  /// Gets or sets the season identifier.
  @HiveField(61)
  String? seasonId;

  /// Gets or sets the special feature count.
  @HiveField(62)
  int? specialFeatureCount;

  /// Gets or sets the display preferences id.
  @HiveField(63)
  String? displayPreferencesId;

  /// Gets or sets the status.
  @HiveField(64)
  String? status;

  /// Gets or sets the air time.
  @HiveField(65)
  String? airTime;

  /// Items Enum: "Sunday" "Monday" "Tuesday" "Wednesday" "Thursday" "Friday"
  /// "Saturday"
  /// Gets or sets the air days.
  @HiveField(66)
  List<String>? airDays;

  /// Gets or sets the tags.
  @HiveField(67)
  List<String>? tags;

  /// Gets or sets the primary image aspect ratio, after image enhancements.
  @HiveField(68)
  double? primaryImageAspectRatio;

  /// Gets or sets the artists.
  @HiveField(69)
  List<String>? artists;

  /// Gets or sets the artist items.
  @HiveField(70)
  List<NameIdPair>? artistItems;

  /// Gets or sets the album.
  @HiveField(71)
  String? album;

  /// Gets or sets the type of the collection.
  @HiveField(72)
  String? collectionType;

  /// Gets or sets the display order.
  @HiveField(73)
  String? displayOrder;

  /// Gets or sets the album id.
  @HiveField(74)
  String? albumId;

  /// Gets or sets the album image tag.
  @HiveField(75)
  String? albumPrimaryImageTag;

  /// Gets or sets the series primary image tag.
  @HiveField(76)
  String? seriesPrimaryImageTag;

  /// Gets or sets the album artist.
  @HiveField(77)
  String? albumArtist;

  /// Gets or sets the album artists.
  @HiveField(78)
  List<NameIdPair>? albumArtists;

  /// Gets or sets the name of the season.
  @HiveField(79)
  String? seasonName;

  /// Gets or sets the media streams.
  @HiveField(80)
  List<MediaStream>? mediaStreams;

  /// Gets or sets the part count.
  @HiveField(81)
  int? partCount;

  /// Gets or sets the image tags.
  @HiveField(82)
  Map<dynamic, String>? imageTags;

  /// Gets or sets the backdrop image tags.
  @HiveField(83)
  List<String>? backdropImageTags;

  /// Gets or sets the parent logo image tag.
  @HiveField(84)
  String? parentLogoImageTag;

  /// If the item does not have a art, this will hold the Id of the Parent that
  /// has one.
  @HiveField(85)
  String? parentArtItemId;

  /// Gets or sets the parent art image tag.
  @HiveField(86)
  String? parentArtImageTag;

  /// Gets or sets the series thumb image tag.
  @HiveField(87)
  String? seriesThumbImageTag;

  /// Gets or sets the series studio.
  @HiveField(88)
  String? seriesStudio;

  /// Gets or sets the parent thumb item id.
  @HiveField(89)
  String? parentThumbItemId;

  /// Gets or sets the parent thumb image tag.
  @HiveField(90)
  String? parentThumbImageTag;

  /// Gets or sets the parent primary image item identifier.
  @HiveField(91)
  String? parentPrimaryImageItemId;

  /// Gets or sets the parent primary image tag.
  @HiveField(92)
  String? parentPrimaryImageTag;

  /// Gets or sets the chapters.
  @HiveField(93)
  List<ChapterInfo>? chapters;

  /// Enum: "FileSystem" "Remote" "Virtual" "Offline"
  /// Gets or sets the type of the location.
  @HiveField(94)
  String? locationType;

  /// Gets or sets the type of the media.
  @HiveField(95)
  String? mediaType;

  /// Gets or sets the end date.
  @HiveField(96)
  String? endDate;

  /// Items Enum: "Cast" "Genres" "ProductionLocations" "Studios" "Tags" "Name"
  /// "Overview" "Runtime" "OfficialRating"
  /// Gets or sets the locked fields.
  @HiveField(97)
  List<String>? lockedFields;

  /// Gets or sets a value indicating whether [enable internet providers].
  @HiveField(98)
  bool? lockData;

  @HiveField(99)
  int? width;

  @HiveField(100)
  int? height;

  @HiveField(101)
  String? cameraMake;

  @HiveField(102)
  String? cameraModel;

  @HiveField(103)
  String? software;

  @HiveField(104)
  double? exposureTime;

  @HiveField(105)
  double? focalLength;

  /// Enum: "TopLeft" "TopRight" "BottomRight" "BottomLeft" "LeftTop" "RightTop"
  /// "RightBottom" "LeftBottom"
  @HiveField(106)
  String? imageOrientation;

  @HiveField(107)
  double? aperture;

  @HiveField(108)
  double? shutterSpeed;

  @HiveField(109)
  double? latitude;

  @HiveField(110)
  double? longitude;

  @HiveField(111)
  double? altitude;

  @HiveField(112)
  int? isoSpeedRating;

  /// Gets or sets the series timer identifier.
  @HiveField(113)
  String? seriesTimerId;

  /// Gets or sets the channel primary image tag.
  @HiveField(114)
  String? channelPrimaryImageTag;

  /// The start date of the recording, in UTC.
  @HiveField(115)
  String? startDate;

  /// Gets or sets the completion percentage.
  @HiveField(116)
  double? completionPercentage;

  /// Gets or sets a value indicating whether this instance is repeat.
  @HiveField(117)
  bool? isRepeat;

  /// Gets or sets the episode title.
  @HiveField(118)
  String? episodeTitle;

  /// Gets or sets a value indicating whether this instance is movie.
  @HiveField(119)
  bool? isMovie;

  /// Gets or sets a value indicating whether this instance is sports.
  @HiveField(120)
  bool? isSports;

  /// Gets or sets a value indicating whether this instance is series.
  @HiveField(121)
  bool? isSeries;

  /// Gets or sets a value indicating whether this instance is live.
  @HiveField(122)
  bool? isLive;

  /// Gets or sets a value indicating whether this instance is news.
  @HiveField(123)
  bool? isNews;

  /// Gets or sets a value indicating whether this instance is kids.
  @HiveField(124)
  bool? isKids;

  /// Gets or sets a value indicating whether this instance is premiere.
  @HiveField(125)
  bool? isPremiere;

  /// Gets or sets the timer identifier.
  @HiveField(126)
  String? timerId;

  /// Gets or sets the current program.
  @HiveField(127)
  dynamic currentProgram;

  /// Gets or sets the movie count.
  @HiveField(128)
  int? movieCount;

  /// Gets or sets the series count.
  @HiveField(129)
  int? seriesCount;

  /// Gets or sets the album count.
  @HiveField(130)
  int? albumCount;

  /// Gets or sets the song count.
  @HiveField(131)
  int? songCount;

  /// Gets or sets the music video count.
  @HiveField(132)
  int? musicVideoCount;

  // Below fields were added during null safety migration (0.5.0)

  /// Gets or sets the type of the source.
  @HiveField(133)
  String? sourceType;

  @HiveField(134)
  String? dateLastMediaAdded;

  @HiveField(135)
  bool? enableMediaSourceDisplay;

  /// Gets or sets the cumulative run time ticks.
  @HiveField(136)
  int? cumulativeRunTimeTicks;

  /// Gets or sets a value indicating whether this instance is place holder.
  @HiveField(137)
  bool? isPlaceHolder;

  /// Gets or sets a value indicating whether this instance is HD.
  @HiveField(138)
  bool? isHD;

  /// Enum: "VideoFile" "Iso" "Dvd" "BluRay"
  /// Gets or sets the type of the video.
  @HiveField(139)
  String? videoType;

  @HiveField(140)
  int? mediaSourceCount;

  /// Gets or sets the screenshot image tags.
  @HiveField(141)
  List<String>? screenshotImageTags;

  /// Gets or sets the blurhashes for the image tags. Maps image type to
  /// dictionary mapping image tag to blurhash value.
  @HiveField(142)
  ImageBlurHashes? imageBlurHashes;

  /// Enum: "Dvd" "BluRay"
  /// Gets or sets the type of the iso.
  @HiveField(143)
  String? isoType;

  /// Gets or sets the trailer count.
  @HiveField(144)
  int? trailerCount;

  @HiveField(145)
  int? programCount;

  /// Gets or sets the episode count.
  @HiveField(146)
  int? episodeCount;

  @HiveField(147)
  int? artistCount;

  /// Gets or sets the program identifier.
  @HiveField(148)
  String? programId;

  /// Enum: "TV" "Radio"
  /// Gets or sets the type of the channel.
  @HiveField(149)
  String? channelType;

  /// Enum: "Mono" "Stereo" "Dolby" "DolbyDigital" "Thx" "Atmos"
  /// Gets or sets the audio.
  @HiveField(150)
  String? audio;

  factory BaseItemDto.fromJson(Map<String, dynamic> json) =>
      _$BaseItemDtoFromJson(json);
  Map<String, dynamic> toJson() => _$BaseItemDtoToJson(this);
}

@JsonSerializable(
  fieldRename: FieldRename.pascal,
  explicitToJson: true,
  anyMap: true,
)
@HiveType(typeId: 29)
class ExternalUrl {
  ExternalUrl({
    this.name,
    this.url,
  });

  @HiveField(0)
  String? name;

  @HiveField(1)
  String? url;

  factory ExternalUrl.fromJson(Map<String, dynamic> json) =>
      _$ExternalUrlFromJson(json);
  Map<String, dynamic> toJson() => _$ExternalUrlToJson(this);
}

@JsonSerializable(
  fieldRename: FieldRename.pascal,
  explicitToJson: true,
  anyMap: true,
)
@HiveType(typeId: 5)
class MediaSourceInfo {
  MediaSourceInfo({
    required this.protocol,
    this.id,
    this.path,
    this.encoderPath,
    this.encoderProtocol,
    required this.type,
    this.container,
    this.size,
    this.name,
    required this.isRemote,
    this.runTimeTicks,
    required this.supportsTranscoding,
    required this.supportsDirectStream,
    required this.supportsDirectPlay,
    required this.isInfiniteStream,
    required this.requiresOpening,
    this.openToken,
    required this.requiresClosing,
    this.liveStreamId,
    this.bufferMs,
    required this.requiresLooping,
    required this.supportsProbing,
    this.video3DFormat,
    required this.mediaStreams,
    this.formats,
    this.bitrate,
    this.timestamp,
    this.requiredHttpHeaders,
    this.transcodingUrl,
    this.transcodingSubProtocol,
    this.transcodingContainer,
    this.analyzeDurationMs,
    required this.readAtNativeFramerate,
    this.defaultAudioStreamIndex,
    this.defaultSubtitleStreamIndex,
    this.etag,
    required this.ignoreDts,
    required this.ignoreIndex,
    required this.genPtsInput,
    this.videoType,
    this.isoType,
    this.mediaAttachments,
  });

  /// Enum: "File" "Http" "Rtmp" "Rtsp" "Udp" "Rtp" "Ftp"
  @HiveField(0)
  String protocol;

  @HiveField(1)
  String? id;

  @HiveField(2)
  String? path;

  @HiveField(3)
  String? encoderPath;

  /// Enum: "File" "Http" "Rtmp" "Rtsp" "Udp" "Rtp" "Ftp"
  @HiveField(4)
  String? encoderProtocol;

  /// Enum: "Default" "Grouping" "Placeholder"
  @HiveField(5)
  String type;

  @HiveField(6)
  String? container;

  @HiveField(7)
  int? size;

  @HiveField(8)
  String? name;

  /// Differentiate internet url vs local network.
  @HiveField(9)
  bool isRemote;

  @HiveField(10)
  int? runTimeTicks;

  @HiveField(11)
  bool supportsTranscoding;

  @HiveField(12)
  bool supportsDirectStream;

  @HiveField(13)
  bool supportsDirectPlay;

  @HiveField(14)
  bool isInfiniteStream;

  @HiveField(15)
  bool requiresOpening;

  @HiveField(16)
  String? openToken;

  @HiveField(17)
  bool requiresClosing;

  @HiveField(18)
  String? liveStreamId;

  @HiveField(19)
  int? bufferMs;

  @HiveField(20)
  bool requiresLooping;

  @HiveField(21)
  bool supportsProbing;

  /// Enum: "HalfSideBySide" "FullSideBySide" "FullTopAndBottom"
  /// "HalfTopAndBottom" "MVC"
  @HiveField(22)
  String? video3DFormat;

  @HiveField(23)
  List<MediaStream> mediaStreams;

  @HiveField(24)
  List<String>? formats;

  @HiveField(25)
  int? bitrate;

  /// Enum: "None" "Zero" "Valid"
  @HiveField(26)
  String? timestamp;

  @HiveField(27)
  Map<dynamic, String>? requiredHttpHeaders;

  @HiveField(28)
  String? transcodingUrl;

  @HiveField(29)
  String? transcodingSubProtocol;

  @HiveField(30)
  String? transcodingContainer;

  @HiveField(31)
  int? analyzeDurationMs;

  @HiveField(32)
  bool readAtNativeFramerate;

  @HiveField(33)
  int? defaultAudioStreamIndex;

  @HiveField(34)
  int? defaultSubtitleStreamIndex;

  // Below fields were added during null safety migration (0.5.0)

  @HiveField(35)
  String? etag;

  @HiveField(36)
  bool ignoreDts;

  @HiveField(37)
  bool ignoreIndex;

  @HiveField(38)
  bool genPtsInput;

  /// Enum: "VideoFile" "Iso" "Dvd" "BluRay"
  /// Enum VideoType.
  @HiveField(39)
  String? videoType;

  /// Enum: "Dvd" "BluRay"
  /// Enum IsoType.
  @HiveField(40)
  String? isoType;

  @HiveField(41)
  List<MediaAttachment>? mediaAttachments;

  factory MediaSourceInfo.fromJson(Map<String, dynamic> json) =>
      _$MediaSourceInfoFromJson(json);
  Map<String, dynamic> toJson() => _$MediaSourceInfoToJson(this);
}

@JsonSerializable(
  fieldRename: FieldRename.pascal,
  explicitToJson: true,
  anyMap: true,
)
@HiveType(typeId: 6)
class MediaStream {
  MediaStream({
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
    this.videoRange,
    this.displayTitle,
    this.nalLengthSize,
    required this.isInterlaced,
    this.isAVC,
    this.channelLayout,
    this.bitRate,
    this.bitDepth,
    this.refFrames,
    this.packetLength,
    this.channels,
    this.sampleRate,
    required this.isDefault,
    required this.isForced,
    this.height,
    this.width,
    this.averageFrameRate,
    this.realFrameRate,
    this.profile,
    required this.type,
    this.aspectRatio,
    required this.index,
    this.score,
    required this.isExternal,
    this.deliveryMethod,
    this.deliveryUrl,
    this.isExternalUrl,
    required this.isTextSubtitleStream,
    required this.supportsExternalStream,
    this.path,
    this.pixelFormat,
    this.level,
    this.isAnamorphic,
  });

  /// Gets or sets the codec.
  @HiveField(0)
  String? codec;

  /// Gets or sets the codec tag.
  @HiveField(1)
  String? codecTag;

  /// Gets or sets the language.
  @HiveField(2)
  String? language;

  /// Gets or sets the color transfer.
  @HiveField(3)
  String? colorTransfer;

  /// Gets or sets the color primaries.
  @HiveField(4)
  String? colorPrimaries;

  /// Gets or sets the color space.
  @HiveField(5)
  String? colorSpace;

  /// Gets or sets the comment.
  @HiveField(6)
  String? comment;

  /// Gets or sets the time base.
  @HiveField(7)
  String? timeBase;

  /// Gets or sets the codec time base.
  @HiveField(8)
  String? codecTimeBase;

  /// Gets or sets the title.
  @HiveField(9)
  String? title;

  /// Gets or sets the video range.
  @HiveField(10)
  String? videoRange;

  @HiveField(11)
  String? displayTitle;

  @HiveField(12)
  String? nalLengthSize;

  /// Gets or sets a value indicating whether this instance is interlaced.
  @HiveField(13)
  bool isInterlaced;

  @HiveField(14)
  bool? isAVC;

  /// Gets or sets the channel layout.
  @HiveField(15)
  String? channelLayout;

  /// Gets or sets the bit rate.
  @HiveField(16)
  int? bitRate;

  /// Gets or sets the bit depth.
  @HiveField(17)
  int? bitDepth;

  /// Gets or sets the reference frames.
  @HiveField(18)
  int? refFrames;

  /// Gets or sets the length of the packet.
  @HiveField(19)
  int? packetLength;

  /// Gets or sets the channels.
  @HiveField(20)
  int? channels;

  /// Gets or sets the sample rate.
  @HiveField(21)
  int? sampleRate;

  /// Gets or sets a value indicating whether this instance is default.
  @HiveField(22)
  bool isDefault;

  /// Gets or sets a value indicating whether this instance is forced.
  @HiveField(23)
  bool isForced;

  /// Gets or sets the height.
  @HiveField(24)
  int? height;

  /// Gets or sets the width.
  @HiveField(25)
  int? width;

  /// Gets or sets the average frame rate.
  @HiveField(26)
  double? averageFrameRate;

  /// Gets or sets the real frame rate.
  @HiveField(27)
  double? realFrameRate;

  /// Gets or sets the profile.
  @HiveField(28)
  String? profile;

  /// Enum: "Audio" "Video" "Subtitle" "EmbeddedImage"
  /// Gets or sets the type.
  @HiveField(29)
  String type;

  /// Gets or sets the aspect ratio.
  @HiveField(30)
  String? aspectRatio;

  /// Gets or sets the index.
  @HiveField(31)
  int index;

  /// Gets or sets the score.
  @HiveField(32)
  int? score;

  /// Gets or sets a value indicating whether this instance is external.
  @HiveField(33)
  bool isExternal;

  /// Enum: "Encode" "Embed" "External" "Hls"
  /// Gets or sets the method.
  @HiveField(34)
  String? deliveryMethod;

  /// Gets or sets the delivery URL.
  @HiveField(35)
  String? deliveryUrl;

  /// Gets or sets a value indicating whether this instance is external URL.
  @HiveField(36)
  bool? isExternalUrl;

  @HiveField(37)
  bool isTextSubtitleStream;

  /// Gets or sets a value indicating whether [supports external stream].
  @HiveField(38)
  bool supportsExternalStream;

  /// Gets or sets the filename.
  @HiveField(39)
  String? path;

  /// Gets or sets the pixel format.
  @HiveField(40)
  String? pixelFormat;

  /// Gets or sets the level.
  @HiveField(41)
  double? level;

  /// Gets a value indicating whether this instance is anamorphic.
  @HiveField(42)
  bool? isAnamorphic;

  // Below fields were added during null safety migration (0.5.0)

  /// Gets or sets the color range.
  @HiveField(43)
  String? colorRange;

  @HiveField(44)
  String? localizedUndefined;

  @HiveField(45)
  String? localizedDefault;

  @HiveField(46)
  String? localizedForced;

  factory MediaStream.fromJson(Map<String, dynamic> json) =>
      _$MediaStreamFromJson(json);
  Map<String, dynamic> toJson() => _$MediaStreamToJson(this);
}

@JsonSerializable(
  fieldRename: FieldRename.pascal,
  explicitToJson: true,
  anyMap: true,
)
class MediaUrl {
  MediaUrl({this.url, this.name});

  String? url;

  String? name;

  factory MediaUrl.fromJson(Map<String, dynamic> json) =>
      _$MediaUrlFromJson(json);
  Map<String, dynamic> toJson() => _$MediaUrlToJson(this);
}

@JsonSerializable(
  fieldRename: FieldRename.pascal,
  explicitToJson: true,
  anyMap: true,
)
class BaseItemPerson {
  BaseItemPerson({
    this.name,
    this.id,
    this.role,
    this.type,
    this.primaryImageTag,
  });

  /// Gets or sets the name.
  String? name;

  /// Gets or sets the identifier.
  String? id;

  /// Gets or sets the role.
  String? role;

  /// Gets or sets the type.
  String? type;

  /// Gets or sets the primary image tag.
  String? primaryImageTag;

  /// Gets or sets the primary image blurhash.
  ImageBlurHashes? imageBlurHashes;

  factory BaseItemPerson.fromJson(Map<String, dynamic> json) =>
      _$BaseItemPersonFromJson(json);
  Map<String, dynamic> toJson() => _$BaseItemPersonToJson(this);
}

@JsonSerializable(
  fieldRename: FieldRename.pascal,
  explicitToJson: true,
  anyMap: true,
)
@HiveType(typeId: 30)
class NameLongIdPair {
  NameLongIdPair({
    this.name,
    required this.id,
  });

  @HiveField(0)
  String? name;

  @HiveField(1)
  String id;

  factory NameLongIdPair.fromJson(Map<String, dynamic> json) =>
      _$NameLongIdPairFromJson(json);
  Map<String, dynamic> toJson() => _$NameLongIdPairToJson(this);
}

@JsonSerializable(
  fieldRename: FieldRename.pascal,
  explicitToJson: true,
  anyMap: true,
)
@HiveType(typeId: 1)
class UserItemDataDto {
  UserItemDataDto({
    this.rating,
    this.playedPercentage,
    this.unplayedItemCount,
    required this.playbackPositionTicks,
    required this.playCount,
    required this.isFavorite,
    this.likes,
    this.lastPlayedDate,
    required this.played,
    this.key,
    this.itemId,
  });

  /// Gets or sets the rating.
  @HiveField(0)
  double? rating;

  /// Gets or sets the played percentage.
  @HiveField(1)
  double? playedPercentage;

  /// Gets or sets the unplayed item count.
  @HiveField(2)
  int? unplayedItemCount;

  /// Gets or sets the playback position ticks.
  @HiveField(3)
  int playbackPositionTicks;

  /// Gets or sets the play count.
  @HiveField(4)
  int playCount;

  /// Gets or sets a value indicating whether this instance is favorite.
  @HiveField(5)
  bool isFavorite;

  /// Gets or sets a value indicating whether this
  /// MediaBrowser.Model.Dto.UserItemDataDto is likes.
  @HiveField(6)
  bool? likes;

  /// Gets or sets the last played date.
  @HiveField(7)
  String? lastPlayedDate;

  /// Gets or sets a value indicating whether this
  /// MediaBrowser.Model.Dto.UserItemDataDto is played.
  @HiveField(8)
  bool played;

  /// Gets or sets the key.
  @HiveField(9)
  String? key;

  /// Gets or sets the item identifier.
  @HiveField(10)
  String? itemId;

  factory UserItemDataDto.fromJson(Map<String, dynamic> json) =>
      _$UserItemDataDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UserItemDataDtoToJson(this);
}

@JsonSerializable(
  fieldRename: FieldRename.pascal,
  explicitToJson: true,
  anyMap: true,
)
@HiveType(typeId: 2)
class NameIdPair {
  NameIdPair({
    this.name,
    required this.id,
  });

  @HiveField(0)
  String? name;

  @HiveField(1)
  String id;

  factory NameIdPair.fromJson(Map<String, dynamic> json) =>
      _$NameIdPairFromJson(json);
  Map<String, dynamic> toJson() => _$NameIdPairToJson(this);
}

@JsonSerializable(
  fieldRename: FieldRename.pascal,
  explicitToJson: true,
  anyMap: true,
)
class ChapterInfo {
  ChapterInfo({
    required this.startPositionTicks,
    this.name,
    this.imageTag,
    this.imagePath,
    required this.imageDateModified,
  });

  /// Gets or sets the start position ticks.
  int startPositionTicks;

  /// Gets or sets the name.
  String? name;

  String? imageTag;

  // Below fields were added during null safety migration (0.5.0)

  /// Gets or sets the image path.
  String? imagePath;

  String imageDateModified;

  factory ChapterInfo.fromJson(Map<String, dynamic> json) =>
      _$ChapterInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ChapterInfoToJson(this);
}

@JsonSerializable(
  fieldRename: FieldRename.pascal,
  explicitToJson: true,
  anyMap: true,
)
// ignore: camel_case_types
class QueryResult_BaseItemDto {
  QueryResult_BaseItemDto({
    this.items,
    required this.totalRecordCount,
    required this.startIndex,
  });

  /// Gets or sets the items.
  List<BaseItemDto>? items;

  /// The total number of records available.
  int totalRecordCount;

  /// The index of the first record in Items.
  int startIndex;

  factory QueryResult_BaseItemDto.fromJson(Map<String, dynamic> json) =>
      _$QueryResult_BaseItemDtoFromJson(json);
  Map<String, dynamic> toJson() => _$QueryResult_BaseItemDtoToJson(this);
}

@JsonSerializable(
  fieldRename: FieldRename.pascal,
  explicitToJson: true,
  anyMap: true,
)
class PlaybackInfoResponse {
  PlaybackInfoResponse({
    this.mediaSources,
    this.playSessionId,
    this.errorCode,
  });

  /// Gets or sets the media sources.
  List<MediaSourceInfo>? mediaSources;

  /// Gets or sets the play session identifier.
  String? playSessionId;

  /// Enum: "NotAllowed" "NoCompatibleStream" "RateLimitExceeded"
  /// Gets or sets the error code.
  String? errorCode;

  factory PlaybackInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$PlaybackInfoResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PlaybackInfoResponseToJson(this);
}

@JsonSerializable(
  fieldRename: FieldRename.pascal,
  explicitToJson: true,
  anyMap: true,
)
class PlaybackProgressInfo {
  PlaybackProgressInfo({
    this.canSeek = true,
    this.item,
    required this.itemId,
    this.sessionId,
    this.mediaSourceId,
    this.audioStreamIndex,
    this.subtitleStreamIndex,
    required this.isPaused,
    required this.isMuted,
    this.positionTicks,
    this.playbackStartTimeTicks,
    this.volumeLevel,
    this.brightness,
    this.aspectRatio,
    this.playMethod = "DirectPlay",
    this.liveStreamId,
    this.playSessionId,
    required this.repeatMode,
    this.nowPlayingQueue,
    this.playlistItemId,
  });

  /// Gets or sets a value indicating whether this instance can seek.
  bool canSeek;

  /// Gets or sets the item.
  BaseItemDto? item;

  /// Gets or sets the item identifier.
  String itemId;

  /// Gets or sets the session id.
  String? sessionId;

  /// Gets or sets the media version identifier.
  String? mediaSourceId;

  /// Gets or sets the index of the audio stream.
  int? audioStreamIndex;

  /// Gets or sets the index of the subtitle stream.
  int? subtitleStreamIndex;

  /// Gets or sets a value indicating whether this instance is paused.
  bool isPaused;

  /// Gets or sets a value indicating whether this instance is muted.
  bool isMuted;

  /// Gets or sets the position ticks.
  int? positionTicks;

  int? playbackStartTimeTicks;

  /// Gets or sets the volume level.
  int? volumeLevel;

  int? brightness;

  String? aspectRatio;

  /// Enum: "Transcode" "DirectStream" "DirectPlay"
  /// Gets or sets the play method.
  String playMethod;

  /// Gets or sets the live stream identifier.
  String? liveStreamId;

  /// Gets or sets the play session identifier.
  String? playSessionId;

  /// Enum: "RepeatNone" "RepeatAll" "RepeatOne"
  /// Gets or sets the repeat mode.
  String repeatMode;

  List<QueueItem>? nowPlayingQueue;

  String? playlistItemId;

  factory PlaybackProgressInfo.fromJson(Map<String, dynamic> json) =>
      _$PlaybackProgressInfoFromJson(json);
  Map<String, dynamic> toJson() => _$PlaybackProgressInfoToJson(this);
}

@HiveType(typeId: 32)
@JsonSerializable(
  fieldRename: FieldRename.pascal,
  explicitToJson: true,
  anyMap: true,
)
class ImageBlurHashes {
  ImageBlurHashes({
    this.primary,
    this.art,
    this.backdrop,
    this.banner,
    this.logo,
    this.thumb,
    this.disc,
    this.box,
    this.screenshot,
    this.menu,
    this.chapter,
    this.boxRear,
    this.profile,
  });

  @HiveField(0)
  Map<String, String>? primary;

  @HiveField(1)
  Map<String, String>? art;

  @HiveField(2)
  Map<String, String>? backdrop;

  @HiveField(3)
  Map<String, String>? banner;

  @HiveField(4)
  Map<String, String>? logo;

  @HiveField(5)
  Map<String, String>? thumb;

  @HiveField(6)
  Map<String, String>? disc;

  @HiveField(7)
  Map<String, String>? box;

  @HiveField(8)
  Map<String, String>? screenshot;

  @HiveField(9)
  Map<String, String>? menu;

  @HiveField(10)
  Map<String, String>? chapter;

  @HiveField(11)
  Map<String, String>? boxRear;

  @HiveField(12)
  Map<String, String>? profile;

  factory ImageBlurHashes.fromJson(Map<String, dynamic> json) =>
      _$ImageBlurHashesFromJson(json);
  Map<String, dynamic> toJson() => _$ImageBlurHashesToJson(this);
}

@HiveType(typeId: 33)
@JsonSerializable(
  fieldRename: FieldRename.pascal,
  explicitToJson: true,
  anyMap: true,
)
class MediaAttachment {
  MediaAttachment({
    this.codec,
    this.codecTag,
    this.comment,
    required this.index,
    this.fileName,
    this.mimeType,
    this.deliveryUrl,
  });

  /// Gets or sets the codec.
  @HiveField(0)
  String? codec;

  /// Gets or sets the codec tag.
  @HiveField(1)
  String? codecTag;

  /// Gets or sets the comment.
  @HiveField(2)
  String? comment;

  /// Gets or sets the index.
  @HiveField(3)
  int index;

  /// Gets or sets the filename.
  @HiveField(4)
  String? fileName;

  /// Gets or sets the MIME type.
  @HiveField(5)
  String? mimeType;

  /// Gets or sets the delivery URL.
  @HiveField(6)
  String? deliveryUrl;

  factory MediaAttachment.fromJson(Map<String, dynamic> json) =>
      _$MediaAttachmentFromJson(json);
  Map<String, dynamic> toJson() => _$MediaAttachmentToJson(this);
}

@HiveType(typeId: 34)
@JsonSerializable(
  fieldRename: FieldRename.pascal,
  explicitToJson: true,
  anyMap: true,
)
class BaseItem {
  BaseItem({
    this.size,
    this.container,
    this.dateLastSaved,
    this.remoteTrailers,
    required this.isHD,
    required this.isShortcut,
    this.shortcutPath,
    this.width,
    this.height,
    this.extraIds,
    required this.supportsExternalTransfer,
  });

  @HiveField(0)
  int? size;

  @HiveField(1)
  String? container;

  @HiveField(2)
  String? dateLastSaved;

  /// Gets or sets the remote trailers.
  @HiveField(3)
  List<MediaUrl>? remoteTrailers;

  @HiveField(4)
  bool isHD;

  @HiveField(5)
  bool isShortcut;

  @HiveField(6)
  String? shortcutPath;

  @HiveField(7)
  int? width;

  @HiveField(8)
  int? height;

  @HiveField(9)
  List<String>? extraIds;

  @HiveField(10)
  bool supportsExternalTransfer;

  factory BaseItem.fromJson(Map<String, dynamic> json) =>
      _$BaseItemFromJson(json);
  Map<String, dynamic> toJson() => _$BaseItemToJson(this);
}

@HiveType(typeId: 35)
@JsonSerializable(
  fieldRename: FieldRename.pascal,
  explicitToJson: true,
  anyMap: true,
)
class QueueItem {
  QueueItem({
    required this.id,
    this.playlistItemId,
  });

  @HiveField(0)
  String id;

  @HiveField(1)
  String? playlistItemId;

  factory QueueItem.fromJson(Map<String, dynamic> json) =>
      _$QueueItemFromJson(json);
  Map<String, dynamic> toJson() => _$QueueItemToJson(this);
}

/// Class used to create new playlist. Not returned from Jellyfin.
@JsonSerializable(
  fieldRename: FieldRename.pascal,
  explicitToJson: true,
  anyMap: true,
)
class NewPlaylist {
  NewPlaylist({
    this.name,
    required this.ids,
    this.userId,
    this.mediaType,
  });

  /// Gets or sets the name of the new playlist.
  String? name;

  /// Gets or sets item ids to add to the playlist.
  List<String> ids;

  /// Gets or sets the user id. Required when creating playlists, but not adding
  /// to them.
  String? userId;

  /// Gets or sets the media type.
  String? mediaType;

  factory NewPlaylist.fromJson(Map<String, dynamic> json) =>
      _$NewPlaylistFromJson(json);
  Map<String, dynamic> toJson() => _$NewPlaylistToJson(this);
}

/// Jellyfin response when creating new playlist.
@JsonSerializable(
  fieldRename: FieldRename.pascal,
  explicitToJson: true,
  anyMap: true,
)
class NewPlaylistResponse {
  NewPlaylistResponse({this.id});

  String? id;

  factory NewPlaylistResponse.fromJson(Map<String, dynamic> json) =>
      _$NewPlaylistResponseFromJson(json);
  Map<String, dynamic> toJson() => _$NewPlaylistResponseToJson(this);
}

/// Enum for sort types.
@HiveType(typeId: 37)
enum SortBy {
  @HiveField(0)
  album,

  @HiveField(1)
  albumArtist,

  @HiveField(2)
  artist,

  @HiveField(3)
  budget,

  @HiveField(4)
  communityRating,

  @HiveField(5)
  criticRating,

  @HiveField(6)
  dateCreated,

  @HiveField(7)
  datePlayed,

  @HiveField(8)
  playCount,

  @HiveField(9)
  premiereDate,

  @HiveField(10)
  productionYear,

  @HiveField(11)
  sortName,

  @HiveField(12)
  random,

  @HiveField(13)
  revenue,

  @HiveField(14)
  runtime,
}

extension SortByExtension on SortBy {
  /// Human-readable version of the [SortBy]. For example, toString() on
  /// [SortBy.album], toString() would return "SortBy.album". With this
  /// function, the same input would return "Album".
  String get humanReadableName => _humanReadableName(this);

  /// Name used by Jellyfin in API requests.
  String get jellyfinName => _jellyfinName(this);

  String _humanReadableName(SortBy sortBy) {
    switch (sortBy) {
      case SortBy.album:
        return "Album";
      case SortBy.albumArtist:
        return "Album Artist";
      case SortBy.artist:
        return "Artist";
      case SortBy.budget:
        return "Budget";
      case SortBy.communityRating:
        return "Community Rating";
      case SortBy.criticRating:
        return "Critic Rating";
      case SortBy.dateCreated:
        return "Date Added";
      case SortBy.datePlayed:
        return "Date Played";
      case SortBy.playCount:
        return "Play Count";
      case SortBy.premiereDate:
        return "Premiere Date";
      case SortBy.productionYear:
        return "Production Year";
      case SortBy.sortName:
        return "Name";
      case SortBy.random:
        return "Random";
      case SortBy.revenue:
        return "Revenue";
      case SortBy.runtime:
        return "Runtime";
    }
  }

  String _jellyfinName(SortBy sortBy) {
    switch (sortBy) {
      case SortBy.album:
        return "Album";
      case SortBy.albumArtist:
        return "AlbumArtist";
      case SortBy.artist:
        return "Artist";
      case SortBy.budget:
        return "Budget";
      case SortBy.communityRating:
        return "CommunityRating";
      case SortBy.criticRating:
        return "CriticRating";
      case SortBy.dateCreated:
        return "DateCreated";
      case SortBy.datePlayed:
        return "DatePlayed";
      case SortBy.playCount:
        return "PlayCount";
      case SortBy.premiereDate:
        return "PremiereDate";
      case SortBy.productionYear:
        return "ProductionYear";
      case SortBy.sortName:
        return "SortName";
      case SortBy.random:
        return "Random";
      case SortBy.revenue:
        return "Revenue";
      case SortBy.runtime:
        return "Runtime";
    }
  }
}

/// Enum for sort orders.
@HiveType(typeId: 38)
enum SortOrder {
  @HiveField(0)
  ascending,

  @HiveField(1)
  descending,
}

extension SortOrderExtension on SortOrder {
  /// Human-readable version of the [SortOrder]. For example, toString() on
  /// [SortOrder.ascending], toString() would return "SortOrder.ascending". With
  /// this function, the same input would return "Ascending". This function is
  /// also used in Jellyfin API calls, but another function will be needed when
  /// localisation support is added.
  String get humanReadableName => _humanReadableName(this);

  String _humanReadableName(SortOrder sortOrder) {
    switch (sortOrder) {
      case SortOrder.ascending:
        return "Ascending";
      case SortOrder.descending:
        return "Descending";
    }
  }
}
