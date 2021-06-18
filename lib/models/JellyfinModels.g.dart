// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'JellyfinModels.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDtoAdapter extends TypeAdapter<UserDto> {
  @override
  final int typeId = 9;

  @override
  UserDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserDto(
      name: fields[0] as String?,
      serverId: fields[1] as String?,
      serverName: fields[2] as String?,
      connectUserName: fields[3] as String?,
      connectLinkType: fields[4] as String?,
      id: fields[5] as String,
      primaryImageTag: fields[6] as String?,
      hasPassword: fields[7] as bool,
      hasConfiguredPassword: fields[8] as bool,
      hasConfiguredEasyPassword: fields[9] as bool,
      enableAutoLogin: fields[10] as bool?,
      lastLoginDate: fields[11] as String?,
      lastActivityDate: fields[12] as String?,
      configuration: fields[13] as UserConfiguration?,
      policy: fields[14] as UserPolicy?,
      primaryImageAspectRatio: fields[15] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, UserDto obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.serverId)
      ..writeByte(2)
      ..write(obj.serverName)
      ..writeByte(3)
      ..write(obj.connectUserName)
      ..writeByte(4)
      ..write(obj.connectLinkType)
      ..writeByte(5)
      ..write(obj.id)
      ..writeByte(6)
      ..write(obj.primaryImageTag)
      ..writeByte(7)
      ..write(obj.hasPassword)
      ..writeByte(8)
      ..write(obj.hasConfiguredPassword)
      ..writeByte(9)
      ..write(obj.hasConfiguredEasyPassword)
      ..writeByte(10)
      ..write(obj.enableAutoLogin)
      ..writeByte(11)
      ..write(obj.lastLoginDate)
      ..writeByte(12)
      ..write(obj.lastActivityDate)
      ..writeByte(13)
      ..write(obj.configuration)
      ..writeByte(14)
      ..write(obj.policy)
      ..writeByte(15)
      ..write(obj.primaryImageAspectRatio);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserConfigurationAdapter extends TypeAdapter<UserConfiguration> {
  @override
  final int typeId = 11;

  @override
  UserConfiguration read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserConfiguration(
      audioLanguagePreference: fields[0] as String?,
      playDefaultAudioTrack: fields[1] as bool,
      subtitleLanguagePreference: fields[2] as String?,
      displayMissingEpisodes: fields[3] as bool,
      groupedFolders: (fields[4] as List?)?.cast<String>(),
      subtitleMode: fields[5] as String,
      displayCollectionsView: fields[6] as bool,
      enableLocalPassword: fields[7] as bool,
      orderedViews: (fields[8] as List?)?.cast<String>(),
      latestItemsExcludes: (fields[9] as List?)?.cast<String>(),
      myMediaExcludes: (fields[10] as List?)?.cast<String>(),
      hidePlayedInLatest: fields[11] as bool,
      rememberAudioSelections: fields[12] as bool,
      rememberSubtitleSelections: fields[13] as bool,
      enableNextEpisodeAutoPlay: fields[14] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserConfiguration obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.audioLanguagePreference)
      ..writeByte(1)
      ..write(obj.playDefaultAudioTrack)
      ..writeByte(2)
      ..write(obj.subtitleLanguagePreference)
      ..writeByte(3)
      ..write(obj.displayMissingEpisodes)
      ..writeByte(4)
      ..write(obj.groupedFolders)
      ..writeByte(5)
      ..write(obj.subtitleMode)
      ..writeByte(6)
      ..write(obj.displayCollectionsView)
      ..writeByte(7)
      ..write(obj.enableLocalPassword)
      ..writeByte(8)
      ..write(obj.orderedViews)
      ..writeByte(9)
      ..write(obj.latestItemsExcludes)
      ..writeByte(10)
      ..write(obj.myMediaExcludes)
      ..writeByte(11)
      ..write(obj.hidePlayedInLatest)
      ..writeByte(12)
      ..write(obj.rememberAudioSelections)
      ..writeByte(13)
      ..write(obj.rememberSubtitleSelections)
      ..writeByte(14)
      ..write(obj.enableNextEpisodeAutoPlay);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserConfigurationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserPolicyAdapter extends TypeAdapter<UserPolicy> {
  @override
  final int typeId = 12;

  @override
  UserPolicy read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserPolicy(
      isAdministrator: fields[0] as bool,
      isHidden: fields[1] as bool,
      isHiddenRemotely: fields[2] as bool?,
      isDisabled: fields[3] as bool,
      maxParentalRating: fields[4] as int?,
      blockedTags: (fields[5] as List?)?.cast<String>(),
      enableUserPreferenceAccess: fields[6] as bool,
      accessSchedules: (fields[7] as List?)?.cast<AccessSchedule>(),
      blockUnratedItems: (fields[8] as List?)?.cast<String>(),
      enableRemoteControlOfOtherUsers: fields[9] as bool,
      enableSharedDeviceControl: fields[10] as bool,
      enableRemoteAccess: fields[11] as bool,
      enableLiveTvManagement: fields[12] as bool,
      enableLiveTvAccess: fields[13] as bool,
      enableMediaPlayback: fields[14] as bool,
      enableAudioPlaybackTranscoding: fields[15] as bool,
      enableVideoPlaybackTranscoding: fields[16] as bool,
      enablePlaybackRemuxing: fields[17] as bool,
      forceRemoteSourceTranscoding: fields[39] as bool?,
      enableContentDeletion: fields[18] as bool,
      enableContentDeletionFromFolders: (fields[19] as List?)?.cast<String>(),
      enableContentDownloading: fields[20] as bool,
      enableSubtitleDownloading: fields[21] as bool?,
      enableSubtitleManagement: fields[22] as bool?,
      enableSyncTranscoding: fields[23] as bool,
      enableMediaConversion: fields[24] as bool,
      enabledDevices: (fields[25] as List?)?.cast<String>(),
      enableAllDevices: fields[26] as bool,
      enabledChannels: (fields[27] as List?)?.cast<String>(),
      enableAllChannels: fields[28] as bool,
      enabledFolders: (fields[29] as List?)?.cast<String>(),
      enableAllFolders: fields[30] as bool,
      invalidLoginAttemptCount: fields[31] as int,
      loginAttemptsBeforeLockout: fields[40] as int?,
      maxActiveSessions: fields[41] as int?,
      enablePublicSharing: fields[32] as bool,
      blockedMediaFolders: (fields[33] as List?)?.cast<String>(),
      blockedChannels: (fields[34] as List?)?.cast<String>(),
      remoteClientBitrateLimit: fields[35] as int,
      authenticationProviderId: fields[36] as String?,
      passwordResetProviderId: fields[42] as String?,
      syncPlayAccess: fields[43] as String,
      excludedSubFolders: (fields[37] as List?)?.cast<String>(),
      disablePremiumFeatures: fields[38] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, UserPolicy obj) {
    writer
      ..writeByte(44)
      ..writeByte(0)
      ..write(obj.isAdministrator)
      ..writeByte(1)
      ..write(obj.isHidden)
      ..writeByte(2)
      ..write(obj.isHiddenRemotely)
      ..writeByte(3)
      ..write(obj.isDisabled)
      ..writeByte(4)
      ..write(obj.maxParentalRating)
      ..writeByte(5)
      ..write(obj.blockedTags)
      ..writeByte(6)
      ..write(obj.enableUserPreferenceAccess)
      ..writeByte(7)
      ..write(obj.accessSchedules)
      ..writeByte(8)
      ..write(obj.blockUnratedItems)
      ..writeByte(9)
      ..write(obj.enableRemoteControlOfOtherUsers)
      ..writeByte(10)
      ..write(obj.enableSharedDeviceControl)
      ..writeByte(11)
      ..write(obj.enableRemoteAccess)
      ..writeByte(12)
      ..write(obj.enableLiveTvManagement)
      ..writeByte(13)
      ..write(obj.enableLiveTvAccess)
      ..writeByte(14)
      ..write(obj.enableMediaPlayback)
      ..writeByte(15)
      ..write(obj.enableAudioPlaybackTranscoding)
      ..writeByte(16)
      ..write(obj.enableVideoPlaybackTranscoding)
      ..writeByte(17)
      ..write(obj.enablePlaybackRemuxing)
      ..writeByte(18)
      ..write(obj.enableContentDeletion)
      ..writeByte(19)
      ..write(obj.enableContentDeletionFromFolders)
      ..writeByte(20)
      ..write(obj.enableContentDownloading)
      ..writeByte(21)
      ..write(obj.enableSubtitleDownloading)
      ..writeByte(22)
      ..write(obj.enableSubtitleManagement)
      ..writeByte(23)
      ..write(obj.enableSyncTranscoding)
      ..writeByte(24)
      ..write(obj.enableMediaConversion)
      ..writeByte(25)
      ..write(obj.enabledDevices)
      ..writeByte(26)
      ..write(obj.enableAllDevices)
      ..writeByte(27)
      ..write(obj.enabledChannels)
      ..writeByte(28)
      ..write(obj.enableAllChannels)
      ..writeByte(29)
      ..write(obj.enabledFolders)
      ..writeByte(30)
      ..write(obj.enableAllFolders)
      ..writeByte(31)
      ..write(obj.invalidLoginAttemptCount)
      ..writeByte(32)
      ..write(obj.enablePublicSharing)
      ..writeByte(33)
      ..write(obj.blockedMediaFolders)
      ..writeByte(34)
      ..write(obj.blockedChannels)
      ..writeByte(35)
      ..write(obj.remoteClientBitrateLimit)
      ..writeByte(36)
      ..write(obj.authenticationProviderId)
      ..writeByte(37)
      ..write(obj.excludedSubFolders)
      ..writeByte(38)
      ..write(obj.disablePremiumFeatures)
      ..writeByte(39)
      ..write(obj.forceRemoteSourceTranscoding)
      ..writeByte(40)
      ..write(obj.loginAttemptsBeforeLockout)
      ..writeByte(41)
      ..write(obj.maxActiveSessions)
      ..writeByte(42)
      ..write(obj.passwordResetProviderId)
      ..writeByte(43)
      ..write(obj.syncPlayAccess);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPolicyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AccessScheduleAdapter extends TypeAdapter<AccessSchedule> {
  @override
  final int typeId = 13;

  @override
  AccessSchedule read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AccessSchedule(
      id: fields[3] as int,
      userId: fields[4] as String,
      dayOfWeek: fields[0] as String,
      startHour: fields[1] as double,
      endHour: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, AccessSchedule obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.dayOfWeek)
      ..writeByte(1)
      ..write(obj.startHour)
      ..writeByte(2)
      ..write(obj.endHour)
      ..writeByte(3)
      ..write(obj.id)
      ..writeByte(4)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccessScheduleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AuthenticationResultAdapter extends TypeAdapter<AuthenticationResult> {
  @override
  final int typeId = 7;

  @override
  AuthenticationResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AuthenticationResult(
      user: fields[0] as UserDto?,
      sessionInfo: fields[1] as SessionInfo?,
      accessToken: fields[2] as String?,
      serverId: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AuthenticationResult obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.user)
      ..writeByte(1)
      ..write(obj.sessionInfo)
      ..writeByte(2)
      ..write(obj.accessToken)
      ..writeByte(3)
      ..write(obj.serverId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthenticationResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SessionInfoAdapter extends TypeAdapter<SessionInfo> {
  @override
  final int typeId = 10;

  @override
  SessionInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SessionInfo(
      playState: fields[0] as PlayerStateInfo?,
      additionalUsers: (fields[1] as List?)?.cast<SessionUserInfo>(),
      capabilities: fields[2] as ClientCapabilities?,
      remoteEndPoint: fields[3] as String?,
      playableMediaTypes: (fields[4] as List?)?.cast<String>(),
      playlistItemId: fields[5] as String?,
      id: fields[6] as String?,
      serverId: fields[7] as String?,
      userId: fields[8] as String,
      userName: fields[9] as String?,
      userPrimaryImageTag: fields[10] as String?,
      client: fields[11] as String?,
      lastActivityDate: fields[12] as String,
      deviceName: fields[13] as String?,
      deviceType: fields[14] as String?,
      nowPlayingItem: fields[15] as BaseItemDto?,
      deviceId: fields[16] as String?,
      appIconUrl: fields[17] as String?,
      supportedCommands: (fields[18] as List?)?.cast<String>(),
      transcodingInfo: fields[19] as TranscodingInfo?,
      supportsRemoteControl: fields[20] as bool,
      lastPlaybackCheckIn: fields[21] as String?,
      fullNowPlayingItem: fields[22] as BaseItem?,
      nowViewingItem: fields[23] as BaseItemDto?,
      applicationVersion: fields[24] as String?,
      isActive: fields[25] as bool,
      supportsMediaControl: fields[26] as bool,
      nowPlayingQueue: (fields[27] as List?)?.cast<QueueItem>(),
      hasCustomDeviceName: fields[28] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SessionInfo obj) {
    writer
      ..writeByte(29)
      ..writeByte(0)
      ..write(obj.playState)
      ..writeByte(1)
      ..write(obj.additionalUsers)
      ..writeByte(2)
      ..write(obj.capabilities)
      ..writeByte(3)
      ..write(obj.remoteEndPoint)
      ..writeByte(4)
      ..write(obj.playableMediaTypes)
      ..writeByte(5)
      ..write(obj.playlistItemId)
      ..writeByte(6)
      ..write(obj.id)
      ..writeByte(7)
      ..write(obj.serverId)
      ..writeByte(8)
      ..write(obj.userId)
      ..writeByte(9)
      ..write(obj.userName)
      ..writeByte(10)
      ..write(obj.userPrimaryImageTag)
      ..writeByte(11)
      ..write(obj.client)
      ..writeByte(12)
      ..write(obj.lastActivityDate)
      ..writeByte(13)
      ..write(obj.deviceName)
      ..writeByte(14)
      ..write(obj.deviceType)
      ..writeByte(15)
      ..write(obj.nowPlayingItem)
      ..writeByte(16)
      ..write(obj.deviceId)
      ..writeByte(17)
      ..write(obj.appIconUrl)
      ..writeByte(18)
      ..write(obj.supportedCommands)
      ..writeByte(19)
      ..write(obj.transcodingInfo)
      ..writeByte(20)
      ..write(obj.supportsRemoteControl)
      ..writeByte(21)
      ..write(obj.lastPlaybackCheckIn)
      ..writeByte(22)
      ..write(obj.fullNowPlayingItem)
      ..writeByte(23)
      ..write(obj.nowViewingItem)
      ..writeByte(24)
      ..write(obj.applicationVersion)
      ..writeByte(25)
      ..write(obj.isActive)
      ..writeByte(26)
      ..write(obj.supportsMediaControl)
      ..writeByte(27)
      ..write(obj.nowPlayingQueue)
      ..writeByte(28)
      ..write(obj.hasCustomDeviceName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PlayerStateInfoAdapter extends TypeAdapter<PlayerStateInfo> {
  @override
  final int typeId = 14;

  @override
  PlayerStateInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlayerStateInfo(
      positionTicks: fields[0] as int?,
      canSeek: fields[1] as bool,
      isPaused: fields[2] as bool,
      isMuted: fields[3] as bool,
      volumeLevel: fields[4] as int?,
      audioStreamIndex: fields[5] as int?,
      subtitleStreamIndex: fields[6] as int?,
      mediaSourceId: fields[7] as String?,
      playMethod: fields[8] as String?,
      repeatMode: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PlayerStateInfo obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.positionTicks)
      ..writeByte(1)
      ..write(obj.canSeek)
      ..writeByte(2)
      ..write(obj.isPaused)
      ..writeByte(3)
      ..write(obj.isMuted)
      ..writeByte(4)
      ..write(obj.volumeLevel)
      ..writeByte(5)
      ..write(obj.audioStreamIndex)
      ..writeByte(6)
      ..write(obj.subtitleStreamIndex)
      ..writeByte(7)
      ..write(obj.mediaSourceId)
      ..writeByte(8)
      ..write(obj.playMethod)
      ..writeByte(9)
      ..write(obj.repeatMode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerStateInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SessionUserInfoAdapter extends TypeAdapter<SessionUserInfo> {
  @override
  final int typeId = 15;

  @override
  SessionUserInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SessionUserInfo(
      userId: fields[0] as String,
      userName: fields[1] as String?,
      userInternalId: fields[2] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, SessionUserInfo obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.userName)
      ..writeByte(2)
      ..write(obj.userInternalId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionUserInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ClientCapabilitiesAdapter extends TypeAdapter<ClientCapabilities> {
  @override
  final int typeId = 16;

  @override
  ClientCapabilities read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClientCapabilities(
      playableMediaTypes: (fields[0] as List?)?.cast<String>(),
      supportedCommands: (fields[1] as List?)?.cast<String>(),
      supportsMediaControl: fields[2] as bool,
      pushToken: fields[3] as String?,
      pushTokenType: fields[4] as String?,
      supportsPersistentIdentifier: fields[5] as bool,
      supportsSync: fields[6] as bool,
      deviceProfile: fields[7] as DeviceProfile?,
      iconUrl: fields[8] as String?,
      appId: fields[9] as String?,
      supportsContentUploading: fields[10] as bool,
      messageCallbackUrl: fields[11] as String?,
      appStoreUrl: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ClientCapabilities obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.playableMediaTypes)
      ..writeByte(1)
      ..write(obj.supportedCommands)
      ..writeByte(2)
      ..write(obj.supportsMediaControl)
      ..writeByte(3)
      ..write(obj.pushToken)
      ..writeByte(4)
      ..write(obj.pushTokenType)
      ..writeByte(5)
      ..write(obj.supportsPersistentIdentifier)
      ..writeByte(6)
      ..write(obj.supportsSync)
      ..writeByte(7)
      ..write(obj.deviceProfile)
      ..writeByte(8)
      ..write(obj.iconUrl)
      ..writeByte(9)
      ..write(obj.appId)
      ..writeByte(10)
      ..write(obj.supportsContentUploading)
      ..writeByte(11)
      ..write(obj.messageCallbackUrl)
      ..writeByte(12)
      ..write(obj.appStoreUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClientCapabilitiesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DeviceProfileAdapter extends TypeAdapter<DeviceProfile> {
  @override
  final int typeId = 17;

  @override
  DeviceProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeviceProfile(
      name: fields[0] as String?,
      id: fields[1] as String?,
      identification: fields[2] as DeviceIdentification?,
      friendlyName: fields[3] as String?,
      manufacturer: fields[4] as String?,
      manufacturerUrl: fields[5] as String?,
      modelName: fields[6] as String?,
      modelDescription: fields[7] as String?,
      modelNumber: fields[8] as String?,
      modelUrl: fields[9] as String?,
      serialNumber: fields[10] as String?,
      enableAlbumArtInDidl: fields[11] as bool,
      enableSingleAlbumArtLimit: fields[12] as bool,
      enableSingleSubtitleLimit: fields[13] as bool,
      supportedMediaTypes: fields[14] as String?,
      userId: fields[15] as String?,
      albumArtPn: fields[16] as String?,
      maxAlbumArtWidth: fields[17] as int,
      maxAlbumArtHeight: fields[18] as int,
      maxIconWidth: fields[19] as int?,
      maxIconHeight: fields[20] as int?,
      maxStreamingBitrate: fields[21] as int?,
      maxStaticBitrate: fields[22] as int?,
      musicStreamingTranscodingBitrate: fields[23] as int?,
      maxStaticMusicBitrate: fields[24] as int?,
      sonyAggregationFlags: fields[25] as String?,
      protocolInfo: fields[26] as String?,
      timelineOffsetSeconds: fields[27] as int,
      requiresPlainVideoItems: fields[28] as bool,
      requiresPlainFolders: fields[29] as bool,
      enableMSMediaReceiverRegistrar: fields[30] as bool,
      ignoreTranscodeByteRangeRequests: fields[31] as bool,
      xmlRootAttributes: (fields[32] as List?)?.cast<XmlAttribute>(),
      directPlayProfiles: (fields[33] as List?)?.cast<DirectPlayProfile>(),
      transcodingProfiles: (fields[34] as List?)?.cast<TranscodingProfile>(),
      containerProfiles: (fields[35] as List?)?.cast<ContainerProfile>(),
      codecProfiles: (fields[36] as List?)?.cast<CodecProfile>(),
      responseProfiles: (fields[37] as List?)?.cast<ResponseProfile>(),
      subtitleProfiles: (fields[38] as List?)?.cast<SubtitleProfile>(),
    );
  }

  @override
  void write(BinaryWriter writer, DeviceProfile obj) {
    writer
      ..writeByte(39)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.identification)
      ..writeByte(3)
      ..write(obj.friendlyName)
      ..writeByte(4)
      ..write(obj.manufacturer)
      ..writeByte(5)
      ..write(obj.manufacturerUrl)
      ..writeByte(6)
      ..write(obj.modelName)
      ..writeByte(7)
      ..write(obj.modelDescription)
      ..writeByte(8)
      ..write(obj.modelNumber)
      ..writeByte(9)
      ..write(obj.modelUrl)
      ..writeByte(10)
      ..write(obj.serialNumber)
      ..writeByte(11)
      ..write(obj.enableAlbumArtInDidl)
      ..writeByte(12)
      ..write(obj.enableSingleAlbumArtLimit)
      ..writeByte(13)
      ..write(obj.enableSingleSubtitleLimit)
      ..writeByte(14)
      ..write(obj.supportedMediaTypes)
      ..writeByte(15)
      ..write(obj.userId)
      ..writeByte(16)
      ..write(obj.albumArtPn)
      ..writeByte(17)
      ..write(obj.maxAlbumArtWidth)
      ..writeByte(18)
      ..write(obj.maxAlbumArtHeight)
      ..writeByte(19)
      ..write(obj.maxIconWidth)
      ..writeByte(20)
      ..write(obj.maxIconHeight)
      ..writeByte(21)
      ..write(obj.maxStreamingBitrate)
      ..writeByte(22)
      ..write(obj.maxStaticBitrate)
      ..writeByte(23)
      ..write(obj.musicStreamingTranscodingBitrate)
      ..writeByte(24)
      ..write(obj.maxStaticMusicBitrate)
      ..writeByte(25)
      ..write(obj.sonyAggregationFlags)
      ..writeByte(26)
      ..write(obj.protocolInfo)
      ..writeByte(27)
      ..write(obj.timelineOffsetSeconds)
      ..writeByte(28)
      ..write(obj.requiresPlainVideoItems)
      ..writeByte(29)
      ..write(obj.requiresPlainFolders)
      ..writeByte(30)
      ..write(obj.enableMSMediaReceiverRegistrar)
      ..writeByte(31)
      ..write(obj.ignoreTranscodeByteRangeRequests)
      ..writeByte(32)
      ..write(obj.xmlRootAttributes)
      ..writeByte(33)
      ..write(obj.directPlayProfiles)
      ..writeByte(34)
      ..write(obj.transcodingProfiles)
      ..writeByte(35)
      ..write(obj.containerProfiles)
      ..writeByte(36)
      ..write(obj.codecProfiles)
      ..writeByte(37)
      ..write(obj.responseProfiles)
      ..writeByte(38)
      ..write(obj.subtitleProfiles);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DeviceIdentificationAdapter extends TypeAdapter<DeviceIdentification> {
  @override
  final int typeId = 18;

  @override
  DeviceIdentification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeviceIdentification(
      friendlyName: fields[0] as String?,
      modelNumber: fields[1] as String?,
      serialNumber: fields[2] as String?,
      modelName: fields[3] as String?,
      modelDescription: fields[4] as String?,
      deviceDescription: fields[5] as String?,
      modelUrl: fields[6] as String?,
      manufacturer: fields[7] as String?,
      manufacturerUrl: fields[8] as String?,
      headers: (fields[9] as List?)?.cast<HttpHeaderInfo>(),
    );
  }

  @override
  void write(BinaryWriter writer, DeviceIdentification obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.friendlyName)
      ..writeByte(1)
      ..write(obj.modelNumber)
      ..writeByte(2)
      ..write(obj.serialNumber)
      ..writeByte(3)
      ..write(obj.modelName)
      ..writeByte(4)
      ..write(obj.modelDescription)
      ..writeByte(5)
      ..write(obj.deviceDescription)
      ..writeByte(6)
      ..write(obj.modelUrl)
      ..writeByte(7)
      ..write(obj.manufacturer)
      ..writeByte(8)
      ..write(obj.manufacturerUrl)
      ..writeByte(9)
      ..write(obj.headers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceIdentificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HttpHeaderInfoAdapter extends TypeAdapter<HttpHeaderInfo> {
  @override
  final int typeId = 19;

  @override
  HttpHeaderInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HttpHeaderInfo(
      name: fields[0] as String?,
      value: fields[1] as String?,
      match: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HttpHeaderInfo obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.value)
      ..writeByte(2)
      ..write(obj.match);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HttpHeaderInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class XmlAttributeAdapter extends TypeAdapter<XmlAttribute> {
  @override
  final int typeId = 20;

  @override
  XmlAttribute read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return XmlAttribute(
      name: fields[0] as String?,
      value: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, XmlAttribute obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is XmlAttributeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DirectPlayProfileAdapter extends TypeAdapter<DirectPlayProfile> {
  @override
  final int typeId = 21;

  @override
  DirectPlayProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DirectPlayProfile(
      container: fields[0] as String?,
      audioCodec: fields[1] as String?,
      videoCodec: fields[2] as String?,
      type: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DirectPlayProfile obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.container)
      ..writeByte(1)
      ..write(obj.audioCodec)
      ..writeByte(2)
      ..write(obj.videoCodec)
      ..writeByte(3)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DirectPlayProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TranscodingProfileAdapter extends TypeAdapter<TranscodingProfile> {
  @override
  final int typeId = 22;

  @override
  TranscodingProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TranscodingProfile(
      container: fields[0] as String?,
      type: fields[1] as String,
      videoCodec: fields[2] as String?,
      audioCodec: fields[3] as String?,
      protocol: fields[4] as String?,
      estimateContentLength: fields[5] as bool,
      enableMpegtsM2TsMode: fields[6] as bool,
      transcodeSeekInfo: fields[7] as String,
      copyTimestamps: fields[8] as bool,
      context: fields[9] as String,
      maxAudioChannels: fields[10] as String?,
      minSegments: fields[11] as int,
      segmentLength: fields[12] as int,
      breakOnNonKeyFrames: fields[13] as bool,
      manifestSubtitles: fields[14] as String?,
      enableSubtitlesInManifest: fields[15] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TranscodingProfile obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.container)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.videoCodec)
      ..writeByte(3)
      ..write(obj.audioCodec)
      ..writeByte(4)
      ..write(obj.protocol)
      ..writeByte(5)
      ..write(obj.estimateContentLength)
      ..writeByte(6)
      ..write(obj.enableMpegtsM2TsMode)
      ..writeByte(7)
      ..write(obj.transcodeSeekInfo)
      ..writeByte(8)
      ..write(obj.copyTimestamps)
      ..writeByte(9)
      ..write(obj.context)
      ..writeByte(10)
      ..write(obj.maxAudioChannels)
      ..writeByte(11)
      ..write(obj.minSegments)
      ..writeByte(12)
      ..write(obj.segmentLength)
      ..writeByte(13)
      ..write(obj.breakOnNonKeyFrames)
      ..writeByte(14)
      ..write(obj.manifestSubtitles)
      ..writeByte(15)
      ..write(obj.enableSubtitlesInManifest);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TranscodingProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ContainerProfileAdapter extends TypeAdapter<ContainerProfile> {
  @override
  final int typeId = 23;

  @override
  ContainerProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContainerProfile(
      type: fields[0] as String,
      conditions: (fields[1] as List?)?.cast<ProfileCondition>(),
      container: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ContainerProfile obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.conditions)
      ..writeByte(2)
      ..write(obj.container);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContainerProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProfileConditionAdapter extends TypeAdapter<ProfileCondition> {
  @override
  final int typeId = 24;

  @override
  ProfileCondition read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfileCondition(
      condition: fields[0] as String,
      property: fields[1] as String,
      value: fields[2] as String?,
      isRequired: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ProfileCondition obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.condition)
      ..writeByte(1)
      ..write(obj.property)
      ..writeByte(2)
      ..write(obj.value)
      ..writeByte(3)
      ..write(obj.isRequired);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileConditionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CodecProfileAdapter extends TypeAdapter<CodecProfile> {
  @override
  final int typeId = 25;

  @override
  CodecProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CodecProfile(
      type: fields[0] as String,
      conditions: (fields[1] as List?)?.cast<ProfileCondition>(),
      applyConditions: (fields[2] as List?)?.cast<ProfileCondition>(),
      codec: fields[3] as String?,
      container: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CodecProfile obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.conditions)
      ..writeByte(2)
      ..write(obj.applyConditions)
      ..writeByte(3)
      ..write(obj.codec)
      ..writeByte(4)
      ..write(obj.container);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CodecProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ResponseProfileAdapter extends TypeAdapter<ResponseProfile> {
  @override
  final int typeId = 26;

  @override
  ResponseProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ResponseProfile(
      container: fields[0] as String?,
      audioCodec: fields[1] as String?,
      videoCodec: fields[2] as String?,
      type: fields[3] as String,
      orgPn: fields[4] as String?,
      mimeType: fields[5] as String?,
      conditions: (fields[6] as List?)?.cast<ProfileCondition>(),
    );
  }

  @override
  void write(BinaryWriter writer, ResponseProfile obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.container)
      ..writeByte(1)
      ..write(obj.audioCodec)
      ..writeByte(2)
      ..write(obj.videoCodec)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.orgPn)
      ..writeByte(5)
      ..write(obj.mimeType)
      ..writeByte(6)
      ..write(obj.conditions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResponseProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SubtitleProfileAdapter extends TypeAdapter<SubtitleProfile> {
  @override
  final int typeId = 27;

  @override
  SubtitleProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubtitleProfile(
      format: fields[0] as String?,
      method: fields[1] as String,
      didlMode: fields[2] as String?,
      language: fields[3] as String?,
      container: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SubtitleProfile obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.format)
      ..writeByte(1)
      ..write(obj.method)
      ..writeByte(2)
      ..write(obj.didlMode)
      ..writeByte(3)
      ..write(obj.language)
      ..writeByte(4)
      ..write(obj.container);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubtitleProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BaseItemDtoAdapter extends TypeAdapter<BaseItemDto> {
  @override
  final int typeId = 0;

  @override
  BaseItemDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BaseItemDto(
      name: fields[0] as String?,
      originalTitle: fields[1] as String?,
      serverId: fields[2] as String?,
      id: fields[3] as String,
      etag: fields[4] as String?,
      playlistItemId: fields[5] as String?,
      dateCreated: fields[6] as String?,
      extraType: fields[7] as String?,
      airsBeforeSeasonNumber: fields[8] as int?,
      airsAfterSeasonNumber: fields[9] as int?,
      airsBeforeEpisodeNumber: fields[10] as int?,
      displaySpecialsWithSeasons: fields[11] as bool?,
      canDelete: fields[12] as bool?,
      canDownload: fields[13] as bool?,
      hasSubtitles: fields[14] as bool?,
      supportsResume: fields[15] as bool?,
      preferredMetadataLanguage: fields[16] as String?,
      preferredMetadataCountryCode: fields[17] as String?,
      supportsSync: fields[18] as bool?,
      container: fields[19] as String?,
      sortName: fields[20] as String?,
      forcedSortName: fields[21] as String?,
      video3DFormat: fields[22] as String?,
      premiereDate: fields[23] as String?,
      externalUrls: (fields[24] as List?)?.cast<ExternalUrl>(),
      mediaSources: (fields[25] as List?)?.cast<MediaSourceInfo>(),
      criticRating: fields[26] as double?,
      gameSystemId: fields[27] as int?,
      gameSystem: fields[28] as String?,
      productionLocations: (fields[29] as List?)?.cast<String>(),
      path: fields[30] as String?,
      officialRating: fields[31] as String?,
      customRating: fields[32] as String?,
      channelId: fields[33] as String?,
      channelName: fields[34] as String?,
      overview: fields[35] as String?,
      taglines: (fields[36] as List?)?.cast<String>(),
      genres: (fields[37] as List?)?.cast<String>(),
      communityRating: fields[38] as double?,
      runTimeTicks: fields[39] as int?,
      playAccess: fields[40] as String?,
      aspectRatio: fields[41] as String?,
      productionYear: fields[42] as int?,
      number: fields[43] as String?,
      channelNumber: fields[44] as String?,
      indexNumber: fields[45] as int?,
      indexNumberEnd: fields[46] as int?,
      parentIndexNumber: fields[47] as int?,
      remoteTrailers: (fields[48] as List?)?.cast<MediaUrl>(),
      providerIds: (fields[49] as Map?)?.cast<dynamic, String>(),
      isFolder: fields[50] as bool?,
      parentId: fields[51] as String?,
      type: fields[52] as String?,
      people: (fields[53] as List?)?.cast<BaseItemPerson>(),
      studios: (fields[54] as List?)?.cast<NameLongIdPair>(),
      genreItems: (fields[55] as List?)?.cast<NameLongIdPair>(),
      parentLogoItemId: fields[56] as String?,
      parentBackdropItemId: fields[57] as String?,
      parentBackdropImageTags: (fields[58] as List?)?.cast<String>(),
      localTrailerCount: fields[59] as int?,
      userData: fields[60] as UserItemDataDto?,
      recursiveItemCount: fields[61] as int?,
      childCount: fields[62] as int?,
      seriesName: fields[63] as String?,
      seriesId: fields[64] as String?,
      seasonId: fields[65] as String?,
      specialFeatureCount: fields[66] as int?,
      displayPreferencesId: fields[67] as String?,
      status: fields[68] as String?,
      airTime: fields[69] as String?,
      airDays: (fields[70] as List?)?.cast<String>(),
      tags: (fields[71] as List?)?.cast<String>(),
      primaryImageAspectRatio: fields[72] as double?,
      artists: (fields[73] as List?)?.cast<String>(),
      artistItems: (fields[74] as List?)?.cast<NameIdPair>(),
      album: fields[75] as String?,
      collectionType: fields[76] as String?,
      displayOrder: fields[77] as String?,
      albumId: fields[78] as String?,
      albumPrimaryImageTag: fields[79] as String?,
      seriesPrimaryImageTag: fields[80] as String?,
      albumArtist: fields[81] as String?,
      albumArtists: (fields[82] as List?)?.cast<NameIdPair>(),
      seasonName: fields[83] as String?,
      mediaStreams: (fields[84] as List?)?.cast<MediaStream>(),
      partCount: fields[85] as int?,
      imageTags: (fields[86] as Map?)?.cast<dynamic, String>(),
      backdropImageTags: (fields[87] as List?)?.cast<String>(),
      parentLogoImageTag: fields[88] as String?,
      parentArtItemId: fields[89] as String?,
      parentArtImageTag: fields[90] as String?,
      seriesThumbImageTag: fields[91] as String?,
      seriesStudio: fields[92] as String?,
      parentThumbItemId: fields[93] as String?,
      parentThumbImageTag: fields[94] as String?,
      parentPrimaryImageItemId: fields[95] as String?,
      parentPrimaryImageTag: fields[96] as String?,
      chapters: (fields[97] as List?)?.cast<ChapterInfo>(),
      locationType: fields[98] as String?,
      mediaType: fields[99] as String?,
      endDate: fields[100] as String?,
      lockedFields: (fields[101] as List?)?.cast<String>(),
      lockData: fields[102] as bool?,
      width: fields[103] as int?,
      height: fields[104] as int?,
      cameraMake: fields[105] as String?,
      cameraModel: fields[106] as String?,
      software: fields[107] as String?,
      exposureTime: fields[108] as double?,
      focalLength: fields[109] as double?,
      imageOrientation: fields[110] as String?,
      aperture: fields[111] as double?,
      shutterSpeed: fields[112] as double?,
      latitude: fields[113] as double?,
      longitude: fields[114] as double?,
      altitude: fields[115] as double?,
      isoSpeedRating: fields[116] as int?,
      seriesTimerId: fields[117] as String?,
      channelPrimaryImageTag: fields[118] as String?,
      startDate: fields[119] as String?,
      completionPercentage: fields[120] as double?,
      isRepeat: fields[121] as bool?,
      isNew: fields[122] as bool?,
      episodeTitle: fields[123] as String?,
      isMovie: fields[124] as bool?,
      isSports: fields[125] as bool?,
      isSeries: fields[126] as bool?,
      isLive: fields[127] as bool?,
      isNews: fields[128] as bool?,
      isKids: fields[129] as bool?,
      isPremiere: fields[130] as bool?,
      timerId: fields[131] as String?,
      currentProgram: fields[132] as dynamic,
      movieCount: fields[133] as int?,
      seriesCount: fields[134] as int?,
      albumCount: fields[135] as int?,
      songCount: fields[136] as int?,
      musicVideoCount: fields[137] as int?,
      sourceType: fields[138] as String?,
      dateLastMediaAdded: fields[139] as String?,
      enableMediaSourceDisplay: fields[140] as bool?,
      cumulativeRunTimeTicks: fields[141] as int?,
      isPlaceHolder: fields[142] as bool?,
      isHD: fields[143] as bool?,
      videoType: fields[144] as String?,
      mediaSourceCount: fields[145] as int?,
      screenshotImageTags: (fields[146] as List?)?.cast<String>(),
      imageBlurHashes: fields[147] as ImageBlurHashes?,
      isoType: fields[148] as String?,
      trailerCount: fields[149] as int?,
      programCount: fields[150] as int?,
      episodeCount: fields[151] as int?,
      artistCount: fields[152] as int?,
      programId: fields[153] as String?,
      channelType: fields[154] as String?,
      audio: fields[155] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BaseItemDto obj) {
    writer
      ..writeByte(156)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.originalTitle)
      ..writeByte(2)
      ..write(obj.serverId)
      ..writeByte(3)
      ..write(obj.id)
      ..writeByte(4)
      ..write(obj.etag)
      ..writeByte(5)
      ..write(obj.playlistItemId)
      ..writeByte(6)
      ..write(obj.dateCreated)
      ..writeByte(7)
      ..write(obj.extraType)
      ..writeByte(8)
      ..write(obj.airsBeforeSeasonNumber)
      ..writeByte(9)
      ..write(obj.airsAfterSeasonNumber)
      ..writeByte(10)
      ..write(obj.airsBeforeEpisodeNumber)
      ..writeByte(11)
      ..write(obj.displaySpecialsWithSeasons)
      ..writeByte(12)
      ..write(obj.canDelete)
      ..writeByte(13)
      ..write(obj.canDownload)
      ..writeByte(14)
      ..write(obj.hasSubtitles)
      ..writeByte(15)
      ..write(obj.supportsResume)
      ..writeByte(16)
      ..write(obj.preferredMetadataLanguage)
      ..writeByte(17)
      ..write(obj.preferredMetadataCountryCode)
      ..writeByte(18)
      ..write(obj.supportsSync)
      ..writeByte(19)
      ..write(obj.container)
      ..writeByte(20)
      ..write(obj.sortName)
      ..writeByte(21)
      ..write(obj.forcedSortName)
      ..writeByte(22)
      ..write(obj.video3DFormat)
      ..writeByte(23)
      ..write(obj.premiereDate)
      ..writeByte(24)
      ..write(obj.externalUrls)
      ..writeByte(25)
      ..write(obj.mediaSources)
      ..writeByte(26)
      ..write(obj.criticRating)
      ..writeByte(27)
      ..write(obj.gameSystemId)
      ..writeByte(28)
      ..write(obj.gameSystem)
      ..writeByte(29)
      ..write(obj.productionLocations)
      ..writeByte(30)
      ..write(obj.path)
      ..writeByte(31)
      ..write(obj.officialRating)
      ..writeByte(32)
      ..write(obj.customRating)
      ..writeByte(33)
      ..write(obj.channelId)
      ..writeByte(34)
      ..write(obj.channelName)
      ..writeByte(35)
      ..write(obj.overview)
      ..writeByte(36)
      ..write(obj.taglines)
      ..writeByte(37)
      ..write(obj.genres)
      ..writeByte(38)
      ..write(obj.communityRating)
      ..writeByte(39)
      ..write(obj.runTimeTicks)
      ..writeByte(40)
      ..write(obj.playAccess)
      ..writeByte(41)
      ..write(obj.aspectRatio)
      ..writeByte(42)
      ..write(obj.productionYear)
      ..writeByte(43)
      ..write(obj.number)
      ..writeByte(44)
      ..write(obj.channelNumber)
      ..writeByte(45)
      ..write(obj.indexNumber)
      ..writeByte(46)
      ..write(obj.indexNumberEnd)
      ..writeByte(47)
      ..write(obj.parentIndexNumber)
      ..writeByte(48)
      ..write(obj.remoteTrailers)
      ..writeByte(49)
      ..write(obj.providerIds)
      ..writeByte(50)
      ..write(obj.isFolder)
      ..writeByte(51)
      ..write(obj.parentId)
      ..writeByte(52)
      ..write(obj.type)
      ..writeByte(53)
      ..write(obj.people)
      ..writeByte(54)
      ..write(obj.studios)
      ..writeByte(55)
      ..write(obj.genreItems)
      ..writeByte(56)
      ..write(obj.parentLogoItemId)
      ..writeByte(57)
      ..write(obj.parentBackdropItemId)
      ..writeByte(58)
      ..write(obj.parentBackdropImageTags)
      ..writeByte(59)
      ..write(obj.localTrailerCount)
      ..writeByte(60)
      ..write(obj.userData)
      ..writeByte(61)
      ..write(obj.recursiveItemCount)
      ..writeByte(62)
      ..write(obj.childCount)
      ..writeByte(63)
      ..write(obj.seriesName)
      ..writeByte(64)
      ..write(obj.seriesId)
      ..writeByte(65)
      ..write(obj.seasonId)
      ..writeByte(66)
      ..write(obj.specialFeatureCount)
      ..writeByte(67)
      ..write(obj.displayPreferencesId)
      ..writeByte(68)
      ..write(obj.status)
      ..writeByte(69)
      ..write(obj.airTime)
      ..writeByte(70)
      ..write(obj.airDays)
      ..writeByte(71)
      ..write(obj.tags)
      ..writeByte(72)
      ..write(obj.primaryImageAspectRatio)
      ..writeByte(73)
      ..write(obj.artists)
      ..writeByte(74)
      ..write(obj.artistItems)
      ..writeByte(75)
      ..write(obj.album)
      ..writeByte(76)
      ..write(obj.collectionType)
      ..writeByte(77)
      ..write(obj.displayOrder)
      ..writeByte(78)
      ..write(obj.albumId)
      ..writeByte(79)
      ..write(obj.albumPrimaryImageTag)
      ..writeByte(80)
      ..write(obj.seriesPrimaryImageTag)
      ..writeByte(81)
      ..write(obj.albumArtist)
      ..writeByte(82)
      ..write(obj.albumArtists)
      ..writeByte(83)
      ..write(obj.seasonName)
      ..writeByte(84)
      ..write(obj.mediaStreams)
      ..writeByte(85)
      ..write(obj.partCount)
      ..writeByte(86)
      ..write(obj.imageTags)
      ..writeByte(87)
      ..write(obj.backdropImageTags)
      ..writeByte(88)
      ..write(obj.parentLogoImageTag)
      ..writeByte(89)
      ..write(obj.parentArtItemId)
      ..writeByte(90)
      ..write(obj.parentArtImageTag)
      ..writeByte(91)
      ..write(obj.seriesThumbImageTag)
      ..writeByte(92)
      ..write(obj.seriesStudio)
      ..writeByte(93)
      ..write(obj.parentThumbItemId)
      ..writeByte(94)
      ..write(obj.parentThumbImageTag)
      ..writeByte(95)
      ..write(obj.parentPrimaryImageItemId)
      ..writeByte(96)
      ..write(obj.parentPrimaryImageTag)
      ..writeByte(97)
      ..write(obj.chapters)
      ..writeByte(98)
      ..write(obj.locationType)
      ..writeByte(99)
      ..write(obj.mediaType)
      ..writeByte(100)
      ..write(obj.endDate)
      ..writeByte(101)
      ..write(obj.lockedFields)
      ..writeByte(102)
      ..write(obj.lockData)
      ..writeByte(103)
      ..write(obj.width)
      ..writeByte(104)
      ..write(obj.height)
      ..writeByte(105)
      ..write(obj.cameraMake)
      ..writeByte(106)
      ..write(obj.cameraModel)
      ..writeByte(107)
      ..write(obj.software)
      ..writeByte(108)
      ..write(obj.exposureTime)
      ..writeByte(109)
      ..write(obj.focalLength)
      ..writeByte(110)
      ..write(obj.imageOrientation)
      ..writeByte(111)
      ..write(obj.aperture)
      ..writeByte(112)
      ..write(obj.shutterSpeed)
      ..writeByte(113)
      ..write(obj.latitude)
      ..writeByte(114)
      ..write(obj.longitude)
      ..writeByte(115)
      ..write(obj.altitude)
      ..writeByte(116)
      ..write(obj.isoSpeedRating)
      ..writeByte(117)
      ..write(obj.seriesTimerId)
      ..writeByte(118)
      ..write(obj.channelPrimaryImageTag)
      ..writeByte(119)
      ..write(obj.startDate)
      ..writeByte(120)
      ..write(obj.completionPercentage)
      ..writeByte(121)
      ..write(obj.isRepeat)
      ..writeByte(122)
      ..write(obj.isNew)
      ..writeByte(123)
      ..write(obj.episodeTitle)
      ..writeByte(124)
      ..write(obj.isMovie)
      ..writeByte(125)
      ..write(obj.isSports)
      ..writeByte(126)
      ..write(obj.isSeries)
      ..writeByte(127)
      ..write(obj.isLive)
      ..writeByte(128)
      ..write(obj.isNews)
      ..writeByte(129)
      ..write(obj.isKids)
      ..writeByte(130)
      ..write(obj.isPremiere)
      ..writeByte(131)
      ..write(obj.timerId)
      ..writeByte(132)
      ..write(obj.currentProgram)
      ..writeByte(133)
      ..write(obj.movieCount)
      ..writeByte(134)
      ..write(obj.seriesCount)
      ..writeByte(135)
      ..write(obj.albumCount)
      ..writeByte(136)
      ..write(obj.songCount)
      ..writeByte(137)
      ..write(obj.musicVideoCount)
      ..writeByte(138)
      ..write(obj.sourceType)
      ..writeByte(139)
      ..write(obj.dateLastMediaAdded)
      ..writeByte(140)
      ..write(obj.enableMediaSourceDisplay)
      ..writeByte(141)
      ..write(obj.cumulativeRunTimeTicks)
      ..writeByte(142)
      ..write(obj.isPlaceHolder)
      ..writeByte(143)
      ..write(obj.isHD)
      ..writeByte(144)
      ..write(obj.videoType)
      ..writeByte(145)
      ..write(obj.mediaSourceCount)
      ..writeByte(146)
      ..write(obj.screenshotImageTags)
      ..writeByte(147)
      ..write(obj.imageBlurHashes)
      ..writeByte(148)
      ..write(obj.isoType)
      ..writeByte(149)
      ..write(obj.trailerCount)
      ..writeByte(150)
      ..write(obj.programCount)
      ..writeByte(151)
      ..write(obj.episodeCount)
      ..writeByte(152)
      ..write(obj.artistCount)
      ..writeByte(153)
      ..write(obj.programId)
      ..writeByte(154)
      ..write(obj.channelType)
      ..writeByte(155)
      ..write(obj.audio);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BaseItemDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExternalUrlAdapter extends TypeAdapter<ExternalUrl> {
  @override
  final int typeId = 29;

  @override
  ExternalUrl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExternalUrl(
      name: fields[0] as String?,
      url: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ExternalUrl obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExternalUrlAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MediaSourceInfoAdapter extends TypeAdapter<MediaSourceInfo> {
  @override
  final int typeId = 5;

  @override
  MediaSourceInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MediaSourceInfo(
      protocol: fields[0] as String,
      id: fields[1] as String?,
      path: fields[2] as String?,
      encoderPath: fields[3] as String?,
      encoderProtocol: fields[4] as String?,
      type: fields[5] as String,
      container: fields[6] as String?,
      size: fields[7] as int?,
      name: fields[8] as String?,
      isRemote: fields[9] as bool,
      runTimeTicks: fields[10] as int?,
      supportsTranscoding: fields[11] as bool,
      supportsDirectStream: fields[12] as bool,
      supportsDirectPlay: fields[13] as bool,
      isInfiniteStream: fields[14] as bool,
      requiresOpening: fields[15] as bool,
      openToken: fields[16] as String?,
      requiresClosing: fields[17] as bool,
      liveStreamId: fields[18] as String?,
      bufferMs: fields[19] as int?,
      requiresLooping: fields[20] as bool,
      supportsProbing: fields[21] as bool,
      video3DFormat: fields[22] as String?,
      mediaStreams: (fields[23] as List).cast<MediaStream>(),
      formats: (fields[24] as List?)?.cast<String>(),
      bitrate: fields[25] as int?,
      timestamp: fields[26] as String?,
      requiredHttpHeaders: (fields[27] as Map?)?.cast<dynamic, String>(),
      transcodingUrl: fields[28] as String?,
      transcodingSubProtocol: fields[29] as String?,
      transcodingContainer: fields[30] as String?,
      analyzeDurationMs: fields[31] as int?,
      readAtNativeFramerate: fields[32] as bool,
      defaultAudioStreamIndex: fields[33] as int?,
      defaultSubtitleStreamIndex: fields[34] as int?,
      etag: fields[35] as String?,
      ignoreDts: fields[36] as bool,
      ignoreIndex: fields[37] as bool,
      genPtsInput: fields[38] as bool,
      videoType: fields[39] as String?,
      isoType: fields[40] as String?,
      mediaAttachments: (fields[41] as List?)?.cast<MediaAttachment>(),
    );
  }

  @override
  void write(BinaryWriter writer, MediaSourceInfo obj) {
    writer
      ..writeByte(42)
      ..writeByte(0)
      ..write(obj.protocol)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.path)
      ..writeByte(3)
      ..write(obj.encoderPath)
      ..writeByte(4)
      ..write(obj.encoderProtocol)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.container)
      ..writeByte(7)
      ..write(obj.size)
      ..writeByte(8)
      ..write(obj.name)
      ..writeByte(9)
      ..write(obj.isRemote)
      ..writeByte(10)
      ..write(obj.runTimeTicks)
      ..writeByte(11)
      ..write(obj.supportsTranscoding)
      ..writeByte(12)
      ..write(obj.supportsDirectStream)
      ..writeByte(13)
      ..write(obj.supportsDirectPlay)
      ..writeByte(14)
      ..write(obj.isInfiniteStream)
      ..writeByte(15)
      ..write(obj.requiresOpening)
      ..writeByte(16)
      ..write(obj.openToken)
      ..writeByte(17)
      ..write(obj.requiresClosing)
      ..writeByte(18)
      ..write(obj.liveStreamId)
      ..writeByte(19)
      ..write(obj.bufferMs)
      ..writeByte(20)
      ..write(obj.requiresLooping)
      ..writeByte(21)
      ..write(obj.supportsProbing)
      ..writeByte(22)
      ..write(obj.video3DFormat)
      ..writeByte(23)
      ..write(obj.mediaStreams)
      ..writeByte(24)
      ..write(obj.formats)
      ..writeByte(25)
      ..write(obj.bitrate)
      ..writeByte(26)
      ..write(obj.timestamp)
      ..writeByte(27)
      ..write(obj.requiredHttpHeaders)
      ..writeByte(28)
      ..write(obj.transcodingUrl)
      ..writeByte(29)
      ..write(obj.transcodingSubProtocol)
      ..writeByte(30)
      ..write(obj.transcodingContainer)
      ..writeByte(31)
      ..write(obj.analyzeDurationMs)
      ..writeByte(32)
      ..write(obj.readAtNativeFramerate)
      ..writeByte(33)
      ..write(obj.defaultAudioStreamIndex)
      ..writeByte(34)
      ..write(obj.defaultSubtitleStreamIndex)
      ..writeByte(35)
      ..write(obj.etag)
      ..writeByte(36)
      ..write(obj.ignoreDts)
      ..writeByte(37)
      ..write(obj.ignoreIndex)
      ..writeByte(38)
      ..write(obj.genPtsInput)
      ..writeByte(39)
      ..write(obj.videoType)
      ..writeByte(40)
      ..write(obj.isoType)
      ..writeByte(41)
      ..write(obj.mediaAttachments);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaSourceInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MediaStreamAdapter extends TypeAdapter<MediaStream> {
  @override
  final int typeId = 6;

  @override
  MediaStream read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MediaStream(
      codec: fields[0] as String?,
      codecTag: fields[1] as String?,
      language: fields[2] as String?,
      colorTransfer: fields[3] as String?,
      colorPrimaries: fields[4] as String?,
      colorSpace: fields[5] as String?,
      comment: fields[6] as String?,
      timeBase: fields[7] as String?,
      codecTimeBase: fields[8] as String?,
      title: fields[9] as String?,
      extradata: fields[10] as String?,
      videoRange: fields[11] as String?,
      displayTitle: fields[12] as String?,
      displayLanguage: fields[13] as String?,
      nalLengthSize: fields[14] as String?,
      isInterlaced: fields[15] as bool,
      isAVC: fields[16] as bool?,
      channelLayout: fields[17] as String?,
      bitRate: fields[18] as int?,
      bitDepth: fields[19] as int?,
      refFrames: fields[20] as int?,
      packetLength: fields[21] as int?,
      channels: fields[22] as int?,
      sampleRate: fields[23] as int?,
      isDefault: fields[24] as bool,
      isForced: fields[25] as bool,
      height: fields[26] as int?,
      width: fields[27] as int?,
      averageFrameRate: fields[28] as double?,
      realFrameRate: fields[29] as double?,
      profile: fields[30] as String?,
      type: fields[31] as String,
      aspectRatio: fields[32] as String?,
      index: fields[33] as int,
      score: fields[34] as int?,
      isExternal: fields[35] as bool,
      deliveryMethod: fields[36] as String?,
      deliveryUrl: fields[37] as String?,
      isExternalUrl: fields[38] as bool?,
      isTextSubtitleStream: fields[39] as bool,
      supportsExternalStream: fields[40] as bool,
      path: fields[41] as String?,
      pixelFormat: fields[42] as String?,
      level: fields[43] as double?,
      isAnamorphic: fields[44] as bool?,
    )
      ..colorRange = fields[45] as String?
      ..localizedUndefined = fields[46] as String?
      ..localizedDefault = fields[47] as String?
      ..localizedForced = fields[48] as String?;
  }

  @override
  void write(BinaryWriter writer, MediaStream obj) {
    writer
      ..writeByte(49)
      ..writeByte(0)
      ..write(obj.codec)
      ..writeByte(1)
      ..write(obj.codecTag)
      ..writeByte(2)
      ..write(obj.language)
      ..writeByte(3)
      ..write(obj.colorTransfer)
      ..writeByte(4)
      ..write(obj.colorPrimaries)
      ..writeByte(5)
      ..write(obj.colorSpace)
      ..writeByte(6)
      ..write(obj.comment)
      ..writeByte(7)
      ..write(obj.timeBase)
      ..writeByte(8)
      ..write(obj.codecTimeBase)
      ..writeByte(9)
      ..write(obj.title)
      ..writeByte(10)
      ..write(obj.extradata)
      ..writeByte(11)
      ..write(obj.videoRange)
      ..writeByte(12)
      ..write(obj.displayTitle)
      ..writeByte(13)
      ..write(obj.displayLanguage)
      ..writeByte(14)
      ..write(obj.nalLengthSize)
      ..writeByte(15)
      ..write(obj.isInterlaced)
      ..writeByte(16)
      ..write(obj.isAVC)
      ..writeByte(17)
      ..write(obj.channelLayout)
      ..writeByte(18)
      ..write(obj.bitRate)
      ..writeByte(19)
      ..write(obj.bitDepth)
      ..writeByte(20)
      ..write(obj.refFrames)
      ..writeByte(21)
      ..write(obj.packetLength)
      ..writeByte(22)
      ..write(obj.channels)
      ..writeByte(23)
      ..write(obj.sampleRate)
      ..writeByte(24)
      ..write(obj.isDefault)
      ..writeByte(25)
      ..write(obj.isForced)
      ..writeByte(26)
      ..write(obj.height)
      ..writeByte(27)
      ..write(obj.width)
      ..writeByte(28)
      ..write(obj.averageFrameRate)
      ..writeByte(29)
      ..write(obj.realFrameRate)
      ..writeByte(30)
      ..write(obj.profile)
      ..writeByte(31)
      ..write(obj.type)
      ..writeByte(32)
      ..write(obj.aspectRatio)
      ..writeByte(33)
      ..write(obj.index)
      ..writeByte(34)
      ..write(obj.score)
      ..writeByte(35)
      ..write(obj.isExternal)
      ..writeByte(36)
      ..write(obj.deliveryMethod)
      ..writeByte(37)
      ..write(obj.deliveryUrl)
      ..writeByte(38)
      ..write(obj.isExternalUrl)
      ..writeByte(39)
      ..write(obj.isTextSubtitleStream)
      ..writeByte(40)
      ..write(obj.supportsExternalStream)
      ..writeByte(41)
      ..write(obj.path)
      ..writeByte(42)
      ..write(obj.pixelFormat)
      ..writeByte(43)
      ..write(obj.level)
      ..writeByte(44)
      ..write(obj.isAnamorphic)
      ..writeByte(45)
      ..write(obj.colorRange)
      ..writeByte(46)
      ..write(obj.localizedUndefined)
      ..writeByte(47)
      ..write(obj.localizedDefault)
      ..writeByte(48)
      ..write(obj.localizedForced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaStreamAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NameLongIdPairAdapter extends TypeAdapter<NameLongIdPair> {
  @override
  final int typeId = 30;

  @override
  NameLongIdPair read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NameLongIdPair(
      name: fields[0] as String?,
      id: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, NameLongIdPair obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NameLongIdPairAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserItemDataDtoAdapter extends TypeAdapter<UserItemDataDto> {
  @override
  final int typeId = 1;

  @override
  UserItemDataDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserItemDataDto(
      rating: fields[0] as double?,
      playedPercentage: fields[1] as double?,
      unplayedItemCount: fields[2] as int?,
      playbackPositionTicks: fields[3] as int,
      playCount: fields[4] as int,
      isFavorite: fields[5] as bool,
      likes: fields[6] as bool?,
      lastPlayedDate: fields[7] as String?,
      played: fields[8] as bool,
      key: fields[9] as String?,
      itemId: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserItemDataDto obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.rating)
      ..writeByte(1)
      ..write(obj.playedPercentage)
      ..writeByte(2)
      ..write(obj.unplayedItemCount)
      ..writeByte(3)
      ..write(obj.playbackPositionTicks)
      ..writeByte(4)
      ..write(obj.playCount)
      ..writeByte(5)
      ..write(obj.isFavorite)
      ..writeByte(6)
      ..write(obj.likes)
      ..writeByte(7)
      ..write(obj.lastPlayedDate)
      ..writeByte(8)
      ..write(obj.played)
      ..writeByte(9)
      ..write(obj.key)
      ..writeByte(10)
      ..write(obj.itemId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserItemDataDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NameIdPairAdapter extends TypeAdapter<NameIdPair> {
  @override
  final int typeId = 2;

  @override
  NameIdPair read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NameIdPair(
      name: fields[0] as String?,
      id: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, NameIdPair obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NameIdPairAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ImageBlurHashesAdapter extends TypeAdapter<ImageBlurHashes> {
  @override
  final int typeId = 32;

  @override
  ImageBlurHashes read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ImageBlurHashes(
      primary: (fields[0] as Map?)?.cast<String, String>(),
      art: (fields[1] as Map?)?.cast<String, String>(),
      backdrop: (fields[2] as Map?)?.cast<String, String>(),
      banner: (fields[3] as Map?)?.cast<String, String>(),
      logo: (fields[4] as Map?)?.cast<String, String>(),
      thumb: (fields[5] as Map?)?.cast<String, String>(),
      disc: (fields[6] as Map?)?.cast<String, String>(),
      box: (fields[7] as Map?)?.cast<String, String>(),
      screenshot: (fields[8] as Map?)?.cast<String, String>(),
      menu: (fields[9] as Map?)?.cast<String, String>(),
      chapter: (fields[10] as Map?)?.cast<String, String>(),
      boxRear: (fields[11] as Map?)?.cast<String, String>(),
      profile: (fields[12] as Map?)?.cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ImageBlurHashes obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.primary)
      ..writeByte(1)
      ..write(obj.art)
      ..writeByte(2)
      ..write(obj.backdrop)
      ..writeByte(3)
      ..write(obj.banner)
      ..writeByte(4)
      ..write(obj.logo)
      ..writeByte(5)
      ..write(obj.thumb)
      ..writeByte(6)
      ..write(obj.disc)
      ..writeByte(7)
      ..write(obj.box)
      ..writeByte(8)
      ..write(obj.screenshot)
      ..writeByte(9)
      ..write(obj.menu)
      ..writeByte(10)
      ..write(obj.chapter)
      ..writeByte(11)
      ..write(obj.boxRear)
      ..writeByte(12)
      ..write(obj.profile);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageBlurHashesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MediaAttachmentAdapter extends TypeAdapter<MediaAttachment> {
  @override
  final int typeId = 33;

  @override
  MediaAttachment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MediaAttachment(
      codec: fields[0] as String?,
      codecTag: fields[1] as String?,
      comment: fields[2] as String?,
      index: fields[3] as int,
      fileName: fields[4] as String?,
      mimeType: fields[5] as String?,
      deliveryUrl: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MediaAttachment obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.codec)
      ..writeByte(1)
      ..write(obj.codecTag)
      ..writeByte(2)
      ..write(obj.comment)
      ..writeByte(3)
      ..write(obj.index)
      ..writeByte(4)
      ..write(obj.fileName)
      ..writeByte(5)
      ..write(obj.mimeType)
      ..writeByte(6)
      ..write(obj.deliveryUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaAttachmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BaseItemAdapter extends TypeAdapter<BaseItem> {
  @override
  final int typeId = 34;

  @override
  BaseItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BaseItem(
      size: fields[0] as int?,
      container: fields[1] as String?,
      dateLastSaved: fields[2] as String?,
      remoteTrailers: (fields[3] as List?)?.cast<MediaUrl>(),
      isHD: fields[4] as bool,
      isShortcut: fields[5] as bool,
      shortcutPath: fields[6] as String?,
      width: fields[7] as int?,
      height: fields[8] as int?,
      extraIds: (fields[9] as List?)?.cast<String>(),
      supportsExternalTransfer: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, BaseItem obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.size)
      ..writeByte(1)
      ..write(obj.container)
      ..writeByte(2)
      ..write(obj.dateLastSaved)
      ..writeByte(3)
      ..write(obj.remoteTrailers)
      ..writeByte(4)
      ..write(obj.isHD)
      ..writeByte(5)
      ..write(obj.isShortcut)
      ..writeByte(6)
      ..write(obj.shortcutPath)
      ..writeByte(7)
      ..write(obj.width)
      ..writeByte(8)
      ..write(obj.height)
      ..writeByte(9)
      ..write(obj.extraIds)
      ..writeByte(10)
      ..write(obj.supportsExternalTransfer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BaseItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QueueItemAdapter extends TypeAdapter<QueueItem> {
  @override
  final int typeId = 35;

  @override
  QueueItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QueueItem(
      id: fields[0] as String,
      playlistItemId: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, QueueItem obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.playlistItemId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QueueItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDto _$UserDtoFromJson(Map<String, dynamic> json) {
  return UserDto(
    name: json['Name'] as String?,
    serverId: json['ServerId'] as String?,
    serverName: json['ServerName'] as String?,
    connectUserName: json['ConnectUserName'] as String?,
    connectLinkType: json['ConnectLinkType'] as String?,
    id: json['Id'] as String,
    primaryImageTag: json['PrimaryImageTag'] as String?,
    hasPassword: json['HasPassword'] as bool,
    hasConfiguredPassword: json['HasConfiguredPassword'] as bool,
    hasConfiguredEasyPassword: json['HasConfiguredEasyPassword'] as bool,
    enableAutoLogin: json['EnableAutoLogin'] as bool?,
    lastLoginDate: json['LastLoginDate'] as String?,
    lastActivityDate: json['LastActivityDate'] as String?,
    configuration: json['Configuration'] == null
        ? null
        : UserConfiguration.fromJson(
            json['Configuration'] as Map<String, dynamic>),
    policy: json['Policy'] == null
        ? null
        : UserPolicy.fromJson(json['Policy'] as Map<String, dynamic>),
    primaryImageAspectRatio:
        (json['PrimaryImageAspectRatio'] as num?)?.toDouble(),
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
    audioLanguagePreference: json['AudioLanguagePreference'] as String?,
    playDefaultAudioTrack: json['PlayDefaultAudioTrack'] as bool,
    subtitleLanguagePreference: json['SubtitleLanguagePreference'] as String?,
    displayMissingEpisodes: json['DisplayMissingEpisodes'] as bool,
    groupedFolders: (json['GroupedFolders'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    subtitleMode: json['SubtitleMode'] as String,
    displayCollectionsView: json['DisplayCollectionsView'] as bool,
    enableLocalPassword: json['EnableLocalPassword'] as bool,
    orderedViews: (json['OrderedViews'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    latestItemsExcludes: (json['LatestItemsExcludes'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    myMediaExcludes: (json['MyMediaExcludes'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    hidePlayedInLatest: json['HidePlayedInLatest'] as bool,
    rememberAudioSelections: json['RememberAudioSelections'] as bool,
    rememberSubtitleSelections: json['RememberSubtitleSelections'] as bool,
    enableNextEpisodeAutoPlay: json['EnableNextEpisodeAutoPlay'] as bool,
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
    isAdministrator: json['IsAdministrator'] as bool,
    isHidden: json['IsHidden'] as bool,
    isHiddenRemotely: json['IsHiddenRemotely'] as bool?,
    isDisabled: json['IsDisabled'] as bool,
    maxParentalRating: json['MaxParentalRating'] as int?,
    blockedTags: (json['BlockedTags'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    enableUserPreferenceAccess: json['EnableUserPreferenceAccess'] as bool,
    accessSchedules: (json['AccessSchedules'] as List<dynamic>?)
        ?.map((e) => AccessSchedule.fromJson(e as Map<String, dynamic>))
        .toList(),
    blockUnratedItems: (json['BlockUnratedItems'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    enableRemoteControlOfOtherUsers:
        json['EnableRemoteControlOfOtherUsers'] as bool,
    enableSharedDeviceControl: json['EnableSharedDeviceControl'] as bool,
    enableRemoteAccess: json['EnableRemoteAccess'] as bool,
    enableLiveTvManagement: json['EnableLiveTvManagement'] as bool,
    enableLiveTvAccess: json['EnableLiveTvAccess'] as bool,
    enableMediaPlayback: json['EnableMediaPlayback'] as bool,
    enableAudioPlaybackTranscoding:
        json['EnableAudioPlaybackTranscoding'] as bool,
    enableVideoPlaybackTranscoding:
        json['EnableVideoPlaybackTranscoding'] as bool,
    enablePlaybackRemuxing: json['EnablePlaybackRemuxing'] as bool,
    forceRemoteSourceTranscoding: json['ForceRemoteSourceTranscoding'] as bool?,
    enableContentDeletion: json['EnableContentDeletion'] as bool,
    enableContentDeletionFromFolders:
        (json['EnableContentDeletionFromFolders'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
    enableContentDownloading: json['EnableContentDownloading'] as bool,
    enableSubtitleDownloading: json['EnableSubtitleDownloading'] as bool?,
    enableSubtitleManagement: json['EnableSubtitleManagement'] as bool?,
    enableSyncTranscoding: json['EnableSyncTranscoding'] as bool,
    enableMediaConversion: json['EnableMediaConversion'] as bool,
    enabledDevices: (json['EnabledDevices'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    enableAllDevices: json['EnableAllDevices'] as bool,
    enabledChannels: (json['EnabledChannels'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    enableAllChannels: json['EnableAllChannels'] as bool,
    enabledFolders: (json['EnabledFolders'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    enableAllFolders: json['EnableAllFolders'] as bool,
    invalidLoginAttemptCount: json['InvalidLoginAttemptCount'] as int,
    loginAttemptsBeforeLockout: json['LoginAttemptsBeforeLockout'] as int?,
    maxActiveSessions: json['MaxActiveSessions'] as int?,
    enablePublicSharing: json['EnablePublicSharing'] as bool,
    blockedMediaFolders: (json['BlockedMediaFolders'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    blockedChannels: (json['BlockedChannels'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    remoteClientBitrateLimit: json['RemoteClientBitrateLimit'] as int,
    authenticationProviderId: json['AuthenticationProviderId'] as String?,
    passwordResetProviderId: json['PasswordResetProviderId'] as String?,
    syncPlayAccess: json['SyncPlayAccess'] as String,
    excludedSubFolders: (json['ExcludedSubFolders'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    disablePremiumFeatures: json['DisablePremiumFeatures'] as bool?,
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
          instance.accessSchedules?.map((e) => e.toJson()).toList(),
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
      'ForceRemoteSourceTranscoding': instance.forceRemoteSourceTranscoding,
      'LoginAttemptsBeforeLockout': instance.loginAttemptsBeforeLockout,
      'MaxActiveSessions': instance.maxActiveSessions,
      'PasswordResetProviderId': instance.passwordResetProviderId,
      'SyncPlayAccess': instance.syncPlayAccess,
    };

AccessSchedule _$AccessScheduleFromJson(Map<String, dynamic> json) {
  return AccessSchedule(
    id: json['Id'] as int,
    userId: json['UserId'] as String,
    dayOfWeek: json['DayOfWeek'] as String,
    startHour: (json['StartHour'] as num).toDouble(),
    endHour: (json['EndHour'] as num).toDouble(),
  );
}

Map<String, dynamic> _$AccessScheduleToJson(AccessSchedule instance) =>
    <String, dynamic>{
      'DayOfWeek': instance.dayOfWeek,
      'StartHour': instance.startHour,
      'EndHour': instance.endHour,
      'Id': instance.id,
      'UserId': instance.userId,
    };

AuthenticationResult _$AuthenticationResultFromJson(Map<String, dynamic> json) {
  return AuthenticationResult(
    user: json['User'] == null
        ? null
        : UserDto.fromJson(json['User'] as Map<String, dynamic>),
    sessionInfo: json['SessionInfo'] == null
        ? null
        : SessionInfo.fromJson(json['SessionInfo'] as Map<String, dynamic>),
    accessToken: json['AccessToken'] as String?,
    serverId: json['ServerId'] as String?,
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
    playState: json['PlayState'] == null
        ? null
        : PlayerStateInfo.fromJson(json['PlayState'] as Map<String, dynamic>),
    additionalUsers: (json['AdditionalUsers'] as List<dynamic>?)
        ?.map((e) => SessionUserInfo.fromJson(e as Map<String, dynamic>))
        .toList(),
    capabilities: json['Capabilities'] == null
        ? null
        : ClientCapabilities.fromJson(
            json['Capabilities'] as Map<String, dynamic>),
    remoteEndPoint: json['RemoteEndPoint'] as String?,
    playableMediaTypes: (json['PlayableMediaTypes'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    playlistItemId: json['PlaylistItemId'] as String?,
    id: json['Id'] as String?,
    serverId: json['ServerId'] as String?,
    userId: json['UserId'] as String,
    userName: json['UserName'] as String?,
    userPrimaryImageTag: json['UserPrimaryImageTag'] as String?,
    client: json['Client'] as String?,
    lastActivityDate: json['LastActivityDate'] as String,
    deviceName: json['DeviceName'] as String?,
    deviceType: json['DeviceType'] as String?,
    nowPlayingItem: json['NowPlayingItem'] == null
        ? null
        : BaseItemDto.fromJson(json['NowPlayingItem'] as Map<String, dynamic>),
    deviceId: json['DeviceId'] as String?,
    appIconUrl: json['AppIconUrl'] as String?,
    supportedCommands: (json['SupportedCommands'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    transcodingInfo: json['TranscodingInfo'] == null
        ? null
        : TranscodingInfo.fromJson(
            json['TranscodingInfo'] as Map<String, dynamic>),
    supportsRemoteControl: json['SupportsRemoteControl'] as bool,
    lastPlaybackCheckIn: json['LastPlaybackCheckIn'] as String?,
    fullNowPlayingItem: json['FullNowPlayingItem'] == null
        ? null
        : BaseItem.fromJson(json['FullNowPlayingItem'] as Map<String, dynamic>),
    nowViewingItem: json['NowViewingItem'] == null
        ? null
        : BaseItemDto.fromJson(json['NowViewingItem'] as Map<String, dynamic>),
    applicationVersion: json['ApplicationVersion'] as String?,
    isActive: json['IsActive'] as bool,
    supportsMediaControl: json['SupportsMediaControl'] as bool,
    nowPlayingQueue: (json['NowPlayingQueue'] as List<dynamic>?)
        ?.map((e) => QueueItem.fromJson(e as Map<String, dynamic>))
        .toList(),
    hasCustomDeviceName: json['HasCustomDeviceName'] as bool,
  );
}

Map<String, dynamic> _$SessionInfoToJson(SessionInfo instance) =>
    <String, dynamic>{
      'PlayState': instance.playState?.toJson(),
      'AdditionalUsers':
          instance.additionalUsers?.map((e) => e.toJson()).toList(),
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
      'LastPlaybackCheckIn': instance.lastPlaybackCheckIn,
      'FullNowPlayingItem': instance.fullNowPlayingItem?.toJson(),
      'NowViewingItem': instance.nowViewingItem?.toJson(),
      'ApplicationVersion': instance.applicationVersion,
      'IsActive': instance.isActive,
      'SupportsMediaControl': instance.supportsMediaControl,
      'NowPlayingQueue':
          instance.nowPlayingQueue?.map((e) => e.toJson()).toList(),
      'HasCustomDeviceName': instance.hasCustomDeviceName,
    };

TranscodingInfo _$TranscodingInfoFromJson(Map<String, dynamic> json) {
  return TranscodingInfo(
    audioCodec: json['AudioCodec'] as String?,
    videoCodec: json['VideoCodec'] as String?,
    container: json['Container'] as String?,
    isVideoDirect: json['IsVideoDirect'] as bool,
    isAudioDirect: json['IsAudioDirect'] as bool,
    bitrate: json['Bitrate'] as int?,
    framerate: (json['Framerate'] as num?)?.toDouble(),
    completionPercentage: (json['CompletionPercentage'] as num?)?.toDouble(),
    transcodingPositionTicks:
        (json['TranscodingPositionTicks'] as num?)?.toDouble(),
    transcodingStartPositionTicks:
        (json['TranscodingStartPositionTicks'] as num?)?.toDouble(),
    width: json['Width'] as int?,
    height: json['Height'] as int?,
    audioChannels: json['AudioChannels'] as int?,
    transcodeReasons: (json['TranscodeReasons'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    currentCpuUsage: (json['CurrentCpuUsage'] as num?)?.toDouble(),
    averageCpuUsage: (json['AverageCpuUsage'] as num?)?.toDouble(),
    cpuHistory: (json['CpuHistory'] as List<dynamic>?)
        ?.map((e) => (e as Map<String, dynamic>).map(
              (k, e) => MapEntry(k, (e as num).toDouble()),
            ))
        .toList(),
    currentThrottle: json['CurrentThrottle'] as int?,
    videoDecoder: json['VideoDecoder'] as String?,
    videoDecoderIsHardware: json['VideoDecoderIsHardware'] as bool?,
    videoDecoderMediaType: json['VideoDecoderMediaType'] as String?,
    videoDecoderHwAccel: json['VideoDecoderHwAccel'] as String?,
    videoEncoder: json['VideoEncoder'] as String?,
    videoEncoderIsHardware: json['VideoEncoderIsHardware'] as bool?,
    videoEncoderMediaType: json['VideoEncoderMediaType'] as String?,
    videoEncoderHwAccel: json['VideoEncoderHwAccel'] as String?,
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
    positionTicks: json['PositionTicks'] as int?,
    canSeek: json['CanSeek'] as bool,
    isPaused: json['IsPaused'] as bool,
    isMuted: json['IsMuted'] as bool,
    volumeLevel: json['VolumeLevel'] as int?,
    audioStreamIndex: json['AudioStreamIndex'] as int?,
    subtitleStreamIndex: json['SubtitleStreamIndex'] as int?,
    mediaSourceId: json['MediaSourceId'] as String?,
    playMethod: json['PlayMethod'] as String?,
    repeatMode: json['RepeatMode'] as String?,
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
    userId: json['UserId'] as String,
    userName: json['UserName'] as String?,
    userInternalId: json['UserInternalId'] as int?,
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
    playableMediaTypes: (json['PlayableMediaTypes'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    supportedCommands: (json['SupportedCommands'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    supportsMediaControl: json['SupportsMediaControl'] as bool,
    pushToken: json['PushToken'] as String?,
    pushTokenType: json['PushTokenType'] as String?,
    supportsPersistentIdentifier: json['SupportsPersistentIdentifier'] as bool,
    supportsSync: json['SupportsSync'] as bool,
    deviceProfile: json['DeviceProfile'] == null
        ? null
        : DeviceProfile.fromJson(json['DeviceProfile'] as Map<String, dynamic>),
    iconUrl: json['IconUrl'] as String?,
    appId: json['AppId'] as String?,
    supportsContentUploading: json['SupportsContentUploading'] as bool,
    messageCallbackUrl: json['MessageCallbackUrl'] as String?,
    appStoreUrl: json['AppStoreUrl'] as String?,
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
      'SupportsContentUploading': instance.supportsContentUploading,
      'MessageCallbackUrl': instance.messageCallbackUrl,
      'AppStoreUrl': instance.appStoreUrl,
    };

DeviceProfile _$DeviceProfileFromJson(Map<String, dynamic> json) {
  return DeviceProfile(
    name: json['Name'] as String?,
    id: json['Id'] as String?,
    identification: json['Identification'] == null
        ? null
        : DeviceIdentification.fromJson(
            json['Identification'] as Map<String, dynamic>),
    friendlyName: json['FriendlyName'] as String?,
    manufacturer: json['Manufacturer'] as String?,
    manufacturerUrl: json['ManufacturerUrl'] as String?,
    modelName: json['ModelName'] as String?,
    modelDescription: json['ModelDescription'] as String?,
    modelNumber: json['ModelNumber'] as String?,
    modelUrl: json['ModelUrl'] as String?,
    serialNumber: json['SerialNumber'] as String?,
    enableAlbumArtInDidl: json['EnableAlbumArtInDidl'] as bool,
    enableSingleAlbumArtLimit: json['EnableSingleAlbumArtLimit'] as bool,
    enableSingleSubtitleLimit: json['EnableSingleSubtitleLimit'] as bool,
    supportedMediaTypes: json['SupportedMediaTypes'] as String?,
    userId: json['UserId'] as String?,
    albumArtPn: json['AlbumArtPn'] as String?,
    maxAlbumArtWidth: json['MaxAlbumArtWidth'] as int,
    maxAlbumArtHeight: json['MaxAlbumArtHeight'] as int,
    maxIconWidth: json['MaxIconWidth'] as int?,
    maxIconHeight: json['MaxIconHeight'] as int?,
    maxStreamingBitrate: json['MaxStreamingBitrate'] as int?,
    maxStaticBitrate: json['MaxStaticBitrate'] as int?,
    musicStreamingTranscodingBitrate:
        json['MusicStreamingTranscodingBitrate'] as int?,
    maxStaticMusicBitrate: json['MaxStaticMusicBitrate'] as int?,
    sonyAggregationFlags: json['SonyAggregationFlags'] as String?,
    protocolInfo: json['ProtocolInfo'] as String?,
    timelineOffsetSeconds: json['TimelineOffsetSeconds'] as int,
    requiresPlainVideoItems: json['RequiresPlainVideoItems'] as bool,
    requiresPlainFolders: json['RequiresPlainFolders'] as bool,
    enableMSMediaReceiverRegistrar:
        json['EnableMSMediaReceiverRegistrar'] as bool,
    ignoreTranscodeByteRangeRequests:
        json['IgnoreTranscodeByteRangeRequests'] as bool,
    xmlRootAttributes: (json['XmlRootAttributes'] as List<dynamic>?)
        ?.map((e) => XmlAttribute.fromJson(e as Map<String, dynamic>))
        .toList(),
    directPlayProfiles: (json['DirectPlayProfiles'] as List<dynamic>?)
        ?.map((e) => DirectPlayProfile.fromJson(e as Map<String, dynamic>))
        .toList(),
    transcodingProfiles: (json['TranscodingProfiles'] as List<dynamic>?)
        ?.map((e) => TranscodingProfile.fromJson(e as Map<String, dynamic>))
        .toList(),
    containerProfiles: (json['ContainerProfiles'] as List<dynamic>?)
        ?.map((e) => ContainerProfile.fromJson(e as Map<String, dynamic>))
        .toList(),
    codecProfiles: (json['CodecProfiles'] as List<dynamic>?)
        ?.map((e) => CodecProfile.fromJson(e as Map<String, dynamic>))
        .toList(),
    responseProfiles: (json['ResponseProfiles'] as List<dynamic>?)
        ?.map((e) => ResponseProfile.fromJson(e as Map<String, dynamic>))
        .toList(),
    subtitleProfiles: (json['SubtitleProfiles'] as List<dynamic>?)
        ?.map((e) => SubtitleProfile.fromJson(e as Map<String, dynamic>))
        .toList(),
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
          instance.xmlRootAttributes?.map((e) => e.toJson()).toList(),
      'DirectPlayProfiles':
          instance.directPlayProfiles?.map((e) => e.toJson()).toList(),
      'TranscodingProfiles':
          instance.transcodingProfiles?.map((e) => e.toJson()).toList(),
      'ContainerProfiles':
          instance.containerProfiles?.map((e) => e.toJson()).toList(),
      'CodecProfiles': instance.codecProfiles?.map((e) => e.toJson()).toList(),
      'ResponseProfiles':
          instance.responseProfiles?.map((e) => e.toJson()).toList(),
      'SubtitleProfiles':
          instance.subtitleProfiles?.map((e) => e.toJson()).toList(),
    };

DeviceIdentification _$DeviceIdentificationFromJson(Map<String, dynamic> json) {
  return DeviceIdentification(
    friendlyName: json['FriendlyName'] as String?,
    modelNumber: json['ModelNumber'] as String?,
    serialNumber: json['SerialNumber'] as String?,
    modelName: json['ModelName'] as String?,
    modelDescription: json['ModelDescription'] as String?,
    deviceDescription: json['DeviceDescription'] as String?,
    modelUrl: json['ModelUrl'] as String?,
    manufacturer: json['Manufacturer'] as String?,
    manufacturerUrl: json['ManufacturerUrl'] as String?,
    headers: (json['Headers'] as List<dynamic>?)
        ?.map((e) => HttpHeaderInfo.fromJson(e as Map<String, dynamic>))
        .toList(),
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
      'Headers': instance.headers?.map((e) => e.toJson()).toList(),
    };

HttpHeaderInfo _$HttpHeaderInfoFromJson(Map<String, dynamic> json) {
  return HttpHeaderInfo(
    name: json['Name'] as String?,
    value: json['Value'] as String?,
    match: json['Match'] as String,
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
    name: json['Name'] as String?,
    value: json['Value'] as String?,
  );
}

Map<String, dynamic> _$XmlAttributeToJson(XmlAttribute instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'Value': instance.value,
    };

DirectPlayProfile _$DirectPlayProfileFromJson(Map<String, dynamic> json) {
  return DirectPlayProfile(
    container: json['Container'] as String?,
    audioCodec: json['AudioCodec'] as String?,
    videoCodec: json['VideoCodec'] as String?,
    type: json['Type'] as String,
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
    container: json['Container'] as String?,
    type: json['Type'] as String,
    videoCodec: json['VideoCodec'] as String?,
    audioCodec: json['AudioCodec'] as String?,
    protocol: json['Protocol'] as String?,
    estimateContentLength: json['EstimateContentLength'] as bool,
    enableMpegtsM2TsMode: json['EnableMpegtsM2TsMode'] as bool,
    transcodeSeekInfo: json['TranscodeSeekInfo'] as String,
    copyTimestamps: json['CopyTimestamps'] as bool,
    context: json['Context'] as String,
    maxAudioChannels: json['MaxAudioChannels'] as String?,
    minSegments: json['MinSegments'] as int,
    segmentLength: json['SegmentLength'] as int,
    breakOnNonKeyFrames: json['BreakOnNonKeyFrames'] as bool,
    manifestSubtitles: json['ManifestSubtitles'] as String?,
    enableSubtitlesInManifest: json['EnableSubtitlesInManifest'] as bool,
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
      'EnableSubtitlesInManifest': instance.enableSubtitlesInManifest,
    };

ContainerProfile _$ContainerProfileFromJson(Map<String, dynamic> json) {
  return ContainerProfile(
    type: json['Type'] as String,
    conditions: (json['Conditions'] as List<dynamic>?)
        ?.map((e) => ProfileCondition.fromJson(e as Map<String, dynamic>))
        .toList(),
    container: json['Container'] as String?,
  );
}

Map<String, dynamic> _$ContainerProfileToJson(ContainerProfile instance) =>
    <String, dynamic>{
      'Type': instance.type,
      'Conditions': instance.conditions?.map((e) => e.toJson()).toList(),
      'Container': instance.container,
    };

ProfileCondition _$ProfileConditionFromJson(Map<String, dynamic> json) {
  return ProfileCondition(
    condition: json['Condition'] as String,
    property: json['Property'] as String,
    value: json['Value'] as String?,
    isRequired: json['IsRequired'] as bool,
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
    type: json['Type'] as String,
    conditions: (json['Conditions'] as List<dynamic>?)
        ?.map((e) => ProfileCondition.fromJson(e as Map<String, dynamic>))
        .toList(),
    applyConditions: (json['ApplyConditions'] as List<dynamic>?)
        ?.map((e) => ProfileCondition.fromJson(e as Map<String, dynamic>))
        .toList(),
    codec: json['Codec'] as String?,
    container: json['Container'] as String?,
  );
}

Map<String, dynamic> _$CodecProfileToJson(CodecProfile instance) =>
    <String, dynamic>{
      'Type': instance.type,
      'Conditions': instance.conditions?.map((e) => e.toJson()).toList(),
      'ApplyConditions':
          instance.applyConditions?.map((e) => e.toJson()).toList(),
      'Codec': instance.codec,
      'Container': instance.container,
    };

ResponseProfile _$ResponseProfileFromJson(Map<String, dynamic> json) {
  return ResponseProfile(
    container: json['Container'] as String?,
    audioCodec: json['AudioCodec'] as String?,
    videoCodec: json['VideoCodec'] as String?,
    type: json['Type'] as String,
    orgPn: json['OrgPn'] as String?,
    mimeType: json['MimeType'] as String?,
    conditions: (json['Conditions'] as List<dynamic>?)
        ?.map((e) => ProfileCondition.fromJson(e as Map<String, dynamic>))
        .toList(),
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
      'Conditions': instance.conditions?.map((e) => e.toJson()).toList(),
    };

SubtitleProfile _$SubtitleProfileFromJson(Map<String, dynamic> json) {
  return SubtitleProfile(
    format: json['Format'] as String?,
    method: json['Method'] as String,
    didlMode: json['DidlMode'] as String?,
    language: json['Language'] as String?,
    container: json['Container'] as String?,
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
    name: json['Name'] as String?,
    originalTitle: json['OriginalTitle'] as String?,
    serverId: json['ServerId'] as String?,
    id: json['Id'] as String,
    etag: json['Etag'] as String?,
    playlistItemId: json['PlaylistItemId'] as String?,
    dateCreated: json['DateCreated'] as String?,
    extraType: json['ExtraType'] as String?,
    airsBeforeSeasonNumber: json['AirsBeforeSeasonNumber'] as int?,
    airsAfterSeasonNumber: json['AirsAfterSeasonNumber'] as int?,
    airsBeforeEpisodeNumber: json['AirsBeforeEpisodeNumber'] as int?,
    displaySpecialsWithSeasons: json['DisplaySpecialsWithSeasons'] as bool?,
    canDelete: json['CanDelete'] as bool?,
    canDownload: json['CanDownload'] as bool?,
    hasSubtitles: json['HasSubtitles'] as bool?,
    supportsResume: json['SupportsResume'] as bool?,
    preferredMetadataLanguage: json['PreferredMetadataLanguage'] as String?,
    preferredMetadataCountryCode:
        json['PreferredMetadataCountryCode'] as String?,
    supportsSync: json['SupportsSync'] as bool?,
    container: json['Container'] as String?,
    sortName: json['SortName'] as String?,
    forcedSortName: json['ForcedSortName'] as String?,
    video3DFormat: json['Video3DFormat'] as String?,
    premiereDate: json['PremiereDate'] as String?,
    externalUrls: (json['ExternalUrls'] as List<dynamic>?)
        ?.map((e) => ExternalUrl.fromJson(e as Map<String, dynamic>))
        .toList(),
    mediaSources: (json['MediaSources'] as List<dynamic>?)
        ?.map((e) => MediaSourceInfo.fromJson(e as Map<String, dynamic>))
        .toList(),
    criticRating: (json['CriticRating'] as num?)?.toDouble(),
    gameSystemId: json['GameSystemId'] as int?,
    gameSystem: json['GameSystem'] as String?,
    productionLocations: (json['ProductionLocations'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    path: json['Path'] as String?,
    officialRating: json['OfficialRating'] as String?,
    customRating: json['CustomRating'] as String?,
    channelId: json['ChannelId'] as String?,
    channelName: json['ChannelName'] as String?,
    overview: json['Overview'] as String?,
    taglines:
        (json['Taglines'] as List<dynamic>?)?.map((e) => e as String).toList(),
    genres:
        (json['Genres'] as List<dynamic>?)?.map((e) => e as String).toList(),
    communityRating: (json['CommunityRating'] as num?)?.toDouble(),
    runTimeTicks: json['RunTimeTicks'] as int?,
    playAccess: json['PlayAccess'] as String?,
    aspectRatio: json['AspectRatio'] as String?,
    productionYear: json['ProductionYear'] as int?,
    number: json['Number'] as String?,
    channelNumber: json['ChannelNumber'] as String?,
    indexNumber: json['IndexNumber'] as int?,
    indexNumberEnd: json['IndexNumberEnd'] as int?,
    parentIndexNumber: json['ParentIndexNumber'] as int?,
    remoteTrailers: (json['RemoteTrailers'] as List<dynamic>?)
        ?.map((e) => MediaUrl.fromJson(e as Map<String, dynamic>))
        .toList(),
    providerIds: (json['ProviderIds'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
    isFolder: json['IsFolder'] as bool?,
    parentId: json['ParentId'] as String?,
    type: json['Type'] as String?,
    people: (json['People'] as List<dynamic>?)
        ?.map((e) => BaseItemPerson.fromJson(e as Map<String, dynamic>))
        .toList(),
    studios: (json['Studios'] as List<dynamic>?)
        ?.map((e) => NameLongIdPair.fromJson(e as Map<String, dynamic>))
        .toList(),
    genreItems: (json['GenreItems'] as List<dynamic>?)
        ?.map((e) => NameLongIdPair.fromJson(e as Map<String, dynamic>))
        .toList(),
    parentLogoItemId: json['ParentLogoItemId'] as String?,
    parentBackdropItemId: json['ParentBackdropItemId'] as String?,
    parentBackdropImageTags: (json['ParentBackdropImageTags'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    localTrailerCount: json['LocalTrailerCount'] as int?,
    userData: json['UserData'] == null
        ? null
        : UserItemDataDto.fromJson(json['UserData'] as Map<String, dynamic>),
    recursiveItemCount: json['RecursiveItemCount'] as int?,
    childCount: json['ChildCount'] as int?,
    seriesName: json['SeriesName'] as String?,
    seriesId: json['SeriesId'] as String?,
    seasonId: json['SeasonId'] as String?,
    specialFeatureCount: json['SpecialFeatureCount'] as int?,
    displayPreferencesId: json['DisplayPreferencesId'] as String?,
    status: json['Status'] as String?,
    airTime: json['AirTime'] as String?,
    airDays:
        (json['AirDays'] as List<dynamic>?)?.map((e) => e as String).toList(),
    tags: (json['Tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
    primaryImageAspectRatio:
        (json['PrimaryImageAspectRatio'] as num?)?.toDouble(),
    artists:
        (json['Artists'] as List<dynamic>?)?.map((e) => e as String).toList(),
    artistItems: (json['ArtistItems'] as List<dynamic>?)
        ?.map((e) => NameIdPair.fromJson(e as Map<String, dynamic>))
        .toList(),
    album: json['Album'] as String?,
    collectionType: json['CollectionType'] as String?,
    displayOrder: json['DisplayOrder'] as String?,
    albumId: json['AlbumId'] as String?,
    albumPrimaryImageTag: json['AlbumPrimaryImageTag'] as String?,
    seriesPrimaryImageTag: json['SeriesPrimaryImageTag'] as String?,
    albumArtist: json['AlbumArtist'] as String?,
    albumArtists: (json['AlbumArtists'] as List<dynamic>?)
        ?.map((e) => NameIdPair.fromJson(e as Map<String, dynamic>))
        .toList(),
    seasonName: json['SeasonName'] as String?,
    mediaStreams: (json['MediaStreams'] as List<dynamic>?)
        ?.map((e) => MediaStream.fromJson(e as Map<String, dynamic>))
        .toList(),
    partCount: json['PartCount'] as int?,
    imageTags: (json['ImageTags'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
    backdropImageTags: (json['BackdropImageTags'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    parentLogoImageTag: json['ParentLogoImageTag'] as String?,
    parentArtItemId: json['ParentArtItemId'] as String?,
    parentArtImageTag: json['ParentArtImageTag'] as String?,
    seriesThumbImageTag: json['SeriesThumbImageTag'] as String?,
    seriesStudio: json['SeriesStudio'] as String?,
    parentThumbItemId: json['ParentThumbItemId'] as String?,
    parentThumbImageTag: json['ParentThumbImageTag'] as String?,
    parentPrimaryImageItemId: json['ParentPrimaryImageItemId'] as String?,
    parentPrimaryImageTag: json['ParentPrimaryImageTag'] as String?,
    chapters: (json['Chapters'] as List<dynamic>?)
        ?.map((e) => ChapterInfo.fromJson(e as Map<String, dynamic>))
        .toList(),
    locationType: json['LocationType'] as String?,
    mediaType: json['MediaType'] as String?,
    endDate: json['EndDate'] as String?,
    lockedFields: (json['LockedFields'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    lockData: json['LockData'] as bool?,
    width: json['Width'] as int?,
    height: json['Height'] as int?,
    cameraMake: json['CameraMake'] as String?,
    cameraModel: json['CameraModel'] as String?,
    software: json['Software'] as String?,
    exposureTime: (json['ExposureTime'] as num?)?.toDouble(),
    focalLength: (json['FocalLength'] as num?)?.toDouble(),
    imageOrientation: json['ImageOrientation'] as String?,
    aperture: (json['Aperture'] as num?)?.toDouble(),
    shutterSpeed: (json['ShutterSpeed'] as num?)?.toDouble(),
    latitude: (json['Latitude'] as num?)?.toDouble(),
    longitude: (json['Longitude'] as num?)?.toDouble(),
    altitude: (json['Altitude'] as num?)?.toDouble(),
    isoSpeedRating: json['IsoSpeedRating'] as int?,
    seriesTimerId: json['SeriesTimerId'] as String?,
    channelPrimaryImageTag: json['ChannelPrimaryImageTag'] as String?,
    startDate: json['StartDate'] as String?,
    completionPercentage: (json['CompletionPercentage'] as num?)?.toDouble(),
    isRepeat: json['IsRepeat'] as bool?,
    isNew: json['IsNew'] as bool?,
    episodeTitle: json['EpisodeTitle'] as String?,
    isMovie: json['IsMovie'] as bool?,
    isSports: json['IsSports'] as bool?,
    isSeries: json['IsSeries'] as bool?,
    isLive: json['IsLive'] as bool?,
    isNews: json['IsNews'] as bool?,
    isKids: json['IsKids'] as bool?,
    isPremiere: json['IsPremiere'] as bool?,
    timerId: json['TimerId'] as String?,
    currentProgram: json['CurrentProgram'],
    movieCount: json['MovieCount'] as int?,
    seriesCount: json['SeriesCount'] as int?,
    albumCount: json['AlbumCount'] as int?,
    songCount: json['SongCount'] as int?,
    musicVideoCount: json['MusicVideoCount'] as int?,
    sourceType: json['SourceType'] as String?,
    dateLastMediaAdded: json['DateLastMediaAdded'] as String?,
    enableMediaSourceDisplay: json['EnableMediaSourceDisplay'] as bool?,
    cumulativeRunTimeTicks: json['CumulativeRunTimeTicks'] as int?,
    isPlaceHolder: json['IsPlaceHolder'] as bool?,
    isHD: json['IsHD'] as bool?,
    videoType: json['VideoType'] as String?,
    mediaSourceCount: json['MediaSourceCount'] as int?,
    screenshotImageTags: (json['ScreenshotImageTags'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    imageBlurHashes: json['ImageBlurHashes'] == null
        ? null
        : ImageBlurHashes.fromJson(
            json['ImageBlurHashes'] as Map<String, dynamic>),
    isoType: json['IsoType'] as String?,
    trailerCount: json['TrailerCount'] as int?,
    programCount: json['ProgramCount'] as int?,
    episodeCount: json['EpisodeCount'] as int?,
    artistCount: json['ArtistCount'] as int?,
    programId: json['ProgramId'] as String?,
    channelType: json['ChannelType'] as String?,
    audio: json['Audio'] as String?,
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
      'ExternalUrls': instance.externalUrls?.map((e) => e.toJson()).toList(),
      'MediaSources': instance.mediaSources?.map((e) => e.toJson()).toList(),
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
          instance.remoteTrailers?.map((e) => e.toJson()).toList(),
      'ProviderIds': instance.providerIds,
      'IsFolder': instance.isFolder,
      'ParentId': instance.parentId,
      'Type': instance.type,
      'People': instance.people?.map((e) => e.toJson()).toList(),
      'Studios': instance.studios?.map((e) => e.toJson()).toList(),
      'GenreItems': instance.genreItems?.map((e) => e.toJson()).toList(),
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
      'ArtistItems': instance.artistItems?.map((e) => e.toJson()).toList(),
      'Album': instance.album,
      'CollectionType': instance.collectionType,
      'DisplayOrder': instance.displayOrder,
      'AlbumId': instance.albumId,
      'AlbumPrimaryImageTag': instance.albumPrimaryImageTag,
      'SeriesPrimaryImageTag': instance.seriesPrimaryImageTag,
      'AlbumArtist': instance.albumArtist,
      'AlbumArtists': instance.albumArtists?.map((e) => e.toJson()).toList(),
      'SeasonName': instance.seasonName,
      'MediaStreams': instance.mediaStreams?.map((e) => e.toJson()).toList(),
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
      'Chapters': instance.chapters?.map((e) => e.toJson()).toList(),
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
      'SourceType': instance.sourceType,
      'DateLastMediaAdded': instance.dateLastMediaAdded,
      'EnableMediaSourceDisplay': instance.enableMediaSourceDisplay,
      'CumulativeRunTimeTicks': instance.cumulativeRunTimeTicks,
      'IsPlaceHolder': instance.isPlaceHolder,
      'IsHD': instance.isHD,
      'VideoType': instance.videoType,
      'MediaSourceCount': instance.mediaSourceCount,
      'ScreenshotImageTags': instance.screenshotImageTags,
      'ImageBlurHashes': instance.imageBlurHashes?.toJson(),
      'IsoType': instance.isoType,
      'TrailerCount': instance.trailerCount,
      'ProgramCount': instance.programCount,
      'EpisodeCount': instance.episodeCount,
      'ArtistCount': instance.artistCount,
      'ProgramId': instance.programId,
      'ChannelType': instance.channelType,
      'Audio': instance.audio,
    };

ExternalUrl _$ExternalUrlFromJson(Map<String, dynamic> json) {
  return ExternalUrl(
    name: json['Name'] as String?,
    url: json['Url'] as String?,
  );
}

Map<String, dynamic> _$ExternalUrlToJson(ExternalUrl instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'Url': instance.url,
    };

MediaSourceInfo _$MediaSourceInfoFromJson(Map<String, dynamic> json) {
  return MediaSourceInfo(
    protocol: json['Protocol'] as String,
    id: json['Id'] as String?,
    path: json['Path'] as String?,
    encoderPath: json['EncoderPath'] as String?,
    encoderProtocol: json['EncoderProtocol'] as String?,
    type: json['Type'] as String,
    container: json['Container'] as String?,
    size: json['Size'] as int?,
    name: json['Name'] as String?,
    isRemote: json['IsRemote'] as bool,
    runTimeTicks: json['RunTimeTicks'] as int?,
    supportsTranscoding: json['SupportsTranscoding'] as bool,
    supportsDirectStream: json['SupportsDirectStream'] as bool,
    supportsDirectPlay: json['SupportsDirectPlay'] as bool,
    isInfiniteStream: json['IsInfiniteStream'] as bool,
    requiresOpening: json['RequiresOpening'] as bool,
    openToken: json['OpenToken'] as String?,
    requiresClosing: json['RequiresClosing'] as bool,
    liveStreamId: json['LiveStreamId'] as String?,
    bufferMs: json['BufferMs'] as int?,
    requiresLooping: json['RequiresLooping'] as bool,
    supportsProbing: json['SupportsProbing'] as bool,
    video3DFormat: json['Video3DFormat'] as String?,
    mediaStreams: (json['MediaStreams'] as List<dynamic>)
        .map((e) => MediaStream.fromJson(e as Map<String, dynamic>))
        .toList(),
    formats:
        (json['Formats'] as List<dynamic>?)?.map((e) => e as String).toList(),
    bitrate: json['Bitrate'] as int?,
    timestamp: json['Timestamp'] as String?,
    requiredHttpHeaders:
        (json['RequiredHttpHeaders'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
    transcodingUrl: json['TranscodingUrl'] as String?,
    transcodingSubProtocol: json['TranscodingSubProtocol'] as String?,
    transcodingContainer: json['TranscodingContainer'] as String?,
    analyzeDurationMs: json['AnalyzeDurationMs'] as int?,
    readAtNativeFramerate: json['ReadAtNativeFramerate'] as bool,
    defaultAudioStreamIndex: json['DefaultAudioStreamIndex'] as int?,
    defaultSubtitleStreamIndex: json['DefaultSubtitleStreamIndex'] as int?,
    etag: json['Etag'] as String?,
    ignoreDts: json['IgnoreDts'] as bool,
    ignoreIndex: json['IgnoreIndex'] as bool,
    genPtsInput: json['GenPtsInput'] as bool,
    videoType: json['VideoType'] as String?,
    isoType: json['IsoType'] as String?,
    mediaAttachments: (json['MediaAttachments'] as List<dynamic>?)
        ?.map((e) => MediaAttachment.fromJson(e as Map<String, dynamic>))
        .toList(),
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
      'MediaStreams': instance.mediaStreams.map((e) => e.toJson()).toList(),
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
      'Etag': instance.etag,
      'IgnoreDts': instance.ignoreDts,
      'IgnoreIndex': instance.ignoreIndex,
      'GenPtsInput': instance.genPtsInput,
      'VideoType': instance.videoType,
      'IsoType': instance.isoType,
      'MediaAttachments':
          instance.mediaAttachments?.map((e) => e.toJson()).toList(),
    };

MediaStream _$MediaStreamFromJson(Map<String, dynamic> json) {
  return MediaStream(
    codec: json['Codec'] as String?,
    codecTag: json['CodecTag'] as String?,
    language: json['Language'] as String?,
    colorTransfer: json['ColorTransfer'] as String?,
    colorPrimaries: json['ColorPrimaries'] as String?,
    colorSpace: json['ColorSpace'] as String?,
    comment: json['Comment'] as String?,
    timeBase: json['TimeBase'] as String?,
    codecTimeBase: json['CodecTimeBase'] as String?,
    title: json['Title'] as String?,
    extradata: json['Extradata'] as String?,
    videoRange: json['VideoRange'] as String?,
    displayTitle: json['DisplayTitle'] as String?,
    displayLanguage: json['DisplayLanguage'] as String?,
    nalLengthSize: json['NalLengthSize'] as String?,
    isInterlaced: json['IsInterlaced'] as bool,
    isAVC: json['IsAVC'] as bool?,
    channelLayout: json['ChannelLayout'] as String?,
    bitRate: json['BitRate'] as int?,
    bitDepth: json['BitDepth'] as int?,
    refFrames: json['RefFrames'] as int?,
    packetLength: json['PacketLength'] as int?,
    channels: json['Channels'] as int?,
    sampleRate: json['SampleRate'] as int?,
    isDefault: json['IsDefault'] as bool,
    isForced: json['IsForced'] as bool,
    height: json['Height'] as int?,
    width: json['Width'] as int?,
    averageFrameRate: (json['AverageFrameRate'] as num?)?.toDouble(),
    realFrameRate: (json['RealFrameRate'] as num?)?.toDouble(),
    profile: json['Profile'] as String?,
    type: json['Type'] as String,
    aspectRatio: json['AspectRatio'] as String?,
    index: json['Index'] as int,
    score: json['Score'] as int?,
    isExternal: json['IsExternal'] as bool,
    deliveryMethod: json['DeliveryMethod'] as String?,
    deliveryUrl: json['DeliveryUrl'] as String?,
    isExternalUrl: json['IsExternalUrl'] as bool?,
    isTextSubtitleStream: json['IsTextSubtitleStream'] as bool,
    supportsExternalStream: json['SupportsExternalStream'] as bool,
    path: json['Path'] as String?,
    pixelFormat: json['PixelFormat'] as String?,
    level: (json['Level'] as num?)?.toDouble(),
    isAnamorphic: json['IsAnamorphic'] as bool?,
  )
    ..colorRange = json['ColorRange'] as String?
    ..localizedUndefined = json['LocalizedUndefined'] as String?
    ..localizedDefault = json['LocalizedDefault'] as String?
    ..localizedForced = json['LocalizedForced'] as String?;
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
      'ColorRange': instance.colorRange,
      'LocalizedUndefined': instance.localizedUndefined,
      'LocalizedDefault': instance.localizedDefault,
      'LocalizedForced': instance.localizedForced,
    };

MediaUrl _$MediaUrlFromJson(Map<String, dynamic> json) {
  return MediaUrl(
    url: json['Url'] as String?,
    name: json['Name'] as String?,
  );
}

Map<String, dynamic> _$MediaUrlToJson(MediaUrl instance) => <String, dynamic>{
      'Url': instance.url,
      'Name': instance.name,
    };

BaseItemPerson _$BaseItemPersonFromJson(Map<String, dynamic> json) {
  return BaseItemPerson(
    name: json['Name'] as String?,
    id: json['Id'] as String?,
    role: json['Role'] as String?,
    type: json['Type'] as String?,
    primaryImageTag: json['PrimaryImageTag'] as String?,
  )..imageBlurHashes = json['ImageBlurHashes'] == null
      ? null
      : ImageBlurHashes.fromJson(
          json['ImageBlurHashes'] as Map<String, dynamic>);
}

Map<String, dynamic> _$BaseItemPersonToJson(BaseItemPerson instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'Id': instance.id,
      'Role': instance.role,
      'Type': instance.type,
      'PrimaryImageTag': instance.primaryImageTag,
      'ImageBlurHashes': instance.imageBlurHashes?.toJson(),
    };

NameLongIdPair _$NameLongIdPairFromJson(Map<String, dynamic> json) {
  return NameLongIdPair(
    name: json['Name'] as String?,
    id: json['Id'] as String,
  );
}

Map<String, dynamic> _$NameLongIdPairToJson(NameLongIdPair instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'Id': instance.id,
    };

UserItemDataDto _$UserItemDataDtoFromJson(Map<String, dynamic> json) {
  return UserItemDataDto(
    rating: (json['Rating'] as num?)?.toDouble(),
    playedPercentage: (json['PlayedPercentage'] as num?)?.toDouble(),
    unplayedItemCount: json['UnplayedItemCount'] as int?,
    playbackPositionTicks: json['PlaybackPositionTicks'] as int,
    playCount: json['PlayCount'] as int,
    isFavorite: json['IsFavorite'] as bool,
    likes: json['Likes'] as bool?,
    lastPlayedDate: json['LastPlayedDate'] as String?,
    played: json['Played'] as bool,
    key: json['Key'] as String?,
    itemId: json['ItemId'] as String?,
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
    name: json['Name'] as String?,
    id: json['Id'] as String,
  );
}

Map<String, dynamic> _$NameIdPairToJson(NameIdPair instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'Id': instance.id,
    };

ChapterInfo _$ChapterInfoFromJson(Map<String, dynamic> json) {
  return ChapterInfo(
    startPositionTicks: json['StartPositionTicks'] as int,
    name: json['Name'] as String?,
    imageTag: json['ImageTag'] as String?,
    imagePath: json['ImagePath'] as String?,
    imageDateModified: json['ImageDateModified'] as String,
  );
}

Map<String, dynamic> _$ChapterInfoToJson(ChapterInfo instance) =>
    <String, dynamic>{
      'StartPositionTicks': instance.startPositionTicks,
      'Name': instance.name,
      'ImageTag': instance.imageTag,
      'ImagePath': instance.imagePath,
      'ImageDateModified': instance.imageDateModified,
    };

QueryResult_BaseItemDto _$QueryResult_BaseItemDtoFromJson(
    Map<String, dynamic> json) {
  return QueryResult_BaseItemDto(
    items: (json['Items'] as List<dynamic>?)
        ?.map((e) => BaseItemDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    totalRecordCount: json['TotalRecordCount'] as int,
    startIndex: json['StartIndex'] as int,
  );
}

Map<String, dynamic> _$QueryResult_BaseItemDtoToJson(
        QueryResult_BaseItemDto instance) =>
    <String, dynamic>{
      'Items': instance.items?.map((e) => e.toJson()).toList(),
      'TotalRecordCount': instance.totalRecordCount,
      'StartIndex': instance.startIndex,
    };

PlaybackInfoResponse _$PlaybackInfoResponseFromJson(Map<String, dynamic> json) {
  return PlaybackInfoResponse(
    mediaSources: (json['MediaSources'] as List<dynamic>?)
        ?.map((e) => MediaSourceInfo.fromJson(e as Map<String, dynamic>))
        .toList(),
    playSessionId: json['PlaySessionId'] as String?,
    errorCode: json['ErrorCode'] as String?,
  );
}

Map<String, dynamic> _$PlaybackInfoResponseToJson(
        PlaybackInfoResponse instance) =>
    <String, dynamic>{
      'MediaSources': instance.mediaSources?.map((e) => e.toJson()).toList(),
      'PlaySessionId': instance.playSessionId,
      'ErrorCode': instance.errorCode,
    };

PlaybackProgressInfo _$PlaybackProgressInfoFromJson(Map<String, dynamic> json) {
  return PlaybackProgressInfo(
    canSeek: json['CanSeek'] as bool,
    item: json['Item'] == null
        ? null
        : BaseItemDto.fromJson(json['Item'] as Map<String, dynamic>),
    itemId: json['ItemId'] as String,
    sessionId: json['SessionId'] as String?,
    mediaSourceId: json['MediaSourceId'] as String?,
    audioStreamIndex: json['AudioStreamIndex'] as int?,
    subtitleStreamIndex: json['SubtitleStreamIndex'] as int?,
    isPaused: json['IsPaused'] as bool,
    isMuted: json['IsMuted'] as bool,
    positionTicks: json['PositionTicks'] as int?,
    playbackStartTimeTicks: json['PlaybackStartTimeTicks'] as int?,
    volumeLevel: json['VolumeLevel'] as int?,
    brightness: json['Brightness'] as int?,
    aspectRatio: json['AspectRatio'] as String?,
    playMethod: json['PlayMethod'] as String,
    liveStreamId: json['LiveStreamId'] as String?,
    playSessionId: json['PlaySessionId'] as String?,
    repeatMode: json['RepeatMode'] as String,
    nowPlayingQueue: json['NowPlayingQueue'] as List<dynamic>?,
    playlistItemId: json['PlaylistItemId'] as String?,
  );
}

Map<String, dynamic> _$PlaybackProgressInfoToJson(
        PlaybackProgressInfo instance) =>
    <String, dynamic>{
      'CanSeek': instance.canSeek,
      'Item': instance.item?.toJson(),
      'ItemId': instance.itemId,
      'SessionId': instance.sessionId,
      'MediaSourceId': instance.mediaSourceId,
      'AudioStreamIndex': instance.audioStreamIndex,
      'SubtitleStreamIndex': instance.subtitleStreamIndex,
      'IsPaused': instance.isPaused,
      'IsMuted': instance.isMuted,
      'PositionTicks': instance.positionTicks,
      'PlaybackStartTimeTicks': instance.playbackStartTimeTicks,
      'VolumeLevel': instance.volumeLevel,
      'Brightness': instance.brightness,
      'AspectRatio': instance.aspectRatio,
      'PlayMethod': instance.playMethod,
      'LiveStreamId': instance.liveStreamId,
      'PlaySessionId': instance.playSessionId,
      'RepeatMode': instance.repeatMode,
      'NowPlayingQueue': instance.nowPlayingQueue,
      'PlaylistItemId': instance.playlistItemId,
    };

ImageBlurHashes _$ImageBlurHashesFromJson(Map<String, dynamic> json) {
  return ImageBlurHashes(
    primary: (json['Primary'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
    art: (json['Art'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
    backdrop: (json['Backdrop'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
    banner: (json['Banner'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
    logo: (json['Logo'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
    thumb: (json['Thumb'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
    disc: (json['Disc'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
    box: (json['Box'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
    screenshot: (json['Screenshot'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
    menu: (json['Menu'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
    chapter: (json['Chapter'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
    boxRear: (json['BoxRear'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
    profile: (json['Profile'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
  );
}

Map<String, dynamic> _$ImageBlurHashesToJson(ImageBlurHashes instance) =>
    <String, dynamic>{
      'Primary': instance.primary,
      'Art': instance.art,
      'Backdrop': instance.backdrop,
      'Banner': instance.banner,
      'Logo': instance.logo,
      'Thumb': instance.thumb,
      'Disc': instance.disc,
      'Box': instance.box,
      'Screenshot': instance.screenshot,
      'Menu': instance.menu,
      'Chapter': instance.chapter,
      'BoxRear': instance.boxRear,
      'Profile': instance.profile,
    };

MediaAttachment _$MediaAttachmentFromJson(Map<String, dynamic> json) {
  return MediaAttachment(
    codec: json['Codec'] as String?,
    codecTag: json['CodecTag'] as String?,
    comment: json['Comment'] as String?,
    index: json['Index'] as int,
    fileName: json['FileName'] as String?,
    mimeType: json['MimeType'] as String?,
    deliveryUrl: json['DeliveryUrl'] as String?,
  );
}

Map<String, dynamic> _$MediaAttachmentToJson(MediaAttachment instance) =>
    <String, dynamic>{
      'Codec': instance.codec,
      'CodecTag': instance.codecTag,
      'Comment': instance.comment,
      'Index': instance.index,
      'FileName': instance.fileName,
      'MimeType': instance.mimeType,
      'DeliveryUrl': instance.deliveryUrl,
    };

BaseItem _$BaseItemFromJson(Map<String, dynamic> json) {
  return BaseItem(
    size: json['Size'] as int?,
    container: json['Container'] as String?,
    dateLastSaved: json['DateLastSaved'] as String?,
    remoteTrailers: (json['RemoteTrailers'] as List<dynamic>?)
        ?.map((e) => MediaUrl.fromJson(e as Map<String, dynamic>))
        .toList(),
    isHD: json['IsHD'] as bool,
    isShortcut: json['IsShortcut'] as bool,
    shortcutPath: json['ShortcutPath'] as String?,
    width: json['Width'] as int?,
    height: json['Height'] as int?,
    extraIds:
        (json['ExtraIds'] as List<dynamic>?)?.map((e) => e as String).toList(),
    supportsExternalTransfer: json['SupportsExternalTransfer'] as bool,
  );
}

Map<String, dynamic> _$BaseItemToJson(BaseItem instance) => <String, dynamic>{
      'Size': instance.size,
      'Container': instance.container,
      'DateLastSaved': instance.dateLastSaved,
      'RemoteTrailers':
          instance.remoteTrailers?.map((e) => e.toJson()).toList(),
      'IsHD': instance.isHD,
      'IsShortcut': instance.isShortcut,
      'ShortcutPath': instance.shortcutPath,
      'Width': instance.width,
      'Height': instance.height,
      'ExtraIds': instance.extraIds,
      'SupportsExternalTransfer': instance.supportsExternalTransfer,
    };

QueueItem _$QueueItemFromJson(Map<String, dynamic> json) {
  return QueueItem(
    id: json['Id'] as String,
    playlistItemId: json['PlaylistItemId'] as String?,
  );
}

Map<String, dynamic> _$QueueItemToJson(QueueItem instance) => <String, dynamic>{
      'Id': instance.id,
      'PlaylistItemId': instance.playlistItemId,
    };

NewPlaylist _$NewPlaylistFromJson(Map<String, dynamic> json) {
  return NewPlaylist(
    name: json['Name'] as String?,
    ids: (json['Ids'] as List<dynamic>?)?.map((e) => e as String).toList(),
    userId:
        (json['UserId'] as List<dynamic>?)?.map((e) => e as String).toList(),
    mediaType: json['MediaType'] as String?,
  );
}

Map<String, dynamic> _$NewPlaylistToJson(NewPlaylist instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'Ids': instance.ids,
      'UserId': instance.userId,
      'MediaType': instance.mediaType,
    };

NewPlaylistResponse _$NewPlaylistResponseFromJson(Map<String, dynamic> json) {
  return NewPlaylistResponse(
    id: json['Id'] as String?,
  );
}

Map<String, dynamic> _$NewPlaylistResponseToJson(
        NewPlaylistResponse instance) =>
    <String, dynamic>{
      'Id': instance.id,
    };
