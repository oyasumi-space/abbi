import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final fsePod = Provider.family<FileSystemEntity?, String>((ref, path) {
  switch (FileSystemEntity.typeSync(path)) {
    case FileSystemEntityType.file:
      return File(path);
    case FileSystemEntityType.directory:
      return Directory(path);
    default:
      return null;
  }
});

final watchFsePod = Provider.family<void, String>((ref, path) {
  final fse = ref.watch(fsePod(path));
  if (fse is! File) return;
  final sub = fse.watch().listen((_) {
    ref.invalidate(fsePod(path));
  });

  ref.onDispose(sub.cancel);
});

final watchDirPod =
    StreamProvider.family<List<String>, String>((ref, path) async* {
  final dir = Directory(path);
  if (!await dir.exists()) {
    await dir.create(recursive: true);
  }
  yield await dir.list().map((e) => e.path).toList();

  await for (final _ in dir.watch()) {
    yield await dir.list().map((e) => e.path).toList();
  }
});
