import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:collection/collection.dart';
import 'package:get_it/get_it.dart';

import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'downloads_helper.dart';
import 'finamp_user_helper.dart';
import 'jellyfin_api_helper.dart';
import 'finamp_settings_helper.dart';
import 'queue_service.dart';
import 'audio_service_helper.dart';

class AndroidAutoHelper {

  static final _androidAutoHelperLogger = Logger("AndroidAutoHelper");
  
  final _finampUserHelper = GetIt.instance<FinampUserHelper>();
  final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final _downloadsHelper = GetIt.instance<DownloadsHelper>();

  Future<BaseItemDto?> getParentFromId(String parentId) async {
    final downloadedParent = _downloadsHelper.getDownloadedParent(parentId)?.item;
    if (downloadedParent != null) {
      return downloadedParent;
    } else if (FinampSettingsHelper.finampSettings.isOffline) {
      return null;
    }

    return await _jellyfinApiHelper.getItemById(parentId);
  }

  Future<List<BaseItemDto>> getBaseItems(MediaItemId itemId) async {
    final tabContentType = TabContentType.values.firstWhere((e) => e == itemId.contentType);

    // limit amount so it doesn't crash on large libraries
    // TODO: somehow load more after the limit
    //       a problem with this is: how? i don't *think* there is a callback for scrolling. maybe there could be a button to load more?
    const limit = 100;

    final sortBy = FinampSettingsHelper.finampSettings.getTabSortBy(tabContentType);
    final sortOrder = FinampSettingsHelper.finampSettings.getSortOrder(tabContentType);

    // if we are in offline mode and in root parent/collection, display all matching downloaded parents
    if (FinampSettingsHelper.finampSettings.isOffline && itemId.parentType == MediaItemParentType.rootCollection) {
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
    if (itemId.parentType == MediaItemParentType.collection) {
      var downloadedParent = _downloadsHelper.getDownloadedParent(itemId.itemId!);
      if (downloadedParent != null) {
        final downloadedItems = [for (final child in downloadedParent.downloadedChildren.values.whereIndexed((i, e) => i < limit)) child];
        // only sort items if we are not playing them
        return _isPlayable(tabContentType) ? downloadedItems : _sortItems(downloadedItems, sortBy, sortOrder);
      }
    }

    // fetch the online version if we can't get offline version

    // select the item type that each parent holds
    final includeItemTypes = itemId.parentType == MediaItemParentType.collection // if parentId is -1, we are browsing a root library. e.g. browsing the list of all albums or artists
        ? (tabContentType == TabContentType.albums ? TabContentType.songs.itemType() // get an album's songs
        : tabContentType == TabContentType.artists ? TabContentType.albums.itemType() // get an artist's albums
        : tabContentType == TabContentType.playlists ? TabContentType.songs.itemType() // get a playlist's songs
        : tabContentType == TabContentType.genres ? TabContentType.albums.itemType() // get a genre's albums
        : TabContentType.songs.itemType() ) // if we don't have one of these categories, we are probably dealing with stray songs
        : tabContentType.itemType(); // get the root library

    // if parent id is defined, use that to get items.
    // otherwise, use the current view as fallback to ensure we get the correct items.
    final parentItem = itemId.parentType == MediaItemParentType.collection
        ? BaseItemDto(id: itemId.itemId!, type: tabContentType.itemType())
        : _finampUserHelper.currentUser?.currentView;

    final items = await _jellyfinApiHelper.getItems(parentItem: parentItem, sortBy: sortBy.jellyfinName(tabContentType), sortOrder: sortOrder.toString(), includeItemTypes: includeItemTypes, isGenres: tabContentType == TabContentType.genres, limit: limit);
    return items ?? [];
  }

  Future<List<MediaItem>> getRecentItems() async {
    final finampUserHelper = GetIt.instance<FinampUserHelper>();
    final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
    final queueService = GetIt.instance<QueueService>();

    try {
      final recentItems = queueService.getNextXTracksInQueue(0, reverse: 5);
      return [ for (final item in recentItems ?? []) await _convertToMediaItem(item: item, parentType: MediaItemParentType.collection) ];
    } catch (err) {
      _androidAutoHelperLogger.severe("Error while getting recent items:", err);
      return [];
    }
  }

  Future<List<MediaItem>> searchItems(String query, Map<String, dynamic>? extras) async {
    final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
    final finampUserHelper = GetIt.instance<FinampUserHelper>();

    try {

      List<BaseItemDto>? searchResult;

      if (extras?["android.intent.extra.title"] != null) {
        // search for exact query first, then search for adjusted query
        // sometimes Google's adjustment might not be what we want, but sometimes it actually helps
        List<BaseItemDto>? searchResultExactQuery;
        List<BaseItemDto>? searchResultAdjustedQuery;
        try {
          searchResultExactQuery = await jellyfinApiHelper.getItems(
            parentItem: finampUserHelper.currentUser?.currentView,
            includeItemTypes: "Audio",
            searchTerm: query.trim(),
            isGenres: false,
            startIndex: 0,
            limit: 7,
          );
        } catch (e) {
          _androidAutoHelperLogger.severe("Error while searching for exact query:", e);
        }
        try {
          searchResultAdjustedQuery = await jellyfinApiHelper.getItems(
            parentItem: finampUserHelper.currentUser?.currentView,
            includeItemTypes: "Audio",
            searchTerm: extras!["android.intent.extra.title"].trim(),
            isGenres: false,
            startIndex: 0,
            limit: (searchResultExactQuery != null && searchResultExactQuery.isNotEmpty) ? 13 : 20,
          );
        } catch (e) {
          _androidAutoHelperLogger.severe("Error while searching for adjusted query:", e);
        }
        
        searchResult = searchResultExactQuery?.followedBy(searchResultAdjustedQuery ?? []).toList() ?? [];
        
      } else {
        searchResult = await jellyfinApiHelper.getItems(
          parentItem: finampUserHelper.currentUser?.currentView,
          includeItemTypes: "Audio",
          searchTerm: query.trim(),
          isGenres: false,
          startIndex: 0,
          limit: 20,
        );
      }

      if (searchResult != null && searchResult.isEmpty) {
        _androidAutoHelperLogger.warning("No search results found for query: $query (extras: $extras)");
      }

      return [ for (final item in searchResult!) await _convertToMediaItem(item: item, parentType: MediaItemParentType.instantMix, parentId: item.parentId) ];
    } catch (err) {
      _androidAutoHelperLogger.severe("Error while searching:", err);
      return [];
    }
  }

  Future<void> playFromSearch(String query, Map<String, dynamic>? extras) async {
    final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
    final finampUserHelper = GetIt.instance<FinampUserHelper>();
    final audioServiceHelper = GetIt.instance<AudioServiceHelper>();
    final queueService = GetIt.instance<QueueService>();
    
    String itemType = "Audio";
    String? alternativeQuery;

    if (extras?["android.intent.extra.album"] != null && extras?["android.intent.extra.artist"] != null && extras?["android.intent.extra.title"] != null) {
      // if all metadata is provided, search for song
      itemType = "Audio";
      alternativeQuery = extras?["android.intent.extra.title"];
    } else if (extras?["android.intent.extra.album"] != null && extras?["android.intent.extra.artist"] != null && extras?["android.intent.extra.title"] == null) {
      // if only album is provided, search for album
      itemType = "MusicAlbum";
      alternativeQuery = extras?["android.intent.extra.album"];
    } else if (extras?["android.intent.extra.artist"] != null && extras?["android.intent.extra.title"] == null) {
      // if only artist is provided, search for artist
      itemType = "MusicArtist";
      alternativeQuery = extras?["android.intent.extra.artist"];
    } 

    _androidAutoHelperLogger.info("Searching for: $itemType that matches query '${alternativeQuery ?? query}'");

    try {
      List<BaseItemDto>? searchResult = await jellyfinApiHelper.getItems(
        parentItem: finampUserHelper.currentUser?.currentView,
        includeItemTypes: itemType,
        searchTerm: alternativeQuery?.trim() ?? query.trim(),
        isGenres: false,
        startIndex: 0,
        limit: 25, // get more than the first result so we can filter using additional metadata
      );

      if (searchResult == null || searchResult.isEmpty) {

        if (alternativeQuery != null) {
          // try again with metadata provided by android (could be corrected based on metadata or localizations)
          
          searchResult = await jellyfinApiHelper.getItems(
            parentItem: finampUserHelper.currentUser?.currentView,
            includeItemTypes: itemType,
            searchTerm: alternativeQuery.trim(),
            isGenres: false,
            startIndex: 0,
            limit: 25, // get more than the first result so we can filter using additional metadata
          );

        }
        
        if (searchResult == null || searchResult.isEmpty) {
          return;
        }
      }

      final selectedResult = searchResult.firstWhere((element) {
        if (itemType == "Audio" && extras?["android.intent.extra.artist"] != null) {
          return element.albumArtists?.any((artist) => extras?["android.intent.extra.artist"]?.contains(artist.name) == true) == true;
        } else if (itemType == "MusicAlbum" && extras?["android.intent.extra.artist"] != null) {
          return element.albumArtists?.any((artist) => extras?["android.intent.extra.artist"]?.contains(artist.name) == true) == true;
        } else {
          return false;
        }
        }, orElse: () => searchResult![0]
      );

      _androidAutoHelperLogger.info("Playing from search: ${selectedResult.name}");
      
      if (itemType == "MusicAlbum") {
        final album = await jellyfinApiHelper.getItemById(selectedResult.id);
        final items = await _jellyfinApiHelper.getItems(parentItem: album, includeItemTypes: "Audio", isGenres: false, sortBy: "ParentIndexNumber,IndexNumber,SortName", sortOrder: "Ascending", limit: 200);
        _androidAutoHelperLogger.info("Playing album: ${album.name} (${items?.length} songs)");

        queueService.startPlayback(items: items ?? [], source: QueueItemSource(
            type: QueueItemSourceType.album,
            name: QueueItemSourceName(
                type: QueueItemSourceNameType.preTranslated,
                pretranslatedName: album.name),
            id: album.id,
            item: album,
          ),
          order: FinampPlaybackOrder.linear, //TODO add a setting that sets the default (because Android Auto doesn't give use the prompt as an extra), or use the current order?
        );
      } else if (itemType == "MusicArtist") {
        await audioServiceHelper.startInstantMixForArtists([selectedResult]).then((value) => 1);
      } else {
        await audioServiceHelper.startInstantMixForItem(selectedResult).then((value) => 1);
      }
    } catch (err) {
      _androidAutoHelperLogger.severe("Error while playing from search query:", err);
    }
  }

  Future<List<MediaItem>> getMediaItems(MediaItemId itemId) async {
    return [ for (final item in await getBaseItems(itemId)) await _convertToMediaItem(item: item, parentType: MediaItemParentType.collection, parentId: item.parentId) ];
  }

  Future<void> toggleShuffle() async {
    final queueService = GetIt.instance<QueueService>();
    queueService.togglePlaybackOrder();
  }

  Future<void> playFromMediaId(MediaItemId itemId) async {
    final audioServiceHelper = GetIt.instance<AudioServiceHelper>();
    final tabContentType = TabContentType.values.firstWhere((e) => e == itemId.contentType);

    // shouldn't happen, but just in case
    if (!_isPlayable(tabContentType)) {
      _androidAutoHelperLogger.warning("Tried to play from media id with non-playable item type ${itemId.parentType.name}");
      return;
    }

    if (itemId.parentType == MediaItemParentType.instantMix) {
      return await audioServiceHelper.startInstantMixForItem(await _jellyfinApiHelper.getItemById(itemId.itemId!));
    }

    if (itemId.parentType != MediaItemParentType.collection || itemId.itemId == null) {
      _androidAutoHelperLogger.warning("Tried to play from media id with invalid parent type '${itemId.parentType.name}' or null id");
      return;
    }
    // get all songs of current parrent
    final parentItem = await getParentFromId(itemId.itemId!);

    // start instant mix for artists
    if (tabContentType == TabContentType.artists) {
      // we don't show artists in offline mode, and parent item can't be null for mix
      // this shouldn't happen, but just in case
      if (FinampSettingsHelper.finampSettings.isOffline || parentItem == null) {
        return;
      }

      return await audioServiceHelper.startInstantMixForArtists([parentItem]);
    }

    final parentBaseItems = await getBaseItems(itemId);

    // queue service should be initialized by time we get here
    final queueService = GetIt.instance<QueueService>();
    await queueService.startPlayback(items: parentBaseItems, source: QueueItemSource(
      type: tabContentType == TabContentType.playlists
          ? QueueItemSourceType.playlist
          : QueueItemSourceType.album,
      name: QueueItemSourceName(
          type: QueueItemSourceNameType.preTranslated,
          pretranslatedName: parentItem?.name),
      id: parentItem?.id ?? itemId.parentId!,
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

  Future<MediaItem> _convertToMediaItem({
    required BaseItemDto item,
    required MediaItemParentType parentType,
    String? parentId,
  }) async {
    final tabContentType = TabContentType.fromItemType(item.type!);
    final itemId = MediaItemId(
      contentType: tabContentType,
      parentType: parentType,
      parentId: parentId ?? item.parentId,
      itemId: item.id,
    );

    final downloadedSong = _downloadsHelper.getDownloadedSong(item.id);
    final isDownloaded = downloadedSong == null
        ? false
        : await _downloadsHelper.verifyDownloadedSong(downloadedSong);

    var downloadedImage = _downloadsHelper.getDownloadedImage(item);
    Uri? artUri;

    // replace with content uri or jellyfin api uri
    if (downloadedImage != null) {
      artUri = downloadedImage.file.uri.replace(scheme: "content", host: "com.unicornsonlsd.finamp");
    } else if (!FinampSettingsHelper.finampSettings.isOffline) {
      artUri = _jellyfinApiHelper.getImageUrl(item: item);
      // try to get image file (Android Automotive needs this)
      if (artUri != null) {
        try {
          final fileInfo = await AudioService.cacheManager.getFileFromCache(item.id);
          if (fileInfo != null) {
            artUri = fileInfo.file.uri.replace(scheme: "content", host: "com.unicornsonlsd.finamp");
          } else {
            // store the origin in fragment since it should be unused
            artUri = artUri.replace(scheme: "content", host: "com.unicornsonlsd.finamp", fragment: artUri.origin);
          }
        } catch (e) {
          _androidAutoHelperLogger.severe("Error setting new media artwork uri for item: ${item.id} name: ${item.name}", e);
        }
      }
    }

    // replace with placeholder art
    if (artUri == null) {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      artUri = Uri(scheme: "content", host: "com.unicornsonlsd.finamp", path: "${documentsDirectory.absolute.path}/images/album_white.png");
    }

    return MediaItem(
      id: itemId.toString(),
      playable: _isPlayable(tabContentType), // this dictates whether clicking on an item will try to play it or browse it
      album: item.album,
      artist: item.artists?.join(", ") ?? item.albumArtist,
      artUri: artUri,
      title: item.name ?? "unknown",
      extras: {
        "itemJson": item.toJson(),
        "shouldTranscode": FinampSettingsHelper.finampSettings.shouldTranscode,
        "downloadedSongJson": isDownloaded
            ? (_downloadsHelper.getDownloadedSong(item.id))!.toJson()
            : null,
        "isOffline": FinampSettingsHelper.finampSettings.isOffline,
      },
      // Jellyfin returns microseconds * 10 for some reason
      duration: Duration(
        microseconds:
        (item.runTimeTicks == null ? 0 : item.runTimeTicks! ~/ 10),
      ),
    );
  }
}
