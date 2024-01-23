import 'package:android_content_provider/android_content_provider.dart';

class MediaItemContentProvider extends AndroidContentProvider {
  MediaItemContentProvider(String authority) : super(authority);

  @override
  Future<String?> openFile(String uri, String mode) async {
    return Uri.parse(uri).replace(scheme: "file", host: "").toFilePath();
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