import 'dart:async';
import 'dart:convert';

import 'package:background_downloader/background_downloader.dart';
import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/services/isar_downloads.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:logging/logging.dart';

import '../models/finamp_models.dart';
import 'finamp_settings_helper.dart';

part 'backgroundDownloaderStorage.g.dart';

class IsarPersistentStorage implements PersistentStorage {
  final _isar = GetIt.instance<Isar>();

  @override
  Future<void> storeTaskRecord(TaskRecord record) =>
      _store(IsarTaskDataType.taskRecord, record.taskId, record);

  @override
  Future<TaskRecord?> retrieveTaskRecord(String taskId) =>
      _get(IsarTaskDataType.taskRecord, taskId);

  @override
  Future<List<TaskRecord>> retrieveAllTaskRecords() =>
      _getAll(IsarTaskDataType.taskRecord);

  @override
  Future<void> removeTaskRecord(String? taskId) =>
      _remove(IsarTaskDataType.taskRecord, taskId);

  @override
  Future<void> storePausedTask(Task task) =>
      _store(IsarTaskDataType.pausedTask, task.taskId, task);

  @override
  Future<Task?> retrievePausedTask(String taskId) =>
      _get(IsarTaskDataType.pausedTask, taskId);

  @override
  Future<List<Task>> retrieveAllPausedTasks() =>
      _getAll(IsarTaskDataType.pausedTask);

  @override
  Future<void> removePausedTask(String? taskId) =>
      _remove(IsarTaskDataType.pausedTask, taskId);

  @override
  Future<void> storeResumeData(ResumeData resumeData) =>
      _store(IsarTaskDataType.resumeData, resumeData.taskId, resumeData);

  @override
  Future<ResumeData?> retrieveResumeData(String taskId) =>
      _get(IsarTaskDataType.resumeData, taskId);

  @override
  Future<List<ResumeData>> retrieveAllResumeData() =>
      _getAll(IsarTaskDataType.resumeData);

  @override
  Future<void> removeResumeData(String? taskId) =>
      _remove(IsarTaskDataType.resumeData, taskId);

  @override
  (String, int) get currentDatabaseVersion => ("FinampIsar", 1);

  @override
  // This should come from finamp settings if migration needed
  Future<(String, int)> get storedDatabaseVersion =>
      Future.value(("FinampIsar", 1));

  @override
  Future<void> initialize() async {
    // Isar database gets opened by main
  }

  Future<void> _store(IsarTaskDataType type, String id, dynamic data) async {
    type.check(data); // Verify the data object has the correct type
    String json = jsonEncode(data.toJson());
    await _isar.writeTxn(() async {
      await _isar.isarTaskDatas
          .put(IsarTaskData(IsarTaskData.getHash(type, id), type, json, 0));
    });
  }

  Future<T?> _get<T>(IsarTaskDataType<T> type, String id) async {
    var item = await _isar.isarTaskDatas.get(IsarTaskData.getHash(type, id));
    return (item == null) ? null : type.fromJson(jsonDecode(item.jsonData));
  }

  Future<List<T>> _getAll<T>(IsarTaskDataType<T> type) async {
    var items = await _isar.isarTaskDatas.where().typeEqualTo(type).findAll();
    return items.map((e) => type.fromJson(jsonDecode(e.jsonData))).toList();
  }

  Future<void> _remove(IsarTaskDataType type, String? id) async {
    await _isar.writeTxn(() async {
      if (id != null) {
        await _isar.isarTaskDatas.delete(IsarTaskData.getHash(type, id));
      } else {
        await _isar.isarTaskDatas.where().typeEqualTo(type).deleteAll();
      }
    });
  }
}

@collection

/// A wrapper for storing various types of download related data in isar as JSON.
/// Do not confuse the id of this type with the ids that the content types have.
/// They will not match.
class IsarTaskData<T> {
  IsarTaskData(this.id, this.type, this.jsonData, this.age);
  final Id id;
  String jsonData;
  @Enumerated(EnumType.ordinal)
  @Index()
  final IsarTaskDataType<T> type;
  // This allows prioritization and uniqueness checking by delete buffer
  final int age;

  static int globalAge = 0;

  IsarTaskData.build(String stringId, this.type, T data)
      : id = IsarTaskData.getHash(type, stringId),
        jsonData = _toJson(data),
        age = globalAge++;

  static int getHash(IsarTaskDataType type, String id) {
    return _fastHash(type.name + id);
  }

  @ignore
  T get data => type.fromJson(jsonDecode(jsonData));
  set data(T item) => jsonData = _toJson(item);

