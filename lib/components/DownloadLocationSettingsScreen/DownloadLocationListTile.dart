import 'package:flutter/material.dart';

import '../../models/FinampModels.dart';

class DownloadLocationListTile extends StatelessWidget {
  const DownloadLocationListTile({Key key, @required this.downloadLocation})
      : super(key: key);

  final DownloadLocation downloadLocation;

  @override
  Widget build(BuildContext context) {
    print(downloadLocation.deletable);
    return ListTile(
      title: Text(downloadLocation.name),
      subtitle: Text(
        downloadLocation.path,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: downloadLocation.deletable ? () {} : null,
      ),
    );
  }
}
