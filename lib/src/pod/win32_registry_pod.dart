import 'dart:core';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:win32_registry/win32_registry.dart';

final steamPathPod =
    NotifierProvider<Win32RegistryPod, String?>(() => Win32RegistryPod(
          Registry.currentUser.createKey(r'SOFTWARE\Valve\Steam'),
          'SteamPath',
        ));

final omoriRunningPod = Provider<bool>((ref) {
  return ref.watch(_omoriRunningPod) == '1';
});

final _omoriRunningPod =
    NotifierProvider<Win32RegistryPod, String?>(() => Win32RegistryPod(
          Registry.currentUser.createKey(r'SOFTWARE\Valve\Steam\Apps\1150690'),
          'Running',
        ));

final omoriInstalledPod = Provider<bool>((ref) {
  return ref.watch(_omoriInstalledPod) == '1';
});

final _omoriInstalledPod =
    NotifierProvider<Win32RegistryPod, String?>(() => Win32RegistryPod(
          Registry.currentUser.createKey(r'SOFTWARE\Valve\Steam\Apps\1150690'),
          'Installed',
        ));

class Win32RegistryPod extends Notifier<String?> {
  final RegistryKey key;
  final String name;

  Win32RegistryPod(this.key, this.name);

  @override
  String? build() {
    final sub = key.onChanged().listen((event) {
      state = _get();
    });
    ref.onDispose(sub.cancel);
    return _get();
  }

  String? _get() {
    final value = key.getValue(name);
    print(value);
    if (value == null) {
      return null;
    }
    switch (value) {
      case StringValue(:final value):
        return value;
      case Int32Value(:final value):
        return value.toString();
      default:
        throw Exception('Unknown value type by Win32RegistryPod');
    }
  }
}
