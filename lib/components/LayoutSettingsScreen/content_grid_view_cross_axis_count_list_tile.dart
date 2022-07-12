import 'package:flutter/material.dart';

import '../../services/finamp_settings_helper.dart';

enum ContentGridViewCrossAxisCountType {
  portrait,
  landscape;

  /// Human-readable version of the [ContentGridViewCrossAxisCountType]. For
  /// example, toString() on [ContentGridViewCrossAxisCountType.portrait],
  /// toString() would return "ContentGridViewCrossAxisCountType.portrait". With
  /// this function, the same input would return "Portrait".
  @override
  String toString() => _humanReadableName(this);

  String _humanReadableName(
      ContentGridViewCrossAxisCountType contentGridViewCrossAxisCountType) {
    switch (contentGridViewCrossAxisCountType) {
      case ContentGridViewCrossAxisCountType.portrait:
        return "Portrait";
      case ContentGridViewCrossAxisCountType.landscape:
        return "Landscape";
    }
  }
}

class ContentGridViewCrossAxisCountListTile extends StatefulWidget {
  const ContentGridViewCrossAxisCountListTile({
    Key? key,
    required this.type,
  }) : super(key: key);

  final ContentGridViewCrossAxisCountType type;

  @override
  State<ContentGridViewCrossAxisCountListTile> createState() =>
      _ContentGridViewCrossAxisCountListTileState();
}

class _ContentGridViewCrossAxisCountListTileState
    extends State<ContentGridViewCrossAxisCountListTile> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    switch (widget.type) {
      case ContentGridViewCrossAxisCountType.portrait:
        _controller.text = FinampSettingsHelper
            .finampSettings.contentGridViewCrossAxisCountPortrait
            .toString();
        break;
      case ContentGridViewCrossAxisCountType.landscape:
        _controller.text = FinampSettingsHelper
            .finampSettings.contentGridViewCrossAxisCountLandscape
            .toString();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("${widget.type.toString()} Grid Cross-Axis Count"),
      subtitle: Text(
          "Amount of grid tiles to use per-row when ${widget.type.toString().toLowerCase()}."),
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
                  FinampSettingsHelper.setContentGridViewCrossAxisCountPortrait(
                      valueInt);
                  break;
                case ContentGridViewCrossAxisCountType.landscape:
                  FinampSettingsHelper
                      .setContentGridViewCrossAxisCountLandscape(valueInt);
                  break;
              }
            }
          },
        ),
      ),
    );
  }
}