  static String _toJson(dynamic item) {
    switch (item) {
      case int id:
        return jsonEncode({"id": id});
      case (DownloadStub stub, bool required, String? viewId):
        return jsonEncode({"stub": stub, "required": required, "view": viewId});
      case _:
        return jsonEncode((item as dynamic).toJson());
    }
  }

  /// FNV-1a 64bit hash algorithm optimized for Dart Strings
  /// Provided by Isar documentation
  static int _fastHash(String string) {
    var hash = 0xcbf29ce484222325;

    var i = 0;
    while (i < string.length) {
      final codeUnit = string.codeUnitAt(i++);
      hash ^= codeUnit >> 8;
      hash *= 0x100000001b3;
      hash ^= codeUnit & 0xFF;
      hash *= 0x100000001b3;
    }

    return hash;
  }

  @override
  bool operator ==(Object other) {
    return other is IsarTaskData && other.id == id;
  }

  @override
  @ignore
  int get hashCode => id;
}

/// Type enum for IsarTaskData
/// Enumerated by Isar, do not modify existing entries.
enum IsarTaskDataType<T> {
  pausedTask<Task>(Task.createFromJson),
  taskRecord<TaskRecord>(TaskRecord.fromJson),
  enqueuedTask<Task>(Task.createFromJson),
  resumeData<ResumeData>(ResumeData.fromJson),
  deleteNode<int>(_deleteFromJson),
  syncNode<(DownloadStub, bool, String?)>(_syncFromJson);

  const IsarTaskDataType(this.fromJson);

  static int _deleteFromJson(Map<String, dynamic> map) {
    return map["id"];
  }

  static (DownloadStub, bool, String?) _syncFromJson(Map<String, dynamic> map) {
    return (DownloadStub.fromJson(map["stub"]), map["required"], map["view"]);
  }

  final T Function(Map<String, dynamic>) fromJson;
  void check(T data) {}
}

/// This is a TaskQueue for FileDownloader that stores enqueued tasks in Isar.
/// It is heavily based on FileDownloader's MemoryTaskQueue.
class IsarTaskQueue implements TaskQueue {
  static final _log = Logger('IsarTaskQueue');

  /// Set of tasks that are believed to be actively running
  final activeDownloads = <Task>{}; // by TaskId

  var _readyForEnqueue = Completer();

  final _isar = GetIt.instance<Isar>();

  /// Initialize the queue and start stored downloads.
  /// Should only be called after background_downloader and IsarDownloads are
  /// fully set up.
  Future<void> startQueue() async {
    activeDownloads.addAll(
        await FileDownloader().allTasks(includeTasksWaitingToRetry: true));
    FinampSettingsHelper.finampSettingsListener.addListener(() {
      if (!FinampSettingsHelper.finampSettings.isOffline) {
        advanceQueue();
      }
    });
    _readyForEnqueue.complete();
    advanceQueue();
  }

  /// Add one [task] to the queue and advance the queue if possible
  void add(Task task) {
    String json = jsonEncode(task.toJson());
    IsarTaskDataType type = IsarTaskDataType.enqueuedTask;
    var item =
        IsarTaskData(IsarTaskData.getHash(type, task.taskId), type, json, 0);
    _isar.writeTxn(() async {
      await _isar.isarTaskDatas.put(item);
    });
    advanceQueue();
  }

  /// Advance the queue if possible and ready, no-op if not.
  /// Will recurse to enqueue all items possible at this time.
  /// Will enqueue 20 downloads per second at most.
  void advanceQueue() {
    if (_readyForEnqueue.isCompleted) {
      final wrappedTask = getNextTask();
      final isarDownloads = GetIt.instance<IsarDownloads>();
      if (wrappedTask == null ||
          !isarDownloads.allowDownloads ||
          FinampSettingsHelper.finampSettings.isOffline) {
        return;
      }
      final Task originalTask = IsarTaskDataType.enqueuedTask
          .fromJson(jsonDecode(wrappedTask.jsonData));
      final task = originalTask.copyWith(
          requiresWiFi:
              FinampSettingsHelper.finampSettings.requireWifiForDownloads);
      _readyForEnqueue = Completer();
      activeDownloads.add(task);
      FileDownloader().enqueue(task).then((success) async {
        if (!success) {
          _log.warning(
              'TaskId ${task.taskId} did not enqueue successfully and will be ignored');
        }
        // Do not enqueue more than 20 items per second
        await Future.delayed(const Duration(milliseconds: 50));
        _readyForEnqueue.complete();
      });
      unawaited(_readyForEnqueue.future.then((_) => advanceQueue()));
    }
  }

