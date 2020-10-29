// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'JellyfinModels.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDto _$UserDtoFromJson(Map<String, dynamic> json) {
  return UserDto(
    json['Name'] as String,
    json['ServerId'] as String,
    json['ServerName'] as String,
    json['ConnectUserName'] as String,
    json['ConnectLinkType'] as String,
    json['Id'] as String,
    json['PrimaryImageTag'] as String,
    json['HasPassword'] as bool,
    json['HasConfiguredPassword'] as bool,
    json['HasConfiguredEasyPassword'] as bool,
    json['EnableAutoLogin'] as bool,
    json['LastLoginDate'] as String,
    json['LastActivityDate'] as String,
    json['Configuration'] == null
        ? null
        : UserConfiguration.fromJson(
            json['Configuration'] as Map<String, dynamic>),
    json['Policy'] == null
        ? null
        : UserPolicy.fromJson(json['Policy'] as Map<String, dynamic>),
    (json['PrimaryImageAspectRatio'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$UserDtoToJson(UserDto instance) => <String, dynamic>{
      'Name': instance.name,
      'ServerId': instance.serverId,
      'ServerName': instance.serverName,
      'ConnectUserName': instance.connectUserName,
      'ConnectLinkType': instance.connectLinkType,
      'Id': instance.id,
      'PrimaryImageTag': instance.primaryImageTag,
      'HasPassword': instance.hasPassword,
      'HasConfiguredPassword': instance.hasConfiguredPassword,
      'HasConfiguredEasyPassword': instance.hasConfiguredEasyPassword,
      'EnableAutoLogin': instance.enableAutoLogin,
      'LastLoginDate': instance.lastLoginDate,
      'LastActivityDate': instance.lastActivityDate,
      'Configuration': instance.configuration?.toJson(),
      'Policy': instance.policy?.toJson(),
      'PrimaryImageAspectRatio': instance.primaryImageAspectRatio,
    };

UserConfiguration _$UserConfigurationFromJson(Map<String, dynamic> json) {
  return UserConfiguration(
    json['AudioLanguagePreference'] as String,
    json['PlayDefaultAudioTrack'] as bool,
    json['SubtitleLanguagePreference'] as String,
    json['DisplayMissingEpisodes'] as bool,
    (json['GroupedFolders'] as List)?.map((e) => e as String)?.toList(),
    json['SubtitleMode'] as String,
    json['DisplayCollectionsView'] as bool,
    json['EnableLocalPassword'] as bool,
    (json['OrderedViews'] as List)?.map((e) => e as String)?.toList(),
    (json['LatestItemsExcludes'] as List)?.map((e) => e as String)?.toList(),
    (json['MyMediaExcludes'] as List)?.map((e) => e as String)?.toList(),
    json['HidePlayedInLatest'] as bool,
    json['RememberAudioSelections'] as bool,
    json['RememberSubtitleSelections'] as bool,
    json['EnableNextEpisodeAutoPlay'] as bool,
  );
}

Map<String, dynamic> _$UserConfigurationToJson(UserConfiguration instance) =>
    <String, dynamic>{
      'AudioLanguagePreference': instance.audioLanguagePreference,
      'PlayDefaultAudioTrack': instance.playDefaultAudioTrack,
      'SubtitleLanguagePreference': instance.subtitleLanguagePreference,
      'DisplayMissingEpisodes': instance.displayMissingEpisodes,
      'GroupedFolders': instance.groupedFolders,
      'SubtitleMode': instance.subtitleMode,
      'DisplayCollectionsView': instance.displayCollectionsView,
      'EnableLocalPassword': instance.enableLocalPassword,
      'OrderedViews': instance.orderedViews,
      'LatestItemsExcludes': instance.latestItemsExcludes,
      'MyMediaExcludes': instance.myMediaExcludes,
      'HidePlayedInLatest': instance.hidePlayedInLatest,
      'RememberAudioSelections': instance.rememberAudioSelections,
      'RememberSubtitleSelections': instance.rememberSubtitleSelections,
      'EnableNextEpisodeAutoPlay': instance.enableNextEpisodeAutoPlay,
    };

UserPolicy _$UserPolicyFromJson(Map<String, dynamic> json) {
  return UserPolicy(
    json['IsAdministrator'] as bool,
    json['IsHidden'] as bool,
    json['IsHiddenRemotely'] as bool,
    json['IsDisabled'] as bool,
    json['MaxParentalRating'] as int,
    (json['BlockedTags'] as List)?.map((e) => e as String)?.toList(),
    json['EnableUserPreferenceAccess'] as bool,
    (json['AccessSchedules'] as List)
        ?.map((e) => e == null
            ? null
            : AccessSchedule.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['BlockUnratedItems'] as List)?.map((e) => e as String)?.toList(),
    json['EnableRemoteControlOfOtherUsers'] as bool,
    json['EnableSharedDeviceControl'] as bool,
    json['EnableRemoteAccess'] as bool,
    json['EnableLiveTvManagement'] as bool,
    json['EnableLiveTvAccess'] as bool,
    json['EnableMediaPlayback'] as bool,
    json['EnableAudioPlaybackTranscoding'] as bool,
    json['EnableVideoPlaybackTranscoding'] as bool,
    json['EnablePlaybackRemuxing'] as bool,
    json['EnableContentDeletion'] as bool,
    (json['EnableContentDeletionFromFolders'] as List)
        ?.map((e) => e as String)
        ?.toList(),
    json['EnableContentDownloading'] as bool,
    json['EnableSubtitleDownloading'] as bool,
    json['EnableSubtitleManagement'] as bool,
    json['EnableSyncTranscoding'] as bool,
    json['EnableMediaConversion'] as bool,
    (json['EnabledDevices'] as List)?.map((e) => e as String)?.toList(),
    json['EnableAllDevices'] as bool,
    (json['EnabledChannels'] as List)?.map((e) => e as String)?.toList(),
    json['EnableAllChannels'] as bool,
    (json['EnabledFolders'] as List)?.map((e) => e as String)?.toList(),
    json['EnableAllFolders'] as bool,
    json['InvalidLoginAttemptCount'] as int,
    json['EnablePublicSharing'] as bool,
    (json['BlockedMediaFolders'] as List)?.map((e) => e as String)?.toList(),
    (json['BlockedChannels'] as List)?.map((e) => e as String)?.toList(),
    json['RemoteClientBitrateLimit'] as int,
    json['AuthenticationProviderId'] as String,
    (json['ExcludedSubFolders'] as List)?.map((e) => e as String)?.toList(),
    json['DisablePremiumFeatures'] as bool,
  );
}

Map<String, dynamic> _$UserPolicyToJson(UserPolicy instance) =>
    <String, dynamic>{
      'IsAdministrator': instance.isAdministrator,
      'IsHidden': instance.isHidden,
      'IsHiddenRemotely': instance.isHiddenRemotely,
      'IsDisabled': instance.isDisabled,
      'MaxParentalRating': instance.maxParentalRating,
      'BlockedTags': instance.blockedTags,
      'EnableUserPreferenceAccess': instance.enableUserPreferenceAccess,
      'AccessSchedules':
          instance.accessSchedules?.map((e) => e?.toJson())?.toList(),
      'BlockUnratedItems': instance.blockUnratedItems,
      'EnableRemoteControlOfOtherUsers':
          instance.enableRemoteControlOfOtherUsers,
      'EnableSharedDeviceControl': instance.enableSharedDeviceControl,
      'EnableRemoteAccess': instance.enableRemoteAccess,
      'EnableLiveTvManagement': instance.enableLiveTvManagement,
      'EnableLiveTvAccess': instance.enableLiveTvAccess,
      'EnableMediaPlayback': instance.enableMediaPlayback,
      'EnableAudioPlaybackTranscoding': instance.enableAudioPlaybackTranscoding,
      'EnableVideoPlaybackTranscoding': instance.enableVideoPlaybackTranscoding,
      'EnablePlaybackRemuxing': instance.enablePlaybackRemuxing,
      'EnableContentDeletion': instance.enableContentDeletion,
      'EnableContentDeletionFromFolders':
          instance.enableContentDeletionFromFolders,
      'EnableContentDownloading': instance.enableContentDownloading,
      'EnableSubtitleDownloading': instance.enableSubtitleDownloading,
      'EnableSubtitleManagement': instance.enableSubtitleManagement,
      'EnableSyncTranscoding': instance.enableSyncTranscoding,
      'EnableMediaConversion': instance.enableMediaConversion,
      'EnabledDevices': instance.enabledDevices,
      'EnableAllDevices': instance.enableAllDevices,
      'EnabledChannels': instance.enabledChannels,
      'EnableAllChannels': instance.enableAllChannels,
      'EnabledFolders': instance.enabledFolders,
      'EnableAllFolders': instance.enableAllFolders,
      'InvalidLoginAttemptCount': instance.invalidLoginAttemptCount,
      'EnablePublicSharing': instance.enablePublicSharing,
      'BlockedMediaFolders': instance.blockedMediaFolders,
      'BlockedChannels': instance.blockedChannels,
      'RemoteClientBitrateLimit': instance.remoteClientBitrateLimit,
      'AuthenticationProviderId': instance.authenticationProviderId,
      'ExcludedSubFolders': instance.excludedSubFolders,
      'DisablePremiumFeatures': instance.disablePremiumFeatures,
    };

AccessSchedule _$AccessScheduleFromJson(Map<String, dynamic> json) {
  return AccessSchedule(
    json['dayOfWeek'] as String,
    (json['startHour'] as num)?.toDouble(),
    (json['endHour'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$AccessScheduleToJson(AccessSchedule instance) =>
    <String, dynamic>{
      'dayOfWeek': instance.dayOfWeek,
      'startHour': instance.startHour,
      'endHour': instance.endHour,
    };

AuthenticationResult _$AuthenticationResultFromJson(Map<String, dynamic> json) {
  return AuthenticationResult(
    json['User'] == null
        ? null
        : UserDto.fromJson(json['User'] as Map<String, dynamic>),
    json['SessionInfo'] == null
        ? null
        : SessionInfo.fromJson(json['SessionInfo'] as Map<String, dynamic>),
    json['AccessToken'] as String,
    json['ServerId'] as String,
  );
}

Map<String, dynamic> _$AuthenticationResultToJson(
        AuthenticationResult instance) =>
    <String, dynamic>{
      'User': instance.user?.toJson(),
      'SessionInfo': instance.sessionInfo?.toJson(),
      'AccessToken': instance.accessToken,
      'ServerId': instance.serverId,
    };

SessionInfo _$SessionInfoFromJson(Map<String, dynamic> json) {
  return SessionInfo(
    json['PlayState'] == null
        ? null
        : PlayerStateInfo.fromJson(json['PlayState'] as Map<String, dynamic>),
    (json['AdditionalUsers'] as List)
        ?.map((e) => e == null
            ? null
            : SessionUserInfo.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['Capabilities'] == null
        ? null
        : ClientCapabilities.fromJson(
            json['Capabilities'] as Map<String, dynamic>),
    json['RemoteEndPoint'] as String,
    (json['PlayableMediaTypes'] as List)?.map((e) => e as String)?.toList(),
    json['PlaylistItemId'] as String,
    json['Id'] as String,
    json['ServerId'] as String,
    json['UserId'] as String,
    json['UserName'] as String,
    json['UserPrimaryImageTag'] as String,
    json['Client'] as String,
    json['LastActivityDate'] as String,
    json['DeviceName'] as String,
    json['DeviceType'] as String,
    json['NowPlayingItem'] == null
        ? null
        : BaseItemDto.fromJson(json['NowPlayingItem'] as Map<String, dynamic>),
    json['DeviceId'] as String,
    json['AppIconUrl'] as String,
    (json['SupportedCommands'] as List)?.map((e) => e as String)?.toList(),
    json['TranscodingInfo'] == null
        ? null
        : TranscodingInfo.fromJson(
            json['TranscodingInfo'] as Map<String, dynamic>),
    json['SupportsRemoteControl'] as bool,
  );
}

Map<String, dynamic> _$SessionInfoToJson(SessionInfo instance) =>
    <String, dynamic>{
      'PlayState': instance.playState?.toJson(),
      'AdditionalUsers':
          instance.additionalUsers?.map((e) => e?.toJson())?.toList(),
      'Capabilities': instance.capabilities?.toJson(),
      'RemoteEndPoint': instance.remoteEndPoint,
      'PlayableMediaTypes': instance.playableMediaTypes,
      'PlaylistItemId': instance.playlistItemId,
      'Id': instance.id,
      'ServerId': instance.serverId,
      'UserId': instance.userId,
      'UserName': instance.userName,
      'UserPrimaryImageTag': instance.userPrimaryImageTag,
      'Client': instance.client,
      'LastActivityDate': instance.lastActivityDate,
      'DeviceName': instance.deviceName,
      'DeviceType': instance.deviceType,
      'NowPlayingItem': instance.nowPlayingItem?.toJson(),
      'DeviceId': instance.deviceId,
      'AppIconUrl': instance.appIconUrl,
      'SupportedCommands': instance.supportedCommands,
      'TranscodingInfo': instance.transcodingInfo?.toJson(),
      'SupportsRemoteControl': instance.supportsRemoteControl,
    };

TranscodingInfo _$TranscodingInfoFromJson(Map<String, dynamic> json) {
  return TranscodingInfo(
    json['AudioCodec'] as String,
    json['VideoCodec'] as String,
    json['Container'] as String,
    json['IsVideoDirect'] as bool,
    json['IsAudioDirect'] as bool,
    json['Bitrate'] as int,
    (json['Framerate'] as num)?.toDouble(),
    (json['CompletionPercentage'] as num)?.toDouble(),
    (json['TranscodingPositionTicks'] as num)?.toDouble(),
    (json['TranscodingStartPositionTicks'] as num)?.toDouble(),
    json['Width'] as int,
    json['Height'] as int,
    json['AudioChannels'] as int,
    (json['TranscodeReasons'] as List)?.map((e) => e as String)?.toList(),
    (json['CurrentCpuUsage'] as num)?.toDouble(),
    (json['AverageCpuUsage'] as num)?.toDouble(),
    (json['CpuHistory'] as List)
        ?.map((e) => (e as Map<String, dynamic>)?.map(
              (k, e) => MapEntry(k, (e as num)?.toDouble()),
            ))
        ?.toList(),
    json['CurrentThrottle'] as int,
    json['VideoDecoder'] as String,
    json['VideoDecoderIsHardware'] as bool,
    json['VideoDecoderMediaType'] as String,
    json['VideoDecoderHwAccel'] as String,
    json['VideoEncoder'] as String,
    json['VideoEncoderIsHardware'] as bool,
    json['VideoEncoderMediaType'] as String,
    json['VideoEncoderHwAccel'] as String,
  );
}

Map<String, dynamic> _$TranscodingInfoToJson(TranscodingInfo instance) =>
    <String, dynamic>{
      'AudioCodec': instance.audioCodec,
      'VideoCodec': instance.videoCodec,
      'Container': instance.container,
      'IsVideoDirect': instance.isVideoDirect,
      'IsAudioDirect': instance.isAudioDirect,
      'Bitrate': instance.bitrate,
      'Framerate': instance.framerate,
      'CompletionPercentage': instance.completionPercentage,
      'TranscodingPositionTicks': instance.transcodingPositionTicks,
      'TranscodingStartPositionTicks': instance.transcodingStartPositionTicks,
      'Width': instance.width,
      'Height': instance.height,
      'AudioChannels': instance.audioChannels,
      'TranscodeReasons': instance.transcodeReasons,
      'CurrentCpuUsage': instance.currentCpuUsage,
      'AverageCpuUsage': instance.averageCpuUsage,
      'CpuHistory': instance.cpuHistory,
      'CurrentThrottle': instance.currentThrottle,
      'VideoDecoder': instance.videoDecoder,
      'VideoDecoderIsHardware': instance.videoDecoderIsHardware,
      'VideoDecoderMediaType': instance.videoDecoderMediaType,
      'VideoDecoderHwAccel': instance.videoDecoderHwAccel,
      'VideoEncoder': instance.videoEncoder,
      'VideoEncoderIsHardware': instance.videoEncoderIsHardware,
      'VideoEncoderMediaType': instance.videoEncoderMediaType,
      'VideoEncoderHwAccel': instance.videoEncoderHwAccel,
    };

PlayerStateInfo _$PlayerStateInfoFromJson(Map<String, dynamic> json) {
  return PlayerStateInfo(
    json['PositionTicks'] as int,
    json['CanSeek'] as bool,
    json['IsPaused'] as bool,
    json['IsMuted'] as bool,
    json['VolumeLevel'] as int,
    json['AudioStreamIndex'] as int,
    json['SubtitleStreamIndex'] as int,
    json['MediaSourceId'] as String,
    json['PlayMethod'] as String,
    json['RepeatMode'] as String,
  );
}

Map<String, dynamic> _$PlayerStateInfoToJson(PlayerStateInfo instance) =>
    <String, dynamic>{
      'PositionTicks': instance.positionTicks,
      'CanSeek': instance.canSeek,
      'IsPaused': instance.isPaused,
      'IsMuted': instance.isMuted,
      'VolumeLevel': instance.volumeLevel,
      'AudioStreamIndex': instance.audioStreamIndex,
      'SubtitleStreamIndex': instance.subtitleStreamIndex,
      'MediaSourceId': instance.mediaSourceId,
      'PlayMethod': instance.playMethod,
      'RepeatMode': instance.repeatMode,
    };

SessionUserInfo _$SessionUserInfoFromJson(Map<String, dynamic> json) {
  return SessionUserInfo(
    json['UserId'] as String,
    json['UserName'] as String,
    json['UserInternalId'] as int,
  );
}

Map<String, dynamic> _$SessionUserInfoToJson(SessionUserInfo instance) =>
    <String, dynamic>{
      'UserId': instance.userId,
      'UserName': instance.userName,
      'UserInternalId': instance.userInternalId,
    };

ClientCapabilities _$ClientCapabilitiesFromJson(Map<String, dynamic> json) {
  return ClientCapabilities(
    (json['PlayableMediaTypes'] as List)?.map((e) => e as String)?.toList(),
    (json['SupportedCommands'] as List)?.map((e) => e as String)?.toList(),
    json['SupportsMediaControl'] as bool,
    json['PushToken'] as String,
    json['PushTokenType'] as String,
    json['SupportsPersistentIdentifier'] as bool,
    json['SupportsSync'] as bool,
    json['DeviceProfile'] == null
        ? null
        : DeviceProfile.fromJson(json['DeviceProfile'] as Map<String, dynamic>),
    json['IconUrl'] as String,
    json['AppId'] as String,
  );
}

Map<String, dynamic> _$ClientCapabilitiesToJson(ClientCapabilities instance) =>
    <String, dynamic>{
      'PlayableMediaTypes': instance.playableMediaTypes,
      'SupportedCommands': instance.supportedCommands,
      'SupportsMediaControl': instance.supportsMediaControl,
      'PushToken': instance.pushToken,
      'PushTokenType': instance.pushTokenType,
      'SupportsPersistentIdentifier': instance.supportsPersistentIdentifier,
      'SupportsSync': instance.supportsSync,
      'DeviceProfile': instance.deviceProfile?.toJson(),
      'IconUrl': instance.iconUrl,
      'AppId': instance.appId,
    };

DeviceProfile _$DeviceProfileFromJson(Map<String, dynamic> json) {
  return DeviceProfile(
    json['Name'] as String,
    json['Id'] as String,
    json['Identification'] == null
        ? null
        : DeviceIdentification.fromJson(
            json['Identification'] as Map<String, dynamic>),
    json['FriendlyName'] as String,
    json['Manufacturer'] as String,
    json['ManufacturerUrl'] as String,
    json['ModelName'] as String,
    json['ModelDescription'] as String,
    json['ModelNumber'] as String,
    json['ModelUrl'] as String,
    json['SerialNumber'] as String,
    json['EnableAlbumArtInDidl'] as bool,
    json['EnableSingleAlbumArtLimit'] as bool,
    json['EnableSingleSubtitleLimit'] as bool,
    json['SupportedMediaTypes'] as String,
    json['UserId'] as String,
    json['AlbumArtPn'] as String,
    json['MaxAlbumArtWidth'] as int,
    json['MaxAlbumArtHeight'] as int,
    json['MaxIconWidth'] as int,
    json['MaxIconHeight'] as int,
    json['MaxStreamingBitrate'] as int,
    json['MaxStaticBitrate'] as int,
    json['MusicStreamingTranscodingBitrate'] as int,
    json['MaxStaticMusicBitrate'] as int,
    json['SonyAggregationFlags'] as String,
    json['ProtocolInfo'] as String,
    json['TimelineOffsetSeconds'] as int,
    json['RequiresPlainVideoItems'] as bool,
    json['RequiresPlainFolders'] as bool,
    json['EnableMSMediaReceiverRegistrar'] as bool,
    json['IgnoreTranscodeByteRangeRequests'] as bool,
    (json['XmlRootAttributes'] as List)
        ?.map((e) =>
            e == null ? null : XmlAttribute.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['DirectPlayProfiles'] as List)
        ?.map((e) => e == null
            ? null
            : DirectPlayProfile.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['TranscodingProfiles'] as List)
        ?.map((e) => e == null
            ? null
            : TranscodingProfile.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['ContainerProfiles'] as List)
        ?.map((e) => e == null
            ? null
            : ContainerProfile.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['CodecProfiles'] as List)
        ?.map((e) =>
            e == null ? null : CodecProfile.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['ResponseProfiles'] as List)
        ?.map((e) => e == null
            ? null
            : ResponseProfile.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['SubtitleProfiles'] as List)
        ?.map((e) => e == null
            ? null
            : SubtitleProfile.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$DeviceProfileToJson(DeviceProfile instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'Id': instance.id,
      'Identification': instance.identification?.toJson(),
      'FriendlyName': instance.friendlyName,
      'Manufacturer': instance.manufacturer,
      'ManufacturerUrl': instance.manufacturerUrl,
      'ModelName': instance.modelName,
      'ModelDescription': instance.modelDescription,
      'ModelNumber': instance.modelNumber,
      'ModelUrl': instance.modelUrl,
      'SerialNumber': instance.serialNumber,
      'EnableAlbumArtInDidl': instance.enableAlbumArtInDidl,
      'EnableSingleAlbumArtLimit': instance.enableSingleAlbumArtLimit,
      'EnableSingleSubtitleLimit': instance.enableSingleSubtitleLimit,
      'SupportedMediaTypes': instance.supportedMediaTypes,
      'UserId': instance.userId,
      'AlbumArtPn': instance.albumArtPn,
      'MaxAlbumArtWidth': instance.maxAlbumArtWidth,
      'MaxAlbumArtHeight': instance.maxAlbumArtHeight,
      'MaxIconWidth': instance.maxIconWidth,
      'MaxIconHeight': instance.maxIconHeight,
      'MaxStreamingBitrate': instance.maxStreamingBitrate,
      'MaxStaticBitrate': instance.maxStaticBitrate,
      'MusicStreamingTranscodingBitrate':
          instance.musicStreamingTranscodingBitrate,
      'MaxStaticMusicBitrate': instance.maxStaticMusicBitrate,
      'SonyAggregationFlags': instance.sonyAggregationFlags,
      'ProtocolInfo': instance.protocolInfo,
      'TimelineOffsetSeconds': instance.timelineOffsetSeconds,
      'RequiresPlainVideoItems': instance.requiresPlainVideoItems,
      'RequiresPlainFolders': instance.requiresPlainFolders,
      'EnableMSMediaReceiverRegistrar': instance.enableMSMediaReceiverRegistrar,
      'IgnoreTranscodeByteRangeRequests':
          instance.ignoreTranscodeByteRangeRequests,
      'XmlRootAttributes':
          instance.xmlRootAttributes?.map((e) => e?.toJson())?.toList(),
      'DirectPlayProfiles':
          instance.directPlayProfiles?.map((e) => e?.toJson())?.toList(),
      'TranscodingProfiles':
          instance.transcodingProfiles?.map((e) => e?.toJson())?.toList(),
      'ContainerProfiles':
          instance.containerProfiles?.map((e) => e?.toJson())?.toList(),
      'CodecProfiles':
          instance.codecProfiles?.map((e) => e?.toJson())?.toList(),
      'ResponseProfiles':
          instance.responseProfiles?.map((e) => e?.toJson())?.toList(),
      'SubtitleProfiles':
          instance.subtitleProfiles?.map((e) => e?.toJson())?.toList(),
    };

DeviceIdentification _$DeviceIdentificationFromJson(Map<String, dynamic> json) {
  return DeviceIdentification(
    json['FriendlyName'] as String,
    json['ModelNumber'] as String,
    json['SerialNumber'] as String,
    json['ModelName'] as String,
    json['ModelDescription'] as String,
    json['DeviceDescription'] as String,
    json['ModelUrl'] as String,
    json['Manufacturer'] as String,
    json['ManufacturerUrl'] as String,
    (json['Headers'] as List)
        ?.map((e) => e == null
            ? null
            : HttpHeaderInfo.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$DeviceIdentificationToJson(
        DeviceIdentification instance) =>
    <String, dynamic>{
      'FriendlyName': instance.friendlyName,
      'ModelNumber': instance.modelNumber,
      'SerialNumber': instance.serialNumber,
      'ModelName': instance.modelName,
      'ModelDescription': instance.modelDescription,
      'DeviceDescription': instance.deviceDescription,
      'ModelUrl': instance.modelUrl,
      'Manufacturer': instance.manufacturer,
      'ManufacturerUrl': instance.manufacturerUrl,
      'Headers': instance.headers?.map((e) => e?.toJson())?.toList(),
    };

HttpHeaderInfo _$HttpHeaderInfoFromJson(Map<String, dynamic> json) {
  return HttpHeaderInfo(
    json['Name'] as String,
    json['Value'] as String,
    json['Match'] as String,
  );
}

Map<String, dynamic> _$HttpHeaderInfoToJson(HttpHeaderInfo instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'Value': instance.value,
      'Match': instance.match,
    };

XmlAttribute _$XmlAttributeFromJson(Map<String, dynamic> json) {
  return XmlAttribute(
    json['Name'] as String,
    json['Value'] as String,
  );
}

Map<String, dynamic> _$XmlAttributeToJson(XmlAttribute instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'Value': instance.value,
    };

DirectPlayProfile _$DirectPlayProfileFromJson(Map<String, dynamic> json) {
  return DirectPlayProfile(
    json['Container'] as String,
    json['AudioCodec'] as String,
    json['VideoCodec'] as String,
    json['Type'] as String,
  );
}

Map<String, dynamic> _$DirectPlayProfileToJson(DirectPlayProfile instance) =>
    <String, dynamic>{
      'Container': instance.container,
      'AudioCodec': instance.audioCodec,
      'VideoCodec': instance.videoCodec,
      'Type': instance.type,
    };

TranscodingProfile _$TranscodingProfileFromJson(Map<String, dynamic> json) {
  return TranscodingProfile(
    json['Container'] as String,
    json['Type'] as String,
    json['VideoCodec'] as String,
    json['AudioCodec'] as String,
    json['Protocol'] as String,
    json['EstimateContentLength'] as bool,
    json['EnableMpegtsM2TsMode'] as bool,
    json['TranscodeSeekInfo'] as String,
    json['CopyTimestamps'] as bool,
    json['Context'] as String,
    json['MaxAudioChannels'] as String,
    json['MinSegments'] as int,
    json['SegmentLength'] as int,
    json['BreakOnNonKeyFrames'] as bool,
    json['ManifestSubtitles'] as String,
  );
}

Map<String, dynamic> _$TranscodingProfileToJson(TranscodingProfile instance) =>
    <String, dynamic>{
      'Container': instance.container,
      'Type': instance.type,
      'VideoCodec': instance.videoCodec,
      'AudioCodec': instance.audioCodec,
      'Protocol': instance.protocol,
      'EstimateContentLength': instance.estimateContentLength,
      'EnableMpegtsM2TsMode': instance.enableMpegtsM2TsMode,
      'TranscodeSeekInfo': instance.transcodeSeekInfo,
      'CopyTimestamps': instance.copyTimestamps,
      'Context': instance.context,
      'MaxAudioChannels': instance.maxAudioChannels,
      'MinSegments': instance.minSegments,
      'SegmentLength': instance.segmentLength,
      'BreakOnNonKeyFrames': instance.breakOnNonKeyFrames,
      'ManifestSubtitles': instance.manifestSubtitles,
    };

ContainerProfile _$ContainerProfileFromJson(Map<String, dynamic> json) {
  return ContainerProfile(
    json['Type'] as String,
    (json['Conditions'] as List)
        ?.map((e) => e == null
            ? null
            : ProfileCondition.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['Container'] as String,
  );
}

Map<String, dynamic> _$ContainerProfileToJson(ContainerProfile instance) =>
    <String, dynamic>{
      'Type': instance.type,
      'Conditions': instance.conditions?.map((e) => e?.toJson())?.toList(),
      'Container': instance.container,
    };

ProfileCondition _$ProfileConditionFromJson(Map<String, dynamic> json) {
  return ProfileCondition(
    json['Condition'] as String,
    json['Property'] as String,
    json['Value'] as String,
    json['IsRequired'] as bool,
  );
}

Map<String, dynamic> _$ProfileConditionToJson(ProfileCondition instance) =>
    <String, dynamic>{
      'Condition': instance.condition,
      'Property': instance.property,
      'Value': instance.value,
      'IsRequired': instance.isRequired,
    };

CodecProfile _$CodecProfileFromJson(Map<String, dynamic> json) {
  return CodecProfile(
    json['Type'] as String,
    (json['Conditions'] as List)
        ?.map((e) => e == null
            ? null
            : ProfileCondition.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['ApplyConditions'] as List)
        ?.map((e) => e == null
            ? null
            : ProfileCondition.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['Codec'] as String,
    json['Container'] as String,
  );
}

Map<String, dynamic> _$CodecProfileToJson(CodecProfile instance) =>
    <String, dynamic>{
      'Type': instance.type,
      'Conditions': instance.conditions?.map((e) => e?.toJson())?.toList(),
      'ApplyConditions':
          instance.applyConditions?.map((e) => e?.toJson())?.toList(),
      'Codec': instance.codec,
      'Container': instance.container,
    };

ResponseProfile _$ResponseProfileFromJson(Map<String, dynamic> json) {
  return ResponseProfile(
    json['Container'] as String,
    json['AudioCodec'] as String,
    json['VideoCodec'] as String,
    json['Type'] as String,
    json['OrgPn'] as String,
    json['MimeType'] as String,
    (json['Conditions'] as List)
        ?.map((e) => e == null
            ? null
            : ProfileCondition.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ResponseProfileToJson(ResponseProfile instance) =>
    <String, dynamic>{
      'Container': instance.container,
      'AudioCodec': instance.audioCodec,
      'VideoCodec': instance.videoCodec,
      'Type': instance.type,
      'OrgPn': instance.orgPn,
      'MimeType': instance.mimeType,
      'Conditions': instance.conditions?.map((e) => e?.toJson())?.toList(),
    };

SubtitleProfile _$SubtitleProfileFromJson(Map<String, dynamic> json) {
  return SubtitleProfile(
    json['Format'] as String,
    json['Method'] as String,
    json['DidlMode'] as String,
    json['Language'] as String,
    json['Container'] as String,
  );
}

Map<String, dynamic> _$SubtitleProfileToJson(SubtitleProfile instance) =>
    <String, dynamic>{
      'Format': instance.format,
      'Method': instance.method,
      'DidlMode': instance.didlMode,
      'Language': instance.language,
      'Container': instance.container,
    };

BaseItemDto _$BaseItemDtoFromJson(Map<String, dynamic> json) {
  return BaseItemDto(
    json['Name'] as String,
    json['OriginalTitle'] as String,
    json['ServerId'] as String,
    json['Id'] as String,
    json['Etag'] as String,
    json['PlaylistItemId'] as String,
    json['DateCreated'] as String,
    json['ExtraType'] as String,
    json['AirsBeforeSeasonNumber'] as int,
    json['AirsAfterSeasonNumber'] as int,
    json['AirsBeforeEpisodeNumber'] as int,
    json['DisplaySpecialsWithSeasons'] as bool,
    json['CanDelete'] as bool,
    json['CanDownload'] as bool,
    json['HasSubtitles'] as bool,
    json['SupportsResume'] as bool,
    json['PreferredMetadataLanguage'] as String,
    json['PreferredMetadataCountryCode'] as String,
    json['SupportsSync'] as bool,
    json['Container'] as String,
    json['SortName'] as String,
    json['ForcedSortName'] as String,
    json['Video3DFormat'] as String,
    json['PremiereDate'] as String,
    (json['ExternalUrls'] as List)
        ?.map((e) =>
            e == null ? null : ExternalUrl.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['MediaSources'] as List)
        ?.map((e) => e == null
            ? null
            : MediaSourceInfo.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['CriticRating'] as num)?.toDouble(),
    json['GameSystemId'] as int,
    json['GameSystem'] as String,
    (json['ProductionLocations'] as List)?.map((e) => e as String)?.toList(),
    json['Path'] as String,
    json['OfficialRating'] as String,
    json['CustomRating'] as String,
    json['ChannelId'] as String,
    json['ChannelName'] as String,
    json['Overview'] as String,
    (json['Taglines'] as List)?.map((e) => e as String)?.toList(),
    (json['Genres'] as List)?.map((e) => e as String)?.toList(),
    (json['CommunityRating'] as num)?.toDouble(),
    json['RunTimeTicks'] as int,
    json['PlayAccess'] as String,
    json['AspectRatio'] as String,
    json['ProductionYear'] as int,
    json['Number'] as String,
    json['ChannelNumber'] as String,
    json['IndexNumber'] as int,
    json['IndexNumberEnd'] as int,
    json['ParentIndexNumber'] as int,
    (json['RemoteTrailers'] as List)
        ?.map((e) =>
            e == null ? null : MediaUrl.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['ProviderIds'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
    json['IsFolder'] as bool,
    json['ParentId'] as String,
    json['Type'] as String,
    (json['People'] as List)
        ?.map((e) => e == null
            ? null
            : BaseItemPerson.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['Studios'] as List)
        ?.map((e) => e == null
            ? null
            : NameLongIdPair.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['GenreItems'] as List)
        ?.map((e) => e == null
            ? null
            : NameLongIdPair.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['ParentLogoItemId'] as String,
    json['ParentBackdropItemId'] as String,
    (json['ParentBackdropImageTags'] as List)
        ?.map((e) => e as String)
        ?.toList(),
    json['LocalTrailerCount'] as int,
    json['UserData'] == null
        ? null
        : UserItemDataDto.fromJson(json['UserData'] as Map<String, dynamic>),
    json['RecursiveItemCount'] as int,
    json['ChildCount'] as int,
    json['SeriesName'] as String,
    json['SeriesId'] as String,
    json['SeasonId'] as String,
    json['SpecialFeatureCount'] as int,
    json['DisplayPreferencesId'] as String,
    json['Status'] as String,
    json['AirTime'] as String,
    (json['AirDays'] as List)?.map((e) => e as String)?.toList(),
    (json['Tags'] as List)?.map((e) => e as String)?.toList(),
    (json['PrimaryImageAspectRatio'] as num)?.toDouble(),
    (json['Artists'] as List)?.map((e) => e as String)?.toList(),
    (json['ArtistItems'] as List)
        ?.map((e) =>
            e == null ? null : NameIdPair.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['Album'] as String,
    json['CollectionType'] as String,
    json['DisplayOrder'] as String,
    json['AlbumId'] as String,
    json['AlbumPrimaryImageTag'] as String,
    json['SeriesPrimaryImageTag'] as String,
    json['AlbumArtist'] as String,
    (json['AlbumArtists'] as List)
        ?.map((e) =>
            e == null ? null : NameIdPair.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['SeasonName'] as String,
    (json['MediaStreams'] as List)
        ?.map((e) =>
            e == null ? null : MediaStream.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['PartCount'] as int,
    (json['ImageTags'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
    (json['BackdropImageTags'] as List)?.map((e) => e as String)?.toList(),
    json['ParentLogoImageTag'] as String,
    json['ParentArtItemId'] as String,
    json['ParentArtImageTag'] as String,
    json['SeriesThumbImageTag'] as String,
    json['SeriesStudio'] as String,
    json['ParentThumbItemId'] as String,
    json['ParentThumbImageTag'] as String,
    json['ParentPrimaryImageItemId'] as String,
    json['ParentPrimaryImageTag'] as String,
    (json['Chapters'] as List)
        ?.map((e) =>
            e == null ? null : ChapterInfo.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['LocationType'] as String,
    json['MediaType'] as String,
    json['EndDate'] as String,
    (json['LockedFields'] as List)?.map((e) => e as String)?.toList(),
    json['LockData'] as bool,
    json['Width'] as int,
    json['Height'] as int,
    json['CameraMake'] as String,
    json['CameraModel'] as String,
    json['Software'] as String,
    (json['ExposureTime'] as num)?.toDouble(),
    (json['FocalLength'] as num)?.toDouble(),
    json['ImageOrientation'] as String,
    (json['Aperture'] as num)?.toDouble(),
    (json['ShutterSpeed'] as num)?.toDouble(),
    (json['Latitude'] as num)?.toDouble(),
    (json['Longitude'] as num)?.toDouble(),
    (json['Altitude'] as num)?.toDouble(),
    json['IsoSpeedRating'] as int,
    json['SeriesTimerId'] as String,
    json['ChannelPrimaryImageTag'] as String,
    json['StartDate'] as String,
    (json['CompletionPercentage'] as num)?.toDouble(),
    json['IsRepeat'] as bool,
    json['IsNew'] as bool,
    json['EpisodeTitle'] as String,
    json['IsMovie'] as bool,
    json['IsSports'] as bool,
    json['IsSeries'] as bool,
    json['IsLive'] as bool,
    json['IsNews'] as bool,
    json['IsKids'] as bool,
    json['IsPremiere'] as bool,
    json['TimerId'] as String,
    json['CurrentProgram'],
    json['MovieCount'] as int,
    json['SeriesCount'] as int,
    json['AlbumCount'] as int,
    json['SongCount'] as int,
    json['MusicVideoCount'] as int,
  );
}

Map<String, dynamic> _$BaseItemDtoToJson(BaseItemDto instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'OriginalTitle': instance.originalTitle,
      'ServerId': instance.serverId,
      'Id': instance.id,
      'Etag': instance.etag,
      'PlaylistItemId': instance.playlistItemId,
      'DateCreated': instance.dateCreated,
      'ExtraType': instance.extraType,
      'AirsBeforeSeasonNumber': instance.airsBeforeSeasonNumber,
      'AirsAfterSeasonNumber': instance.airsAfterSeasonNumber,
      'AirsBeforeEpisodeNumber': instance.airsBeforeEpisodeNumber,
      'DisplaySpecialsWithSeasons': instance.displaySpecialsWithSeasons,
      'CanDelete': instance.canDelete,
      'CanDownload': instance.canDownload,
      'HasSubtitles': instance.hasSubtitles,
      'SupportsResume': instance.supportsResume,
      'PreferredMetadataLanguage': instance.preferredMetadataLanguage,
      'PreferredMetadataCountryCode': instance.preferredMetadataCountryCode,
      'SupportsSync': instance.supportsSync,
      'Container': instance.container,
      'SortName': instance.sortName,
      'ForcedSortName': instance.forcedSortName,
      'Video3DFormat': instance.video3DFormat,
      'PremiereDate': instance.premiereDate,
      'ExternalUrls': instance.externalUrls?.map((e) => e?.toJson())?.toList(),
      'MediaSources': instance.mediaSources?.map((e) => e?.toJson())?.toList(),
      'CriticRating': instance.criticRating,
      'GameSystemId': instance.gameSystemId,
      'GameSystem': instance.gameSystem,
      'ProductionLocations': instance.productionLocations,
      'Path': instance.path,
      'OfficialRating': instance.officialRating,
      'CustomRating': instance.customRating,
      'ChannelId': instance.channelId,
      'ChannelName': instance.channelName,
      'Overview': instance.overview,
      'Taglines': instance.taglines,
      'Genres': instance.genres,
      'CommunityRating': instance.communityRating,
      'RunTimeTicks': instance.runTimeTicks,
      'PlayAccess': instance.playAccess,
      'AspectRatio': instance.aspectRatio,
      'ProductionYear': instance.productionYear,
      'Number': instance.number,
      'ChannelNumber': instance.channelNumber,
      'IndexNumber': instance.indexNumber,
      'IndexNumberEnd': instance.indexNumberEnd,
      'ParentIndexNumber': instance.parentIndexNumber,
      'RemoteTrailers':
          instance.remoteTrailers?.map((e) => e?.toJson())?.toList(),
      'ProviderIds': instance.providerIds,
      'IsFolder': instance.isFolder,
      'ParentId': instance.parentId,
      'Type': instance.type,
      'People': instance.people?.map((e) => e?.toJson())?.toList(),
      'Studios': instance.studios?.map((e) => e?.toJson())?.toList(),
      'GenreItems': instance.genreItems?.map((e) => e?.toJson())?.toList(),
      'ParentLogoItemId': instance.parentLogoItemId,
      'ParentBackdropItemId': instance.parentBackdropItemId,
      'ParentBackdropImageTags': instance.parentBackdropImageTags,
      'LocalTrailerCount': instance.localTrailerCount,
      'UserData': instance.userData?.toJson(),
      'RecursiveItemCount': instance.recursiveItemCount,
      'ChildCount': instance.childCount,
      'SeriesName': instance.seriesName,
      'SeriesId': instance.seriesId,
      'SeasonId': instance.seasonId,
      'SpecialFeatureCount': instance.specialFeatureCount,
      'DisplayPreferencesId': instance.displayPreferencesId,
      'Status': instance.status,
      'AirTime': instance.airTime,
      'AirDays': instance.airDays,
      'Tags': instance.tags,
      'PrimaryImageAspectRatio': instance.primaryImageAspectRatio,
      'Artists': instance.artists,
      'ArtistItems': instance.artistItems?.map((e) => e?.toJson())?.toList(),
      'Album': instance.album,
      'CollectionType': instance.collectionType,
      'DisplayOrder': instance.displayOrder,
      'AlbumId': instance.albumId,
      'AlbumPrimaryImageTag': instance.albumPrimaryImageTag,
      'SeriesPrimaryImageTag': instance.seriesPrimaryImageTag,
      'AlbumArtist': instance.albumArtist,
      'AlbumArtists': instance.albumArtists?.map((e) => e?.toJson())?.toList(),
      'SeasonName': instance.seasonName,
      'MediaStreams': instance.mediaStreams?.map((e) => e?.toJson())?.toList(),
      'PartCount': instance.partCount,
      'ImageTags': instance.imageTags,
      'BackdropImageTags': instance.backdropImageTags,
      'ParentLogoImageTag': instance.parentLogoImageTag,
      'ParentArtItemId': instance.parentArtItemId,
      'ParentArtImageTag': instance.parentArtImageTag,
      'SeriesThumbImageTag': instance.seriesThumbImageTag,
      'SeriesStudio': instance.seriesStudio,
      'ParentThumbItemId': instance.parentThumbItemId,
      'ParentThumbImageTag': instance.parentThumbImageTag,
      'ParentPrimaryImageItemId': instance.parentPrimaryImageItemId,
      'ParentPrimaryImageTag': instance.parentPrimaryImageTag,
      'Chapters': instance.chapters?.map((e) => e?.toJson())?.toList(),
      'LocationType': instance.locationType,
      'MediaType': instance.mediaType,
      'EndDate': instance.endDate,
      'LockedFields': instance.lockedFields,
      'LockData': instance.lockData,
      'Width': instance.width,
      'Height': instance.height,
      'CameraMake': instance.cameraMake,
      'CameraModel': instance.cameraModel,
      'Software': instance.software,
      'ExposureTime': instance.exposureTime,
      'FocalLength': instance.focalLength,
      'ImageOrientation': instance.imageOrientation,
      'Aperture': instance.aperture,
      'ShutterSpeed': instance.shutterSpeed,
      'Latitude': instance.latitude,
      'Longitude': instance.longitude,
      'Altitude': instance.altitude,
      'IsoSpeedRating': instance.isoSpeedRating,
      'SeriesTimerId': instance.seriesTimerId,
      'ChannelPrimaryImageTag': instance.channelPrimaryImageTag,
      'StartDate': instance.startDate,
      'CompletionPercentage': instance.completionPercentage,
      'IsRepeat': instance.isRepeat,
      'IsNew': instance.isNew,
      'EpisodeTitle': instance.episodeTitle,
      'IsMovie': instance.isMovie,
      'IsSports': instance.isSports,
      'IsSeries': instance.isSeries,
      'IsLive': instance.isLive,
      'IsNews': instance.isNews,
      'IsKids': instance.isKids,
      'IsPremiere': instance.isPremiere,
      'TimerId': instance.timerId,
      'CurrentProgram': instance.currentProgram,
      'MovieCount': instance.movieCount,
      'SeriesCount': instance.seriesCount,
      'AlbumCount': instance.albumCount,
      'SongCount': instance.songCount,
      'MusicVideoCount': instance.musicVideoCount,
    };

ExternalUrl _$ExternalUrlFromJson(Map<String, dynamic> json) {
  return ExternalUrl(
    json['Name'] as String,
    json['Url'] as String,
  );
}

Map<String, dynamic> _$ExternalUrlToJson(ExternalUrl instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'Url': instance.url,
    };

MediaSourceInfo _$MediaSourceInfoFromJson(Map<String, dynamic> json) {
  return MediaSourceInfo(
    json['Protocol'] as String,
    json['Id'] as String,
    json['Path'] as String,
    json['EncoderPath'] as String,
    json['EncoderProtocol'] as String,
    json['Type'] as String,
    json['Container'] as String,
    json['Size'] as int,
    json['Name'] as String,
    json['IsRemote'] as bool,
    json['RunTimeTicks'] as int,
    json['SupportsTranscoding'] as bool,
    json['SupportsDirectStream'] as bool,
    json['SupportsDirectPlay'] as bool,
    json['IsInfiniteStream'] as bool,
    json['RequiresOpening'] as bool,
    json['OpenToken'] as String,
    json['RequiresClosing'] as bool,
    json['LiveStreamId'] as String,
    json['BufferMs'] as int,
    json['RequiresLooping'] as bool,
    json['SupportsProbing'] as bool,
    json['Video3DFormat'] as String,
    (json['MediaStreams'] as List)
        ?.map((e) =>
            e == null ? null : MediaStream.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['Formats'] as List)?.map((e) => e as String)?.toList(),
    json['Bitrate'] as int,
    json['Timestamp'] as String,
    (json['RequiredHttpHeaders'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
    json['TranscodingUrl'] as String,
    json['TranscodingSubProtocol'] as String,
    json['TranscodingContainer'] as String,
    json['AnalyzeDurationMs'] as int,
    json['ReadAtNativeFramerate'] as bool,
    json['DefaultAudioStreamIndex'] as int,
    json['DefaultSubtitleStreamIndex'] as int,
  );
}

Map<String, dynamic> _$MediaSourceInfoToJson(MediaSourceInfo instance) =>
    <String, dynamic>{
      'Protocol': instance.protocol,
      'Id': instance.id,
      'Path': instance.path,
      'EncoderPath': instance.encoderPath,
      'EncoderProtocol': instance.encoderProtocol,
      'Type': instance.type,
      'Container': instance.container,
      'Size': instance.size,
      'Name': instance.name,
      'IsRemote': instance.isRemote,
      'RunTimeTicks': instance.runTimeTicks,
      'SupportsTranscoding': instance.supportsTranscoding,
      'SupportsDirectStream': instance.supportsDirectStream,
      'SupportsDirectPlay': instance.supportsDirectPlay,
      'IsInfiniteStream': instance.isInfiniteStream,
      'RequiresOpening': instance.requiresOpening,
      'OpenToken': instance.openToken,
      'RequiresClosing': instance.requiresClosing,
      'LiveStreamId': instance.liveStreamId,
      'BufferMs': instance.bufferMs,
      'RequiresLooping': instance.requiresLooping,
      'SupportsProbing': instance.supportsProbing,
      'Video3DFormat': instance.video3DFormat,
      'MediaStreams': instance.mediaStreams?.map((e) => e?.toJson())?.toList(),
      'Formats': instance.formats,
      'Bitrate': instance.bitrate,
      'Timestamp': instance.timestamp,
      'RequiredHttpHeaders': instance.requiredHttpHeaders,
      'TranscodingUrl': instance.transcodingUrl,
      'TranscodingSubProtocol': instance.transcodingSubProtocol,
      'TranscodingContainer': instance.transcodingContainer,
      'AnalyzeDurationMs': instance.analyzeDurationMs,
      'ReadAtNativeFramerate': instance.readAtNativeFramerate,
      'DefaultAudioStreamIndex': instance.defaultAudioStreamIndex,
      'DefaultSubtitleStreamIndex': instance.defaultSubtitleStreamIndex,
    };

MediaStream _$MediaStreamFromJson(Map<String, dynamic> json) {
  return MediaStream(
    json['Codec'] as String,
    json['CodecTag'] as String,
    json['Language'] as String,
    json['ColorTransfer'] as String,
    json['ColorPrimaries'] as String,
    json['ColorSpace'] as String,
    json['Comment'] as String,
    json['TimeBase'] as String,
    json['CodecTimeBase'] as String,
    json['Title'] as String,
    json['Extradata'] as String,
    json['VideoRange'] as String,
    json['DisplayTitle'] as String,
    json['DisplayLanguage'] as String,
    json['NalLengthSize'] as String,
    json['IsInterlaced'] as bool,
    json['IsAVC'] as bool,
    json['ChannelLayout'] as String,
    json['BitRate'] as int,
    json['BitDepth'] as int,
    json['RefFrames'] as int,
    json['PacketLength'] as int,
    json['Channels'] as int,
    json['SampleRate'] as int,
    json['IsDefault'] as bool,
    json['IsForced'] as bool,
    json['Height'] as int,
    json['Width'] as int,
    (json['AverageFrameRate'] as num)?.toDouble(),
    (json['RealFrameRate'] as num)?.toDouble(),
    json['Profile'] as String,
    json['Type'] as String,
    json['AspectRatio'] as String,
    json['Index'] as int,
    json['Score'] as int,
    json['IsExternal'] as bool,
    json['DeliveryMethod'] as String,
    json['DeliveryUrl'] as String,
    json['IsExternalUrl'] as bool,
    json['IsTextSubtitleStream'] as bool,
    json['SupportsExternalStream'] as bool,
    json['Path'] as String,
    json['PixelFormat'] as String,
    (json['Level'] as num)?.toDouble(),
    json['IsAnamorphic'] as bool,
  );
}

Map<String, dynamic> _$MediaStreamToJson(MediaStream instance) =>
    <String, dynamic>{
      'Codec': instance.codec,
      'CodecTag': instance.codecTag,
      'Language': instance.language,
      'ColorTransfer': instance.colorTransfer,
      'ColorPrimaries': instance.colorPrimaries,
      'ColorSpace': instance.colorSpace,
      'Comment': instance.comment,
      'TimeBase': instance.timeBase,
      'CodecTimeBase': instance.codecTimeBase,
      'Title': instance.title,
      'Extradata': instance.extradata,
      'VideoRange': instance.videoRange,
      'DisplayTitle': instance.displayTitle,
      'DisplayLanguage': instance.displayLanguage,
      'NalLengthSize': instance.nalLengthSize,
      'IsInterlaced': instance.isInterlaced,
      'IsAVC': instance.isAVC,
      'ChannelLayout': instance.channelLayout,
      'BitRate': instance.bitRate,
      'BitDepth': instance.bitDepth,
      'RefFrames': instance.refFrames,
      'PacketLength': instance.packetLength,
      'Channels': instance.channels,
      'SampleRate': instance.sampleRate,
      'IsDefault': instance.isDefault,
      'IsForced': instance.isForced,
      'Height': instance.height,
      'Width': instance.width,
      'AverageFrameRate': instance.averageFrameRate,
      'RealFrameRate': instance.realFrameRate,
      'Profile': instance.profile,
      'Type': instance.type,
      'AspectRatio': instance.aspectRatio,
      'Index': instance.index,
      'Score': instance.score,
      'IsExternal': instance.isExternal,
      'DeliveryMethod': instance.deliveryMethod,
      'DeliveryUrl': instance.deliveryUrl,
      'IsExternalUrl': instance.isExternalUrl,
      'IsTextSubtitleStream': instance.isTextSubtitleStream,
      'SupportsExternalStream': instance.supportsExternalStream,
      'Path': instance.path,
      'PixelFormat': instance.pixelFormat,
      'Level': instance.level,
      'IsAnamorphic': instance.isAnamorphic,
    };

MediaUrl _$MediaUrlFromJson(Map<String, dynamic> json) {
  return MediaUrl(
    json['Url'] as String,
    json['Name'] as String,
  );
}

Map<String, dynamic> _$MediaUrlToJson(MediaUrl instance) => <String, dynamic>{
      'Url': instance.url,
      'Name': instance.name,
    };

BaseItemPerson _$BaseItemPersonFromJson(Map<String, dynamic> json) {
  return BaseItemPerson(
    json['Name'] as String,
    json['Id'] as String,
    json['Role'] as String,
    json['Type'] as String,
    json['PrimaryImageTag'] as String,
  );
}

Map<String, dynamic> _$BaseItemPersonToJson(BaseItemPerson instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'Id': instance.id,
      'Role': instance.role,
      'Type': instance.type,
      'PrimaryImageTag': instance.primaryImageTag,
    };

NameLongIdPair _$NameLongIdPairFromJson(Map<String, dynamic> json) {
  return NameLongIdPair(
    json['Name'] as String,
    json['Id'] as int,
  );
}

Map<String, dynamic> _$NameLongIdPairToJson(NameLongIdPair instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'Id': instance.id,
    };

UserItemDataDto _$UserItemDataDtoFromJson(Map<String, dynamic> json) {
  return UserItemDataDto(
    (json['Rating'] as num)?.toDouble(),
    (json['PlayedPercentage'] as num)?.toDouble(),
    json['UnplayedItemCount'] as int,
    json['PlaybackPositionTicks'] as int,
    json['PlayCount'] as int,
    json['IsFavorite'] as bool,
    json['Likes'] as bool,
    json['LastPlayedDate'] as String,
    json['Played'] as bool,
    json['Key'] as String,
    json['ItemId'] as String,
  );
}

Map<String, dynamic> _$UserItemDataDtoToJson(UserItemDataDto instance) =>
    <String, dynamic>{
      'Rating': instance.rating,
      'PlayedPercentage': instance.playedPercentage,
      'UnplayedItemCount': instance.unplayedItemCount,
      'PlaybackPositionTicks': instance.playbackPositionTicks,
      'PlayCount': instance.playCount,
      'IsFavorite': instance.isFavorite,
      'Likes': instance.likes,
      'LastPlayedDate': instance.lastPlayedDate,
      'Played': instance.played,
      'Key': instance.key,
      'ItemId': instance.itemId,
    };

NameIdPair _$NameIdPairFromJson(Map<String, dynamic> json) {
  return NameIdPair(
    json['Name'] as String,
    json['Id'] as String,
  );
}

Map<String, dynamic> _$NameIdPairToJson(NameIdPair instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'Id': instance.id,
    };

ChapterInfo _$ChapterInfoFromJson(Map<String, dynamic> json) {
  return ChapterInfo(
    json['StartPositionTicks'] as int,
    json['Name'] as String,
    json['ImageTag'] as String,
  );
}

Map<String, dynamic> _$ChapterInfoToJson(ChapterInfo instance) =>
    <String, dynamic>{
      'StartPositionTicks': instance.startPositionTicks,
      'Name': instance.name,
      'ImageTag': instance.imageTag,
    };

QueryResult_BaseItemDto _$QueryResult_BaseItemDtoFromJson(
    Map<String, dynamic> json) {
  return QueryResult_BaseItemDto(
    (json['Items'] as List)
        ?.map((e) =>
            e == null ? null : BaseItemDto.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['TotalRecordCount'] as int,
  );
}

Map<String, dynamic> _$QueryResult_BaseItemDtoToJson(
        QueryResult_BaseItemDto instance) =>
    <String, dynamic>{
      'Items': instance.items?.map((e) => e?.toJson())?.toList(),
      'TotalRecordCount': instance.totalRecordCount,
    };

PlaybackInfoResponse _$PlaybackInfoResponseFromJson(Map<String, dynamic> json) {
  return PlaybackInfoResponse(
    mediaSources: (json['MediaSources'] as List)
        ?.map((e) => e == null
            ? null
            : MediaSourceInfo.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    playSessionId: json['PlaySessionId'] as String,
    errorCode: json['ErrorCode'] as String,
  );
}

Map<String, dynamic> _$PlaybackInfoResponseToJson(
        PlaybackInfoResponse instance) =>
    <String, dynamic>{
      'MediaSources': instance.mediaSources?.map((e) => e?.toJson())?.toList(),
      'PlaySessionId': instance.playSessionId,
      'ErrorCode': instance.errorCode,
    };
