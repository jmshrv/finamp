import 'package:json_annotation/json_annotation.dart';

part 'JellyfinModels.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
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

  final String name;
  final String serverId;
  final String serverName;
  final String connectUserName;
  final String connectLinkType;
  final String id;
  final String primaryImageTag;
  final bool hasPassword;
  final bool hasConfiguredPassword;
  final bool hasConfiguredEasyPassword;
  final bool enableAutoLogin;
  final String lastLoginDate;
  final String lastActivityDate;
  final UserConfiguration configuration;
  final UserPolicy policy;
  final double primaryImageAspectRatio;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
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

  final String audioLanguagePreference;
  final bool playDefaultAudioTrack;
  final String subtitleLanguagePreference;
  final bool displayMissingEpisodes;
  final List<String> groupedFolders;
  final String subtitleMode;
  final bool displayCollectionsView;
  final bool enableLocalPassword;
  final List<String> orderedViews;
  final List<String> latestItemsExcludes;
  final List<String> myMediaExcludes;
  final bool hidePlayedInLatest;
  final bool rememberAudioSelections;
  final bool rememberSubtitleSelections;
  final bool enableNextEpisodeAutoPlay;

  factory UserConfiguration.fromJson(Map<String, dynamic> json) =>
      _$UserConfigurationFromJson(json);
  Map<String, dynamic> toJson() => _$UserConfigurationToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
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

  final bool isAdministrator;
  final bool isHidden;
  final bool isHiddenRemotely;
  final bool isDisabled;
  final int maxParentalRating;
  final List<String> blockedTags;
  final bool enableUserPreferenceAccess;
  final List<AccessSchedule> accessSchedules;
  final List<String> blockUnratedItems;
  final bool enableRemoteControlOfOtherUsers;
  final bool enableSharedDeviceControl;
  final bool enableRemoteAccess;
  final bool enableLiveTvManagement;
  final bool enableLiveTvAccess;
  final bool enableMediaPlayback;
  final bool enableAudioPlaybackTranscoding;
  final bool enableVideoPlaybackTranscoding;
  final bool enablePlaybackRemuxing;
  final bool enableContentDeletion;
  final List<String> enableContentDeletionFromFolders;
  final bool enableContentDownloading;
  final bool enableSubtitleDownloading;
  final bool enableSubtitleManagement;
  final bool enableSyncTranscoding;
  final bool enableMediaConversion;
  final List<String> enabledDevices;
  final bool enableAllDevices;
  final List<String> enabledChannels;
  final bool enableAllChannels;
  final List<String> enabledFolders;
  final bool enableAllFolders;
  final int invalidLoginAttemptCount;
  final bool enablePublicSharing;
  final List<String> blockedMediaFolders;
  final List<String> blockedChannels;
  final int remoteClientBitrateLimit;
  final String authenticationProviderId;
  final List<String> excludedSubFolders;
  final bool disablePremiumFeatures;

  factory UserPolicy.fromJson(Map<String, dynamic> json) =>
      _$UserPolicyFromJson(json);
  Map<String, dynamic> toJson() => _$UserPolicyToJson(this);
}

@JsonSerializable()
class AccessSchedule {
  AccessSchedule(this.dayOfWeek, this.startHour, this.endHour);

  final String dayOfWeek;
  final double startHour;
  final double endHour;

  factory AccessSchedule.fromJson(Map<String, dynamic> json) =>
      _$AccessScheduleFromJson(json);
  Map<String, dynamic> toJson() => _$AccessScheduleToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
class AuthenticationResult {
  AuthenticationResult(
      this.user, this.sessionInfo, this.accessToken, this.serverId);

  final UserDto user;
  final SessionInfo sessionInfo;
  final String accessToken;
  final String serverId;

  factory AuthenticationResult.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationResultFromJson(json);
  Map<String, dynamic> toJson() => _$AuthenticationResultToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
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

  final PlayerStateInfo playState;
  final List<SessionUserInfo> additionalUsers;
  final ClientCapabilities capabilities;
  final String remoteEndPoint;
  final List<String> playableMediaTypes;
  final String playlistItemId;
  final String id;
  final String serverId;
  final String userId;
  final String userName;
  final String userPrimaryImageTag;
  final String client;
  final String lastActivityDate;
  final String deviceName;
  final String deviceType;
  final BaseItemDto nowPlayingItem;
  final String deviceId;
  final String appIconUrl;
  final List<String> supportedCommands;
  final TranscodingInfo transcodingInfo;
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

