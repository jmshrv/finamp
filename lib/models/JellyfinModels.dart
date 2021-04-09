import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'JellyfinModels.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
@HiveType(typeId: 9)
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
      this.lastLoginDate,
      this.lastActivityDate,
      this.configuration,
      this.policy,
      this.primaryImageAspectRatio);

  @HiveField(0)
  final String name;
  @HiveField(1)
  final String serverId;
  @HiveField(2)
  final String serverName;
  @HiveField(3)
  final String connectUserName;
  @HiveField(4)
  final String connectLinkType;
  @HiveField(5)
  final String id;
  @HiveField(6)
  final String primaryImageTag;
  @HiveField(7)
  final bool hasPassword;
  @HiveField(8)
  final bool hasConfiguredPassword;
  @HiveField(9)
  final bool hasConfiguredEasyPassword;
  @HiveField(10)
  final bool enableAutoLogin;
  @HiveField(11)
  final String lastLoginDate;
  @HiveField(12)
  final String lastActivityDate;
  @HiveField(13)
  final UserConfiguration configuration;
  @HiveField(14)
  final UserPolicy policy;
  @HiveField(15)
  final double primaryImageAspectRatio;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
@HiveType(typeId: 11)
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

  @HiveField(0)
  final String audioLanguagePreference;
  @HiveField(1)
  final bool playDefaultAudioTrack;
  @HiveField(2)
  final String subtitleLanguagePreference;
  @HiveField(3)
  final bool displayMissingEpisodes;
  @HiveField(4)
  final List<String> groupedFolders;
  @HiveField(5)
  final String subtitleMode;
  @HiveField(6)
  final bool displayCollectionsView;
  @HiveField(7)
  final bool enableLocalPassword;
  @HiveField(8)
  final List<String> orderedViews;
  @HiveField(9)
  final List<String> latestItemsExcludes;
  @HiveField(10)
  final List<String> myMediaExcludes;
  @HiveField(11)
  final bool hidePlayedInLatest;
  @HiveField(12)
  final bool rememberAudioSelections;
  @HiveField(13)
  final bool rememberSubtitleSelections;
  @HiveField(14)
  final bool enableNextEpisodeAutoPlay;

  factory UserConfiguration.fromJson(Map<String, dynamic> json) =>
      _$UserConfigurationFromJson(json);
  Map<String, dynamic> toJson() => _$UserConfigurationToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
@HiveType(typeId: 12)
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

  @HiveField(0)
  final bool isAdministrator;
  @HiveField(1)
  final bool isHidden;
  @HiveField(2)
  final bool isHiddenRemotely;
  @HiveField(3)
  final bool isDisabled;
  @HiveField(4)
  final int maxParentalRating;
  @HiveField(5)
  final List<String> blockedTags;
  @HiveField(6)
  final bool enableUserPreferenceAccess;
  @HiveField(7)
  final List<AccessSchedule> accessSchedules;
  @HiveField(8)
  final List<String> blockUnratedItems;
  @HiveField(9)
  final bool enableRemoteControlOfOtherUsers;
  @HiveField(10)
  final bool enableSharedDeviceControl;
  @HiveField(11)
  final bool enableRemoteAccess;
  @HiveField(12)
  final bool enableLiveTvManagement;
  @HiveField(13)
  final bool enableLiveTvAccess;
  @HiveField(14)
  final bool enableMediaPlayback;
  @HiveField(15)
  final bool enableAudioPlaybackTranscoding;
  @HiveField(16)
  final bool enableVideoPlaybackTranscoding;
  @HiveField(17)
  final bool enablePlaybackRemuxing;
  @HiveField(18)
  final bool enableContentDeletion;
  @HiveField(19)
  final List<String> enableContentDeletionFromFolders;
  @HiveField(20)
  final bool enableContentDownloading;
  @HiveField(21)
  final bool enableSubtitleDownloading;
  @HiveField(22)
  final bool enableSubtitleManagement;
  @HiveField(23)
  final bool enableSyncTranscoding;
  @HiveField(24)
  final bool enableMediaConversion;
  @HiveField(25)
  final List<String> enabledDevices;
  @HiveField(26)
  final bool enableAllDevices;
  @HiveField(27)
  final List<String> enabledChannels;
  @HiveField(28)
  final bool enableAllChannels;
  @HiveField(29)
  final List<String> enabledFolders;
  @HiveField(30)
  final bool enableAllFolders;
  @HiveField(31)
  final int invalidLoginAttemptCount;
  @HiveField(32)
  final bool enablePublicSharing;
  @HiveField(33)
  final List<String> blockedMediaFolders;
  @HiveField(34)
  final List<String> blockedChannels;
  @HiveField(35)
  final int remoteClientBitrateLimit;
  @HiveField(36)
  final String authenticationProviderId;
  @HiveField(37)
  final List<String> excludedSubFolders;
  @HiveField(38)
  final bool disablePremiumFeatures;

  factory UserPolicy.fromJson(Map<String, dynamic> json) =>
      _$UserPolicyFromJson(json);
  Map<String, dynamic> toJson() => _$UserPolicyToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
