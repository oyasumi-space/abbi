import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as $path;

import 'config_pod.dart';
import 'omori_path_pod.dart';

final modsPathPod = NotifierProvider<PathNotifier, String>(
  () => PathNotifier(modsPathConfigPod),
);

class PathNotifier extends Notifier<String> {
  final NotifierProvider<ConfigValueNotifier<String>, String> pod;

  PathNotifier(this.pod);

  @override
  String build() {
    var path = ref.watch(pod);
    final omoriPath = ref.watch(omoriPathProvider);
    if (omoriPath == null) {
      throw Exception('OMORI is not installed');
    }
    path.replaceAll('{omori}', omoriPath);
    path.replaceAll('{abbi}', $path.dirname(Platform.resolvedExecutable));
    return path;
  }
}
