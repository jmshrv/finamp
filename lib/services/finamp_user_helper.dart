import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:isar/isar.dart';

import '../models/finamp_models.dart';
import '../models/jellyfin_models.dart';
import 'jellyfin_api.dart' as jellyfin_api;

/// Helper class for Finamp users. Note that this class does not talk to the
/// Jellyfin server, so stuff like logging in/out is handled in JellyfinApiData.
class FinampUserHelper {
  FinampUserHelper() {
    _isar.finampUsers.watchObjectLazy(0).listen((event) {
      _currentUserCache = null;
      setAuthHeader();
    });
  }

  Future<void> setAuthHeader() async {
    authorizationHeader = await jellyfin_api.getAuthHeader();
  }

  final _isar = GetIt.instance<Isar>();

  /// Checks if there are any saved users.
  bool get isUsersEmpty => _isar.finampUsers.countSync() == 0;

  /// Loads the id from CurrentUserId. Returns null if no id is stored.
  String? get currentUserId => _isar.finampUsers.getSync(0)?.id;

  /// Loads the FinampUser with the id from CurrentUserId. Returns null if no
  /// user exists.
  FinampUser? get currentUser =>
      _currentUserCache ??= _isar.finampUsers.getSync(0);
  FinampUser? _currentUserCache;

  Iterable<FinampUser> get finampUsers =>
      _isar.finampUsers.where().findAllSync();

  late String authorizationHeader;

  static final AutoDisposeStreamProvider<FinampUser?>
      finampCurrentUserProvider = StreamProvider.autoDispose((ref) {
    final isar = GetIt.instance<Isar>();
    return isar.finampUsers.watchObject(0, fireImmediately: true);
  });

  Future<void> migrateFromHive() async {
    await Hive.openBox<FinampUser>("FinampUsers");
    await Hive.openBox<String>("CurrentUserId");
    var currentUserId = Hive.box<String>("CurrentUserId").get("CurrentUserId");
    if (currentUserId != null) {
      var currentUser = Hive.box<FinampUser>("FinampUsers").get(currentUserId);
      if (currentUser != null) {
        _isar.writeTxnSync(() {
          _isar.finampUsers.putSync(currentUser);
        });
      }
    }
  }

  /// Saves a new user to the Hive box and sets the CurrentUserId.
  Future<void> saveUser(FinampUser newUser) async {
    _isar.writeTxnSync(() {
      _isar.finampUsers.putSync(newUser);
    });
    await setAuthHeader();
  }

  /// Sets the views of the current user
  void setCurrentUserViews(List<BaseItemDto> newViews) {
    FinampUser currentUserTemp = currentUser!;

    currentUserTemp.views = Map<String, BaseItemDto>.fromEntries(
        newViews.map((e) => MapEntry(e.id, e)));
    currentUserTemp.currentViewId = currentUserTemp.views.keys.first;

    _isar.writeTxnSync(() {
      _isar.finampUsers.putSync(currentUserTemp);
    });
  }

  void setCurrentUserCurrentViewId(String newViewId) {
    FinampUser currentUserTemp = currentUser!;

    currentUserTemp.currentViewId = newViewId;

    _isar.writeTxnSync(() {
      _isar.finampUsers.putSync(currentUserTemp);
    });
  }

  /// Removes the user with the given id. If the given id is the current user
  /// id, CurrentUserId is cleared.
  void removeUser(String id) {
    _isar.writeTxnSync(() {
      _isar.finampUsers.filter().idEqualTo(id).deleteAllSync();
    });
  }
}