@HiveType(typeId: 13)
class AccessSchedule {
  AccessSchedule(this.dayOfWeek, this.startHour, this.endHour);

  @HiveField(0)
  final String dayOfWeek;
  @HiveField(1)
  final double startHour;
  @HiveField(2)
  final double endHour;

  factory AccessSchedule.fromJson(Map<String, dynamic> json) =>
      _$AccessScheduleFromJson(json);
  Map<String, dynamic> toJson() => _$AccessScheduleToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
@HiveType(typeId: 7)
class AuthenticationResult {
  AuthenticationResult(
      this.user, this.sessionInfo, this.accessToken, this.serverId);

  @HiveField(0)
  final UserDto user;
  @HiveField(1)
  final SessionInfo sessionInfo;
  @HiveField(2)
  final String accessToken;
  @HiveField(3)
  final String serverId;

  factory AuthenticationResult.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationResultFromJson(json);
  Map<String, dynamic> toJson() => _$AuthenticationResultToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
@HiveType(typeId: 10)
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
      this.transcodingInfo,
      this.supportsRemoteControl);

  @HiveField(0)
  final PlayerStateInfo playState;
  @HiveField(1)
  final List<SessionUserInfo> additionalUsers;
  @HiveField(2)
  final ClientCapabilities capabilities;
  @HiveField(3)
  final String remoteEndPoint;
  @HiveField(4)
  final List<String> playableMediaTypes;
  @HiveField(5)
  final String playlistItemId;
  @HiveField(6)
  final String id;
  @HiveField(7)
  final String serverId;
  @HiveField(8)
  final String userId;
  @HiveField(9)
  final String userName;
  @HiveField(10)
  final String userPrimaryImageTag;
  @HiveField(11)
  final String client;
  @HiveField(12)
  final String lastActivityDate;
  @HiveField(13)
  final String deviceName;
  @HiveField(14)
  final String deviceType;
  @HiveField(15)
  final BaseItemDto nowPlayingItem;
  @HiveField(16)
  final String deviceId;
  @HiveField(17)
  final String appIconUrl;
  @HiveField(18)
  final List<String> supportedCommands;
  @HiveField(19)
  final TranscodingInfo transcodingInfo;
  @HiveField(20)
  final bool supportsRemoteControl;

  factory SessionInfo.fromJson(Map<String, dynamic> json) =>
      _$SessionInfoFromJson(json);
  Map<String, dynamic> toJson() => _$SessionInfoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
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

  final String audioCodec;
  final String videoCodec;
  final String container;
  final bool isVideoDirect;
  final bool isAudioDirect;
  final int bitrate;
  final double framerate;
  final double completionPercentage;
  final double transcodingPositionTicks;
  final double transcodingStartPositionTicks;
  final int width;
  final int height;
  final int audioChannels;
  final List<String> transcodeReasons;
  final double currentCpuUsage;
  final double averageCpuUsage;
  final List<Map<String, double>> cpuHistory;
  final int currentThrottle;
  final String videoDecoder;
  final bool videoDecoderIsHardware;
  final String videoDecoderMediaType;
  final String videoDecoderHwAccel;
  final String videoEncoder;
  final bool videoEncoderIsHardware;
  final String videoEncoderMediaType;
  final String videoEncoderHwAccel;

  factory TranscodingInfo.fromJson(Map<String, dynamic> json) =>
      _$TranscodingInfoFromJson(json);
  Map<String, dynamic> toJson() => _$TranscodingInfoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
@HiveType(typeId: 14)
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

  @HiveField(0)
  final int positionTicks;
  @HiveField(1)
  final bool canSeek;
  @HiveField(2)
  final bool isPaused;
  @HiveField(3)
  final bool isMuted;
  @HiveField(4)
  final int volumeLevel;
  @HiveField(5)
  final int audioStreamIndex;
  @HiveField(6)
  final int subtitleStreamIndex;
  @HiveField(7)
  final String mediaSourceId;
  @HiveField(8)
  final String playMethod;
  @HiveField(9)
  final String repeatMode;

