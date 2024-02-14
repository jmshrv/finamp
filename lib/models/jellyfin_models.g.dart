// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jellyfin_models.dart';

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
      id: fields[3] as String,
      primaryImageTag: fields[4] as String?,
      hasPassword: fields[5] as bool,
      hasConfiguredPassword: fields[6] as bool,
      hasConfiguredEasyPassword: fields[7] as bool,
      enableAutoLogin: fields[8] as bool?,
      lastLoginDate: fields[9] as String?,
      lastActivityDate: fields[10] as String?,
      configuration: fields[11] as UserConfiguration?,
      policy: fields[12] as UserPolicy?,
      primaryImageAspectRatio: fields[13] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, UserDto obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.serverId)
      ..writeByte(2)
      ..write(obj.serverName)
      ..writeByte(3)
      ..write(obj.id)
      ..writeByte(4)
      ..write(obj.primaryImageTag)
      ..writeByte(5)
      ..write(obj.hasPassword)
      ..writeByte(6)
      ..write(obj.hasConfiguredPassword)
      ..writeByte(7)
      ..write(obj.hasConfiguredEasyPassword)
      ..writeByte(8)
      ..write(obj.enableAutoLogin)
      ..writeByte(9)
      ..write(obj.lastLoginDate)
      ..writeByte(10)
      ..write(obj.lastActivityDate)
      ..writeByte(11)
      ..write(obj.configuration)
      ..writeByte(12)
      ..write(obj.policy)
      ..writeByte(13)
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
      isDisabled: fields[2] as bool,
      maxParentalRating: fields[3] as int?,
      blockedTags: (fields[4] as List?)?.cast<String>(),
      enableUserPreferenceAccess: fields[5] as bool,
      accessSchedules: (fields[6] as List?)?.cast<AccessSchedule>(),
      blockUnratedItems: (fields[7] as List?)?.cast<String>(),
      enableRemoteControlOfOtherUsers: fields[8] as bool,
      enableSharedDeviceControl: fields[9] as bool,
      enableRemoteAccess: fields[10] as bool,
      enableLiveTvManagement: fields[11] as bool,
      enableLiveTvAccess: fields[12] as bool,
      enableMediaPlayback: fields[13] as bool,
      enableAudioPlaybackTranscoding: fields[14] as bool,
      enableVideoPlaybackTranscoding: fields[15] as bool,
      enablePlaybackRemuxing: fields[16] as bool,
      forceRemoteSourceTranscoding: fields[34] as bool?,
      enableContentDeletion: fields[17] as bool,
      enableContentDeletionFromFolders: (fields[18] as List?)?.cast<String>(),
      enableContentDownloading: fields[19] as bool,
      enableSyncTranscoding: fields[20] as bool,
      enableMediaConversion: fields[21] as bool,
      enabledDevices: (fields[22] as List?)?.cast<String>(),
      enableAllDevices: fields[23] as bool,
      enabledChannels: (fields[24] as List?)?.cast<String>(),
      enableAllChannels: fields[25] as bool,
      enabledFolders: (fields[26] as List?)?.cast<String>(),
      enableAllFolders: fields[27] as bool,
      invalidLoginAttemptCount: fields[28] as int,
      loginAttemptsBeforeLockout: fields[35] as int?,
      maxActiveSessions: fields[36] as int?,
      enablePublicSharing: fields[29] as bool,
      blockedMediaFolders: (fields[30] as List?)?.cast<String>(),
      blockedChannels: (fields[31] as List?)?.cast<String>(),
      remoteClientBitrateLimit: fields[32] as int,
      authenticationProviderId: fields[33] as String?,
      passwordResetProviderId: fields[37] as String?,
      syncPlayAccess: fields[38] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserPolicy obj) {
    writer
      ..writeByte(39)
      ..writeByte(0)
      ..write(obj.isAdministrator)
      ..writeByte(1)
      ..write(obj.isHidden)
      ..writeByte(2)
      ..write(obj.isDisabled)
      ..writeByte(3)
      ..write(obj.maxParentalRating)
      ..writeByte(4)
      ..write(obj.blockedTags)
      ..writeByte(5)
      ..write(obj.enableUserPreferenceAccess)
      ..writeByte(6)
      ..write(obj.accessSchedules)
      ..writeByte(7)
      ..write(obj.blockUnratedItems)
      ..writeByte(8)
      ..write(obj.enableRemoteControlOfOtherUsers)
      ..writeByte(9)
      ..write(obj.enableSharedDeviceControl)
      ..writeByte(10)
      ..write(obj.enableRemoteAccess)
      ..writeByte(11)
      ..write(obj.enableLiveTvManagement)
      ..writeByte(12)
      ..write(obj.enableLiveTvAccess)
      ..writeByte(13)
      ..write(obj.enableMediaPlayback)
      ..writeByte(14)
      ..write(obj.enableAudioPlaybackTranscoding)
      ..writeByte(15)
      ..write(obj.enableVideoPlaybackTranscoding)
      ..writeByte(16)
      ..write(obj.enablePlaybackRemuxing)
      ..writeByte(17)
      ..write(obj.enableContentDeletion)
      ..writeByte(18)
      ..write(obj.enableContentDeletionFromFolders)
      ..writeByte(19)
      ..write(obj.enableContentDownloading)
      ..writeByte(20)
      ..write(obj.enableSyncTranscoding)
      ..writeByte(21)
      ..write(obj.enableMediaConversion)
      ..writeByte(22)
      ..write(obj.enabledDevices)
      ..writeByte(23)
      ..write(obj.enableAllDevices)
      ..writeByte(24)
      ..write(obj.enabledChannels)
      ..writeByte(25)
      ..write(obj.enableAllChannels)
      ..writeByte(26)
      ..write(obj.enabledFolders)
      ..writeByte(27)
      ..write(obj.enableAllFolders)
      ..writeByte(28)
      ..write(obj.invalidLoginAttemptCount)
      ..writeByte(29)
      ..write(obj.enablePublicSharing)
      ..writeByte(30)
      ..write(obj.blockedMediaFolders)
      ..writeByte(31)
      ..write(obj.blockedChannels)
      ..writeByte(32)
      ..write(obj.remoteClientBitrateLimit)
      ..writeByte(33)
      ..write(obj.authenticationProviderId)
      ..writeByte(34)
      ..write(obj.forceRemoteSourceTranscoding)
      ..writeByte(35)
      ..write(obj.loginAttemptsBeforeLockout)
      ..writeByte(36)
      ..write(obj.maxActiveSessions)
      ..writeByte(37)
      ..write(obj.passwordResetProviderId)
      ..writeByte(38)
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
      supportedCommands: (fields[17] as List?)?.cast<String>(),
      transcodingInfo: fields[18] as TranscodingInfo?,
      supportsRemoteControl: fields[19] as bool,
      lastPlaybackCheckIn: fields[20] as String?,
      fullNowPlayingItem: fields[21] as BaseItem?,
      nowViewingItem: fields[22] as BaseItemDto?,
      applicationVersion: fields[23] as String?,
      isActive: fields[24] as bool,
      supportsMediaControl: fields[25] as bool,
      nowPlayingQueue: (fields[26] as List?)?.cast<QueueItem>(),
      hasCustomDeviceName: fields[27] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SessionInfo obj) {
    writer
      ..writeByte(28)
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
      ..write(obj.supportedCommands)
      ..writeByte(18)
      ..write(obj.transcodingInfo)
      ..writeByte(19)
      ..write(obj.supportsRemoteControl)
      ..writeByte(20)
      ..write(obj.lastPlaybackCheckIn)
      ..writeByte(21)
      ..write(obj.fullNowPlayingItem)
      ..writeByte(22)
      ..write(obj.nowViewingItem)
      ..writeByte(23)
      ..write(obj.applicationVersion)
      ..writeByte(24)
      ..write(obj.isActive)
      ..writeByte(25)
      ..write(obj.supportsMediaControl)
      ..writeByte(26)
      ..write(obj.nowPlayingQueue)
      ..writeByte(27)
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
    );
  }

  @override
  void write(BinaryWriter writer, SessionUserInfo obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.userName);
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
      supportsMediaControl: fields[2] as bool?,
      supportsPersistentIdentifier: fields[3] as bool?,
      supportsSync: fields[4] as bool?,
      deviceProfile: fields[5] as DeviceProfile?,
      iconUrl: fields[6] as String?,
      supportsContentUploading: fields[7] as bool?,
      messageCallbackUrl: fields[8] as String?,
      appStoreUrl: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ClientCapabilities obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.playableMediaTypes)
      ..writeByte(1)
      ..write(obj.supportedCommands)
      ..writeByte(2)
      ..write(obj.supportsMediaControl)
      ..writeByte(3)
      ..write(obj.supportsPersistentIdentifier)
      ..writeByte(4)
      ..write(obj.supportsSync)
      ..writeByte(5)
      ..write(obj.deviceProfile)
      ..writeByte(6)
      ..write(obj.iconUrl)
      ..writeByte(7)
      ..write(obj.supportsContentUploading)
      ..writeByte(8)
      ..write(obj.messageCallbackUrl)
      ..writeByte(9)
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
      modelUrl: fields[5] as String?,
      manufacturer: fields[6] as String?,
      manufacturerUrl: fields[7] as String?,
      headers: (fields[8] as List?)?.cast<HttpHeaderInfo>(),
    );
  }

  @override
  void write(BinaryWriter writer, DeviceIdentification obj) {
    writer
      ..writeByte(9)
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
      ..write(obj.modelUrl)
      ..writeByte(6)
      ..write(obj.manufacturer)
      ..writeByte(7)
      ..write(obj.manufacturerUrl)
      ..writeByte(8)
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
      enableSubtitlesInManifest: fields[14] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TranscodingProfile obj) {
    writer
      ..writeByte(15)
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
      canDelete: fields[11] as bool?,
      canDownload: fields[12] as bool?,
      hasSubtitles: fields[13] as bool?,
      preferredMetadataLanguage: fields[14] as String?,
      preferredMetadataCountryCode: fields[15] as String?,
      supportsSync: fields[16] as bool?,
      container: fields[17] as String?,
      sortName: fields[18] as String?,
      forcedSortName: fields[19] as String?,
      video3DFormat: fields[20] as String?,
      premiereDate: fields[21] as String?,
      externalUrls: (fields[22] as List?)?.cast<ExternalUrl>(),
      mediaSources: (fields[23] as List?)?.cast<MediaSourceInfo>(),
      criticRating: fields[24] as double?,
      productionLocations: (fields[25] as List?)?.cast<String>(),
      path: fields[26] as String?,
      officialRating: fields[27] as String?,
      customRating: fields[28] as String?,
      channelId: fields[29] as String?,
      channelName: fields[30] as String?,
      overview: fields[31] as String?,
      taglines: (fields[32] as List?)?.cast<String>(),
      genres: (fields[33] as List?)?.cast<String>(),
      communityRating: fields[34] as double?,
      runTimeTicks: fields[35] as int?,
      playAccess: fields[36] as String?,
      aspectRatio: fields[37] as String?,
      productionYear: fields[38] as int?,
      number: fields[39] as String?,
      channelNumber: fields[40] as String?,
      indexNumber: fields[41] as int?,
      indexNumberEnd: fields[42] as int?,
      parentIndexNumber: fields[43] as int?,
      remoteTrailers: (fields[44] as List?)?.cast<MediaUrl>(),
      providerIds: (fields[45] as Map?)?.cast<String, dynamic>(),
      isFolder: fields[46] as bool?,
      parentId: fields[47] as String?,
      type: fields[48] as String?,
      people: (fields[49] as List?)?.cast<BaseItemPerson>(),
      studios: (fields[50] as List?)?.cast<NameLongIdPair>(),
      genreItems: (fields[51] as List?)?.cast<NameLongIdPair>(),
      parentLogoItemId: fields[52] as String?,
      parentBackdropItemId: fields[53] as String?,
      parentBackdropImageTags: (fields[54] as List?)?.cast<String>(),
      localTrailerCount: fields[55] as int?,
      userData: fields[56] as UserItemDataDto?,
      recursiveItemCount: fields[57] as int?,
      childCount: fields[58] as int?,
      seriesName: fields[59] as String?,
      seriesId: fields[60] as String?,
      seasonId: fields[61] as String?,
      specialFeatureCount: fields[62] as int?,
      displayPreferencesId: fields[63] as String?,
      status: fields[64] as String?,
      airTime: fields[65] as String?,
      airDays: (fields[66] as List?)?.cast<String>(),
      tags: (fields[67] as List?)?.cast<String>(),
      primaryImageAspectRatio: fields[68] as double?,
      artists: (fields[69] as List?)?.cast<String>(),
      artistItems: (fields[70] as List?)?.cast<NameIdPair>(),
      album: fields[71] as String?,
      collectionType: fields[72] as String?,
      displayOrder: fields[73] as String?,
      albumId: fields[74] as String?,
      albumPrimaryImageTag: fields[75] as String?,
      seriesPrimaryImageTag: fields[76] as String?,
      albumArtist: fields[77] as String?,
      albumArtists: (fields[78] as List?)?.cast<NameIdPair>(),
      seasonName: fields[79] as String?,
      mediaStreams: (fields[80] as List?)?.cast<MediaStream>(),
      partCount: fields[81] as int?,
      imageTags: (fields[82] as Map?)?.cast<dynamic, String>(),
      backdropImageTags: (fields[83] as List?)?.cast<String>(),
      parentLogoImageTag: fields[84] as String?,
      parentArtItemId: fields[85] as String?,
      parentArtImageTag: fields[86] as String?,
      seriesThumbImageTag: fields[87] as String?,
      seriesStudio: fields[88] as String?,
      parentThumbItemId: fields[89] as String?,
      parentThumbImageTag: fields[90] as String?,
      parentPrimaryImageItemId: fields[91] as String?,
      parentPrimaryImageTag: fields[92] as String?,
      chapters: (fields[93] as List?)?.cast<ChapterInfo>(),
      locationType: fields[94] as String?,
      mediaType: fields[95] as String?,
      endDate: fields[96] as String?,
      lockedFields: (fields[97] as List?)?.cast<String>(),
      lockData: fields[98] as bool?,
      width: fields[99] as int?,
      height: fields[100] as int?,
      cameraMake: fields[101] as String?,
      cameraModel: fields[102] as String?,
      software: fields[103] as String?,
      exposureTime: fields[104] as double?,
      focalLength: fields[105] as double?,
      imageOrientation: fields[106] as String?,
      aperture: fields[107] as double?,
      shutterSpeed: fields[108] as double?,
      latitude: fields[109] as double?,
      longitude: fields[110] as double?,
      altitude: fields[111] as double?,
      isoSpeedRating: fields[112] as int?,
      seriesTimerId: fields[113] as String?,
      channelPrimaryImageTag: fields[114] as String?,
      startDate: fields[115] as String?,
      completionPercentage: fields[116] as double?,
      isRepeat: fields[117] as bool?,
      episodeTitle: fields[118] as String?,
      isMovie: fields[119] as bool?,
      isSports: fields[120] as bool?,
      isSeries: fields[121] as bool?,
      isLive: fields[122] as bool?,
      isNews: fields[123] as bool?,
      isKids: fields[124] as bool?,
      isPremiere: fields[125] as bool?,
      timerId: fields[126] as String?,
      currentProgram: fields[127] as dynamic,
      movieCount: fields[128] as int?,
      seriesCount: fields[129] as int?,
      albumCount: fields[130] as int?,
      songCount: fields[131] as int?,
      musicVideoCount: fields[132] as int?,
      sourceType: fields[133] as String?,
      dateLastMediaAdded: fields[134] as String?,
      enableMediaSourceDisplay: fields[135] as bool?,
      cumulativeRunTimeTicks: fields[136] as int?,
      isPlaceHolder: fields[137] as bool?,
      isHD: fields[138] as bool?,
      videoType: fields[139] as String?,
      mediaSourceCount: fields[140] as int?,
      screenshotImageTags: (fields[141] as List?)?.cast<String>(),
      imageBlurHashes: fields[142] as ImageBlurHashes?,
      isoType: fields[143] as String?,
      trailerCount: fields[144] as int?,
      programCount: fields[145] as int?,
      episodeCount: fields[146] as int?,
      artistCount: fields[147] as int?,
      programId: fields[148] as String?,
      channelType: fields[149] as String?,
      audio: fields[150] as String?,
      lufs: fields[151] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, BaseItemDto obj) {
    writer
      ..writeByte(152)
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
      ..write(obj.canDelete)
      ..writeByte(12)
      ..write(obj.canDownload)
      ..writeByte(13)
      ..write(obj.hasSubtitles)
      ..writeByte(14)
      ..write(obj.preferredMetadataLanguage)
      ..writeByte(15)
      ..write(obj.preferredMetadataCountryCode)
      ..writeByte(16)
      ..write(obj.supportsSync)
      ..writeByte(17)
      ..write(obj.container)
      ..writeByte(18)
      ..write(obj.sortName)
      ..writeByte(19)
      ..write(obj.forcedSortName)
      ..writeByte(20)
      ..write(obj.video3DFormat)
      ..writeByte(21)
      ..write(obj.premiereDate)
      ..writeByte(22)
      ..write(obj.externalUrls)
      ..writeByte(23)
      ..write(obj.mediaSources)
      ..writeByte(24)
      ..write(obj.criticRating)
      ..writeByte(25)
      ..write(obj.productionLocations)
      ..writeByte(26)
      ..write(obj.path)
      ..writeByte(27)
      ..write(obj.officialRating)
      ..writeByte(28)
      ..write(obj.customRating)
      ..writeByte(29)
      ..write(obj.channelId)
      ..writeByte(30)
      ..write(obj.channelName)
      ..writeByte(31)
      ..write(obj.overview)
      ..writeByte(32)
      ..write(obj.taglines)
      ..writeByte(33)
      ..write(obj.genres)
      ..writeByte(34)
      ..write(obj.communityRating)
      ..writeByte(35)
      ..write(obj.runTimeTicks)
      ..writeByte(36)
      ..write(obj.playAccess)
      ..writeByte(37)
      ..write(obj.aspectRatio)
      ..writeByte(38)
      ..write(obj.productionYear)
      ..writeByte(39)
      ..write(obj.number)
      ..writeByte(40)
      ..write(obj.channelNumber)
      ..writeByte(41)
      ..write(obj.indexNumber)
      ..writeByte(42)
      ..write(obj.indexNumberEnd)
      ..writeByte(43)
      ..write(obj.parentIndexNumber)
      ..writeByte(44)
      ..write(obj.remoteTrailers)
      ..writeByte(45)
      ..write(obj.providerIds)
      ..writeByte(46)
      ..write(obj.isFolder)
      ..writeByte(47)
      ..write(obj.parentId)
      ..writeByte(48)
      ..write(obj.type)
      ..writeByte(49)
      ..write(obj.people)
      ..writeByte(50)
      ..write(obj.studios)
      ..writeByte(51)
      ..write(obj.genreItems)
      ..writeByte(52)
      ..write(obj.parentLogoItemId)
      ..writeByte(53)
      ..write(obj.parentBackdropItemId)
      ..writeByte(54)
      ..write(obj.parentBackdropImageTags)
      ..writeByte(55)
      ..write(obj.localTrailerCount)
      ..writeByte(56)
      ..write(obj.userData)
      ..writeByte(57)
      ..write(obj.recursiveItemCount)
      ..writeByte(58)
      ..write(obj.childCount)
      ..writeByte(59)
      ..write(obj.seriesName)
      ..writeByte(60)
      ..write(obj.seriesId)
      ..writeByte(61)
      ..write(obj.seasonId)
      ..writeByte(62)
      ..write(obj.specialFeatureCount)
      ..writeByte(63)
      ..write(obj.displayPreferencesId)
      ..writeByte(64)
      ..write(obj.status)
      ..writeByte(65)
      ..write(obj.airTime)
      ..writeByte(66)
      ..write(obj.airDays)
      ..writeByte(67)
      ..write(obj.tags)
      ..writeByte(68)
      ..write(obj.primaryImageAspectRatio)
      ..writeByte(69)
      ..write(obj.artists)
      ..writeByte(70)
      ..write(obj.artistItems)
      ..writeByte(71)
      ..write(obj.album)
      ..writeByte(72)
      ..write(obj.collectionType)
      ..writeByte(73)
      ..write(obj.displayOrder)
      ..writeByte(74)
      ..write(obj.albumId)
      ..writeByte(75)
      ..write(obj.albumPrimaryImageTag)
      ..writeByte(76)
      ..write(obj.seriesPrimaryImageTag)
      ..writeByte(77)
      ..write(obj.albumArtist)
      ..writeByte(78)
      ..write(obj.albumArtists)
      ..writeByte(79)
      ..write(obj.seasonName)
      ..writeByte(80)
      ..write(obj.mediaStreams)
      ..writeByte(81)
      ..write(obj.partCount)
      ..writeByte(82)
      ..write(obj.imageTags)
      ..writeByte(83)
      ..write(obj.backdropImageTags)
      ..writeByte(84)
      ..write(obj.parentLogoImageTag)
      ..writeByte(85)
      ..write(obj.parentArtItemId)
      ..writeByte(86)
      ..write(obj.parentArtImageTag)
      ..writeByte(87)
      ..write(obj.seriesThumbImageTag)
      ..writeByte(88)
      ..write(obj.seriesStudio)
      ..writeByte(89)
      ..write(obj.parentThumbItemId)
      ..writeByte(90)
      ..write(obj.parentThumbImageTag)
      ..writeByte(91)
      ..write(obj.parentPrimaryImageItemId)
      ..writeByte(92)
      ..write(obj.parentPrimaryImageTag)
      ..writeByte(93)
      ..write(obj.chapters)
      ..writeByte(94)
      ..write(obj.locationType)
      ..writeByte(95)
      ..write(obj.mediaType)
      ..writeByte(96)
      ..write(obj.endDate)
      ..writeByte(97)
      ..write(obj.lockedFields)
      ..writeByte(98)
      ..write(obj.lockData)
      ..writeByte(99)
      ..write(obj.width)
      ..writeByte(100)
      ..write(obj.height)
      ..writeByte(101)
      ..write(obj.cameraMake)
      ..writeByte(102)
      ..write(obj.cameraModel)
      ..writeByte(103)
      ..write(obj.software)
      ..writeByte(104)
      ..write(obj.exposureTime)
      ..writeByte(105)
      ..write(obj.focalLength)
      ..writeByte(106)
      ..write(obj.imageOrientation)
      ..writeByte(107)
      ..write(obj.aperture)
      ..writeByte(108)
      ..write(obj.shutterSpeed)
      ..writeByte(109)
      ..write(obj.latitude)
      ..writeByte(110)
      ..write(obj.longitude)
      ..writeByte(111)
      ..write(obj.altitude)
      ..writeByte(112)
      ..write(obj.isoSpeedRating)
      ..writeByte(113)
      ..write(obj.seriesTimerId)
      ..writeByte(114)
      ..write(obj.channelPrimaryImageTag)
      ..writeByte(115)
      ..write(obj.startDate)
      ..writeByte(116)
      ..write(obj.completionPercentage)
      ..writeByte(117)
      ..write(obj.isRepeat)
      ..writeByte(118)
      ..write(obj.episodeTitle)
      ..writeByte(119)
      ..write(obj.isMovie)
      ..writeByte(120)
      ..write(obj.isSports)
      ..writeByte(121)
      ..write(obj.isSeries)
      ..writeByte(122)
      ..write(obj.isLive)
      ..writeByte(123)
      ..write(obj.isNews)
      ..writeByte(124)
      ..write(obj.isKids)
      ..writeByte(125)
      ..write(obj.isPremiere)
      ..writeByte(126)
      ..write(obj.timerId)
      ..writeByte(127)
      ..write(obj.currentProgram)
      ..writeByte(128)
      ..write(obj.movieCount)
      ..writeByte(129)
      ..write(obj.seriesCount)
      ..writeByte(130)
      ..write(obj.albumCount)
      ..writeByte(131)
      ..write(obj.songCount)
      ..writeByte(132)
      ..write(obj.musicVideoCount)
      ..writeByte(133)
      ..write(obj.sourceType)
      ..writeByte(134)
      ..write(obj.dateLastMediaAdded)
      ..writeByte(135)
      ..write(obj.enableMediaSourceDisplay)
      ..writeByte(136)
      ..write(obj.cumulativeRunTimeTicks)
      ..writeByte(137)
      ..write(obj.isPlaceHolder)
      ..writeByte(138)
      ..write(obj.isHD)
      ..writeByte(139)
      ..write(obj.videoType)
      ..writeByte(140)
      ..write(obj.mediaSourceCount)
      ..writeByte(141)
      ..write(obj.screenshotImageTags)
      ..writeByte(142)
      ..write(obj.imageBlurHashes)
      ..writeByte(143)
      ..write(obj.isoType)
      ..writeByte(144)
      ..write(obj.trailerCount)
      ..writeByte(145)
      ..write(obj.programCount)
      ..writeByte(146)
      ..write(obj.episodeCount)
      ..writeByte(147)
      ..write(obj.artistCount)
      ..writeByte(148)
      ..write(obj.programId)
      ..writeByte(149)
      ..write(obj.channelType)
      ..writeByte(150)
      ..write(obj.audio)
      ..writeByte(151)
      ..write(obj.lufs);
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
      videoRange: fields[10] as String?,
      displayTitle: fields[11] as String?,
      nalLengthSize: fields[12] as String?,
      isInterlaced: fields[13] as bool,
      isAVC: fields[14] as bool?,
      channelLayout: fields[15] as String?,
      bitRate: fields[16] as int?,
      bitDepth: fields[17] as int?,
      refFrames: fields[18] as int?,
      packetLength: fields[19] as int?,
      channels: fields[20] as int?,
      sampleRate: fields[21] as int?,
      isDefault: fields[22] as bool,
      isForced: fields[23] as bool,
      height: fields[24] as int?,
      width: fields[25] as int?,
      averageFrameRate: fields[26] as double?,
      realFrameRate: fields[27] as double?,
      profile: fields[28] as String?,
      type: fields[29] as String,
      aspectRatio: fields[30] as String?,
      index: fields[31] as int,
      score: fields[32] as int?,
      isExternal: fields[33] as bool,
      deliveryMethod: fields[34] as String?,
      deliveryUrl: fields[35] as String?,
      isExternalUrl: fields[36] as bool?,
      isTextSubtitleStream: fields[37] as bool,
      supportsExternalStream: fields[38] as bool,
      path: fields[39] as String?,
      pixelFormat: fields[40] as String?,
      level: fields[41] as double?,
      isAnamorphic: fields[42] as bool?,
    )
      ..colorRange = fields[43] as String?
      ..localizedUndefined = fields[44] as String?
      ..localizedDefault = fields[45] as String?
      ..localizedForced = fields[46] as String?;
  }

  @override
  void write(BinaryWriter writer, MediaStream obj) {
    writer
      ..writeByte(47)
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
      ..write(obj.videoRange)
      ..writeByte(11)
      ..write(obj.displayTitle)
      ..writeByte(12)
      ..write(obj.nalLengthSize)
      ..writeByte(13)
      ..write(obj.isInterlaced)
      ..writeByte(14)
      ..write(obj.isAVC)
      ..writeByte(15)
      ..write(obj.channelLayout)
      ..writeByte(16)
      ..write(obj.bitRate)
      ..writeByte(17)
      ..write(obj.bitDepth)
      ..writeByte(18)
      ..write(obj.refFrames)
      ..writeByte(19)
      ..write(obj.packetLength)
      ..writeByte(20)
      ..write(obj.channels)
      ..writeByte(21)
      ..write(obj.sampleRate)
      ..writeByte(22)
      ..write(obj.isDefault)
      ..writeByte(23)
      ..write(obj.isForced)
      ..writeByte(24)
      ..write(obj.height)
      ..writeByte(25)
      ..write(obj.width)
      ..writeByte(26)
      ..write(obj.averageFrameRate)
      ..writeByte(27)
      ..write(obj.realFrameRate)
      ..writeByte(28)
      ..write(obj.profile)
      ..writeByte(29)
      ..write(obj.type)
      ..writeByte(30)
      ..write(obj.aspectRatio)
      ..writeByte(31)
      ..write(obj.index)
      ..writeByte(32)
      ..write(obj.score)
      ..writeByte(33)
      ..write(obj.isExternal)
      ..writeByte(34)
      ..write(obj.deliveryMethod)
      ..writeByte(35)
      ..write(obj.deliveryUrl)
      ..writeByte(36)
      ..write(obj.isExternalUrl)
      ..writeByte(37)
      ..write(obj.isTextSubtitleStream)
      ..writeByte(38)
      ..write(obj.supportsExternalStream)
      ..writeByte(39)
      ..write(obj.path)
      ..writeByte(40)
      ..write(obj.pixelFormat)
      ..writeByte(41)
      ..write(obj.level)
      ..writeByte(42)
      ..write(obj.isAnamorphic)
      ..writeByte(43)
      ..write(obj.colorRange)
      ..writeByte(44)
      ..write(obj.localizedUndefined)
      ..writeByte(45)
      ..write(obj.localizedDefault)
      ..writeByte(46)
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

class PublicSystemInfoResultAdapter
    extends TypeAdapter<PublicSystemInfoResult> {
  @override
  final int typeId = 39;

  @override
  PublicSystemInfoResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PublicSystemInfoResult(
      localAddress: fields[0] as String?,
      serverName: fields[1] as String?,
      version: fields[2] as String?,
      productName: fields[3] as String?,
      operatingSystem: fields[4] as String?,
      id: fields[5] as String?,
      startupWizardCompleted: fields[6] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, PublicSystemInfoResult obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.localAddress)
      ..writeByte(1)
      ..write(obj.serverName)
      ..writeByte(2)
      ..write(obj.version)
      ..writeByte(3)
      ..write(obj.productName)
      ..writeByte(4)
      ..write(obj.operatingSystem)
      ..writeByte(5)
      ..write(obj.id)
      ..writeByte(6)
      ..write(obj.startupWizardCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PublicSystemInfoResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PublicUsersResponseAdapter extends TypeAdapter<PublicUsersResponse> {
  @override
  final int typeId = 41;

  @override
  PublicUsersResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PublicUsersResponse(
      users: (fields[0] as List).cast<UserDto>(),
    );
  }

  @override
  void write(BinaryWriter writer, PublicUsersResponse obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.users);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PublicUsersResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuickConnectStateAdapter extends TypeAdapter<QuickConnectState> {
  @override
  final int typeId = 42;

  @override
  QuickConnectState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuickConnectState(
      authenticated: fields[0] as bool,
      secret: fields[1] as String?,
      code: fields[2] as String?,
      deviceId: fields[3] as String?,
      deviceName: fields[4] as String?,
      appName: fields[5] as String?,
      appVersion: fields[6] as String?,
      dateAdded: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, QuickConnectState obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.authenticated)
      ..writeByte(1)
      ..write(obj.secret)
      ..writeByte(2)
      ..write(obj.code)
      ..writeByte(3)
      ..write(obj.deviceId)
      ..writeByte(4)
      ..write(obj.deviceName)
      ..writeByte(5)
      ..write(obj.appName)
      ..writeByte(6)
      ..write(obj.appVersion)
      ..writeByte(7)
      ..write(obj.dateAdded);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuickConnectStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ClientDiscoveryResponseAdapter
    extends TypeAdapter<ClientDiscoveryResponse> {
  @override
  final int typeId = 43;

  @override
  ClientDiscoveryResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClientDiscoveryResponse(
      address: fields[0] as String?,
      id: fields[1] as String?,
      name: fields[2] as String?,
      endpointAddress: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ClientDiscoveryResponse obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.address)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.endpointAddress);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClientDiscoveryResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SortByAdapter extends TypeAdapter<SortBy> {
  @override
  final int typeId = 37;

  @override
  SortBy read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SortBy.album;
      case 1:
        return SortBy.albumArtist;
      case 2:
        return SortBy.artist;
      case 3:
        return SortBy.budget;
      case 4:
        return SortBy.communityRating;
      case 5:
        return SortBy.criticRating;
      case 6:
        return SortBy.dateCreated;
      case 7:
        return SortBy.datePlayed;
      case 8:
        return SortBy.playCount;
      case 9:
        return SortBy.premiereDate;
      case 10:
        return SortBy.productionYear;
      case 11:
        return SortBy.sortName;
      case 12:
        return SortBy.random;
      case 13:
        return SortBy.revenue;
      case 14:
        return SortBy.runtime;
      default:
        return SortBy.album;
    }
  }

  @override
  void write(BinaryWriter writer, SortBy obj) {
    switch (obj) {
      case SortBy.album:
        writer.writeByte(0);
        break;
      case SortBy.albumArtist:
        writer.writeByte(1);
        break;
      case SortBy.artist:
        writer.writeByte(2);
        break;
      case SortBy.budget:
        writer.writeByte(3);
        break;
      case SortBy.communityRating:
        writer.writeByte(4);
        break;
      case SortBy.criticRating:
        writer.writeByte(5);
        break;
      case SortBy.dateCreated:
        writer.writeByte(6);
        break;
      case SortBy.datePlayed:
        writer.writeByte(7);
        break;
      case SortBy.playCount:
        writer.writeByte(8);
        break;
      case SortBy.premiereDate:
        writer.writeByte(9);
        break;
      case SortBy.productionYear:
        writer.writeByte(10);
        break;
      case SortBy.sortName:
        writer.writeByte(11);
        break;
      case SortBy.random:
        writer.writeByte(12);
        break;
      case SortBy.revenue:
        writer.writeByte(13);
        break;
      case SortBy.runtime:
        writer.writeByte(14);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SortByAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SortOrderAdapter extends TypeAdapter<SortOrder> {
  @override
  final int typeId = 38;

  @override
  SortOrder read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SortOrder.ascending;
      case 1:
        return SortOrder.descending;
      default:
        return SortOrder.ascending;
    }
  }

  @override
  void write(BinaryWriter writer, SortOrder obj) {
    switch (obj) {
      case SortOrder.ascending:
        writer.writeByte(0);
        break;
      case SortOrder.descending:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SortOrderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDto _$UserDtoFromJson(Map json) => UserDto(
      name: json['Name'] as String?,
      serverId: json['ServerId'] as String?,
      serverName: json['ServerName'] as String?,
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
              Map<String, dynamic>.from(json['Configuration'] as Map)),
      policy: json['Policy'] == null
          ? null
          : UserPolicy.fromJson(
              Map<String, dynamic>.from(json['Policy'] as Map)),
      primaryImageAspectRatio:
          (json['PrimaryImageAspectRatio'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$UserDtoToJson(UserDto instance) => <String, dynamic>{
      'Name': instance.name,
      'ServerId': instance.serverId,
      'ServerName': instance.serverName,
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

UserConfiguration _$UserConfigurationFromJson(Map json) => UserConfiguration(
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

UserPolicy _$UserPolicyFromJson(Map json) => UserPolicy(
      isAdministrator: json['IsAdministrator'] as bool,
      isHidden: json['IsHidden'] as bool,
      isDisabled: json['IsDisabled'] as bool,
      maxParentalRating: json['MaxParentalRating'] as int?,
      blockedTags: (json['BlockedTags'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      enableUserPreferenceAccess: json['EnableUserPreferenceAccess'] as bool,
      accessSchedules: (json['AccessSchedules'] as List<dynamic>?)
          ?.map((e) =>
              AccessSchedule.fromJson(Map<String, dynamic>.from(e as Map)))
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
      forceRemoteSourceTranscoding:
          json['ForceRemoteSourceTranscoding'] as bool?,
      enableContentDeletion: json['EnableContentDeletion'] as bool,
      enableContentDeletionFromFolders:
          (json['EnableContentDeletionFromFolders'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      enableContentDownloading: json['EnableContentDownloading'] as bool,
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
    );

Map<String, dynamic> _$UserPolicyToJson(UserPolicy instance) =>
    <String, dynamic>{
      'IsAdministrator': instance.isAdministrator,
      'IsHidden': instance.isHidden,
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
      'ForceRemoteSourceTranscoding': instance.forceRemoteSourceTranscoding,
      'LoginAttemptsBeforeLockout': instance.loginAttemptsBeforeLockout,
      'MaxActiveSessions': instance.maxActiveSessions,
      'PasswordResetProviderId': instance.passwordResetProviderId,
      'SyncPlayAccess': instance.syncPlayAccess,
    };

AccessSchedule _$AccessScheduleFromJson(Map json) => AccessSchedule(
      id: json['Id'] as int,
      userId: json['UserId'] as String,
      dayOfWeek: json['DayOfWeek'] as String,
      startHour: (json['StartHour'] as num).toDouble(),
      endHour: (json['EndHour'] as num).toDouble(),
    );

Map<String, dynamic> _$AccessScheduleToJson(AccessSchedule instance) =>
    <String, dynamic>{
      'DayOfWeek': instance.dayOfWeek,
      'StartHour': instance.startHour,
      'EndHour': instance.endHour,
      'Id': instance.id,
      'UserId': instance.userId,
    };

AuthenticationResult _$AuthenticationResultFromJson(Map json) =>
    AuthenticationResult(
      user: json['User'] == null
          ? null
          : UserDto.fromJson(Map<String, dynamic>.from(json['User'] as Map)),
      sessionInfo: json['SessionInfo'] == null
          ? null
          : SessionInfo.fromJson(
              Map<String, dynamic>.from(json['SessionInfo'] as Map)),
      accessToken: json['AccessToken'] as String?,
      serverId: json['ServerId'] as String?,
    );

Map<String, dynamic> _$AuthenticationResultToJson(
        AuthenticationResult instance) =>
    <String, dynamic>{
      'User': instance.user?.toJson(),
      'SessionInfo': instance.sessionInfo?.toJson(),
      'AccessToken': instance.accessToken,
      'ServerId': instance.serverId,
    };

SessionInfo _$SessionInfoFromJson(Map json) => SessionInfo(
      playState: json['PlayState'] == null
          ? null
          : PlayerStateInfo.fromJson(
              Map<String, dynamic>.from(json['PlayState'] as Map)),
      additionalUsers: (json['AdditionalUsers'] as List<dynamic>?)
          ?.map((e) =>
              SessionUserInfo.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      capabilities: json['Capabilities'] == null
          ? null
          : ClientCapabilities.fromJson(
              Map<String, dynamic>.from(json['Capabilities'] as Map)),
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
          : BaseItemDto.fromJson(
              Map<String, dynamic>.from(json['NowPlayingItem'] as Map)),
      deviceId: json['DeviceId'] as String?,
      supportedCommands: (json['SupportedCommands'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      transcodingInfo: json['TranscodingInfo'] == null
          ? null
          : TranscodingInfo.fromJson(
              Map<String, dynamic>.from(json['TranscodingInfo'] as Map)),
      supportsRemoteControl: json['SupportsRemoteControl'] as bool,
      lastPlaybackCheckIn: json['LastPlaybackCheckIn'] as String?,
      fullNowPlayingItem: json['FullNowPlayingItem'] == null
          ? null
          : BaseItem.fromJson(
              Map<String, dynamic>.from(json['FullNowPlayingItem'] as Map)),
      nowViewingItem: json['NowViewingItem'] == null
          ? null
          : BaseItemDto.fromJson(
              Map<String, dynamic>.from(json['NowViewingItem'] as Map)),
      applicationVersion: json['ApplicationVersion'] as String?,
      isActive: json['IsActive'] as bool,
      supportsMediaControl: json['SupportsMediaControl'] as bool,
      nowPlayingQueue: (json['NowPlayingQueue'] as List<dynamic>?)
          ?.map((e) => QueueItem.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      hasCustomDeviceName: json['HasCustomDeviceName'] as bool,
    );

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

TranscodingInfo _$TranscodingInfoFromJson(Map json) => TranscodingInfo(
      audioCodec: json['AudioCodec'] as String?,
      videoCodec: json['VideoCodec'] as String?,
      container: json['Container'] as String?,
      isVideoDirect: json['IsVideoDirect'] as bool,
      isAudioDirect: json['IsAudioDirect'] as bool,
      bitrate: json['Bitrate'] as int?,
      framerate: (json['Framerate'] as num?)?.toDouble(),
      completionPercentage: (json['CompletionPercentage'] as num?)?.toDouble(),
      width: json['Width'] as int?,
      height: json['Height'] as int?,
      audioChannels: json['AudioChannels'] as int?,
      transcodeReasons: (json['TranscodeReasons'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

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
      'Width': instance.width,
      'Height': instance.height,
      'AudioChannels': instance.audioChannels,
      'TranscodeReasons': instance.transcodeReasons,
    };

PlayerStateInfo _$PlayerStateInfoFromJson(Map json) => PlayerStateInfo(
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

SessionUserInfo _$SessionUserInfoFromJson(Map json) => SessionUserInfo(
      userId: json['UserId'] as String,
      userName: json['UserName'] as String?,
    );

Map<String, dynamic> _$SessionUserInfoToJson(SessionUserInfo instance) =>
    <String, dynamic>{
      'UserId': instance.userId,
      'UserName': instance.userName,
    };

ClientCapabilities _$ClientCapabilitiesFromJson(Map json) => ClientCapabilities(
      playableMediaTypes: (json['PlayableMediaTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      supportedCommands: (json['SupportedCommands'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      supportsMediaControl: json['SupportsMediaControl'] as bool?,
      supportsPersistentIdentifier:
          json['SupportsPersistentIdentifier'] as bool?,
      supportsSync: json['SupportsSync'] as bool?,
      deviceProfile: json['DeviceProfile'] == null
          ? null
          : DeviceProfile.fromJson(
              Map<String, dynamic>.from(json['DeviceProfile'] as Map)),
      iconUrl: json['IconUrl'] as String?,
      supportsContentUploading: json['SupportsContentUploading'] as bool?,
      messageCallbackUrl: json['MessageCallbackUrl'] as String?,
      appStoreUrl: json['AppStoreUrl'] as String?,
    );

Map<String, dynamic> _$ClientCapabilitiesToJson(ClientCapabilities instance) =>
    <String, dynamic>{
      'PlayableMediaTypes': instance.playableMediaTypes,
      'SupportedCommands': instance.supportedCommands,
      'SupportsMediaControl': instance.supportsMediaControl,
      'SupportsPersistentIdentifier': instance.supportsPersistentIdentifier,
      'SupportsSync': instance.supportsSync,
      'DeviceProfile': instance.deviceProfile?.toJson(),
      'IconUrl': instance.iconUrl,
      'SupportsContentUploading': instance.supportsContentUploading,
      'MessageCallbackUrl': instance.messageCallbackUrl,
      'AppStoreUrl': instance.appStoreUrl,
    };

DeviceProfile _$DeviceProfileFromJson(Map json) => DeviceProfile(
      name: json['Name'] as String?,
      id: json['Id'] as String?,
      identification: json['Identification'] == null
          ? null
          : DeviceIdentification.fromJson(
              Map<String, dynamic>.from(json['Identification'] as Map)),
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
          ?.map(
              (e) => XmlAttribute.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      directPlayProfiles: (json['DirectPlayProfiles'] as List<dynamic>?)
          ?.map((e) =>
              DirectPlayProfile.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      transcodingProfiles: (json['TranscodingProfiles'] as List<dynamic>?)
          ?.map((e) =>
              TranscodingProfile.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      containerProfiles: (json['ContainerProfiles'] as List<dynamic>?)
          ?.map((e) =>
              ContainerProfile.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      codecProfiles: (json['CodecProfiles'] as List<dynamic>?)
          ?.map(
              (e) => CodecProfile.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      responseProfiles: (json['ResponseProfiles'] as List<dynamic>?)
          ?.map((e) =>
              ResponseProfile.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      subtitleProfiles: (json['SubtitleProfiles'] as List<dynamic>?)
          ?.map((e) =>
              SubtitleProfile.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

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

DeviceIdentification _$DeviceIdentificationFromJson(Map json) =>
    DeviceIdentification(
      friendlyName: json['FriendlyName'] as String?,
      modelNumber: json['ModelNumber'] as String?,
      serialNumber: json['SerialNumber'] as String?,
      modelName: json['ModelName'] as String?,
      modelDescription: json['ModelDescription'] as String?,
      modelUrl: json['ModelUrl'] as String?,
      manufacturer: json['Manufacturer'] as String?,
      manufacturerUrl: json['ManufacturerUrl'] as String?,
      headers: (json['Headers'] as List<dynamic>?)
          ?.map((e) =>
              HttpHeaderInfo.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$DeviceIdentificationToJson(
        DeviceIdentification instance) =>
    <String, dynamic>{
      'FriendlyName': instance.friendlyName,
      'ModelNumber': instance.modelNumber,
      'SerialNumber': instance.serialNumber,
      'ModelName': instance.modelName,
      'ModelDescription': instance.modelDescription,
      'ModelUrl': instance.modelUrl,
      'Manufacturer': instance.manufacturer,
      'ManufacturerUrl': instance.manufacturerUrl,
      'Headers': instance.headers?.map((e) => e.toJson()).toList(),
    };

HttpHeaderInfo _$HttpHeaderInfoFromJson(Map json) => HttpHeaderInfo(
      name: json['Name'] as String?,
      value: json['Value'] as String?,
      match: json['Match'] as String,
    );

Map<String, dynamic> _$HttpHeaderInfoToJson(HttpHeaderInfo instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'Value': instance.value,
      'Match': instance.match,
    };

XmlAttribute _$XmlAttributeFromJson(Map json) => XmlAttribute(
      name: json['Name'] as String?,
      value: json['Value'] as String?,
    );

Map<String, dynamic> _$XmlAttributeToJson(XmlAttribute instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'Value': instance.value,
    };

DirectPlayProfile _$DirectPlayProfileFromJson(Map json) => DirectPlayProfile(
      container: json['Container'] as String?,
      audioCodec: json['AudioCodec'] as String?,
      videoCodec: json['VideoCodec'] as String?,
      type: json['Type'] as String,
    );

Map<String, dynamic> _$DirectPlayProfileToJson(DirectPlayProfile instance) =>
    <String, dynamic>{
      'Container': instance.container,
      'AudioCodec': instance.audioCodec,
      'VideoCodec': instance.videoCodec,
      'Type': instance.type,
    };

TranscodingProfile _$TranscodingProfileFromJson(Map json) => TranscodingProfile(
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
      enableSubtitlesInManifest: json['EnableSubtitlesInManifest'] as bool,
    );

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
      'EnableSubtitlesInManifest': instance.enableSubtitlesInManifest,
    };

ContainerProfile _$ContainerProfileFromJson(Map json) => ContainerProfile(
      type: json['Type'] as String,
      conditions: (json['Conditions'] as List<dynamic>?)
          ?.map((e) =>
              ProfileCondition.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      container: json['Container'] as String?,
    );

Map<String, dynamic> _$ContainerProfileToJson(ContainerProfile instance) =>
    <String, dynamic>{
      'Type': instance.type,
      'Conditions': instance.conditions?.map((e) => e.toJson()).toList(),
      'Container': instance.container,
    };

ProfileCondition _$ProfileConditionFromJson(Map json) => ProfileCondition(
      condition: json['Condition'] as String,
      property: json['Property'] as String,
      value: json['Value'] as String?,
      isRequired: json['IsRequired'] as bool,
    );

Map<String, dynamic> _$ProfileConditionToJson(ProfileCondition instance) =>
    <String, dynamic>{
      'Condition': instance.condition,
      'Property': instance.property,
      'Value': instance.value,
      'IsRequired': instance.isRequired,
    };

CodecProfile _$CodecProfileFromJson(Map json) => CodecProfile(
      type: json['Type'] as String,
      conditions: (json['Conditions'] as List<dynamic>?)
          ?.map((e) =>
              ProfileCondition.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      applyConditions: (json['ApplyConditions'] as List<dynamic>?)
          ?.map((e) =>
              ProfileCondition.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      codec: json['Codec'] as String?,
      container: json['Container'] as String?,
    );

Map<String, dynamic> _$CodecProfileToJson(CodecProfile instance) =>
    <String, dynamic>{
      'Type': instance.type,
      'Conditions': instance.conditions?.map((e) => e.toJson()).toList(),
      'ApplyConditions':
          instance.applyConditions?.map((e) => e.toJson()).toList(),
      'Codec': instance.codec,
      'Container': instance.container,
    };

ResponseProfile _$ResponseProfileFromJson(Map json) => ResponseProfile(
      container: json['Container'] as String?,
      audioCodec: json['AudioCodec'] as String?,
      videoCodec: json['VideoCodec'] as String?,
      type: json['Type'] as String,
      orgPn: json['OrgPn'] as String?,
      mimeType: json['MimeType'] as String?,
      conditions: (json['Conditions'] as List<dynamic>?)
          ?.map((e) =>
              ProfileCondition.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

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

SubtitleProfile _$SubtitleProfileFromJson(Map json) => SubtitleProfile(
      format: json['Format'] as String?,
      method: json['Method'] as String,
      didlMode: json['DidlMode'] as String?,
      language: json['Language'] as String?,
      container: json['Container'] as String?,
    );

Map<String, dynamic> _$SubtitleProfileToJson(SubtitleProfile instance) =>
    <String, dynamic>{
      'Format': instance.format,
      'Method': instance.method,
      'DidlMode': instance.didlMode,
      'Language': instance.language,
      'Container': instance.container,
    };

BaseItemDto _$BaseItemDtoFromJson(Map json) => BaseItemDto(
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
      canDelete: json['CanDelete'] as bool?,
      canDownload: json['CanDownload'] as bool?,
      hasSubtitles: json['HasSubtitles'] as bool?,
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
          ?.map(
              (e) => ExternalUrl.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      mediaSources: (json['MediaSources'] as List<dynamic>?)
          ?.map((e) =>
              MediaSourceInfo.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      criticRating: (json['CriticRating'] as num?)?.toDouble(),
      productionLocations: (json['ProductionLocations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      path: json['Path'] as String?,
      officialRating: json['OfficialRating'] as String?,
      customRating: json['CustomRating'] as String?,
      channelId: json['ChannelId'] as String?,
      channelName: json['ChannelName'] as String?,
      overview: json['Overview'] as String?,
      taglines: (json['Taglines'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
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
          ?.map((e) => MediaUrl.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      providerIds: (json['ProviderIds'] as Map?)?.map(
        (k, e) => MapEntry(k as String, e),
      ),
      isFolder: json['IsFolder'] as bool?,
      parentId: json['ParentId'] as String?,
      type: json['Type'] as String?,
      people: (json['People'] as List<dynamic>?)
          ?.map((e) =>
              BaseItemPerson.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      studios: (json['Studios'] as List<dynamic>?)
          ?.map((e) =>
              NameLongIdPair.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      genreItems: (json['GenreItems'] as List<dynamic>?)
          ?.map((e) =>
              NameLongIdPair.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      parentLogoItemId: json['ParentLogoItemId'] as String?,
      parentBackdropItemId: json['ParentBackdropItemId'] as String?,
      parentBackdropImageTags:
          (json['ParentBackdropImageTags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      localTrailerCount: json['LocalTrailerCount'] as int?,
      userData: json['UserData'] == null
          ? null
          : UserItemDataDto.fromJson(
              Map<String, dynamic>.from(json['UserData'] as Map)),
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
          ?.map((e) => NameIdPair.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      album: json['Album'] as String?,
      collectionType: json['CollectionType'] as String?,
      displayOrder: json['DisplayOrder'] as String?,
      albumId: json['AlbumId'] as String?,
      albumPrimaryImageTag: json['AlbumPrimaryImageTag'] as String?,
      seriesPrimaryImageTag: json['SeriesPrimaryImageTag'] as String?,
      albumArtist: json['AlbumArtist'] as String?,
      albumArtists: (json['AlbumArtists'] as List<dynamic>?)
          ?.map((e) => NameIdPair.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      seasonName: json['SeasonName'] as String?,
      mediaStreams: (json['MediaStreams'] as List<dynamic>?)
          ?.map(
              (e) => MediaStream.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      partCount: json['PartCount'] as int?,
      imageTags: (json['ImageTags'] as Map?)?.map(
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
          ?.map(
              (e) => ChapterInfo.fromJson(Map<String, dynamic>.from(e as Map)))
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
              Map<String, dynamic>.from(json['ImageBlurHashes'] as Map)),
      isoType: json['IsoType'] as String?,
      trailerCount: json['TrailerCount'] as int?,
      programCount: json['ProgramCount'] as int?,
      episodeCount: json['EpisodeCount'] as int?,
      artistCount: json['ArtistCount'] as int?,
      programId: json['ProgramId'] as String?,
      channelType: json['ChannelType'] as String?,
      audio: json['Audio'] as String?,
      lufs: (json['LUFS'] as num?)?.toDouble(),
    );

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
      'CanDelete': instance.canDelete,
      'CanDownload': instance.canDownload,
      'HasSubtitles': instance.hasSubtitles,
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
      'LUFS': instance.lufs,
    };

ExternalUrl _$ExternalUrlFromJson(Map json) => ExternalUrl(
      name: json['Name'] as String?,
      url: json['Url'] as String?,
    );

Map<String, dynamic> _$ExternalUrlToJson(ExternalUrl instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'Url': instance.url,
    };

MediaSourceInfo _$MediaSourceInfoFromJson(Map json) => MediaSourceInfo(
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
          .map((e) => MediaStream.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      formats:
          (json['Formats'] as List<dynamic>?)?.map((e) => e as String).toList(),
      bitrate: json['Bitrate'] as int?,
      timestamp: json['Timestamp'] as String?,
      requiredHttpHeaders: (json['RequiredHttpHeaders'] as Map?)?.map(
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
          ?.map((e) =>
              MediaAttachment.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

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

MediaStream _$MediaStreamFromJson(Map json) => MediaStream(
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
      videoRange: json['VideoRange'] as String?,
      displayTitle: json['DisplayTitle'] as String?,
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
      'VideoRange': instance.videoRange,
      'DisplayTitle': instance.displayTitle,
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

MediaUrl _$MediaUrlFromJson(Map json) => MediaUrl(
      url: json['Url'] as String?,
      name: json['Name'] as String?,
    );

Map<String, dynamic> _$MediaUrlToJson(MediaUrl instance) => <String, dynamic>{
      'Url': instance.url,
      'Name': instance.name,
    };

BaseItemPerson _$BaseItemPersonFromJson(Map json) => BaseItemPerson(
      name: json['Name'] as String?,
      id: json['Id'] as String?,
      role: json['Role'] as String?,
      type: json['Type'] as String?,
      primaryImageTag: json['PrimaryImageTag'] as String?,
    )..imageBlurHashes = json['ImageBlurHashes'] == null
        ? null
        : ImageBlurHashes.fromJson(
            Map<String, dynamic>.from(json['ImageBlurHashes'] as Map));

Map<String, dynamic> _$BaseItemPersonToJson(BaseItemPerson instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'Id': instance.id,
      'Role': instance.role,
      'Type': instance.type,
      'PrimaryImageTag': instance.primaryImageTag,
      'ImageBlurHashes': instance.imageBlurHashes?.toJson(),
    };

NameLongIdPair _$NameLongIdPairFromJson(Map json) => NameLongIdPair(
      name: json['Name'] as String?,
      id: json['Id'] as String,
    );

Map<String, dynamic> _$NameLongIdPairToJson(NameLongIdPair instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'Id': instance.id,
    };

UserItemDataDto _$UserItemDataDtoFromJson(Map json) => UserItemDataDto(
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

NameIdPair _$NameIdPairFromJson(Map json) => NameIdPair(
      name: json['Name'] as String?,
      id: json['Id'] as String,
    );

Map<String, dynamic> _$NameIdPairToJson(NameIdPair instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'Id': instance.id,
    };

ChapterInfo _$ChapterInfoFromJson(Map json) => ChapterInfo(
      startPositionTicks: json['StartPositionTicks'] as int,
      name: json['Name'] as String?,
      imageTag: json['ImageTag'] as String?,
      imagePath: json['ImagePath'] as String?,
      imageDateModified: json['ImageDateModified'] as String,
    );

Map<String, dynamic> _$ChapterInfoToJson(ChapterInfo instance) =>
    <String, dynamic>{
      'StartPositionTicks': instance.startPositionTicks,
      'Name': instance.name,
      'ImageTag': instance.imageTag,
      'ImagePath': instance.imagePath,
      'ImageDateModified': instance.imageDateModified,
    };

QueryResult_BaseItemDto _$QueryResult_BaseItemDtoFromJson(Map json) =>
    QueryResult_BaseItemDto(
      items: (json['Items'] as List<dynamic>?)
          ?.map(
              (e) => BaseItemDto.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      totalRecordCount: json['TotalRecordCount'] as int,
      startIndex: json['StartIndex'] as int,
    );

Map<String, dynamic> _$QueryResult_BaseItemDtoToJson(
        QueryResult_BaseItemDto instance) =>
    <String, dynamic>{
      'Items': instance.items?.map((e) => e.toJson()).toList(),
      'TotalRecordCount': instance.totalRecordCount,
      'StartIndex': instance.startIndex,
    };

PlaybackInfoResponse _$PlaybackInfoResponseFromJson(Map json) =>
    PlaybackInfoResponse(
      mediaSources: (json['MediaSources'] as List<dynamic>?)
          ?.map((e) =>
              MediaSourceInfo.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      playSessionId: json['PlaySessionId'] as String?,
      errorCode: json['ErrorCode'] as String?,
    );

Map<String, dynamic> _$PlaybackInfoResponseToJson(
        PlaybackInfoResponse instance) =>
    <String, dynamic>{
      'MediaSources': instance.mediaSources?.map((e) => e.toJson()).toList(),
      'PlaySessionId': instance.playSessionId,
      'ErrorCode': instance.errorCode,
    };

PlaybackProgressInfo _$PlaybackProgressInfoFromJson(Map json) =>
    PlaybackProgressInfo(
      canSeek: json['CanSeek'] as bool? ?? true,
      item: json['Item'] == null
          ? null
          : BaseItemDto.fromJson(
              Map<String, dynamic>.from(json['Item'] as Map)),
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
      playMethod: json['PlayMethod'] as String? ?? "DirectPlay",
      liveStreamId: json['LiveStreamId'] as String?,
      playSessionId: json['PlaySessionId'] as String?,
      repeatMode: json['RepeatMode'] as String,
      nowPlayingQueue: (json['NowPlayingQueue'] as List<dynamic>?)
          ?.map((e) => QueueItem.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      playlistItemId: json['PlaylistItemId'] as String?,
    );

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
      'NowPlayingQueue':
          instance.nowPlayingQueue?.map((e) => e.toJson()).toList(),
      'PlaylistItemId': instance.playlistItemId,
    };

ImageBlurHashes _$ImageBlurHashesFromJson(Map json) => ImageBlurHashes(
      primary: (json['Primary'] as Map?)?.map(
        (k, e) => MapEntry(k as String, e as String),
      ),
      art: (json['Art'] as Map?)?.map(
        (k, e) => MapEntry(k as String, e as String),
      ),
      backdrop: (json['Backdrop'] as Map?)?.map(
        (k, e) => MapEntry(k as String, e as String),
      ),
      banner: (json['Banner'] as Map?)?.map(
        (k, e) => MapEntry(k as String, e as String),
      ),
      logo: (json['Logo'] as Map?)?.map(
        (k, e) => MapEntry(k as String, e as String),
      ),
      thumb: (json['Thumb'] as Map?)?.map(
        (k, e) => MapEntry(k as String, e as String),
      ),
      disc: (json['Disc'] as Map?)?.map(
        (k, e) => MapEntry(k as String, e as String),
      ),
      box: (json['Box'] as Map?)?.map(
        (k, e) => MapEntry(k as String, e as String),
      ),
      screenshot: (json['Screenshot'] as Map?)?.map(
        (k, e) => MapEntry(k as String, e as String),
      ),
      menu: (json['Menu'] as Map?)?.map(
        (k, e) => MapEntry(k as String, e as String),
      ),
      chapter: (json['Chapter'] as Map?)?.map(
        (k, e) => MapEntry(k as String, e as String),
      ),
      boxRear: (json['BoxRear'] as Map?)?.map(
        (k, e) => MapEntry(k as String, e as String),
      ),
      profile: (json['Profile'] as Map?)?.map(
        (k, e) => MapEntry(k as String, e as String),
      ),
    );

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

MediaAttachment _$MediaAttachmentFromJson(Map json) => MediaAttachment(
      codec: json['Codec'] as String?,
      codecTag: json['CodecTag'] as String?,
      comment: json['Comment'] as String?,
      index: json['Index'] as int,
      fileName: json['FileName'] as String?,
      mimeType: json['MimeType'] as String?,
      deliveryUrl: json['DeliveryUrl'] as String?,
    );

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

BaseItem _$BaseItemFromJson(Map json) => BaseItem(
      size: json['Size'] as int?,
      container: json['Container'] as String?,
      dateLastSaved: json['DateLastSaved'] as String?,
      remoteTrailers: (json['RemoteTrailers'] as List<dynamic>?)
          ?.map((e) => MediaUrl.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      isHD: json['IsHD'] as bool,
      isShortcut: json['IsShortcut'] as bool,
      shortcutPath: json['ShortcutPath'] as String?,
      width: json['Width'] as int?,
      height: json['Height'] as int?,
      extraIds: (json['ExtraIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      supportsExternalTransfer: json['SupportsExternalTransfer'] as bool,
    );

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

QueueItem _$QueueItemFromJson(Map json) => QueueItem(
      id: json['Id'] as String,
      playlistItemId: json['PlaylistItemId'] as String?,
    );

Map<String, dynamic> _$QueueItemToJson(QueueItem instance) => <String, dynamic>{
      'Id': instance.id,
      'PlaylistItemId': instance.playlistItemId,
    };

NewPlaylist _$NewPlaylistFromJson(Map json) => NewPlaylist(
      name: json['Name'] as String?,
      ids: (json['Ids'] as List<dynamic>).map((e) => e as String).toList(),
      userId: json['UserId'] as String?,
      mediaType: json['MediaType'] as String?,
    );

Map<String, dynamic> _$NewPlaylistToJson(NewPlaylist instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'Ids': instance.ids,
      'UserId': instance.userId,
      'MediaType': instance.mediaType,
    };

NewPlaylistResponse _$NewPlaylistResponseFromJson(Map json) =>
    NewPlaylistResponse(
      id: json['Id'] as String?,
    );

Map<String, dynamic> _$NewPlaylistResponseToJson(
        NewPlaylistResponse instance) =>
    <String, dynamic>{
      'Id': instance.id,
    };

PublicSystemInfoResult _$PublicSystemInfoResultFromJson(Map json) =>
    PublicSystemInfoResult(
      localAddress: json['LocalAddress'] as String?,
      serverName: json['ServerName'] as String?,
      version: json['Version'] as String?,
      productName: json['ProductName'] as String?,
      operatingSystem: json['OperatingSystem'] as String?,
      id: json['Id'] as String?,
      startupWizardCompleted: json['StartupWizardCompleted'] as bool?,
    );

Map<String, dynamic> _$PublicSystemInfoResultToJson(
        PublicSystemInfoResult instance) =>
    <String, dynamic>{
      'LocalAddress': instance.localAddress,
      'ServerName': instance.serverName,
      'Version': instance.version,
      'ProductName': instance.productName,
      'OperatingSystem': instance.operatingSystem,
      'Id': instance.id,
      'StartupWizardCompleted': instance.startupWizardCompleted,
    };

QuickConnectState _$QuickConnectStateFromJson(Map json) => QuickConnectState(
      authenticated: json['Authenticated'] as bool,
      secret: json['Secret'] as String?,
      code: json['Code'] as String?,
      deviceId: json['DeviceId'] as String?,
      deviceName: json['DeviceName'] as String?,
      appName: json['AppName'] as String?,
      appVersion: json['AppVersion'] as String?,
      dateAdded: json['DateAdded'] as String?,
    );

Map<String, dynamic> _$QuickConnectStateToJson(QuickConnectState instance) =>
    <String, dynamic>{
      'Authenticated': instance.authenticated,
      'Secret': instance.secret,
      'Code': instance.code,
      'DeviceId': instance.deviceId,
      'DeviceName': instance.deviceName,
      'AppName': instance.appName,
      'AppVersion': instance.appVersion,
      'DateAdded': instance.dateAdded,
    };

ClientDiscoveryResponse _$ClientDiscoveryResponseFromJson(Map json) =>
    ClientDiscoveryResponse(
      address: json['Address'] as String?,
      id: json['Id'] as String?,
      name: json['Name'] as String?,
      endpointAddress: json['EndpointAddress'] as String?,
    );

Map<String, dynamic> _$ClientDiscoveryResponseToJson(
        ClientDiscoveryResponse instance) =>
    <String, dynamic>{
      'Address': instance.address,
      'Id': instance.id,
      'Name': instance.name,
      'EndpointAddress': instance.endpointAddress,
    };
