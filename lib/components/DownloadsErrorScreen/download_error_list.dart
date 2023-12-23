
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../models/finamp_models.dart';
import '../../services/isar_downloads.dart';
import '../error_snackbar.dart';
import 'download_error_list_tile.dart';

class DownloadErrorList extends StatelessWidget {
  const DownloadErrorList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isarDownloads = GetIt.instance<IsarDownloads>();
    return FutureBuilder(
      future: isarDownloads.getDownloadList(state: DownloadItemState.failed),
      builder: (context, snapshot) {
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