  factory PlayerStateInfo.fromJson(Map<String, dynamic> json) =>
      _$PlayerStateInfoFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerStateInfoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
@HiveType(typeId: 15)
class SessionUserInfo {
  SessionUserInfo(this.userId, this.userName, this.userInternalId);

  @HiveField(0)
  final String userId;
  @HiveField(1)
  final String userName;
  @HiveField(2)
  final int userInternalId;

  factory SessionUserInfo.fromJson(Map<String, dynamic> json) =>
      _$SessionUserInfoFromJson(json);
  Map<String, dynamic> toJson() => _$SessionUserInfoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
@HiveType(typeId: 16)
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

  @HiveField(0)
  final List<String> playableMediaTypes;
  @HiveField(1)
  final List<String> supportedCommands;
  @HiveField(2)
  final bool supportsMediaControl;
  @HiveField(3)
  final String pushToken;
  @HiveField(4)
  final String pushTokenType;
  @HiveField(5)
  final bool supportsPersistentIdentifier;
  @HiveField(6)
  final bool supportsSync;
  @HiveField(7)
  final DeviceProfile deviceProfile;
  @HiveField(8)
  final String iconUrl;
  @HiveField(9)
  final String appId;

  factory ClientCapabilities.fromJson(Map<String, dynamic> json) =>
      _$ClientCapabilitiesFromJson(json);
  Map<String, dynamic> toJson() => _$ClientCapabilitiesToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
@HiveType(typeId: 17)
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

  @HiveField(0)
  final String name;
  @HiveField(1)
  final String id;
  @HiveField(2)
  final DeviceIdentification identification;
  @HiveField(3)
  final String friendlyName;
  @HiveField(4)
  final String manufacturer;
  @HiveField(5)
  final String manufacturerUrl;
  @HiveField(6)
  final String modelName;
  @HiveField(7)
  final String modelDescription;
  @HiveField(8)
  final String modelNumber;
  @HiveField(9)
  final String modelUrl;
  @HiveField(10)
  final String serialNumber;
  @HiveField(11)
  final bool enableAlbumArtInDidl;
  @HiveField(12)
  final bool enableSingleAlbumArtLimit;
  @HiveField(13)
  final bool enableSingleSubtitleLimit;
  @HiveField(14)
  final String supportedMediaTypes;
  @HiveField(15)
  final String userId;
  @HiveField(16)
  final String albumArtPn;
  @HiveField(17)
  final int maxAlbumArtWidth;
  @HiveField(18)
  final int maxAlbumArtHeight;
  @HiveField(19)
  final int maxIconWidth;
  @HiveField(20)
  final int maxIconHeight;
  @HiveField(21)
  final int maxStreamingBitrate;
  @HiveField(22)
  final int maxStaticBitrate;
  @HiveField(23)
  final int musicStreamingTranscodingBitrate;
  @HiveField(24)
  final int maxStaticMusicBitrate;
  @HiveField(25)
  final String sonyAggregationFlags;
  @HiveField(26)
  final String protocolInfo;
  @HiveField(27)
  final int timelineOffsetSeconds;
  @HiveField(28)
  final bool requiresPlainVideoItems;
  @HiveField(29)
  final bool requiresPlainFolders;
  @HiveField(30)
  final bool enableMSMediaReceiverRegistrar;
  @HiveField(31)
  final bool ignoreTranscodeByteRangeRequests;
  @HiveField(32)
  final List<XmlAttribute> xmlRootAttributes;
  @HiveField(33)
  final List<DirectPlayProfile> directPlayProfiles;
  @HiveField(34)
  final List<TranscodingProfile> transcodingProfiles;
  @HiveField(35)
  final List<ContainerProfile> containerProfiles;
  @HiveField(36)
  final List<CodecProfile> codecProfiles;
  @HiveField(37)
  final List<ResponseProfile> responseProfiles;
  @HiveField(38)
  final List<SubtitleProfile> subtitleProfiles;

  factory DeviceProfile.fromJson(Map<String, dynamic> json) =>
      _$DeviceProfileFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceProfileToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
@HiveType(typeId: 18)
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

  @HiveField(0)
  final String friendlyName;
  @HiveField(1)
  final String modelNumber;
  @HiveField(2)
  final String serialNumber;
  @HiveField(3)
  final String modelName;
  @HiveField(4)
  final String modelDescription;
  @HiveField(5)
  final String deviceDescription;
  @HiveField(6)
  final String modelUrl;
  @HiveField(7)
  final String manufacturer;
  @HiveField(8)
  final String manufacturerUrl;
  @HiveField(9)
  final List<HttpHeaderInfo> headers;

