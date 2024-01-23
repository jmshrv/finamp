import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:collection/collection.dart';
import 'package:get_it/get_it.dart';

import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:path_provider/path_provider.dart';
import 'downloads_helper.dart';
import 'finamp_user_helper.dart';
import 'jellyfin_api_helper.dart';
import 'finamp_settings_helper.dart';
import 'queue_service.dart';
import 'audio_service_helper.dart';

class AndroidAutoHelper {
  final _finampUserHelper = GetIt.instance<FinampUserHelper>();
  final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final _downloadsHelper = GetIt.instance<DownloadsHelper>();

  Future<BaseItemDto?> getParentFromId(String parentId) async {
    if (parentId == '-1') return null;

    final downloadedParent = _downloadsHelper.getDownloadedParent(parentId)?.item;
    if (downloadedParent != null) {
      return downloadedParent;
    } else if (FinampSettingsHelper.finampSettings.isOffline) {
      return null;
    }

    return await _jellyfinApiHelper.getItemById(parentId);
  }

  Future<List<BaseItemDto>> getBaseItems(String type, String categoryId, String? itemId) async {
    final tabContentType = TabContentType.values.firstWhere((e) => e.name == type);

    // limit amount so it doesn't crash on large libraries
    // TODO: somehow load more after the limit
    //       a problem with this is: how? i don't *think* there is a callback for scrolling. maybe there could be a button to load more?
    const limit = 100;

    final sortBy = FinampSettingsHelper.finampSettings.getTabSortBy(tabContentType);
    final sortOrder = FinampSettingsHelper.finampSettings.getSortOrder(tabContentType);

    // if we are in offline mode and in root category, display all matching downloaded parents
    if (FinampSettingsHelper.finampSettings.isOffline && categoryId == '-1') {
      List<BaseItemDto> baseItems = [];
      for (final downloadedParent in _downloadsHelper.downloadedParents) {
        if (baseItems.length >= limit) break;
        if (downloadedParent.item.type == tabContentType.itemType()) {
          baseItems.add(downloadedParent.item);
        }
      }
      return _sortItems(baseItems, sortBy, sortOrder);
    }

    // try to use downloaded parent first
    if (categoryId != '-1') {
      var downloadedParent = _downloadsHelper.getDownloadedParent(categoryId);
      if (downloadedParent != null) {
        final downloadedItems = [for (final child in downloadedParent.downloadedChildren.values.whereIndexed((i, e) => i < limit)) child];
        // only sort items if we are not playing them
        return _isPlayable(tabContentType) ? downloadedItems : _sortItems(downloadedItems, sortBy, sortOrder);
      }
    }

    // fetch the online version if we can't get offline version

    // select the item type that each category holds
    final includeItemTypes = categoryId != '-1' // if categoryId is -1, we are browsing a root library. e.g. browsing the list of all albums or artists
        ? (tabContentType == TabContentType.albums ? TabContentType.songs.itemType() // get an album's songs
        : tabContentType == TabContentType.artists ? TabContentType.albums.itemType() // get an artist's albums
        : tabContentType == TabContentType.playlists ? TabContentType.songs.itemType() // get a playlist's songs
        : tabContentType == TabContentType.genres ? TabContentType.albums.itemType() // get a genre's albums
        : throw FormatException("Unsupported TabContentType `$tabContentType`"))
        : tabContentType.itemType(); // get the root library

    // if category id is defined, use that to get items.
    // otherwise, use the current view as fallback to ensure we get the correct items.
    final parentItem = categoryId != '-1'
        ? BaseItemDto(id: categoryId, type: tabContentType.itemType())
        : _finampUserHelper.currentUser?.currentView;

    final items = await _jellyfinApiHelper.getItems(parentItem: parentItem, sortBy: sortBy.jellyfinName(tabContentType), sortOrder: sortOrder.toString(), includeItemTypes: includeItemTypes, isGenres: tabContentType == TabContentType.genres, limit: limit);
    return items ?? [];
  }

  Future<List<MediaItem>> getMediaItems(String type, String categoryId, String? itemId) async {
    return [ for (final item in await getBaseItems(type, categoryId, itemId)) await _convertToMediaItem(item, categoryId) ];
  }

  Future<void> toggleShuffle() async {
    final queueService = GetIt.instance<QueueService>();
    queueService.togglePlaybackOrder();
  }

  Future<void> playFromMediaId(String type, String categoryId, String? itemId) async {
    final tabContentType = TabContentType.values.firstWhere((e) => e.name == type);

    // shouldn't happen, but just in case
    if (categoryId == '-1' || !_isPlayable(tabContentType)) return;

    // get all songs in current category
    final parentItem = await getParentFromId(categoryId);

    // start instant mix for artists
    if (tabContentType == TabContentType.artists) {
      // we don't show artists in offline mode, and parent item can't be null for mix
      // this shouldn't happen, but just in case
      if (FinampSettingsHelper.finampSettings.isOffline || parentItem == null) {
        return;
      }

      final audioServiceHelper = GetIt.instance<AudioServiceHelper>();
      return await audioServiceHelper.startInstantMixForArtists([parentItem]);
    }

    final categoryBaseItems = await getBaseItems(type, categoryId, itemId);

    // queue service should be initialized by time we get here
    final queueService = GetIt.instance<QueueService>();
    await queueService.startPlayback(items: categoryBaseItems, source: QueueItemSource(
      type: tabContentType == TabContentType.playlists
          ? QueueItemSourceType.playlist
          : QueueItemSourceType.album,
      name: QueueItemSourceName(
          type: QueueItemSourceNameType.preTranslated,
          pretranslatedName: parentItem?.name),
      id: parentItem?.id ?? categoryId,
      item: parentItem,
    ));
  }