  final int positionTicks;
  final bool canSeek;
  final bool isPaused;
  final bool isMuted;
  final int volumeLevel;
  final int audioStreamIndex;
  final int subtitleStreamIndex;
  final String mediaSourceId;
  final String playMethod;
  final String repeatMode;

  factory PlayerStateInfo.fromJson(Map<String, dynamic> json) =>
      _$PlayerStateInfoFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerStateInfoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
class SessionUserInfo {
  SessionUserInfo(this.userId, this.userName, this.userInternalId);

  final String userId;
  final String userName;
  final int userInternalId;

  factory SessionUserInfo.fromJson(Map<String, dynamic> json) =>
      _$SessionUserInfoFromJson(json);
  Map<String, dynamic> toJson() => _$SessionUserInfoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
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

  final List<String> playableMediaTypes;
  final List<String> supportedCommands;
  final bool supportsMediaControl;
  final String pushToken;
  final String pushTokenType;
  final bool supportsPersistentIdentifier;
  final bool supportsSync;
  final DeviceProfile deviceProfile;
  final String iconUrl;
  final String appId;

  factory ClientCapabilities.fromJson(Map<String, dynamic> json) =>
      _$ClientCapabilitiesFromJson(json);
  Map<String, dynamic> toJson() => _$ClientCapabilitiesToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
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

  final String name;
  final String id;
  final DeviceIdentification identification;
  final String friendlyName;
  final String manufacturer;
  final String manufacturerUrl;
  final String modelName;
  final String modelDescription;
  final String modelNumber;
  final String modelUrl;
  final String serialNumber;
  final bool enableAlbumArtInDidl;
  final bool enableSingleAlbumArtLimit;
  final bool enableSingleSubtitleLimit;
  final String supportedMediaTypes;
  final String userId;
  final String albumArtPn;
  final int maxAlbumArtWidth;
  final int maxAlbumArtHeight;
  final int maxIconWidth;
  final int maxIconHeight;
  final int maxStreamingBitrate;
  final int maxStaticBitrate;
  final int musicStreamingTranscodingBitrate;
  final int maxStaticMusicBitrate;
  final String sonyAggregationFlags;
  final String protocolInfo;
  final int timelineOffsetSeconds;
  final bool requiresPlainVideoItems;
  final bool requiresPlainFolders;
  final bool enableMSMediaReceiverRegistrar;
  final bool ignoreTranscodeByteRangeRequests;
  final List<XmlAttribute> xmlRootAttributes;
  final List<DirectPlayProfile> directPlayProfiles;
  final List<TranscodingProfile> transcodingProfiles;
  final List<ContainerProfile> containerProfiles;
  final List<CodecProfile> codecProfiles;
  final List<ResponseProfile> responseProfiles;
  final List<SubtitleProfile> subtitleProfiles;

  factory DeviceProfile.fromJson(Map<String, dynamic> json) =>
      _$DeviceProfileFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceProfileToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
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

  final String friendlyName;
  final String modelNumber;
  final String serialNumber;
  final String modelName;
  final String modelDescription;
  final String deviceDescription;
  final String modelUrl;
  final String manufacturer;
  final String manufacturerUrl;
  final List<HttpHeaderInfo> headers;

  factory DeviceIdentification.fromJson(Map<String, dynamic> json) =>
      _$DeviceIdentificationFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceIdentificationToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
class HttpHeaderInfo {
  HttpHeaderInfo(this.name, this.value, this.match);

  final String name;
  final String value;
  final String match;

  factory HttpHeaderInfo.fromJson(Map<String, dynamic> json) =>
      _$HttpHeaderInfoFromJson(json);
  Map<String, dynamic> toJson() => _$HttpHeaderInfoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
class XmlAttribute {
  XmlAttribute(this.name, this.value);

  final String name;
  final String value;

  factory XmlAttribute.fromJson(Map<String, dynamic> json) =>
      _$XmlAttributeFromJson(json);
  Map<String, dynamic> toJson() => _$XmlAttributeToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
class DirectPlayProfile {
  DirectPlayProfile(
      this.container, this.audioCodec, this.videoCodec, this.type);

  final String container;
  final String audioCodec;
  final String videoCodec;
  final String type;

  factory DirectPlayProfile.fromJson(Map<String, dynamic> json) =>
      _$DirectPlayProfileFromJson(json);
  Map<String, dynamic> toJson() => _$DirectPlayProfileToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
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

  final String container;
  final String type;
  final String videoCodec;
  final String audioCodec;
  final String protocol;
  final bool estimateContentLength;
  final bool enableMpegtsM2TsMode;
  final String transcodeSeekInfo;
  final bool copyTimestamps;
  final String context;
  final String maxAudioChannels;
  final int minSegments;
  final int segmentLength;
  final bool breakOnNonKeyFrames;
  final String manifestSubtitles;

