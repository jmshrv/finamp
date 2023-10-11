import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:file_sizes/file_sizes.dart';

import '../../services/downloads_helper.dart';
import '../error_snackbar.dart';

class DownloadsFileSize extends StatefulWidget {
  const DownloadsFileSize({Key? key, required this.directory})
      : super(key: key);

  final Directory directory;

  @override
  State<DownloadsFileSize> createState() => _DownloadsFileSizeState();
}

class _DownloadsFileSizeState extends State<DownloadsFileSize> {
  late Future<int> _downloadsFileSizeFuture;
  final DownloadsHelper _downloadsHelper = GetIt.instance<DownloadsHelper>();

  @override
  void initState() {
    super.initState();
    _downloadsFileSizeFuture = _downloadsHelper.getDirSize(widget.directory);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _downloadsFileSizeFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(
            FileSize.getSize(snapshot.data),
            style: const TextStyle(color: Colors.grey),
          );
        }
        if (snapshot.hasError) {
          errorSnackbar(snapshot.error, context);
          return const Text(
            "??? MB",
            style: TextStyle(color: Colors.red),
          );
        } else {
          return const Text(
            "...",
            style: TextStyle(color: Colors.grey),
          );
        }
      },
    );
  }
}
