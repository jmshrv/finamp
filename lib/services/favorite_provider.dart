import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../components/global_snackbar.dart';
import '../models/jellyfin_models.dart';
import 'downloads_service.dart';
import 'feedback_helper.dart';
import 'finamp_settings_helper.dart';
import 'jellyfin_api_helper.dart';

part 'favorite_provider.g.dart';

/// All favoriteRequests with the same BaseItemDto id should be considered equal.
class FavoriteRequest {
  final BaseItemDto? item;

  FavoriteRequest(this.item);

  @override
  bool operator ==(Object other) {
    return other is FavoriteRequest && other.item?.id == item?.id;
  }

  @override
  int get hashCode => item?.id.hashCode ?? 5436345667;
}

@riverpod
class IsFavorite extends _$IsFavorite {
  bool _changed = false;
  Future<void>? _initializing;

  @override
  bool build(FavoriteRequest value) {
    if (value.item == null) {
      return false;
    }
    var item = value.item!;
    ref.listen(finampSettingsProvider.select((value) => value.value?.isOffline),
        (_, value) {
      if (!_changed && value == false) {
        // If we have not had updateFavorite run and are moving from offline to
        // online, invalidate to fetch latest data from server.
        ref.invalidateSelf();
      }
    });

    if ((item.finampOffline ?? false) || item.userData?.isFavorite == null) {
      if (!FinampSettingsHelper.finampSettings.isOffline) {
        // Fetch the latest value from the server to replace the request's default value
        // as soon as possible.
        _initializing = Future.sync(() async {
          try {
            final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
            var newItem = await jellyfinApiHelper.getItemById(item.id);
            if (!_changed) {
              state = newItem.userData?.isFavorite ?? false;
            }
          } catch (e) {
            GlobalSnackbar.error(e);
          }
        });
      }
      // The favorites status in offline items is unreliable, use isFavorite instead
      // if possible.
      return GetIt.instance<DownloadsService>().isFavorite(item) ??
          item.userData?.isFavorite ??
          false;
    } else {
      return item.userData?.isFavorite ?? false;
    }
  }

  bool updateFavorite(bool isFavorite) {
    assert(value.item != null);
    final isOffline = FinampSettingsHelper.finampSettings.isOffline;
    final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
    if (isOffline) {
      FeedbackHelper.feedback(FeedbackType.error);
      GlobalSnackbar.message(
          (context) => AppLocalizations.of(context)!.notAvailableInOfflineMode);
      return state;
    }

    var oldState = state;
    // Once the favorite has been toggled, any existing BaseItemDtos may be out
    // of date, so we can never safely re-create the widget from a DefaultValue
    // and must keep it alive.
    ref.keepAlive();
    _changed = true;

    Future.sync(() async {
      try {
        UserItemDataDto newUserData;
        if (isFavorite) {
          newUserData = await jellyfinApiHelper.addFavourite(value.item!.id);
        } else {
          newUserData = await jellyfinApiHelper.removeFavourite(value.item!.id);
        }
        state = newUserData.isFavorite;

        FeedbackHelper.feedback(FeedbackType.success);
      } catch (e) {
        state = oldState;
        GlobalSnackbar.error(e);
      }
    });
    state = isFavorite;
    return state;
  }

  void toggleFavorite() async {
    if (_initializing != null) {
      await _initializing;
    }
    updateFavorite(!state);
  }
}
