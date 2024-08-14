import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as $path;

import 'enabled_mods_provider.dart';
import 'preference_provider.dart';

final linksProvider =
    NotifierProvider<LinksNotifier, List<FileSystemEntity>>(LinksNotifier.new);

class LinksNotifier extends Notifier<List<FileSystemEntity>> {
  @override
  List<FileSystemEntity> build() {
    return [];
  }

  Future<void> createLinks() async {
    final gamePath = ref.read(prefGamePathProvider);
    if (gamePath == null) throw Exception('Game path not set');
    List<FileSystemEntity> links = [];
    for (final mod in await ref.read(enabledModsProvider.future)) {
      // if (fse is! File) continue; // todo directory mods
      links.add(await Link($path.join(gamePath, 'www/mods', mod.name))
          .create(mod.fse.path));
    }
    state = [...state, ...links];
  }

  Future<void> delete() async {
    for (final fse in state) {
      if (fse is Link) {
        await fse.delete();
      }
      if (fse is Directory) {
        await fse.delete(recursive: true);
      }
    }
    state = [];
  }
}
