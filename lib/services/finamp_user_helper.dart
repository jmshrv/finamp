import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rxdart/rxdart.dart';

import '../models/finamp_models.dart';
import '../models/jellyfin_models.dart';

/// Helper class for Finamp users. Note that this class does not talk to the
/// Jellyfin server, so stuff like logging in/out is handled in JellyfinApiData.
class FinampUserHelper {
  final _finampUserBox = Hive.box<FinampUser>("FinampUsers");
  final _currentUserIdBox = Hive.box<String>("CurrentUserId");

  /// Checks if there are any saved users.
  bool get isUsersEmpty => _finampUserBox.isEmpty;

  /// Loads the id from CurrentUserId. Returns null if no id is stored.
  String? get currentUserId => _currentUserIdBox.get("CurrentUserId");

  /// Loads the FinampUser with the id from CurrentUserId. Returns null if no
  /// user exists.
  FinampUser? get currentUser =>
      _finampUserBox.get(_currentUserIdBox.get("CurrentUserId"));

  ValueListenable<Box<FinampUser>> get finampUsersListenable =>
      _finampUserBox.listenable();

  static final AutoDisposeStreamProvider<FinampUser?>
      finampCurrentUserProvider = StreamProvider.autoDispose((ref) {
    StreamTransformer;
    return Rx.switchLatest(Hive.box<String>("CurrentUserId")
        .watch()
        .map<String?>((event) => event.value)
        .startWith(Hive.box<String>("CurrentUserId").get("CurrentUserId"))
        .map((id) {
      return Hive.box<FinampUser>("FinampUsers")
          .watch(key: id)
          .map<FinampUser?>((event) => event.value)
          .startWith(Hive.box<FinampUser>("FinampUsers").get(id));
    }));
  });

  Iterable<FinampUser> get finampUsers => _finampUserBox.values;

  /// Saves a new user to the Hive box and sets the CurrentUserId.
  Future<void> saveUser(FinampUser newUser) async {
    await Future.wait([
      _finampUserBox.put(newUser.id, newUser),
      _currentUserIdBox.put("CurrentUserId", newUser.id),
    ]);
  }

  /// Sets the views of the current user
  void setCurrentUserViews(List<BaseItemDto> newViews) {
    final currentUserId = _currentUserIdBox.get("CurrentUserId");
    FinampUser currentUserTemp = currentUser!;

    currentUserTemp.views = Map<String, BaseItemDto>.fromEntries(
        newViews.map((e) => MapEntry(e.id, e)));
    currentUserTemp.currentViewId = currentUserTemp.views.keys.first;

    _finampUserBox.put(currentUserId, currentUserTemp);
  }

  void setCurrentUserCurrentViewId(String newViewId) {
    final currentUserId = _currentUserIdBox.get("CurrentUserId");
    FinampUser currentUserTemp = currentUser!;

    currentUserTemp.currentViewId = newViewId;

    _finampUserBox.put(currentUserId, currentUserTemp);
  }

  /// Removes the user with the given id. If the given id is the current user
  /// id, CurrentUserId is cleared.
  void removeUser(String id) {
    if (id == _currentUserIdBox.get("CurrentUserId")) {
      _currentUserIdBox.delete("CurrentUserId");
    }

    _finampUserBox.delete(id);
  }
}
