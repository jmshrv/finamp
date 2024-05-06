import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';

import '../components/QueueRestoreScreen/queue_restore_tile.dart';
import '../models/finamp_models.dart';

class QueueRestoreScreen extends StatelessWidget {
  const QueueRestoreScreen({Key? key}) : super(key: key);

  static const routeName = "/queues";

  @override
  Widget build(BuildContext context) {
    final _queuesBox = Hive.box<FinampStorableQueueInfo>("Queues");
    var queueMap = _queuesBox.toMap();
    queueMap.remove("latest");
    var queueList = queueMap.values.toList();
    queueList.sort((x, y) => y.creation - x.creation);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.queuesScreen),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(
            left: 0.0, right: 0.0, top: 30.0, bottom: 45.0),
        itemCount: queueList.length,
        itemBuilder: (context, index) {
          return QueueRestoreTile(info: queueList.elementAt(index));
        },
      ),
    );
  }
}
