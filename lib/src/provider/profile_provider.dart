import 'dart:convert' as $convert;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entity/mod.dart';
import '../entity/profile.dart';
import 'available_mods_provider.dart';
import 'preference_provider.dart';

final profilesProvider =
    NotifierProvider<ProfilesNotifier, List<Profile>>(ProfilesNotifier.new);

final currentProfileNameProvider = Provider<String>((ref) {
  return ref.watch(prefCurrentProfileNameProvider) ?? 'Default';
});

final currentProfileProvider = Provider<Profile>((ref) {
  final name = ref.watch(currentProfileNameProvider);
  final profiles = ref.watch(profilesProvider);
  final profile = profiles.where((profile) => profile.name == name).firstOrNull;
  return profile ?? profiles.first;
});

final isAvailableNewProfileNameProvider = Provider<bool>((ref) {
  final name = ref.watch(newProfileNameProvider);
  if (name.isEmpty) return false;
  return ref.watch(profilesProvider).every((profile) => profile.name != name);
});

final newProfileNameProvider = StateProvider<String>((ref) => '');

class ProfilesNotifier extends PreferenceNotifier<List<Profile>, List<String>> {
  ProfilesNotifier() : super('profiles');

  @override
  List<String>? encode(List<Profile> s) {
    return s.map((e) => $convert.jsonEncode(e.toJson())).toList();
  }

  @override
  List<Profile> decode(List<String>? s) {
    return s?.map((e) {
          return Profile.fromJson($convert.jsonDecode(e));
        }).toList() ??
        [Profile(name: 'Default', mods: [])];
  }

  add() {
    final name = ref.read(newProfileNameProvider);
    ref.read(newProfileNameProvider.notifier).state = '';
    set([...state, Profile(name: name, mods: [])]);
  }

  int getProfileIndexByName(String name) {
    return state.indexWhere((profile) => profile.name == name);
  }

  Future<void> changeEnabledCurrentProfileMod(Mod mod, bool enabled) async {
    final profileName = ref.read(currentProfileNameProvider);
    final newProfiles = [...state];
    final index = getProfileIndexByName(profileName);
    final profile = newProfiles[index];
    final newMods = [...profile.mods];
    if (enabled) {
      final idMap = await ref.read(availableModsIdMapProvider.future);
      for (final sameIdMod in idMap[mod.manifest.id] ?? <Mod>[]) {
        newMods.remove(sameIdMod.name);
      }
      newMods.add(mod.name);
    } else {
      newMods.remove(mod.name);
    }
    newProfiles[index] = Profile(name: profileName, mods: newMods);
    set(newProfiles);
  }
}