  // sort items
  List<BaseItemDto> _sortItems(List<BaseItemDto> items, SortBy sortBy, SortOrder sortOrder) {
    items.sort((a, b) {
      switch (sortBy) {
        case SortBy.sortName:
          final aName = a.name?.trim().toLowerCase();
          final bName = b.name?.trim().toLowerCase();
          if (aName == null || bName == null) {
            // Returning 0 is the same as both being the same
            return 0;
          } else {
            return aName.compareTo(bName);
          }
        case SortBy.albumArtist:
          if (a.albumArtist == null || b.albumArtist == null) {
            return 0;
          } else {
            return a.albumArtist!.compareTo(b.albumArtist!);
          }
        case SortBy.communityRating:
          if (a.communityRating == null ||
              b.communityRating == null) {
            return 0;
          } else {
            return a.communityRating!.compareTo(b.communityRating!);
          }
        case SortBy.criticRating:
          if (a.criticRating == null || b.criticRating == null) {
            return 0;
          } else {
            return a.criticRating!.compareTo(b.criticRating!);
          }
        case SortBy.dateCreated:
          if (a.dateCreated == null || b.dateCreated == null) {
            return 0;
          } else {
            return a.dateCreated!.compareTo(b.dateCreated!);
          }
        case SortBy.premiereDate:
          if (a.premiereDate == null || b.premiereDate == null) {
            return 0;
          } else {
            return a.premiereDate!.compareTo(b.premiereDate!);
          }
        case SortBy.random:
        // We subtract the result by one so that we can get -1 values
        // (see compareTo documentation)
          return Random().nextInt(2) - 1;
        default:
          throw UnimplementedError(
              "Unimplemented offline sort mode $sortBy");
      }
    });

    if (sortOrder == SortOrder.descending) {
      // The above sort functions sort in ascending order, so we swap them
      // when sorting in descending order.
      items = items.reversed.toList();
    }

    return items;
  }

  // albums, playlists, and songs should play when clicked
  // clicking artists starts an instant mix, so they are technically playable
  // genres has subcategories, so it should be browsable but not playable
  bool _isPlayable(TabContentType tabContentType) {
    return tabContentType == TabContentType.albums || tabContentType == TabContentType.playlists
        || tabContentType == TabContentType.artists || tabContentType == TabContentType.songs;
  }

  Future<MediaItem> _convertToMediaItem(BaseItemDto item, String categoryId) async {
    final tabContentType = TabContentType.fromItemType(item.type!);
    var newId = '${tabContentType.name}|';
    // if item is a parent type (category), set newId to 'type|categoryId'. otherwise, if it's a specific item (song), set it to 'type|categoryId|itemId'
    if (item.isFolder ?? tabContentType != TabContentType.songs && categoryId == '-1') {
      newId += item.id;
    } else {
      newId += '$categoryId|${item.id}';
    }

    var downloadedImage = _downloadsHelper.getDownloadedImage(item);
    Uri? artUri;

    // replace with content uri or jellyfin api uri
    if (downloadedImage != null) {
      artUri = downloadedImage.file.uri.replace(scheme: "content", host: "com.unicornsonlsd.finamp");
    } else if (!FinampSettingsHelper.finampSettings.isOffline) {
      artUri = _jellyfinApiHelper.getImageUrl(item: item);
      // try to get image file for Android Automotive
      // if (artUri != null) {
      //   try {
      //     final file = (await AudioService.cacheManager.getFileFromMemory(item.id))?.file ?? await AudioService.cacheManager.getSingleFile(artUri.toString());
      //     artUri = file.uri.replace(scheme: "content", host: "com.unicornsonlsd.finamp");
      //   } catch (e, st) {
      //     _androidAutoHelperLogger.fine("Error getting image file for Android Automotive", e, st);
      //   }
      // }
    }

    // replace with placeholder art
    if (artUri == null) {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      artUri = Uri(scheme: "content", host: "com.unicornsonlsd.finamp", path: "${documentsDirectory.absolute.path}/images/album_white.png");
    }

    return MediaItem(
      id: newId,
      playable: _isPlayable(tabContentType), // this dictates whether clicking on an item will try to play it or browse it
      album: item.album,
      artist: item.artists?.join(", ") ?? item.albumArtist,
      artUri: artUri,
      title: item.name ?? "unknown",
      // Jellyfin returns microseconds * 10 for some reason
      duration: Duration(
        microseconds:
        (item.runTimeTicks == null ? 0 : item.runTimeTicks! ~/ 10),
      ),
    );
  }
}