import 'dart:async';
import 'dart:convert';

import 'package:background_downloader/background_downloader.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:logging/logging.dart';

import '../models/finamp_models.dart';

part 'backgroundDownloaderStorage.g.dart';

// TODO make this smarter or more integrated?
class IsarPersistentStorage implements PersistentStorage {
  final _isar = GetIt.instance<Isar>();

  @override
  Future<void> storeTaskRecord(TaskRecord record) =>
      _store(IsarTaskDataType.taskRecord, record.taskId, record);

  @override
  Future<TaskRecord?> retrieveTaskRecord(String taskId) =>
      _get(IsarTaskDataType.taskRecord, taskId) as Future<TaskRecord?>;

  @override
  Future<List<TaskRecord>> retrieveAllTaskRecords() =>
      _getAll(IsarTaskDataType.taskRecord)
          .then((value) => value.cast<TaskRecord>());

  @override
  Future<void> removeTaskRecord(String? taskId) =>
      _remove(IsarTaskDataType.taskRecord, taskId);

  @override
  Future<void> storePausedTask(Task task) =>
      _store(IsarTaskDataType.pausedTask, task.taskId, task);

  @override
  Future<Task?> retrievePausedTask(String taskId) =>
      _get(IsarTaskDataType.pausedTask, taskId) as Future<Task?>;

  @override
  Future<List<Task>> retrieveAllPausedTasks() =>
      _getAll(IsarTaskDataType.pausedTask).then((value) => value.cast<Task>());

  @override
  Future<void> removePausedTask(String? taskId) =>
      _remove(IsarTaskDataType.pausedTask, taskId);

  @override
  Future<void> storeResumeData(ResumeData resumeData) =>
      _store(IsarTaskDataType.resumeData, resumeData.taskId, resumeData);

  @override
  Future<ResumeData?> retrieveResumeData(String taskId) =>
      _get(IsarTaskDataType.resumeData, taskId) as Future<ResumeData?>;

  @override
  Future<List<ResumeData>> retrieveAllResumeData() =>
      _getAll(IsarTaskDataType.resumeData)
          .then((value) => value.cast<ResumeData>());

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
    assert(data.runtimeType == type.type);
    String json = jsonEncode(data.toJson());
    await _isar.writeTxn(() async {
      await _isar.isarTaskDatas
          .put(IsarTaskData(IsarTaskData.getHash(type, id), type, json));
    });
  }

  Future<dynamic> _get(IsarTaskDataType type, String id) async {
    var item = await _isar.isarTaskDatas.get(IsarTaskData.getHash(type, id));
    return (item == null) ? null : type.fromJson(jsonDecode(item.data));
  }

  Future<List<dynamic>> _getAll(IsarTaskDataType type) async {
    var items = await _isar.isarTaskDatas.where().typeEqualTo(type).findAll();
    return items.map((e) => e.type.fromJson(jsonDecode(e.data))).toList();
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
class IsarTaskData {
  IsarTaskData(this.id, this.type, this.data);
  Id id;
  String data;
  @Enumerated(EnumType.ordinal)
  @Index()
  IsarTaskDataType type;

  static int getHash(IsarTaskDataType type, String id) {
    return _fastHash(type.name + id);
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
}

enum IsarTaskDataType {
  pausedTask(DownloadTask, DownloadTask.fromJson),
  taskRecord(TaskRecord, TaskRecord.fromJson),
  enqueuedTask(DownloadTask, DownloadTask.fromJson),
  resumeData(ResumeData, ResumeData.fromJson),
  deleteNode(int, _jsonError);

  static void _jsonError(_) => throw "Cannot parse this type from JSON";

  const IsarTaskDataType(this.type, this.fromJson);

  final dynamic Function(Map<String, dynamic>) fromJson;

  final Type type;
}

/// This is a TaskQueue for FileDownloader that stores enqueued tasks in Isar.
/// It is heavily based on FileDownloader's MemoryTaskQueue.
class IsarTaskQueue implements TaskQueue {
  static final _log = Logger('IsarTaskQueue');

  /// Set of tasks that have been enqueued with the FileDownloader
  final activeDownloads = <Task>{}; // by TaskId

  var _readyForEnqueue = Completer();

  final _isar = GetIt.instance<Isar>();

  IsarTaskQueue();

  Future<void> startQueue() async {
    activeDownloads.addAll(
        await FileDownloader().allTasks(includeTasksWaitingToRetry: true));
    _readyForEnqueue.complete();
    advanceQueue();
  }

  /// Add one [task] to the queue and advance the queue if possible
  void add(Task task) {
    String json = jsonEncode(task.toJson());
    IsarTaskDataType type = IsarTaskDataType.enqueuedTask;
    var item =
        IsarTaskData(IsarTaskData.getHash(type, task.taskId), type, json);
    _isar.writeTxn(() async {
      await _isar.isarTaskDatas.put(item);
    });
    advanceQueue();
  }

  /// Advance the queue if possible and ready, no-op if not
  ///
  /// After the enqueue, [advanceQueue] is called again to ensure the
  /// next item in the queue is enqueued, so the queue keeps going until
  /// empty, or until it cannot enqueue another task
  void advanceQueue() {
    if (_readyForEnqueue.isCompleted) {
      final wrappedTask = getNextTask();
      if (wrappedTask == null) {
        return;
      }
      final task =
          IsarTaskDataType.enqueuedTask.fromJson(jsonDecode(wrappedTask.data));
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
  IsarTaskData? getNextTask() {
    // Do not run more than 30 downloads at once.
    if (activeDownloads.length >= 30) {
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

class IsarDeleteBuffer {
  final _isar = GetIt.instance<Isar>();

  var _readyForDelete = Completer();

  IsarDeleteBuffer() {
    _readyForDelete.complete();
  }

  // this should only be called inside an isar write transaction
  Future<void> addAll(Iterable<DownloadStub> stubs) async {
    IsarTaskDataType type = IsarTaskDataType.deleteNode;
    var items = stubs.map((e) => IsarTaskData(
        IsarTaskData.getHash(type, e.isarId.toString()),
        type,
        e.isarId.toString()));
    await _isar.isarTaskDatas.putAll(items.toList());
  }

  Future<void> executeDeletes(Future<void> Function(int) callback) async {
    if (_readyForDelete.isCompleted) {
      var wrappedDeletes = await _isar.isarTaskDatas
          .where()
          .typeEqualTo(IsarTaskDataType.deleteNode)
          .limit(50)
          .findAll();
      if (wrappedDeletes.isEmpty) {
        return;
      }
      try {
        _readyForDelete = Completer();
        unawaited(_readyForDelete.future.then((_) => executeDeletes(callback)));
        var deletes = wrappedDeletes.map((e) => int.parse(e.data));
        List<Future<void>> futures = [];
        for (var delete in deletes) {
          futures.add(callback(delete));
        }
        await Future.wait(futures);
        var deleteIds = wrappedDeletes.map((e) => e.id);
        await _isar.writeTxn(() async {
          await _isar.isarTaskDatas.deleteAll(deleteIds.toList());
        });
        await Future.delayed(const Duration(milliseconds: 50));
      } finally {
        _readyForDelete.complete();
      }
    }
  }
}
