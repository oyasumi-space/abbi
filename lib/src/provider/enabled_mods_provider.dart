import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'available_mods_provider.dart';

final enabledModsProvider =
    NotifierProvider<EnabledModsNotifier, Set<FileSystemEntity>>(
        EnabledModsNotifier.new);

class EnabledModsNotifier extends Notifier<Set<FileSystemEntity>> {
  @override
  Set<FileSystemEntity> build() {
    return {};
  }

  Future<void> change(FileSystemEntity fse, bool enabled) async {
    if (enabled) {
      final manifest =
          await ref.read(availableModManifestFamilyProvider(fse).future);
      final map = await ref.read(availableModsIdMapProvider.future);
      final set = {...state, fse};
      for (final cfse in map[manifest.id] ?? {}) {
        if (fse == cfse) continue;
        set.remove(cfse);
      }
      state = set;
    } else {
      final set = {...state};
      set.remove(fse);
      state = set;
    }
  }
}
