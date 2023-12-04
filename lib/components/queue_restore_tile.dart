import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../models/finamp_models.dart';
import '../services/queue_service.dart';
import 'error_snackbar.dart';

class QueueRestoreTile extends StatelessWidget {
  const QueueRestoreTile({Key? key, required this.info}) : super(key: key);

  final FinampStorableQueueInfo info;

  @override
  Widget build(BuildContext context) {
    final _queuesBox = Hive.box<FinampStorableQueueInfo>("Queues");
    final _queueService = GetIt.instance<QueueService>();
    int itemCount = info.queue.length + info.nextUp.length + ((info.currentTrack == null)?0:1);

    return ListTile(
      // TODO attempt to load current track album cover here
      title: Text('Queue contaning $itemCount songs.'),
      subtitle: Text('Created '+DateTime.fromMillisecondsSinceEpoch(info.creation).toString()),// TODO format date better?
      trailing: IconButton(
          icon: const Icon(Icons.delete),//TODO change to button with word restore or better icon
          onPressed: () async {
            var latest = _queuesBox.get("latest");
            if ( latest != null ){
              await _queuesBox.put(latest.creation.toString(), latest);
            }
            await _queueService.loadSavedQueue(info).catchError((x) => errorSnackbar(x,context));
            // TODO add some sort of loading spinner on click
            Navigator.of(context).pop();
          }),
    );
  }
}