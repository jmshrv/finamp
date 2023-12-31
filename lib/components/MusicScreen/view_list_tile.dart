import 'package:finamp/components/AlbumScreen/download_button.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/finamp_models.dart';
import '../../models/jellyfin_models.dart';
import '../../services/finamp_user_helper.dart';
import '../view_icon.dart';

class ViewListTile extends StatelessWidget {
  const ViewListTile({Key? key, required this.view}) : super(key: key);

  final BaseItemDto view;

  @override
  Widget build(BuildContext context) {
    final finampUserHelper = GetIt.instance<FinampUserHelper>();

    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: ViewIcon(
          collectionType: view.collectionType,
          color: finampUserHelper.currentUser!.currentViewId == view.id
              ? Theme.of(context).colorScheme.primary
              : null,
        ),
      ),
      title: Text(
        view.name ?? "Unknown Name",
        style: TextStyle(
          color: finampUserHelper.currentUser!.currentViewId == view.id
              ? Theme.of(context).colorScheme.primary
              : null,
        ),
      ),
      onTap: () => finampUserHelper.setCurrentUserCurrentViewId(view.id),
      trailing: DownloadButton(
        isLibrary: true,
        item: DownloadStub.fromItem(
            item: view, type: DownloadItemType.collection),
      ),
    );
  }
}