  factory DeviceIdentification.fromJson(Map<String, dynamic> json) =>
      _$DeviceIdentificationFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceIdentificationToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
@HiveType(typeId: 19)
class HttpHeaderInfo {
  HttpHeaderInfo(this.name, this.value, this.match);

  @HiveField(0)
  final String name;
  @HiveField(1)
  final String value;
  @HiveField(2)
  final String match;

  factory HttpHeaderInfo.fromJson(Map<String, dynamic> json) =>
      _$HttpHeaderInfoFromJson(json);
  Map<String, dynamic> toJson() => _$HttpHeaderInfoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
@HiveType(typeId: 20)
class XmlAttribute {
  XmlAttribute(this.name, this.value);

  @HiveField(0)
  final String name;
  @HiveField(1)
  final String value;

  factory XmlAttribute.fromJson(Map<String, dynamic> json) =>
      _$XmlAttributeFromJson(json);
  Map<String, dynamic> toJson() => _$XmlAttributeToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
@HiveType(typeId: 21)
class DirectPlayProfile {
  DirectPlayProfile(
      this.container, this.audioCodec, this.videoCodec, this.type);

  @HiveField(0)
  final String container;
  @HiveField(1)
  final String audioCodec;
  @HiveField(2)
  final String videoCodec;
  @HiveField(3)
  final String type;

  factory DirectPlayProfile.fromJson(Map<String, dynamic> json) =>
      _$DirectPlayProfileFromJson(json);
  Map<String, dynamic> toJson() => _$DirectPlayProfileToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
@HiveType(typeId: 22)
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

  @HiveField(0)
  final String container;
  @HiveField(1)
  final String type;
  @HiveField(2)
  final String videoCodec;
  @HiveField(3)
  final String audioCodec;
  @HiveField(4)
  final String protocol;
  @HiveField(5)
  final bool estimateContentLength;
  @HiveField(6)
  final bool enableMpegtsM2TsMode;
  @HiveField(7)
  final String transcodeSeekInfo;
  @HiveField(8)
  final bool copyTimestamps;
  @HiveField(9)
  final String context;
  @HiveField(10)
  final String maxAudioChannels;
  @HiveField(11)
  final int minSegments;
  @HiveField(12)
  final int segmentLength;
  @HiveField(13)
  final bool breakOnNonKeyFrames;
  @HiveField(14)
  final String manifestSubtitles;

  factory TranscodingProfile.fromJson(Map<String, dynamic> json) =>
      _$TranscodingProfileFromJson(json);
  Map<String, dynamic> toJson() => _$TranscodingProfileToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
@HiveType(typeId: 23)
class ContainerProfile {
  ContainerProfile(this.type, this.conditions, this.container);

  @HiveField(0)
  final String type;
  @HiveField(1)
  final List<ProfileCondition> conditions;
  @HiveField(2)
  final String container;

  factory ContainerProfile.fromJson(Map<String, dynamic> json) =>
      _$ContainerProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ContainerProfileToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
@HiveType(typeId: 24)
class ProfileCondition {
  ProfileCondition(this.condition, this.property, this.value, this.isRequired);

  @HiveField(0)
  final String condition;
  @HiveField(1)
  final String property;
  @HiveField(2)
  final String value;
  @HiveField(3)
  final bool isRequired;

  factory ProfileCondition.fromJson(Map<String, dynamic> json) =>
      _$ProfileConditionFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileConditionToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
@HiveType(typeId: 25)
class CodecProfile {
  CodecProfile(this.type, this.conditions, this.applyConditions, this.codec,
      this.container);

  @HiveField(0)
  final String type;
  @HiveField(1)
  final List<ProfileCondition> conditions;
  @HiveField(2)
  final List<ProfileCondition> applyConditions;
  @HiveField(3)
  final String codec;
  @HiveField(4)
  final String container;

  factory CodecProfile.fromJson(Map<String, dynamic> json) =>
      _$CodecProfileFromJson(json);
  Map<String, dynamic> toJson() => _$CodecProfileToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
@HiveType(typeId: 26)
class ResponseProfile {
  ResponseProfile(this.container, this.audioCodec, this.videoCodec, this.type,
      this.orgPn, this.mimeType, this.conditions);