  /// Get the next waiting task from the queue, or null if not available
  /// Will not allow more than 30 downloads to be active at once.
  IsarTaskData? getNextTask() {
    // Do not run more than 30 downloads at once.
    if (activeDownloads.length >=
        FinampSettingsHelper.finampSettings.maxConcurrentDownloads) {
      return null;
    }
    return _isar.isarTaskDatas
        .where()
        .typeEqualTo(IsarTaskDataType.enqueuedTask)
        .filter()
        .allOf(
            activeDownloads,
            (q, element) => q.not().idEqualTo(IsarTaskData.getHash(
                IsarTaskDataType.enqueuedTask, element.taskId)))
        .findFirstSync();
  }

  /// Returns true if the internal queue state and downloader state match
  /// the state of the given item.  Download state should be reset if false.
  Future<bool> validateQueued(DownloadItem item) async {
    // Note: IsarTaskData.getHash wants task id, which is item isarId as a string
    String taskId = item.isarId.toString();
    if (await _isar.isarTaskDatas
            .get(IsarTaskData.getHash(IsarTaskDataType.enqueuedTask, taskId)) ==
        null) {
      return false;
    }
    bool isThoughtActive = activeDownloads
        .any((element) => element.taskId == item.isarId.toString());
    if (item.state == DownloadItemState.enqueued) {
      return !isThoughtActive;
    } else if (item.state == DownloadItemState.downloading) {
      if (isThoughtActive) {
        if (await FileDownloader().taskForId(taskId) == null) {
          return false;
        }
        return true;
      }
      return false;
    } else {
      return false;
    }
  }

  /// Remove a download task from this queue and cancel any active download.
  Future<void> remove(DownloadStub stub) async {
    String taskId = stub.isarId.toString();
    await _isar.writeTxn(() async {
      await _isar.isarTaskDatas
          .delete(IsarTaskData.getHash(IsarTaskDataType.enqueuedTask, taskId));
    });
    activeDownloads.removeWhere((element) => element.taskId == taskId);
    await FileDownloader().cancelTaskWithId(taskId);
  }

  @override

  /// Called by FileDownloader whenever a download completes.
  /// Remove the completed task and advance the queue.
  void taskFinished(Task task) {
    _isar.writeTxn(() async {
      await _isar.isarTaskDatas.delete(
          IsarTaskData.getHash(IsarTaskDataType.enqueuedTask, task.taskId));
    }).then((_) {
      activeDownloads.remove(task);
      advanceQueue();
    });
  }
}

/// A class for storing pending deletes in Isar.  This is used to save unlinked
/// but not yet deleted nodes so that they always get cleaned up, even if the
/// app suddenly shuts down.
class IsarDeleteBuffer {
  final _isar = GetIt.instance<Isar>();

  Set<int> activeDeletes = {};
  Completer<void>? callbacksComplete;

  IsarDeleteBuffer(this.callback) {
    IsarTaskData.globalAge = _isar.isarTaskDatas
            .where()
            .typeEqualTo(type)
            .sortByAgeDesc()
            .findFirstSync()
            ?.age ??
        0;
  }

  final type = IsarTaskDataType.deleteNode;
  final Future<void> Function(int) callback;

  final int _batchSize = 10;

  /// Add nodes to be deleted at a later time.  This should
  /// be called before nodes are unlinked to guarantee nodes cannot be lost.
  /// This should only be called inside an isar write transaction
  Future<void> addAll(Iterable<DownloadStub> stubs) async {
    var items = stubs
        .map((e) => IsarTaskData.build(e.isarId.toString(), type, e.isarId))
        .toList();
    await _isar.isarTaskDatas.putAll(items);
  }

  /// Execute all pending deletes.
  Future<void> executeDeletes() async {
    if (callbacksComplete != null) {
      return callbacksComplete!.future;
    }
    try {
      activeDeletes.clear();
      callbacksComplete = Completer();
      unawaited(_advanceQueue());
      await callbacksComplete!.future;
    } finally {
      callbacksComplete = null;
    }
  }

