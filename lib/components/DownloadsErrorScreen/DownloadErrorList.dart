import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get_it/get_it.dart';

import '../../services/DownloadsHelper.dart';
import '../errorSnackbar.dart';
import 'DownloadErrorListTile.dart';

class DownloadErrorList extends StatefulWidget {
  const DownloadErrorList({Key? key}) : super(key: key);

  @override
  _DownloadErrorListState createState() => _DownloadErrorListState();
}

class _DownloadErrorListState extends State<DownloadErrorList> {
  late Future<List<DownloadTask>?> downloadErrorListFuture;
  DownloadsHelper downloadsHelper = GetIt.instance<DownloadsHelper>();

  @override
  void initState() {
    super.initState();
    downloadErrorListFuture =
        downloadsHelper.getDownloadsWithStatus(DownloadTaskStatus.failed);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DownloadTask>?>(
      future: downloadErrorListFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.length == 0) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check,
                    size: 64,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  const Padding(padding: EdgeInsets.all(8.0)),
                  const Text("No errors!"),
                ],
              ),
            );
          } else {
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
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                  "An error occured while getting the list of errors! At this point, you should probably just create an issue on GitHub and delete app data"),
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
