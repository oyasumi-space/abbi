import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as $path;

import 'preference_provider.dart';

final omoriExcutableErrorProvider = FutureProvider<String?>((ref) async {
  final path = ref.watch(prefGamePathProvider);
  if (path == null || path.isEmpty) {
    return 'Please set the game path';
  }
  if (!await File($path.join(path, 'OMORI.exe')).exists()) {
    return 'OMORI.exe not found in the game path';
  }
  return null;
});
