import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../components/global_snackbar.dart';
import '../models/jellyfin_models.dart';
import 'feedback_helper.dart';
import 'finamp_settings_helper.dart';
import 'jellyfin_api_helper.dart';

part 'favorite_provider.g.dart';

/// All DefaultValues should be considered equal
class DefaultValue {
  late final bool? isFavorite;

  DefaultValue([BaseItemDto? item]) {
    isFavorite = item?.userData?.isFavorite;
  }

  @override
  bool operator ==(Object other) {
    return other is DefaultValue;
  }

  @override
  int get hashCode => 7236544576;
}

@riverpod
class IsFavorite extends _$IsFavorite {
  @override
  // Because DefaultValue is always equal and we never invalidate, this should only
  // be called once per itemId and all other DefaultValues should be ignored
  bool build(String? itemId, DefaultValue value) {
    if (itemId == null) {
      return false;
    }
    return value.isFavorite ?? false;
  }

  bool updateFavorite(bool isFavorite) {
    assert(itemId != null);
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

    Future.sync(() async {
      try {
        UserItemDataDto newUserData;
        if (isFavorite) {
          newUserData = await jellyfinApiHelper.addFavourite(itemId!);
        } else {
          newUserData = await jellyfinApiHelper.removeFavourite(itemId!);
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

  bool toggleFavorite() {
    return updateFavorite(!state);
  }
}