  factory TranscodingProfile.fromJson(Map<String, dynamic> json) =>
      _$TranscodingProfileFromJson(json);
  Map<String, dynamic> toJson() => _$TranscodingProfileToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
class ContainerProfile {
  ContainerProfile(this.type, this.conditions, this.container);

  final String type;
  final List<ProfileCondition> conditions;
  final String container;

  factory ContainerProfile.fromJson(Map<String, dynamic> json) =>
      _$ContainerProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ContainerProfileToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
class ProfileCondition {
  ProfileCondition(this.condition, this.property, this.value, this.isRequired);

  final String condition;
  final String property;
  final String value;
  final bool isRequired;

  factory ProfileCondition.fromJson(Map<String, dynamic> json) =>
      _$ProfileConditionFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileConditionToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
class CodecProfile {
  CodecProfile(this.type, this.conditions, this.applyConditions, this.codec,
      this.container);

  final String type;
  final List<ProfileCondition> conditions;
  final List<ProfileCondition> applyConditions;
  final String codec;
  final String container;

  factory CodecProfile.fromJson(Map<String, dynamic> json) =>
      _$CodecProfileFromJson(json);
  Map<String, dynamic> toJson() => _$CodecProfileToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
class ResponseProfile {
  ResponseProfile(this.container, this.audioCodec, this.videoCodec, this.type,
      this.orgPn, this.mimeType, this.conditions);

  final String container;
  final String audioCodec;
  final String videoCodec;
  final String type;
  final String orgPn;
  final String mimeType;
  final List<ProfileCondition> conditions;

  factory ResponseProfile.fromJson(Map<String, dynamic> json) =>
      _$ResponseProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseProfileToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
class SubtitleProfile {
  SubtitleProfile(
      this.format, this.method, this.didlMode, this.language, this.container);

  final String format;
  final String method;
  final String didlMode;
  final String language;
  final String container;

  factory SubtitleProfile.fromJson(Map<String, dynamic> json) =>
      _$SubtitleProfileFromJson(json);
  Map<String, dynamic> toJson() => _$SubtitleProfileToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
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

  final String name;
  final String originalTitle;
  final String serverId;
  final String id;
  final String etag;
  final String playlistItemId;
  final String dateCreated;
  final String extraType;
  final int airsBeforeSeasonNumber;
  final int airsAfterSeasonNumber;
  final int airsBeforeEpisodeNumber;
  final bool displaySpecialsWithSeasons;
  final bool canDelete;
  final bool canDownload;
  final bool hasSubtitles;
  final bool supportsResume;
  final String preferredMetadataLanguage;
  final String preferredMetadataCountryCode;
  final bool supportsSync;
  final String container;
  final String sortName;
  final String forcedSortName;
  final String video3DFormat;
  final String premiereDate;
  final List<ExternalUrl> externalUrls;
  final List<MediaSourceInfo> mediaSources;
  final double criticRating;
  final int gameSystemId;
  final String gameSystem;
  final List<String> productionLocations;
  final String path;
  final String officialRating;
  final String customRating;
  final String channelId;
  final String channelName;
  final String overview;
  final List<String> taglines;
  final List<String> genres;
  final double communityRating;
  final int runTimeTicks;
  final String playAccess;
  final String aspectRatio;
  final int productionYear;
  final String number;
  final String channelNumber;
  final int indexNumber;
  final int indexNumberEnd;
  final int parentIndexNumber;
  final List<MediaUrl> remoteTrailers;
  final Map<dynamic, String> providerIds;
  final bool isFolder;
  final String parentId;
  final String type;
  final List<BaseItemPerson> people;
  final List<NameLongIdPair> studios;
  final List<NameLongIdPair> genreItems;
  final String parentLogoItemId;
  final String parentBackdropItemId;
  final List<String> parentBackdropImageTags;
  final int localTrailerCount;
  final UserItemDataDto userData;
  final int recursiveItemCount;
  final int childCount;
  final String seriesName;
  final String seriesId;
  final String seasonId;
  final int specialFeatureCount;
  final String displayPreferencesId;
  final String status;
  final String airTime;
  final List<String> airDays;
  final List<String> tags;
  final double primaryImageAspectRatio;
  final List<String> artists;
  final List<NameIdPair> artistItems;
  final String album;
  final String collectionType;
  final String displayOrder;
  final String albumId;
  final String albumPrimaryImageTag;
  final String seriesPrimaryImageTag;
  final String albumArtist;
  final List<NameIdPair> albumArtists;
  final String seasonName;
  final List<MediaStream> mediaStreams;
  final int partCount;
  final Map<dynamic, String> imageTags;
  final List<String> backdropImageTags;
  final String parentLogoImageTag;
  final String parentArtItemId;
  final String parentArtImageTag;
  final String seriesThumbImageTag;
  final String seriesStudio;
  final String parentThumbItemId;
  final String parentThumbImageTag;
  final String parentPrimaryImageItemId;
  final String parentPrimaryImageTag;
  final List<ChapterInfo> chapters;
  final String locationType;
  final String mediaType;
  final String endDate;
  final List<String> lockedFields;
  final bool lockData;
  final int width;
  final int height;
  final String cameraMake;
  final String cameraModel;
  final String software;
  final double exposureTime;
  final double focalLength;
  final String imageOrientation;
  final double aperture;
  final double shutterSpeed;
  final double latitude;
  final double longitude;
  final double altitude;
  final int isoSpeedRating;
  final String seriesTimerId;
  final String channelPrimaryImageTag;
  final String startDate;
  final double completionPercentage;
  final bool isRepeat;
  final bool isNew;
  final String episodeTitle;
  final bool isMovie;
  final bool isSports;
  final bool isSeries;
  final bool isLive;
  final bool isNews;
  final bool isKids;
  final bool isPremiere;
  final String timerId;
  final dynamic currentProgram;
  final int movieCount;
  final int seriesCount;
  final int albumCount;
  final int songCount;
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

