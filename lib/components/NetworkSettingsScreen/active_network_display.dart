import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/services/auto_offline.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import '../../models/finamp_models.dart';
import '../../services/finamp_settings_helper.dart';

class ActiveNetworkDisplay extends StatefulWidget {
  const ActiveNetworkDisplay({super.key});

  @override
  State<ActiveNetworkDisplay> createState() => _ActiveNetworkDisplay();
}


var _listener;
class _ActiveNetworkDisplay extends State<ActiveNetworkDisplay> {
  @override
  void dispose() {
    super.dispose();
    if (_listener != null) {
      _listener.cancel();
      _listener = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    String address = FinampUserHelper().currentUser!.baseUrl;

    if (_listener != null) _listener.cancel();
    _listener = currentAddressTextUpdateStream.stream.listen((_) {
      setState(() {});
    });

    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, __) {
        return ListTile(
          leading: Icon(Icons.router_outlined),
          subtitle: Text(AppLocalizations.of(context)!.preferHomeNetworkActiveAddressInfoText),
          trailing: Text(address)
        );
      }
    );
  }
}
