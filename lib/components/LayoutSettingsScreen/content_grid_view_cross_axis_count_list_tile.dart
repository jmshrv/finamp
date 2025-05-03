import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';

import '../../services/finamp_settings_helper.dart';

enum ContentGridViewCrossAxisCountType {
  portrait,
  landscape;

  /// Human-readable version of the [ContentGridViewCrossAxisCountType]. For
  /// example, toString() on [ContentGridViewCrossAxisCountType.portrait],
  /// toString() would return "ContentGridViewCrossAxisCountType.portrait". With
  /// this function, the same input would return "Portrait".
  @override
  @Deprecated("Use toLocalisedString when possible")
  String toString() => _humanReadableName(this);

  String toLocalisedString(BuildContext context) => _humanReadableLocalisedName(this, context);

  String _humanReadableName(ContentGridViewCrossAxisCountType contentGridViewCrossAxisCountType) {
    switch (contentGridViewCrossAxisCountType) {
      case ContentGridViewCrossAxisCountType.portrait:
        return "Portrait";
      case ContentGridViewCrossAxisCountType.landscape:
        return "Landscape";
    }
  }

  String _humanReadableLocalisedName(
      ContentGridViewCrossAxisCountType contentGridViewCrossAxisCountType, BuildContext context) {
    switch (contentGridViewCrossAxisCountType) {
      case ContentGridViewCrossAxisCountType.portrait:
        return AppLocalizations.of(context)!.portrait;
      case ContentGridViewCrossAxisCountType.landscape:
        return AppLocalizations.of(context)!.landscape;
    }
  }
}

class ContentGridViewCrossAxisCountListTile extends StatefulWidget {
  const ContentGridViewCrossAxisCountListTile({
    super.key,
    required this.type,
  });

  final ContentGridViewCrossAxisCountType type;

  @override
  State<ContentGridViewCrossAxisCountListTile> createState() => _ContentGridViewCrossAxisCountListTileState();
}

class _ContentGridViewCrossAxisCountListTileState extends State<ContentGridViewCrossAxisCountListTile> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    switch (widget.type) {
      case ContentGridViewCrossAxisCountType.portrait:
        _controller.text = FinampSettingsHelper.finampSettings.contentGridViewCrossAxisCountPortrait.toString();
        break;
      case ContentGridViewCrossAxisCountType.landscape:
        _controller.text = FinampSettingsHelper.finampSettings.contentGridViewCrossAxisCountLandscape.toString();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.gridCrossAxisCount(widget.type.toLocalisedString(context))),
      subtitle: Text(
        AppLocalizations.of(context)!.gridCrossAxisCountSubtitle(widget.type.toLocalisedString(context).toLowerCase()),
      ),
      trailing: SizedBox(
        width: 50 * MediaQuery.of(context).textScaleFactor,
        child: TextField(
          controller: _controller,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final valueInt = int.tryParse(value);

            if (valueInt != null && valueInt > 0) {
              switch (widget.type) {
                case ContentGridViewCrossAxisCountType.portrait:
                  FinampSetters.setContentGridViewCrossAxisCountPortrait(valueInt);
                  break;
                case ContentGridViewCrossAxisCountType.landscape:
                  FinampSetters.setContentGridViewCrossAxisCountLandscape(valueInt);
                  break;
              }
            }
          },
        ),
      ),
    );
  }
}