  @HiveField(0)
  final String container;
  @HiveField(1)
  final String audioCodec;
  @HiveField(2)
  final String videoCodec;
  @HiveField(3)
  final String type;
  @HiveField(4)
  final String orgPn;
  @HiveField(5)
  final String mimeType;
  @HiveField(6)
  final List<ProfileCondition> conditions;

  factory ResponseProfile.fromJson(Map<String, dynamic> json) =>
      _$ResponseProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseProfileToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
@HiveType(typeId: 27)
class SubtitleProfile {
  SubtitleProfile(
      this.format, this.method, this.didlMode, this.language, this.container);

  @HiveField(0)
  final String format;
  @HiveField(1)
  final String method;
  @HiveField(2)
  final String didlMode;
  @HiveField(3)
  final String language;
  @HiveField(4)
  final String container;

  factory SubtitleProfile.fromJson(Map<String, dynamic> json) =>
      _$SubtitleProfileFromJson(json);
  Map<String, dynamic> toJson() => _$SubtitleProfileToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
@HiveType(typeId: 0)
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

  @HiveField(0)
  final String name;
  @HiveField(1)
  final String originalTitle;
  @HiveField(2)
  final String serverId;
  @HiveField(3)
  final String id;
  @HiveField(4)
  final String etag;
  @HiveField(5)
  final String playlistItemId;
  @HiveField(6)
  final String dateCreated;
  @HiveField(7)
  final String extraType;
  @HiveField(8)
  final int airsBeforeSeasonNumber;
  @HiveField(9)
  final int airsAfterSeasonNumber;
  @HiveField(10)
  final int airsBeforeEpisodeNumber;
  @HiveField(11)
  final bool displaySpecialsWithSeasons;
  @HiveField(12)
  final bool canDelete;
  @HiveField(13)
  final bool canDownload;
  @HiveField(14)
  final bool hasSubtitles;
  @HiveField(15)
  final bool supportsResume;
  @HiveField(16)
  final String preferredMetadataLanguage;
  @HiveField(17)
  final String preferredMetadataCountryCode;
  @HiveField(18)
  final bool supportsSync;
  @HiveField(19)
  final String container;
  @HiveField(20)
  final String sortName;
  @HiveField(21)
  final String forcedSortName;
  @HiveField(22)
  final String video3DFormat;
  @HiveField(23)
  final String premiereDate;
  @HiveField(24)
  final List<ExternalUrl> externalUrls;
  @HiveField(25)
  final List<MediaSourceInfo> mediaSources;
  @HiveField(26)
  final double criticRating;
  @HiveField(27)
  final int gameSystemId;
  @HiveField(28)
  final String gameSystem;
  @HiveField(29)
  final List<String> productionLocations;
  @HiveField(30)
  final String path;
  @HiveField(31)
  final String officialRating;
  @HiveField(32)
  final String customRating;
  @HiveField(33)
  final String channelId;
  @HiveField(34)
  final String channelName;
  @HiveField(35)
  final String overview;
  @HiveField(36)
  final List<String> taglines;
  @HiveField(37)
  final List<String> genres;
  @HiveField(38)
  final double communityRating;
  @HiveField(39)
  final int runTimeTicks;
  @HiveField(40)
  final String playAccess;
  @HiveField(41)
  final String aspectRatio;
  @HiveField(42)
  final int productionYear;
  @HiveField(43)
  final String number;
  @HiveField(44)
  final String channelNumber;
  @HiveField(45)
  final int indexNumber;
  @HiveField(46)
  final int indexNumberEnd;
  @HiveField(47)
  final int parentIndexNumber;
  @HiveField(48)
  final List<MediaUrl> remoteTrailers;
  @HiveField(49)
  final Map<dynamic, String> providerIds;
  @HiveField(50)
  final bool isFolder;
  @HiveField(51)
  final String parentId;
  @HiveField(52)
  final String type;
  @HiveField(53)
  final List<BaseItemPerson> people;
  @HiveField(54)
  final List<NameLongIdPair> studios;
  @HiveField(55)
  final List<NameLongIdPair> genreItems;
  @HiveField(56)
  final String parentLogoItemId;
  @HiveField(57)
  final String parentBackdropItemId;
  @HiveField(58)
  final List<String> parentBackdropImageTags;
  @HiveField(59)
  final int localTrailerCount;
  @HiveField(60)
  final UserItemDataDto userData;
  @HiveField(61)
  final int recursiveItemCount;
  @HiveField(62)
  final int childCount;
  @HiveField(63)
  final String seriesName;
  @HiveField(64)
  final String seriesId;
  @HiveField(65)
  final String seasonId;
  @HiveField(66)
  final int specialFeatureCount;
  @HiveField(67)
  final String displayPreferencesId;
  @HiveField(68)
  final String status;
  @HiveField(69)
  final String airTime;
  @HiveField(70)
  final List<String> airDays;
  @HiveField(71)
  final List<String> tags;
  @HiveField(72)
  final double primaryImageAspectRatio;
  @HiveField(73)
  final List<String> artists;
  @HiveField(74)
  final List<NameIdPair> artistItems;
  @HiveField(75)
  final String album;
  @HiveField(76)
  final String collectionType;
  @HiveField(77)
  final String displayOrder;
  @HiveField(78)
  final String albumId;
  @HiveField(79)
  final String albumPrimaryImageTag;
  @HiveField(80)
  final String seriesPrimaryImageTag;
  @HiveField(81)
  final String albumArtist;
  @HiveField(82)
  final List<NameIdPair> albumArtists;
  @HiveField(83)
  final String seasonName;
  @HiveField(84)
  final List<MediaStream> mediaStreams;
  @HiveField(85)
  final int partCount;
  @HiveField(86)
  final Map<dynamic, String> imageTags;
  @HiveField(87)
  final List<String> backdropImageTags;
  @HiveField(88)
  final String parentLogoImageTag;
  @HiveField(89)
  final String parentArtItemId;
  @HiveField(90)
  final String parentArtImageTag;
  @HiveField(91)
  final String seriesThumbImageTag;
  @HiveField(92)
  final String seriesStudio;
  @HiveField(93)
  final String parentThumbItemId;
  @HiveField(94)
  final String parentThumbImageTag;
  @HiveField(95)
  final String parentPrimaryImageItemId;
  @HiveField(96)
  final String parentPrimaryImageTag;
  @HiveField(97)
  final List<ChapterInfo> chapters;
  @HiveField(98)
  final String locationType;
  @HiveField(99)
  final String mediaType;
  @HiveField(100)
  final String endDate;
  @HiveField(101)
  final List<String> lockedFields;
  @HiveField(102)
  final bool lockData;
  @HiveField(103)
  final int width;
  @HiveField(104)
  final int height;
  @HiveField(105)
  final String cameraMake;
  @HiveField(106)
  final String cameraModel;
  @HiveField(107)
  final String software;
  @HiveField(108)
  final double exposureTime;
  @HiveField(109)
  final double focalLength;
  @HiveField(110)
  final String imageOrientation;
  @HiveField(111)
  final double aperture;
  @HiveField(112)
  final double shutterSpeed;
  @HiveField(113)
  final double latitude;
  @HiveField(114)
  final double longitude;
  @HiveField(115)
  final double altitude;
  @HiveField(116)
  final int isoSpeedRating;
  @HiveField(117)
  final String seriesTimerId;
  @HiveField(118)
  final String channelPrimaryImageTag;
  @HiveField(119)
  final String startDate;
  @HiveField(120)
  final double completionPercentage;
  @HiveField(121)
  final bool isRepeat;
  @HiveField(122)
  final bool isNew;
  @HiveField(123)
  final String episodeTitle;
  @HiveField(124)
  final bool isMovie;
  @HiveField(125)
  final bool isSports;
  @HiveField(126)
  final bool isSeries;
  @HiveField(127)
  final bool isLive;
  @HiveField(128)
  final bool isNews;
  @HiveField(129)
  final bool isKids;
  @HiveField(130)
  final bool isPremiere;
  @HiveField(131)
  final String timerId;
  @HiveField(132)
  final dynamic currentProgram;
  @HiveField(133)
  final int movieCount;
  @HiveField(134)
  final int seriesCount;
  @HiveField(135)
  final int albumCount;
  @HiveField(136)
  final int songCount;
  @HiveField(137)
  final int musicVideoCount;

