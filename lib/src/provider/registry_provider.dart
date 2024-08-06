import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:win32_registry/win32_registry.dart';

final _key = Registry.openPath(RegistryHive.currentUser,
    path: r'Software\Valve\Steam\Apps\1150690');

final registryOmoriInstalledProvider = NotifierProvider<RegistryNotifier, int?>(
  () => RegistryNotifier('Installed'),
);
final registryOmoriRunningProvider = NotifierProvider<RegistryNotifier, int?>(
  () => RegistryNotifier('Running'),
);

class RegistryNotifier extends Notifier<int?> {
  final String valueName;
  static const _duration = Duration(seconds: 1);

  RegistryNotifier(this.valueName);

  @override
  int? build() {
    final timer = Timer.periodic(_duration, (timer) {
      _fetch();
    });
    ref.onDispose(timer.cancel);
    return null;
  }

  _fetch() {
    state = _key.getValueAsInt(valueName);
  }
}
