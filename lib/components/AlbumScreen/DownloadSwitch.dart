import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/DownloadsHelper.dart';
import '../../models/JellyfinModels.dart';

class DownloadSwitch extends StatefulWidget {
  DownloadSwitch({Key key, @required this.parent, @required this.items})
      : super(key: key);

  final BaseItemDto parent;
  final List<BaseItemDto> items;

  @override
  _DownloadSwitchState createState() => _DownloadSwitchState();
}

class _DownloadSwitchState extends State<DownloadSwitch> {
  DownloadsHelper downloadsHelper = GetIt.instance<DownloadsHelper>();
  bool isDownloaded;

  @override
  void initState() {
    super.initState();
    isDownloaded = downloadsHelper.isAlbumDownloaded(widget.parent.id);
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text("Download"),
      value: isDownloaded,
      onChanged: (value) {
        if (value) {
          downloadsHelper.addDownloads(
              items: widget.items, parent: widget.parent);
        } else {
          downloadsHelper.deleteDownloads(
              widget.items.map((e) => e.id).toList(), widget.parent.id);
        }
        setState(() {
          isDownloaded = value;
        });
      },
    );
  }
}