  factory BaseItemDto.fromJson(Map<String, dynamic> json) =>
      _$BaseItemDtoFromJson(json);
  Map<String, dynamic> toJson() => _$BaseItemDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
class ExternalUrl {
  ExternalUrl(this.name, this.url);

  final String name;
  final String url;

  factory ExternalUrl.fromJson(Map<String, dynamic> json) =>
      _$ExternalUrlFromJson(json);
  Map<String, dynamic> toJson() => _$ExternalUrlToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
@HiveType(typeId: 5)
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

  @HiveField(0)
  final String protocol;
  @HiveField(1)
  final String id;
  @HiveField(2)
  final String path;
  @HiveField(3)
  final String encoderPath;
  @HiveField(4)
  final String encoderProtocol;
  @HiveField(5)
  final String type;
  @HiveField(6)
  final String container;
  @HiveField(7)
  final int size;
  @HiveField(8)
  final String name;
  @HiveField(9)
  final bool isRemote;
  @HiveField(10)
  final int runTimeTicks;
  @HiveField(11)
  final bool supportsTranscoding;
  @HiveField(12)
  final bool supportsDirectStream;
  @HiveField(13)
  final bool supportsDirectPlay;
  @HiveField(14)
  final bool isInfiniteStream;
  @HiveField(15)
  final bool requiresOpening;
  @HiveField(16)
  final String openToken;
  @HiveField(17)
  final bool requiresClosing;
  @HiveField(18)
  final String liveStreamId;
  @HiveField(19)
  final int bufferMs;
  @HiveField(20)
  final bool requiresLooping;
  @HiveField(21)
  final bool supportsProbing;
  @HiveField(22)
  final String video3DFormat;
  @HiveField(23)
  final List<MediaStream> mediaStreams;
  @HiveField(24)
  final List<String> formats;
  @HiveField(25)
  final int bitrate;
  @HiveField(26)
  final String timestamp;
  @HiveField(27)
  final Map<dynamic, String> requiredHttpHeaders;
  @HiveField(28)
  final String transcodingUrl;
  @HiveField(29)
  final String transcodingSubProtocol;
  @HiveField(30)
  final String transcodingContainer;
  @HiveField(31)
  final int analyzeDurationMs;
  @HiveField(32)
  final bool readAtNativeFramerate;
  @HiveField(33)
  final int defaultAudioStreamIndex;
  @HiveField(34)
  final int defaultSubtitleStreamIndex;