  Future<void> _advanceQueue() async {
    List<IsarTaskData<dynamic>> wrappedDeletes = [];
    while (true) {
      if (activeDeletes.length >=
              FinampSettingsHelper.finampSettings.downloadWorkers *
                  _batchSize ||
          callbacksComplete == null) {
        return;
      }
      try {
        // This must be synchronous or we can get more than 5 threads and multiple threads
        // processing the same item
        wrappedDeletes = _isar.isarTaskDatas
            .where()
            .typeEqualTo(type)
            .filter()
            .allOf(activeDeletes, (q, value) => q.not().idEqualTo(value))
            .sortByAge() // Try to process oldest deletes first as they are more likely to be deletable
            .limit(_batchSize)
            .findAllSync();
        if (wrappedDeletes.isEmpty) {
          if (activeDeletes.isEmpty && callbacksComplete != null) {
            callbacksComplete!.complete(null);
          }
          return;
        }
        activeDeletes.addAll(wrappedDeletes.map((e) => e.id));
        // Once we've claimed our item, try to launch another worker in case we have <5.
        unawaited(_advanceQueue());
        for (var delete in wrappedDeletes) {
          try {
            await callback(delete.data);
          } catch (e) {
            // we don't expect errors here, _syncDelete should already be catching everything
            // mark node as complete and continue
            GlobalSnackbar.error(e);
          }
        }

        await _isar.writeTxn(() async {
          var canonDeletes = await _isar.isarTaskDatas
              .getAll(wrappedDeletes.map((e) => e.id).toList());
          List<int> removable = [];
          // Items with unexpected ages have been re-added and need reprocessing
          for (int i = 0; i < canonDeletes.length; i++) {
            if (wrappedDeletes[i].age == canonDeletes[i]?.age) {
              removable.add(wrappedDeletes[i].id);
            }
          }
          await _isar.isarTaskDatas.deleteAll(removable);
        });
      } finally {
        var currentIds = wrappedDeletes.map((e) => e.id);
        activeDeletes.removeAll(currentIds);
      }
    }
  }
}

/// A class for storing pending syncs in Isar.  This allows syncing to resume
/// in the event of an app shutdown.  Completed lists are stored in memory,
/// so some nodes may get re-synced unnecessarily after an unexpected reboot
/// but this should have minimal impact.
// TODO add sync/delete queue size on downloads screen
class IsarSyncBuffer {
  final _isar = GetIt.instance<Isar>();

  /// Currently processing syncs.  Will be null if no syncs are executing.
  final Set<int> activeSyncs = {};
  final Set<DownloadStub> requireCompleted = {};
  final Set<DownloadStub> infoCompleted = {};
  Completer<void>? callbacksComplete;

  final int _batchSize = 10;

  IsarSyncBuffer(this.callback);

  final type = IsarTaskDataType.syncNode;
  final Future<void> Function(
          DownloadStub, bool, Set<DownloadStub>, Set<DownloadStub>, String?)
      callback;

  /// Add nodes to be synced at a later time.
  Future<void> addAll(Iterable<DownloadStub> required,
      Iterable<DownloadStub> info, String? viewId) async {
    var items = required
        .map((e) =>
            IsarTaskData.build("required ${e.isarId}", type, (e, true, viewId)))
        .toList();
    items.addAll(info.map((e) =>
        IsarTaskData.build("info ${e.isarId}", type, (e, false, viewId))));
    await _isar.writeTxn(() async {
      await _isar.isarTaskDatas.putAll(items);
    });
  }

  /// Execute all pending syncs.
  Future<void> executeSyncs() async {
    if (callbacksComplete != null) {
      return callbacksComplete!.future;
    }
    try {
      requireCompleted.clear();
      infoCompleted.clear();
      activeSyncs.clear();
      callbacksComplete = Completer();
      unawaited(_advanceQueue());
      await callbacksComplete!.future;
    } finally {
      callbacksComplete = null;
    }
  }

  Future<void> _advanceQueue() async {
    List<IsarTaskData<dynamic>> wrappedSyncs = [];
    while (true) {
      if (activeSyncs.length >=
              FinampSettingsHelper.finampSettings.downloadWorkers *
                  _batchSize ||
          callbacksComplete == null) {
        return;
      }
      try {
        // This must be synchronous or we can get more than 5 threads and multiple threads
        // processing the same item
        wrappedSyncs = _isar.isarTaskDatas
            .where()
            .typeEqualTo(type)
            .filter()
            .allOf(activeSyncs, (q, value) => q.not().idEqualTo(value))
            .limit(_batchSize)
            .findAllSync();
        if (wrappedSyncs.isEmpty) {
          if (activeSyncs.isEmpty && callbacksComplete != null) {
            callbacksComplete!.complete(null);
          }
          return;
        }
        activeSyncs.addAll(wrappedSyncs.map((e) => e.id));
        // Once we've claimed our item, try to launch another worker in case we have <5.
        unawaited(_advanceQueue());
        for (var wrappedSync in wrappedSyncs) {
          var sync = wrappedSync.data;
          try {
            await callback(
                sync.$1, sync.$2, requireCompleted, infoCompleted, sync.$3);
          } catch (e) {
            // we don't expect errors here, _syncDownload should already be catching everything
            // mark node as complete and continue
            GlobalSnackbar.error(e);
          }
        }

        await _isar.writeTxn(() async {
          await _isar.isarTaskDatas
              .deleteAll(wrappedSyncs.map((e) => e.id).toList());
        });
      } finally {
        activeSyncs.removeAll(wrappedSyncs.map((e) => e.id));
      }
    }
  }
}
