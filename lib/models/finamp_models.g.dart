// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finamp_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FinampUserAdapter extends TypeAdapter<FinampUser> {
  @override
  final int typeId = 8;

  @override
  FinampUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FinampUser(
      id: fields[0] as String,
      baseUrl: fields[1] as String,
      accessToken: fields[2] as String,
      serverId: fields[3] as String,
      currentViewId: fields[4] as String?,
      views: (fields[5] as Map).cast<String, BaseItemDto>(),
    );
  }

  @override
  void write(BinaryWriter writer, FinampUser obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.baseUrl)
      ..writeByte(2)
      ..write(obj.accessToken)
      ..writeByte(3)
      ..write(obj.serverId)
      ..writeByte(4)
      ..write(obj.currentViewId)
      ..writeByte(5)
      ..write(obj.views);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinampUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FinampSettingsAdapter extends TypeAdapter<FinampSettings> {
  @override
  final int typeId = 28;

  @override
  FinampSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FinampSettings(
      isOffline: fields[0] as bool,
      shouldTranscode: fields[1] as bool,
      transcodeBitrate: fields[2] as int,
      downloadLocations: (fields[3] as List).cast<DownloadLocation>(),
      androidStopForegroundOnPause: fields[4] as bool,
      showTabs: (fields[5] as Map).cast<TabContentType, bool>(),
      isFavourite: fields[6] as bool,
      sortBy: fields[7] as SortBy,
      sortOrder: fields[8] as SortOrder,
      songShuffleItemCount: fields[9] == null ? 250 : fields[9] as int,
      contentViewType: fields[10] == null
          ? ContentViewType.list
          : fields[10] as ContentViewType,
      contentGridViewCrossAxisCountPortrait:
          fields[11] == null ? 2 : fields[11] as int,
      contentGridViewCrossAxisCountLandscape:
          fields[12] == null ? 3 : fields[12] as int,
      showTextOnGridView: fields[13] == null ? true : fields[13] as bool,
      sleepTimerSeconds: fields[14] == null ? 1800 : fields[14] as int,
      downloadLocationsMap: fields[15] == null
          ? {}
          : (fields[15] as Map).cast<String, DownloadLocation>(),
      showCoverAsPlayerBackground:
          fields[16] == null ? true : fields[16] as bool,
      hideSongArtistsIfSameAsAlbumArtists:
          fields[17] == null ? true : fields[17] as bool,
      bufferDurationSeconds: fields[18] == null ? 50 : fields[18] as int,
      tabSortBy: fields[20] == null
          ? {}
          : (fields[20] as Map).cast<TabContentType, SortBy>(),
      tabSortOrder: fields[21] == null
          ? {}
          : (fields[21] as Map).cast<TabContentType, SortOrder>(),
      tabOrder: fields[22] == null
          ? [
              TabContentType.albums,
              TabContentType.artists,
              TabContentType.playlists,
              TabContentType.genres,
              TabContentType.songs
            ]
          : (fields[22] as List).cast<TabContentType>(),
      hasCompletedBlurhashImageMigration:
          fields[23] == null ? false : fields[23] as bool,
      hasCompletedBlurhashImageMigrationIdFix:
          fields[24] == null ? false : fields[24] as bool,
    )..disableGesture = fields[19] == null ? false : fields[19] as bool;
  }

  @override
  void write(BinaryWriter writer, FinampSettings obj) {
    writer
      ..writeByte(25)
      ..writeByte(0)
      ..write(obj.isOffline)
      ..writeByte(1)
      ..write(obj.shouldTranscode)
      ..writeByte(2)
      ..write(obj.transcodeBitrate)
      ..writeByte(3)
      ..write(obj.downloadLocations)
      ..writeByte(4)
      ..write(obj.androidStopForegroundOnPause)
      ..writeByte(5)
      ..write(obj.showTabs)
      ..writeByte(6)
      ..write(obj.isFavourite)
      ..writeByte(7)
      ..write(obj.sortBy)
      ..writeByte(8)
      ..write(obj.sortOrder)
      ..writeByte(9)
      ..write(obj.songShuffleItemCount)
      ..writeByte(10)
      ..write(obj.contentViewType)
      ..writeByte(11)
      ..write(obj.contentGridViewCrossAxisCountPortrait)
      ..writeByte(12)
      ..write(obj.contentGridViewCrossAxisCountLandscape)
      ..writeByte(13)
      ..write(obj.showTextOnGridView)
      ..writeByte(14)
      ..write(obj.sleepTimerSeconds)
      ..writeByte(15)
      ..write(obj.downloadLocationsMap)
      ..writeByte(16)
      ..write(obj.showCoverAsPlayerBackground)
      ..writeByte(17)
      ..write(obj.hideSongArtistsIfSameAsAlbumArtists)
      ..writeByte(18)
      ..write(obj.bufferDurationSeconds)
      ..writeByte(19)
      ..write(obj.disableGesture)
      ..writeByte(20)
      ..write(obj.tabSortBy)
      ..writeByte(21)
      ..write(obj.tabSortOrder)
      ..writeByte(22)
      ..write(obj.tabOrder)
      ..writeByte(23)
      ..write(obj.hasCompletedBlurhashImageMigration)
      ..writeByte(24)
      ..write(obj.hasCompletedBlurhashImageMigrationIdFix);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinampSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DownloadLocationAdapter extends TypeAdapter<DownloadLocation> {
  @override
  final int typeId = 31;

  @override
  DownloadLocation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloadLocation(
      name: fields[0] as String,
      path: fields[1] as String,
      useHumanReadableNames: fields[2] as bool,
      deletable: fields[3] as bool,
      id: fields[4] == null ? '0' : fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DownloadLocation obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.path)
      ..writeByte(2)
      ..write(obj.useHumanReadableNames)
      ..writeByte(3)
      ..write(obj.deletable)
      ..writeByte(4)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadLocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DownloadedSongAdapter extends TypeAdapter<DownloadedSong> {
  @override
  final int typeId = 3;

  @override
  DownloadedSong read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloadedSong(
      song: fields[0] as BaseItemDto,
      mediaSourceInfo: fields[1] as MediaSourceInfo,
      downloadId: fields[2] as String,
      requiredBy: (fields[3] as List).cast<String>(),
      path: fields[4] as String,
      useHumanReadableNames: fields[5] as bool,
      viewId: fields[6] as String,
      isPathRelative: fields[7] == null ? false : fields[7] as bool,
      downloadLocationId: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DownloadedSong obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.song)
      ..writeByte(1)
      ..write(obj.mediaSourceInfo)
      ..writeByte(2)
      ..write(obj.downloadId)
      ..writeByte(3)
      ..write(obj.requiredBy)
      ..writeByte(4)
      ..write(obj.path)
      ..writeByte(5)
      ..write(obj.useHumanReadableNames)
      ..writeByte(6)
      ..write(obj.viewId)
      ..writeByte(7)
      ..write(obj.isPathRelative)
      ..writeByte(8)
      ..write(obj.downloadLocationId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadedSongAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DownloadedParentAdapter extends TypeAdapter<DownloadedParent> {
  @override
  final int typeId = 4;

  @override
  DownloadedParent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloadedParent(
      item: fields[0] as BaseItemDto,
      downloadedChildren: (fields[1] as Map).cast<String, BaseItemDto>(),
      viewId: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DownloadedParent obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.item)
      ..writeByte(1)
      ..write(obj.downloadedChildren)
      ..writeByte(2)
      ..write(obj.viewId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadedParentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DownloadedImageAdapter extends TypeAdapter<DownloadedImage> {
  @override
  final int typeId = 40;

  @override
  DownloadedImage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloadedImage(
      id: fields[0] as String,
      downloadId: fields[1] as String,
      path: fields[2] as String,
      requiredBy: (fields[3] as List).cast<String>(),
      downloadLocationId: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DownloadedImage obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.downloadId)
      ..writeByte(2)
      ..write(obj.path)
      ..writeByte(3)
      ..write(obj.requiredBy)
      ..writeByte(4)
      ..write(obj.downloadLocationId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadedImageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OfflineListenAdapter extends TypeAdapter<OfflineListen> {
  @override
  final int typeId = 43;

  @override
  OfflineListen read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OfflineListen(
      timestamp: fields[0] as int,
      userId: fields[1] as String,
      itemId: fields[2] as String,
      name: fields[3] as String,
      artist: fields[4] as String?,
      album: fields[5] as String?,
      trackMbid: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OfflineListen obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.timestamp)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.itemId)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.artist)
      ..writeByte(5)
      ..write(obj.album)
      ..writeByte(6)
      ..write(obj.trackMbid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfflineListenAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TabContentTypeAdapter extends TypeAdapter<TabContentType> {
  @override
  final int typeId = 36;

  @override
  TabContentType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TabContentType.albums;
      case 1:
        return TabContentType.artists;
      case 2:
        return TabContentType.playlists;
      case 3:
        return TabContentType.genres;
      case 4:
        return TabContentType.songs;
      default:
        return TabContentType.albums;
    }
  }

  @override
  void write(BinaryWriter writer, TabContentType obj) {
    switch (obj) {
      case TabContentType.albums:
        writer.writeByte(0);
        break;
      case TabContentType.artists:
        writer.writeByte(1);
        break;
      case TabContentType.playlists:
        writer.writeByte(2);
        break;
      case TabContentType.genres:
        writer.writeByte(3);
        break;
      case TabContentType.songs:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TabContentTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ContentViewTypeAdapter extends TypeAdapter<ContentViewType> {
  @override
  final int typeId = 39;

  @override
  ContentViewType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ContentViewType.list;
      case 1:
        return ContentViewType.grid;
      default:
        return ContentViewType.list;
    }
  }

  @override
  void write(BinaryWriter writer, ContentViewType obj) {
    switch (obj) {
      case ContentViewType.list:
        writer.writeByte(0);
        break;
      case ContentViewType.grid:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContentViewTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDownloadedItemCollection on Isar {
  IsarCollection<DownloadedItem> get downloadedItems => this.collection();
}

const DownloadedItemSchema = CollectionSchema(
  name: r'DownloadedItem',
  id: 5247916713646745965,
  properties: {
    r'downloadId': PropertySchema(
      id: 0,
      name: r'downloadId',
      type: IsarType.string,
    ),
    r'downloadLocationId': PropertySchema(
      id: 1,
      name: r'downloadLocationId',
      type: IsarType.string,
    ),
    r'id': PropertySchema(
      id: 2,
      name: r'id',
      type: IsarType.string,
    ),
    r'jsonItem': PropertySchema(
      id: 3,
      name: r'jsonItem',
      type: IsarType.string,
    ),
    r'jsonMediaSource': PropertySchema(
      id: 4,
      name: r'jsonMediaSource',
      type: IsarType.string,
    ),
    r'path': PropertySchema(
      id: 5,
      name: r'path',
      type: IsarType.string,
    ),
    r'state': PropertySchema(
      id: 6,
      name: r'state',
      type: IsarType.byte,
      enumMap: _DownloadedItemstateEnumValueMap,
    ),
    r'type': PropertySchema(
      id: 7,
      name: r'type',
      type: IsarType.byte,
      enumMap: _DownloadedItemtypeEnumValueMap,
    )
  },
  estimateSize: _downloadedItemEstimateSize,
  serialize: _downloadedItemSerialize,
  deserialize: _downloadedItemDeserialize,
  deserializeProp: _downloadedItemDeserializeProp,
  idName: r'isarId',
  indexes: {},
  links: {
    r'requires': LinkSchema(
      id: -8959480073783996389,
      name: r'requires',
      target: r'DownloadedItem',
      single: false,
    ),
    r'requiredBy': LinkSchema(
      id: 7365852555245312816,
      name: r'requiredBy',
      target: r'DownloadedItem',
      single: false,
      linkName: r'requires',
    )
  },
  embeddedSchemas: {},
  getId: _downloadedItemGetId,
  getLinks: _downloadedItemGetLinks,
  attach: _downloadedItemAttach,
  version: '3.1.0+1',
);

int _downloadedItemEstimateSize(
  DownloadedItem object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.downloadId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.downloadLocationId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.id.length * 3;
  {
    final value = object.jsonItem;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.jsonMediaSource;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.path;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _downloadedItemSerialize(
  DownloadedItem object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.downloadId);
  writer.writeString(offsets[1], object.downloadLocationId);
  writer.writeString(offsets[2], object.id);
  writer.writeString(offsets[3], object.jsonItem);
  writer.writeString(offsets[4], object.jsonMediaSource);
  writer.writeString(offsets[5], object.path);
  writer.writeByte(offsets[6], object.state.index);
  writer.writeByte(offsets[7], object.type.index);
}

DownloadedItem _downloadedItemDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DownloadedItem(
    id: reader.readString(offsets[2]),
    isarId: id,
    jsonItem: reader.readStringOrNull(offsets[3]),
    jsonMediaSource: reader.readStringOrNull(offsets[4]),
    type: _DownloadedItemtypeValueEnumMap[reader.readByteOrNull(offsets[7])] ??
        DownloadedItemType.album,
  );
  object.downloadId = reader.readStringOrNull(offsets[0]);
  object.downloadLocationId = reader.readStringOrNull(offsets[1]);
  object.path = reader.readStringOrNull(offsets[5]);
  object.state =
      _DownloadedItemstateValueEnumMap[reader.readByteOrNull(offsets[6])] ??
          DownloadedItemState.notDownloaded;
  return object;
}

P _downloadedItemDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (_DownloadedItemstateValueEnumMap[reader.readByteOrNull(offset)] ??
          DownloadedItemState.notDownloaded) as P;
    case 7:
      return (_DownloadedItemtypeValueEnumMap[reader.readByteOrNull(offset)] ??
          DownloadedItemType.album) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _DownloadedItemstateEnumValueMap = {
  'notDownloaded': 0,
  'downloading': 1,
  'failed': 2,
  'complete': 3,
  'deleting': 4,
};
const _DownloadedItemstateValueEnumMap = {
  0: DownloadedItemState.notDownloaded,
  1: DownloadedItemState.downloading,
  2: DownloadedItemState.failed,
  3: DownloadedItemState.complete,
  4: DownloadedItemState.deleting,
};
const _DownloadedItemtypeEnumValueMap = {
  'album': 0,
  'playlist': 1,
  'song': 2,
  'image': 3,
  'artist': 4,
  'other': 5,
};
const _DownloadedItemtypeValueEnumMap = {
  0: DownloadedItemType.album,
  1: DownloadedItemType.playlist,
  2: DownloadedItemType.song,
  3: DownloadedItemType.image,
  4: DownloadedItemType.artist,
  5: DownloadedItemType.other,
};

Id _downloadedItemGetId(DownloadedItem object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _downloadedItemGetLinks(DownloadedItem object) {
  return [object.requires, object.requiredBy];
}

void _downloadedItemAttach(
    IsarCollection<dynamic> col, Id id, DownloadedItem object) {
  object.requires
      .attach(col, col.isar.collection<DownloadedItem>(), r'requires', id);
  object.requiredBy
      .attach(col, col.isar.collection<DownloadedItem>(), r'requiredBy', id);
}

extension DownloadedItemQueryWhereSort
    on QueryBuilder<DownloadedItem, DownloadedItem, QWhere> {
  QueryBuilder<DownloadedItem, DownloadedItem, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DownloadedItemQueryWhere
    on QueryBuilder<DownloadedItem, DownloadedItem, QWhereClause> {
  QueryBuilder<DownloadedItem, DownloadedItem, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterWhereClause> isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DownloadedItemQueryFilter
    on QueryBuilder<DownloadedItem, DownloadedItem, QFilterCondition> {
  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      downloadIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'downloadId',
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      downloadIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'downloadId',
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      downloadIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'downloadId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      downloadIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'downloadId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      downloadIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'downloadId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      downloadIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'downloadId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      downloadIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'downloadId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      downloadIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'downloadId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      downloadIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'downloadId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      downloadIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'downloadId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      downloadIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'downloadId',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      downloadIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'downloadId',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      downloadLocationIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'downloadLocationId',
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      downloadLocationIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'downloadLocationId',
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      downloadLocationIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'downloadLocationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      downloadLocationIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'downloadLocationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      downloadLocationIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'downloadLocationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      downloadLocationIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'downloadLocationId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      downloadLocationIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'downloadLocationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      downloadLocationIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'downloadLocationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      downloadLocationIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'downloadLocationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      downloadLocationIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'downloadLocationId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      downloadLocationIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'downloadLocationId',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      downloadLocationIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'downloadLocationId',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition> idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      idLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition> idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition> idMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      jsonItemIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'jsonItem',
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      jsonItemIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'jsonItem',
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      jsonItemEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'jsonItem',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      jsonItemGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'jsonItem',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      jsonItemLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'jsonItem',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      jsonItemBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'jsonItem',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      jsonItemStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'jsonItem',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      jsonItemEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'jsonItem',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      jsonItemContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'jsonItem',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      jsonItemMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'jsonItem',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      jsonItemIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'jsonItem',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      jsonItemIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'jsonItem',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      jsonMediaSourceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'jsonMediaSource',
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      jsonMediaSourceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'jsonMediaSource',
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      jsonMediaSourceEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'jsonMediaSource',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      jsonMediaSourceGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'jsonMediaSource',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      jsonMediaSourceLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'jsonMediaSource',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      jsonMediaSourceBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'jsonMediaSource',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      jsonMediaSourceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'jsonMediaSource',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      jsonMediaSourceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'jsonMediaSource',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      jsonMediaSourceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'jsonMediaSource',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      jsonMediaSourceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'jsonMediaSource',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      jsonMediaSourceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'jsonMediaSource',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      jsonMediaSourceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'jsonMediaSource',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      pathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'path',
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      pathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'path',
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      pathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      pathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      pathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      pathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'path',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      pathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      pathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      pathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      pathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'path',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      pathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'path',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      pathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'path',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      stateEqualTo(DownloadedItemState value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'state',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      stateGreaterThan(
    DownloadedItemState value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'state',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      stateLessThan(
    DownloadedItemState value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'state',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      stateBetween(
    DownloadedItemState lower,
    DownloadedItemState upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'state',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      typeEqualTo(DownloadedItemType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      typeGreaterThan(
    DownloadedItemType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      typeLessThan(
    DownloadedItemType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      typeBetween(
    DownloadedItemType lower,
    DownloadedItemType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DownloadedItemQueryObject
    on QueryBuilder<DownloadedItem, DownloadedItem, QFilterCondition> {}

extension DownloadedItemQueryLinks
    on QueryBuilder<DownloadedItem, DownloadedItem, QFilterCondition> {
  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition> requires(
      FilterQuery<DownloadedItem> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'requires');
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      requiresLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'requires', length, true, length, true);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      requiresIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'requires', 0, true, 0, true);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      requiresIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'requires', 0, false, 999999, true);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      requiresLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'requires', 0, true, length, include);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      requiresLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'requires', length, include, 999999, true);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      requiresLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'requires', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      requiredBy(FilterQuery<DownloadedItem> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'requiredBy');
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      requiredByLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'requiredBy', length, true, length, true);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      requiredByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'requiredBy', 0, true, 0, true);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      requiredByIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'requiredBy', 0, false, 999999, true);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      requiredByLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'requiredBy', 0, true, length, include);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      requiredByLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'requiredBy', length, include, 999999, true);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterFilterCondition>
      requiredByLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'requiredBy', lower, includeLower, upper, includeUpper);
    });
  }
}

extension DownloadedItemQuerySortBy
    on QueryBuilder<DownloadedItem, DownloadedItem, QSortBy> {
  QueryBuilder<DownloadedItem, DownloadedItem, QAfterSortBy>
      sortByDownloadId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadId', Sort.asc);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterSortBy>
      sortByDownloadIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadId', Sort.desc);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterSortBy>
      sortByDownloadLocationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadLocationId', Sort.asc);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterSortBy>
      sortByDownloadLocationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadLocationId', Sort.desc);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterSortBy> sortByJsonItem() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jsonItem', Sort.asc);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterSortBy>
      sortByJsonItemDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jsonItem', Sort.desc);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterSortBy>
      sortByJsonMediaSource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jsonMediaSource', Sort.asc);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterSortBy>
      sortByJsonMediaSourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jsonMediaSource', Sort.desc);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterSortBy> sortByPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.asc);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterSortBy> sortByPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.desc);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterSortBy> sortByState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.asc);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterSortBy> sortByStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.desc);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension DownloadedItemQuerySortThenBy
    on QueryBuilder<DownloadedItem, DownloadedItem, QSortThenBy> {
  QueryBuilder<DownloadedItem, DownloadedItem, QAfterSortBy>
      thenByDownloadId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadId', Sort.asc);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterSortBy>
      thenByDownloadIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadId', Sort.desc);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterSortBy>
      thenByDownloadLocationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadLocationId', Sort.asc);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterSortBy>
      thenByDownloadLocationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadLocationId', Sort.desc);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterSortBy> thenByJsonItem() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jsonItem', Sort.asc);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterSortBy>
      thenByJsonItemDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jsonItem', Sort.desc);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterSortBy>
      thenByJsonMediaSource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jsonMediaSource', Sort.asc);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterSortBy>
      thenByJsonMediaSourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jsonMediaSource', Sort.desc);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterSortBy> thenByPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.asc);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterSortBy> thenByPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.desc);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterSortBy> thenByState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.asc);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterSortBy> thenByStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.desc);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension DownloadedItemQueryWhereDistinct
    on QueryBuilder<DownloadedItem, DownloadedItem, QDistinct> {
  QueryBuilder<DownloadedItem, DownloadedItem, QDistinct> distinctByDownloadId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'downloadId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QDistinct>
      distinctByDownloadLocationId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'downloadLocationId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QDistinct> distinctByJsonItem(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'jsonItem', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QDistinct>
      distinctByJsonMediaSource({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'jsonMediaSource',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QDistinct> distinctByPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'path', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QDistinct> distinctByState() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'state');
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItem, QDistinct> distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }
}

extension DownloadedItemQueryProperty
    on QueryBuilder<DownloadedItem, DownloadedItem, QQueryProperty> {
  QueryBuilder<DownloadedItem, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<DownloadedItem, String?, QQueryOperations> downloadIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'downloadId');
    });
  }

  QueryBuilder<DownloadedItem, String?, QQueryOperations>
      downloadLocationIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'downloadLocationId');
    });
  }

  QueryBuilder<DownloadedItem, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DownloadedItem, String?, QQueryOperations> jsonItemProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'jsonItem');
    });
  }

  QueryBuilder<DownloadedItem, String?, QQueryOperations>
      jsonMediaSourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'jsonMediaSource');
    });
  }

  QueryBuilder<DownloadedItem, String?, QQueryOperations> pathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'path');
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItemState, QQueryOperations>
      stateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'state');
    });
  }

  QueryBuilder<DownloadedItem, DownloadedItemType, QQueryOperations>
      typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DownloadedSong _$DownloadedSongFromJson(Map json) => DownloadedSong(
      song:
          BaseItemDto.fromJson(Map<String, dynamic>.from(json['song'] as Map)),
      mediaSourceInfo: MediaSourceInfo.fromJson(
          Map<String, dynamic>.from(json['mediaSourceInfo'] as Map)),
      downloadId: json['downloadId'] as String,
      requiredBy: (json['requiredBy'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      path: json['path'] as String,
      useHumanReadableNames: json['useHumanReadableNames'] as bool,
      viewId: json['viewId'] as String,
      isPathRelative: json['isPathRelative'] as bool? ?? true,
      downloadLocationId: json['downloadLocationId'] as String?,
    );

Map<String, dynamic> _$DownloadedSongToJson(DownloadedSong instance) =>
    <String, dynamic>{
      'song': instance.song.toJson(),
      'mediaSourceInfo': instance.mediaSourceInfo.toJson(),
      'downloadId': instance.downloadId,
      'requiredBy': instance.requiredBy,
      'path': instance.path,
      'useHumanReadableNames': instance.useHumanReadableNames,
      'viewId': instance.viewId,
      'isPathRelative': instance.isPathRelative,
      'downloadLocationId': instance.downloadLocationId,
    };
