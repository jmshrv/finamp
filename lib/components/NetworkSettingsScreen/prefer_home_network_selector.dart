import 'dart:io';

import 'package:finamp/components/ensure_location_permission_prompt.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/auto_offline.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../../services/finamp_settings_helper.dart';

class HomeNetworkSelector extends ConsumerWidget {
  const HomeNetworkSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool preferLocalNetwork = ref.watch(FinampUserHelper.finampCurrentUserProvider).valueOrNull?.preferHomeNetwork ?? DefaultSettings.preferHomeNetwork;

    return SwitchListTile.adaptive(
      title: Text(AppLocalizations.of(context)!.preferHomeNetworkEnableSwitchTitle), // TODO TRANSLATION
      subtitle: Text(AppLocalizations.of(context)!.preferHomeNetworkEnableSwitchDescription),
      value: preferLocalNetwork,
      onChanged: (value) async {
        if (value) {
          value = await ensureLocationPermissions(context);
        }
        GetIt.instance<FinampUserHelper>().currentUser?.update(newPreferHomeNetwork: value);
      },
    );
  }
}

