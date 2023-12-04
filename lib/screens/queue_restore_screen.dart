
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';

import '../components/queue_restore_tile.dart';
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
    queueList.sort((x,y)=>x.creation-y.creation);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.queuesScreen),
      ),
      body: Scrollbar(
        child: ListView.builder(
          itemCount: queueList.length,
          reverse: true,
          itemBuilder: (context, index) {
            return QueueRestoreTile(
                info: queueList.reversed.elementAt(index));
          },
        ),
      ),
    );
  }
}
