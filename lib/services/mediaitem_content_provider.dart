import 'package:android_content_provider/android_content_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:logging/logging.dart';

class MediaItemContentProvider extends AndroidContentProvider {
  static final _mediaItemContentProviderLogger = Logger("MediaItemContentProvider");

  late final DefaultCacheManager _cacheManager;

  MediaItemContentProvider(String authority) : super(authority) {
    WidgetsFlutterBinding.ensureInitialized(); // needed for cache manager
    _cacheManager = DefaultCacheManager();
  }

  @override
  Future<String?> openFile(String uri, String mode) async {
    final parsedUri = Uri.tryParse(uri);
    if (parsedUri == null) {
      _mediaItemContentProviderLogger.severe("Unknown uri in media item content provider: $uri");
      return uri;
    }

    // we store the original scheme://host in fragment since it should be unused
    if (parsedUri.hasFragment) {
      final origin = Uri.parse(parsedUri.fragment);
      final fixedUri = parsedUri.replace(scheme: origin.scheme, host: origin.host).removeFragment().toString();
      try {
        final imageFile = await _cacheManager.getSingleFile(fixedUri, key: fixedUri);
        return imageFile.path;
      } catch (e) {
        _mediaItemContentProviderLogger.severe("Failed resolving uri in media item content provider: $fixedUri");
        return fixedUri;
      }
    }

    // this means it's a local image (downloaded or placeholder art)
    return Uri.parse(uri).path;
  }

  // Unused

  @override
  Future<int> delete(String uri, String? selection, List<String>? selectionArgs) {
    throw UnimplementedError();
  }

  @override
  Future<String?> getType(String uri) {
    return Future.value(null);
  }

  @override
  Future<String?> insert(String uri, ContentValues? values) {
    throw UnimplementedError();
  }

  @override
  Future<CursorData?> query(String uri, List<String>? projection, String? selection, List<String>? selectionArgs, String? sortOrder) {
    throw UnimplementedError();
  }

  @override
  Future<int> update(String uri, ContentValues? values, String? selection, List<String>? selectionArgs) {
    throw UnimplementedError();
  }
}