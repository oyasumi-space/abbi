import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final watchDirPod = StreamProvider.family<List<FileSystemEntity>, String>(
  (ref, arg) async* {
    final dir = Directory(arg);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    cb(_) async {
      ref.state = await AsyncValue.guard(dir.list().toList);
    }

    final sub = dir.watch().listen(cb);
    ref.onDispose(sub.cancel);
    cb(null);
  },
);

final watchFilePod = StreamProvider.family<File, String>((ref, path) async* {
  final file = File(path);
  cb(_) async {
    ref.state = AsyncValue.data(File(path));
  }

  final sub = file.watch().listen(cb);
  ref.onDispose(sub.cancel);
  cb(null);
});
