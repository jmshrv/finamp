import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../../services/downloads_helper.dart';
import '../../services/finamp_settings_helper.dart';
import '../../models/jellyfin_models.dart';
import '../../models/finamp_models.dart';
import 'add_download_button.dart';
import 'delete_download_button.dart';

enum DownloadChoice {
  original,
  transcoded,
}

class DownloadButton extends StatefulWidget {
  const DownloadButton({
    Key? key,
    required this.parent,
    required this.items,
  }) : super(key: key);

  final BaseItemDto parent;
  final List<BaseItemDto> items;

  @override
  State<DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  final _downloadsHelper = GetIt.instance<DownloadsHelper>();
  late bool isDownloaded;

  @override
  void initState() {
    super.initState();
    isDownloaded = _downloadsHelper.isAlbumDownloaded(widget.parent.id);
  }

  @override
  Widget build(BuildContext context) {
    void checkIfDownloaded() {
      if (!mounted) return;
      setState(() {
        isDownloaded = _downloadsHelper.isAlbumDownloaded(widget.parent.id);
      });
    }

    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, child) {
        if (isDownloaded) {
          return DeleteDownloadButton(
            parent: widget.parent,
            items: widget.items,
            onDownloadsDeleted: checkIfDownloaded,
          );
        }

        return AddDownloadButton(
          parent: widget.parent,
          items: widget.items,
          onDownloadsAdded: checkIfDownloaded,
        );
      },
    );
  }
}