  final String protocol;
  final String id;
  final String path;
  final String encoderPath;
  final String encoderProtocol;
  final String type;
  final String container;
  final int size;
  final String name;
  final bool isRemote;
  final int runTimeTicks;
  final bool supportsTranscoding;
  final bool supportsDirectStream;
  final bool supportsDirectPlay;
  final bool isInfiniteStream;
  final bool requiresOpening;
  final String openToken;
  final bool requiresClosing;
  final String liveStreamId;
  final int bufferMs;
  final bool requiresLooping;
  final bool supportsProbing;
  final String video3DFormat;
  final List<MediaStream> mediaStreams;
  final List<String> formats;
  final int bitrate;
  final String timestamp;
  final Map<dynamic, String> requiredHttpHeaders;
  final String transcodingUrl;
  final String transcodingSubProtocol;
  final String transcodingContainer;
  final int analyzeDurationMs;
  final bool readAtNativeFramerate;
  final int defaultAudioStreamIndex;
  final int defaultSubtitleStreamIndex;

  factory MediaSourceInfo.fromJson(Map<String, dynamic> json) =>
      _$MediaSourceInfoFromJson(json);
  Map<String, dynamic> toJson() => _$MediaSourceInfoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
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

  final String codec;
  final String codecTag;
  final String language;
  final String colorTransfer;
  final String colorPrimaries;
  final String colorSpace;
  final String comment;
  final String timeBase;
  final String codecTimeBase;
  final String title;
  final String extradata;
  final String videoRange;
  final String displayTitle;
  final String displayLanguage;
  final String nalLengthSize;
  final bool isInterlaced;
  final bool isAVC;
  final String channelLayout;
  final int bitRate;
  final int bitDepth;
  final int refFrames;
  final int packetLength;
  final int channels;
  final int sampleRate;
  final bool isDefault;
  final bool isForced;
  final int height;
  final int width;
  final double averageFrameRate;
  final double realFrameRate;
  final String profile;
  final String type;
  final String aspectRatio;
  final int index;
  final int score;
  final bool isExternal;
  final String deliveryMethod;
  final String deliveryUrl;
  final bool isExternalUrl;
  final bool isTextSubtitleStream;
  final bool supportsExternalStream;
  final String path;
  final String pixelFormat;
  final double level;
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
  final int id;

  factory NameLongIdPair.fromJson(Map<String, dynamic> json) =>
      _$NameLongIdPairFromJson(json);
  Map<String, dynamic> toJson() => _$NameLongIdPairToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
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

  final double rating;
  final double playedPercentage;
  final int unplayedItemCount;
  final int playbackPositionTicks;
  final int playCount;
  final bool isFavorite;
  final bool likes;
  final String lastPlayedDate;
  final bool played;
  final String key;
  final String itemId;

  factory UserItemDataDto.fromJson(Map<String, dynamic> json) =>
      _$UserItemDataDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UserItemDataDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
class NameIdPair {
  NameIdPair(this.name, this.id);

  final String name;
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