  factory MediaSourceInfo.fromJson(Map<String, dynamic> json) =>
      _$MediaSourceInfoFromJson(json);
  Map<String, dynamic> toJson() => _$MediaSourceInfoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
@HiveType(typeId: 6)
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

  @HiveField(0)
  final String codec;
  @HiveField(1)
  final String codecTag;
  @HiveField(2)
  final String language;
  @HiveField(3)
  final String colorTransfer;
  @HiveField(4)
  final String colorPrimaries;
  @HiveField(5)
  final String colorSpace;
  @HiveField(6)
  final String comment;
  @HiveField(7)
  final String timeBase;
  @HiveField(8)
  final String codecTimeBase;
  @HiveField(9)
  final String title;
  @HiveField(10)
  final String extradata;
  @HiveField(11)
  final String videoRange;
  @HiveField(12)
  final String displayTitle;
  @HiveField(13)
  final String displayLanguage;
  @HiveField(14)
  final String nalLengthSize;
  @HiveField(15)
  final bool isInterlaced;
  @HiveField(16)
  final bool isAVC;
  @HiveField(17)
  final String channelLayout;
  @HiveField(18)
  final int bitRate;
  @HiveField(19)
  final int bitDepth;
  @HiveField(20)
  final int refFrames;
  @HiveField(21)
  final int packetLength;
  @HiveField(22)
  final int channels;
  @HiveField(23)
  final int sampleRate;
  @HiveField(24)
  final bool isDefault;
  @HiveField(25)
  final bool isForced;
  @HiveField(26)
  final int height;
  @HiveField(27)
  final int width;
  @HiveField(28)
  final double averageFrameRate;
  @HiveField(29)
  final double realFrameRate;
  @HiveField(30)
  final String profile;
  @HiveField(31)
  final String type;
  @HiveField(32)
  final String aspectRatio;
  @HiveField(33)
  final int index;
  @HiveField(34)
  final int score;
  @HiveField(35)
  final bool isExternal;
  @HiveField(36)
  final String deliveryMethod;
  @HiveField(37)
  final String deliveryUrl;
  @HiveField(38)
  final bool isExternalUrl;
  @HiveField(39)
  final bool isTextSubtitleStream;
  @HiveField(40)
  final bool supportsExternalStream;
  @HiveField(41)
  final String path;
  @HiveField(42)
  final String pixelFormat;
  @HiveField(43)
  final double level;
  @HiveField(44)
  final bool isAnamorphic;

  factory MediaStream.fromJson(Map<String, dynamic> json) =>
      _$MediaStreamFromJson(json);
  Map<String, dynamic> toJson() => _$MediaStreamToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
class MediaUrl {
  MediaUrl(this.url, this.name);

  final String url;
  final String name;

