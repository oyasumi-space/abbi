import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entity/mod.dart';
import 'available_mods_provider.dart';

final enabledModsProvider = FutureProvider<List<Mod>>((ref) async {
  final mods = await ref.watch(availableModsProvider.future);
  final names = ref.watch(enabledModsNameProvider);
  return mods.where((mod) => names.contains(mod.name)).toList();
});

final enabledModsNameProvider =
    NotifierProvider<EnabledModsNameNotifier, Set<String>>(
        EnabledModsNameNotifier.new);

class EnabledModsNameNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    return {};
  }

  Future<void> change(Mod mod, bool enabled) async {
    if (enabled) {
      final map = await ref.read(availableModsIdMapProvider.future);
      final set = {...state};

      for (final sameIdMod in map[mod.manifest.id] ?? <Mod>[]) {
        set.remove(sameIdMod.name);
      }

      set.add(mod.name);

      state = set;
    } else {
      final set = {...state};
      set.remove(mod.name);
      state = set;
    }
  }
}
