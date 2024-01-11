import 'dart:async';
import 'dart:convert';
import 'dart:io';

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
    _isar.writeTxnSync(() {
      _isar.isarTaskDatas
          .putSync(IsarTaskData(IsarTaskData.getHash(type, id), type, json, 0));
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
    _isar.writeTxnSync(() {
      if (id != null) {
        _isar.isarTaskDatas.deleteSync(IsarTaskData.getHash(type, id));
      } else {
        _isar.isarTaskDatas.where().typeEqualTo(type).deleteAllSync();
      }
    });
  }
}

/// A wrapper for storing various types of download related data in isar as JSON.
/// Do not confuse the id of this type with the ids that the content types have.
/// They will not match.
@collection
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

  IsarTaskData.build(String stringId, this.type, T data, {int? age})
      : id = IsarTaskData.getHash(type, stringId),
        jsonData = _toJson(data),
        age = age ?? globalAge++;

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
      case (int itemIsarId, bool required, String? viewId):
        return jsonEncode(
            {"stubId": itemIsarId, "required": required, "view": viewId});
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
  syncNode<(int, bool, String?)>(_syncFromJson);

  const IsarTaskDataType(this.fromJson);

  static int _deleteFromJson(Map<String, dynamic> map) {
    return map["id"];
  }

  static (int, bool, String?) _syncFromJson(Map<String, dynamic> map) {
    return (map["stubId"], map["required"], map["view"]);
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

  final type = IsarTaskDataType.enqueuedTask;

  Completer<void>? _readyForEnqueue;

  final _isar = GetIt.instance<Isar>();

  /// Initialize the queue and start stored downloads.
  /// Should only be called after background_downloader and IsarDownloads are
  /// fully set up.
  Future<void> startQueue(
      Future<void> Function(List<int> itemIds) markComplete) async {
    activeDownloads.addAll(
        await FileDownloader().allTasks(includeTasksWaitingToRetry: true));
    FinampSettingsHelper.finampSettingsListener.addListener(() {
      if (!FinampSettingsHelper.finampSettings.isOffline) {
        executeSyncs();
      }
    });
    List<int> taskIds = [];
    List<int> itemIds = [];
    for (var wrappedTask in _isar.isarTaskDatas
        .where()
        .typeEqualTo(IsarTaskDataType.enqueuedTask)
        .findAllSync()) {
      final Task task = type.fromJson(jsonDecode(wrappedTask.jsonData));
      if (File(await task.filePath()).existsSync()) {
        activeDownloads.remove(task);
        taskIds.add(wrappedTask.id);
        itemIds.add(int.parse(task.taskId));
      }
    }
    _isar.writeTxnSync(() {
      markComplete(itemIds);
      _isar.isarTaskDatas.deleteAllSync(taskIds);
    });
    unawaited(executeSyncs());
  }

  /// Add one [task] to the queue and advance the queue if possible
  /// Must be called inside an isar write transaction.
  void add(Task task) {
    String json = jsonEncode(task.toJson());
    var item =
        IsarTaskData(IsarTaskData.getHash(type, task.taskId), type, json, 0);
    _isar.isarTaskDatas.putSync(item);
  }

  /// Execute all pending downloads.
  Future<void> executeSyncs() async {
    if (_readyForEnqueue != null) {
      return _readyForEnqueue!.future;
    }
    try {
      activeDownloads.clear();
      _readyForEnqueue = Completer();
      unawaited(_advanceQueue());
      await _readyForEnqueue!.future;
    } finally {
      _readyForEnqueue = null;
    }
  }

  /// Advance the queue if possible and ready, no-op if not.
  /// Will recurse to enqueue all items possible at this time.
  /// Will enqueue 20 downloads per second at most.
  Future<void> _advanceQueue() async {
    final isarDownloads = GetIt.instance<IsarDownloads>();
    try {
      while (true) {
        var nextTasks = _isar.isarTaskDatas
            .where()
            .typeEqualTo(type)
            .filter()
            .allOf(
                activeDownloads,
                (q, element) => q
                    .not()
                    .idEqualTo(IsarTaskData.getHash(type, element.taskId)))
            .limit(20)
            .findAllSync();
        if (nextTasks.isEmpty ||
            !isarDownloads.allowDownloads ||
            FinampSettingsHelper.finampSettings.isOffline) {
          return;
        }
        var tasks = nextTasks.map((e) => type.fromJson(jsonDecode(e.jsonData)));
        for (var task in tasks) {
          while (activeDownloads.length >=
              FinampSettingsHelper.finampSettings.maxConcurrentDownloads) {
            await Future.delayed(const Duration(milliseconds: 500));
          }
          activeDownloads.add(task);
          final newTask = task.copyWith(
              requiresWiFi:
                  FinampSettingsHelper.finampSettings.requireWifiForDownloads);
          bool success = await FileDownloader().enqueue(newTask);
          if (!success) {
            // We currently have no way to recover here.  The user must re-sync to clear
            // the stuck download.
            _log.severe(
                "Task ${task.displayName} failed to enqueue with background_downloader.");
          }
          await Future.delayed(const Duration(milliseconds: 20));
        }
      }
    } finally {
      _readyForEnqueue?.complete();
    }
  }

  /// Returns true if the internal queue state and downloader state match
  /// the state of the given item.  Download state should be reset if false.
  Future<bool> validateQueued(DownloadItem item) async {
    // Note: IsarTaskData.getHash wants task id, which is item isarId as a string
    String taskId = item.isarId.toString();
    if (_isar.isarTaskDatas.getSync(
            IsarTaskData.getHash(IsarTaskDataType.enqueuedTask, taskId)) ==
        null) {
      return false;
    }
    bool isThoughtActive = activeDownloads
        .any((element) => element.taskId == item.isarId.toString());
    if (item.state == DownloadItemState.enqueued) {
      return !isThoughtActive;
    } else if (item.state == DownloadItemState.downloading) {
      if (isThoughtActive) {
        var active =
            await FileDownloader().allTasks(includeTasksWaitingToRetry: true);
        // TODO re-enqueue just in case and return?
        return active.where((element) => element.taskId == taskId).isNotEmpty;
      }
      return false;
    } else {
      return false;
    }
  }

  /// Remove a download task from this queue and cancel any active download.
  Future<void> remove(DownloadStub stub) async {
    String taskId = stub.isarId.toString();
    _isar.writeTxnSync(() {
      _isar.isarTaskDatas.deleteSync(
          IsarTaskData.getHash(IsarTaskDataType.enqueuedTask, taskId));
    });
    activeDownloads.removeWhere((element) => element.taskId == taskId);
    if (activeDownloads
        .where((element) => element.taskId == taskId)
        .isNotEmpty) {
      await FileDownloader().cancelTaskWithId(taskId);
    }
  }

  @override

  /// Called by FileDownloader whenever a download completes.
  /// Remove the completed task and advance the queue.
  void taskFinished(Task task) {
    _isar.writeTxnSync(() {
      _isar.isarTaskDatas.deleteSync(
          IsarTaskData.getHash(IsarTaskDataType.enqueuedTask, task.taskId));
    });
    activeDownloads.remove(task);
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
  void addAll(Iterable<int> isarIds) {
    var items =
        isarIds.map((e) => IsarTaskData.build(e.toString(), type, e)).toList();
    _isar.isarTaskDatas.putAllSync(items);
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
          assert(_isar.isarTaskDatas.where().typeEqualTo(type).countSync() >=
              activeDeletes.length);
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
            await Future.wait([
              callback(delete.data),
              Future.delayed(const Duration(milliseconds: 200))
            ]);
          } catch (e) {
            // we don't expect errors here, _syncDelete should already be catching everything
            // mark node as complete and continue
            GlobalSnackbar.error(e);
          }
        }

        _isar.writeTxnSync(() {
          var canonDeletes = _isar.isarTaskDatas
              .getAllSync(wrappedDeletes.map((e) => e.id).toList());
          List<int> removable = [];
          // Items with unexpected ages have been re-added and need reprocessing
          for (int i = 0; i < canonDeletes.length; i++) {
            if (wrappedDeletes[i].age == canonDeletes[i]?.age) {
              removable.add(wrappedDeletes[i].id);
            }
          }
          _isar.isarTaskDatas.deleteAllSync(removable);
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
class IsarSyncBuffer {
  final _isar = GetIt.instance<Isar>();

  /// Currently processing syncs.  Will be null if no syncs are executing.
  final Set<int> activeSyncs = {};
  final Set<int> requireCompleted = {};
  final Set<int> infoCompleted = {};
  Completer<void>? callbacksComplete;

  final int _batchSize = 10;

  IsarSyncBuffer(this.callback);

  final type = IsarTaskDataType.syncNode;
  final Future<void> Function(DownloadStub, bool, Set<int>, Set<int>, String?)
      callback;

  /// Add nodes to be synced at a later time.
  /// Must be called inside an Isar write transaction.
  void addAll(Iterable<DownloadStub> required, Iterable<DownloadStub> info,
      String? viewId) {
    var items = required
        .map((e) => IsarTaskData.build(
            "required ${e.isarId}", type, (e.isarId, true, viewId),
            age: 0))
        .toList();
    items.addAll(info.map((e) => IsarTaskData.build(
        "info ${e.isarId}", type, (e.isarId, false, viewId),
        age: 1)));
    _isar.isarTaskDatas.putAllSync(items);
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
    // TODO stop sync while offline?
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
            .sortByAge() // Prioritize required nodes
            .limit(_batchSize)
            .findAllSync();
        if (wrappedSyncs.isEmpty) {
          assert(_isar.isarTaskDatas.where().typeEqualTo(type).countSync() >=
              activeSyncs.length);
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
            var item = _isar.downloadItems.getSync(sync.$1);
            if (item != null) {
              await Future.wait([
                callback(
                    item, sync.$2, requireCompleted, infoCompleted, sync.$3),
                Future.delayed(const Duration(milliseconds: 50))
              ]);
            }
          } catch (e) {
            // we don't expect errors here, _syncDownload should already be catching everything
            // mark node as complete and continue
            GlobalSnackbar.error(e);
          }
        }

        _isar.writeTxnSync(() {
          _isar.isarTaskDatas
              .deleteAllSync(wrappedSyncs.map((e) => e.id).toList());
        });
      } finally {
        activeSyncs.removeAll(wrappedSyncs.map((e) => e.id));
      }
    }
  }
}