  factory MediaUrl.fromJson(Map<String, dynamic> json) =>
      _$MediaUrlFromJson(json);
  Map<String, dynamic> toJson() => _$MediaUrlToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
class BaseItemPerson {
  BaseItemPerson(
      this.name, this.id, this.role, this.type, this.primaryImageTag);

  final String name;
  final String id;
  final String role;
  final String type;
  final String primaryImageTag;

  factory BaseItemPerson.fromJson(Map<String, dynamic> json) =>
      _$BaseItemPersonFromJson(json);
  Map<String, dynamic> toJson() => _$BaseItemPersonToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
class NameLongIdPair {
  NameLongIdPair(this.name, this.id);

  final String name;
  final String id;

  factory NameLongIdPair.fromJson(Map<String, dynamic> json) =>
      _$NameLongIdPairFromJson(json);
  Map<String, dynamic> toJson() => _$NameLongIdPairToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
@HiveType(typeId: 1)
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

  @HiveField(0)
  final double rating;
  @HiveField(1)
  final double playedPercentage;
  @HiveField(2)
  final int unplayedItemCount;
  @HiveField(3)
  final int playbackPositionTicks;
  @HiveField(4)
  final int playCount;
  @HiveField(5)
  final bool isFavorite;
  @HiveField(6)
  final bool likes;
  @HiveField(7)
  final String lastPlayedDate;
  @HiveField(8)
  final bool played;
  @HiveField(9)
  final String key;
  @HiveField(10)
  final String itemId;

  factory UserItemDataDto.fromJson(Map<String, dynamic> json) =>
      _$UserItemDataDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UserItemDataDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
@HiveType(typeId: 2)
class NameIdPair {
  NameIdPair(this.name, this.id);

  @HiveField(0)
  final String name;
  @HiveField(1)
  final String id;

  factory NameIdPair.fromJson(Map<String, dynamic> json) =>
      _$NameIdPairFromJson(json);
  Map<String, dynamic> toJson() => _$NameIdPairToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
class ChapterInfo {
  ChapterInfo(this.startPositionTicks, this.name, this.imageTag);

  final int startPositionTicks;
  final String name;
  final String imageTag;

  factory ChapterInfo.fromJson(Map<String, dynamic> json) =>
      _$ChapterInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ChapterInfoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
// ignore: camel_case_types
class QueryResult_BaseItemDto {
  QueryResult_BaseItemDto(this.items, this.totalRecordCount);

  final List<BaseItemDto> items;
  final int totalRecordCount;

  factory QueryResult_BaseItemDto.fromJson(Map<String, dynamic> json) =>
      _$QueryResult_BaseItemDtoFromJson(json);
  Map<String, dynamic> toJson() => _$QueryResult_BaseItemDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
class PlaybackInfoResponse {
  PlaybackInfoResponse({
    this.mediaSources,
    this.playSessionId,
    this.errorCode,
  });

  final List<MediaSourceInfo> mediaSources;
  final String playSessionId;
  final String errorCode;

  factory PlaybackInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$PlaybackInfoResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PlaybackInfoResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
class PlaybackProgressInfo {
  PlaybackProgressInfo({
    this.canSeek = true,
    this.item,
    this.itemId,
    this.sessionId,
    this.mediaSourceId,
    this.audioStreamIndex,
    this.subtitleStreamIndex,
    this.isPaused,
    this.isMuted,
    this.positionTicks,
    this.playbackStartTimeTicks,
    this.volumeLevel,
    this.brightness,
    this.aspectRatio,
    this.playMethod = "DirectPlay",
    this.liveStreamId,
    this.playSessionId,
    this.repeatMode,
    this.nowPlayingQueue,
    this.playlistItemId,
  });

  final bool canSeek;
  final BaseItemDto item;
  final String itemId;
  final String sessionId;
  final String mediaSourceId;
  final int audioStreamIndex;
  final int subtitleStreamIndex;
  final bool isPaused;
  final bool isMuted;
  final int positionTicks;
  final int playbackStartTimeTicks;
  final int volumeLevel;
  final int brightness;
  final String aspectRatio;
  final String playMethod;
  final String liveStreamId;
  final String playSessionId;
  final String repeatMode;
  final List nowPlayingQueue;
  final String playlistItemId;

  factory PlaybackProgressInfo.fromJson(Map<String, dynamic> json) =>
      _$PlaybackProgressInfoFromJson(json);
  Map<String, dynamic> toJson() => _$PlaybackProgressInfoToJson(this);
}
