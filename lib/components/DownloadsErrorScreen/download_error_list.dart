import 'dart:ffi';

import 'package:finamp/models/jellyfin_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../models/finamp_models.dart';
import '../../services/downloads_helper.dart';
import '../../services/finamp_user_helper.dart';
import '../../services/jellyfin_api_helper.dart';
import '../AlbumScreen/download_dialog.dart';
import '../error_snackbar.dart';
import 'download_error_list_tile.dart';

class DownloadErrorController {
  late Future<void> Function() redownloadFailed;
}

class DownloadErrorList extends StatefulWidget {
  final DownloadErrorController downloadErrorController;

  const DownloadErrorList({Key? key, required this.downloadErrorController})
      : super(key: key);

  @override
  State<DownloadErrorList> createState() =>
      _DownloadErrorListState(downloadErrorController);
}

class _DownloadErrorListState extends State<DownloadErrorList> {
  bool isLoaded = false;
  List<DownloadTask>? loadedDownloadTasks;
  final _finampUserHelper = GetIt.instance<FinampUserHelper>();

  _DownloadErrorListState(DownloadErrorController _downloadErrorController) {
    _downloadErrorController.redownloadFailed = redownloadFailed;
  }

  late Future<List<DownloadTask>?> downloadErrorListFuture;
  DownloadsHelper downloadsHelper = GetIt.instance<DownloadsHelper>();

  @override
  void initState() {
    super.initState();
    isLoaded = false;
    downloadErrorListFuture =
        downloadsHelper.getDownloadsWithStatus(DownloadTaskStatus.failed);
  }

  Future<void> redownloadFailed() async {
    if (loadedDownloadTasks?.isEmpty ?? true) {
      // TODO: Add alert
    } else {
      JellyfinApiHelper jellyfinApiHelper = JellyfinApiHelper();
      List<List<BaseItemDto>> items = [];
      List<BaseItemDto> parentItems = [];
      for (DownloadTask downloadTask in loadedDownloadTasks!) {
        DownloadedSong? downloadedSong =
        downloadsHelper.getJellyfinItemFromDownloadId(downloadTask.taskId);

        if (downloadedSong == null) {
          continue;
        }

        List<String> parents = downloadedSong.requiredBy;
        for (String parent in parents) {
          downloadsHelper.deleteDownloads(jellyfinItemIds: [downloadedSong.song.id], deletedFor: parent);
          parentItems.add(await jellyfinApiHelper.getItemById(parent));
          items.add([downloadedSong.song]);
        }
      }
      if (items.isNotEmpty || parentItems.isNotEmpty) {
        showDialog(
            context: context,
            builder: (context) =>
                DownloadDialog(
                    parents: parentItems,
                    items: items,
                    viewId: _finampUserHelper.currentUser!.currentViewId!));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DownloadTask>?>(
      future: downloadErrorListFuture,
      builder: (context, snapshot) {
        loadedDownloadTasks = snapshot.data;
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check,
                      size: 64,
                      // Inactive icons have an opacity of 50% with dark theme and 38%
                      // with bright theme
                      // https://material.io/design/iconography/system-icons.html#color
                      color: Theme
                          .of(context)
                          .iconTheme
                          .color
                          ?.withOpacity(
                          Theme
                              .of(context)
                              .brightness == Brightness.light
                              ? 0.38
                              : 0.5)),
                  const Padding(padding: EdgeInsets.all(8.0)),
                  Text(AppLocalizations.of(context)!.noErrors),
                ],
              ),
            );
          } else {
            isLoaded = true;
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return DownloadErrorListTile(
                    downloadTask: snapshot.data![index]);
              },
            );
          }
        } else if (snapshot.hasError) {
          errorSnackbar(snapshot.error, context);
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(AppLocalizations.of(context)!.errorScreenError),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
      },
    );
  }
}
