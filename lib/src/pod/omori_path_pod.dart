import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as $path;
import 'package:vdf/vdf.dart';

import 'win32_registry_pod.dart';

final omoriPathProvider = Provider<String?>((ref) {
  final steamPath = ref.watch(steamPathPod);
  if (steamPath == null) {
    return null;
  }
  if (!ref.watch(omoriInstalledPod)) {
    return null;
  }
  final lfn = $path.join(steamPath, 'steamapps', 'libraryfolders.vdf');
  final lf = vdfDecode(File(lfn).readAsStringSync())['libraryfolders']
      as Map<dynamic, dynamic>;
  for (final Map<dynamic, dynamic> folders in lf.values) {
    final apps = folders['apps'] as Map<dynamic, dynamic>;
    if (!apps.keys.contains('1150690')) continue;
    var path = folders['path'] as String;
    path = path.replaceAll('\\\\', '\\');
    return $path.join(path, 'steamapps', 'common', 'OMORI');
  }
  return null;
});
