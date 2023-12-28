import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

import '../components/DownloadsErrorScreen/download_error_list.dart';
import '../components/global_snackbar.dart';
import '../models/finamp_models.dart';
import '../services/isar_downloads.dart';

class DownloadsErrorScreen extends StatelessWidget {
  const DownloadsErrorScreen({Key? key}) : super(key: key);

  static const routeName = "/downloads/errors";

  @override
  Widget build(BuildContext context) {
    final isarDownloads = GetIt.instance<IsarDownloads>();
    var stream = Rx.combineLatest3<List<DownloadStub>, List<DownloadStub>, List<DownloadStub>,List<List<DownloadStub>>>(
        isarDownloads.getDownloadList(state: DownloadItemState.failed),
        isarDownloads.getDownloadList(state: DownloadItemState.downloading),
        isarDownloads.getDownloadList(state: DownloadItemState.enqueued),
            (l1,l2,l3) => [l1,l2,l3]);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.downloadErrorsTitle),
      ),
      body: StreamBuilder(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data);
              if (snapshot.data!.every((element) => element.isEmpty)) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check,
                          size: 64,
                          // Inactive icons have an opacity of 50% with dark theme and 38%
                          // with bright theme
                          // https://material.io/design/iconography/system-icons.html#color
                          color: Theme.of(context).iconTheme.color?.withOpacity(
                              Theme.of(context).brightness == Brightness.light
                                  ? 0.38
                                  : 0.5)),
                      const Padding(padding: EdgeInsets.all(8.0)),
                      Text(AppLocalizations.of(context)!.noErrors),
                    ],
                  ),
                );
              } else {
                return CustomScrollView(slivers: [
                  if (snapshot.data![0].isNotEmpty) DownloadErrorList(state: DownloadItemState.failed, children: snapshot.data![0]),
                  if (snapshot.data![1].isNotEmpty) DownloadErrorList(state: DownloadItemState.downloading, children: snapshot.data![1]),
                  if (snapshot.data![2].isNotEmpty) DownloadErrorList(state: DownloadItemState.enqueued, children: snapshot.data![2])
                ]);
              }
            } else if (snapshot.hasError) {
              GlobalSnackbar.error(snapshot.error);
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
          }),
    );
  }
}
