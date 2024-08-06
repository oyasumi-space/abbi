import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';

class ComputeManager<M, R> {
  final Queue<Future<void> Function()> _taskQueue = Queue();
  bool _isProcessing = false;

  final FutureOr<R> Function(M) task;

  ComputeManager(this.task);

  Future<R> run(M message) {
    final completer = Completer<R>();

    _taskQueue.add(() async {
      try {
        final result = await compute(task, message);
        completer.complete(result);
      } catch (e) {
        completer.completeError(e);
      } finally {
        _processNext();
      }
    });

    if (!_isProcessing) {
      _processNext();
    }

    return completer.future;
  }

  void _processNext() {
    if (_taskQueue.isNotEmpty) {
      _isProcessing = true;
      final task = _taskQueue.removeFirst();
      task();
    } else {
      _isProcessing = false;
    }
  }
}
