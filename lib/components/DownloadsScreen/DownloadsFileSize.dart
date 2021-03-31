import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:file_sizes/file_sizes.dart';

import '../../services/DownloadsHelper.dart';
import '../errorSnackbar.dart';

class DownloadsFileSize extends StatefulWidget {
  DownloadsFileSize({Key key}) : super(key: key);

  @override
  _DownloadsFileSizeState createState() => _DownloadsFileSizeState();
}

class _DownloadsFileSizeState extends State<DownloadsFileSize> {
  Future _downloadsFileSizeFuture;
  DownloadsHelper _downloadsHelper = GetIt.instance<DownloadsHelper>();

  @override
  void initState() {
    super.initState();
    _downloadsFileSizeFuture = _downloadsHelper.getSongDirSize();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _downloadsFileSizeFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(
            FileSize().getSize(snapshot.data),
            style: TextStyle(color: Colors.grey),
          );
        }
        if (snapshot.hasError) {
          errorSnackbar(snapshot.error, context);
          return Text(
            "??? MB",
            style: TextStyle(color: Colors.red),
          );
        } else {
          return Text(
            "...",
            style: TextStyle(color: Colors.grey),
          );
        }
      },
    );
  }
}
