import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as $path;

import 'config_path_pod.dart';
import 'mods_pod.dart';
import 'omori_path_pod.dart';

final installerPod = NotifierProvider(InstallerNotifier.new);

class InstallerNotifier extends Notifier {
  @override
  List build() => [];

  Future<void> install() async {
    final linksTask = SetupTaskModsLink();
    state = [...state, linksTask];
    linksTask.execute(ref);
  }

  Future<void> uninstall() async {
    for (final task in state) {
      await task.rollback(ref);
    }
    state = [];
  }
}

sealed class SetupTask {
  Future<void> execute(Ref ref);
  Future<void> rollback(Ref ref);
}

class SetupTaskModsLink extends SetupTask {
  SetupTaskModsLink();

  final _links = <Link>[];

  @override
  Future<void> execute(Ref ref) async {
    final mods = await ref.read(enabledModsPod.future);
    final modPath = $path.join(ref.read(modsPathPod));
    final a = ref.read(omoriPathPod)!;
    final installPath = $path.join(a, 'www/mods');

    for (final mod in mods) {
      final link = await Link($path.join(installPath, mod.name))
          .create($path.join(modPath, mod.name));
      _links.add(link);
    }
  }

  @override
  Future<void> rollback(Ref ref) async {
    for (final link in _links) {
      await link.delete();
    }
    _links.clear();
  }
}
