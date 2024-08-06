import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../provider/registry_provider.dart';

class RunWithModsFloatingActionButton extends HookConsumerWidget {
  const RunWithModsFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final launching = useState(false);
    final registryOmoriRunning = ref.watch(registryOmoriRunningProvider);
    if (registryOmoriRunning == null) {
      return const FloatingActionButton(
        onPressed: null,
        tooltip: 'Cannot launch OMORI',
        child: Icon(Icons.play_arrow),
      );
    }
    if (registryOmoriRunning == 1) {
      return const FloatingActionButton(
        onPressed: null,
        tooltip: 'OMORI is already running',
        child: Icon(Icons.play_arrow),
      );
    }
    return FloatingActionButton(
      onPressed: launching.value
          ? null
          : () async {
              launching.value = true;
              await launchUrlString('steam://run/1150690');
              await Future.delayed(const Duration(seconds: 3));
              launching.value = false;
            },
      tooltip: 'Play OMORI with Mods',
      child: launching.value
          ? const CircularProgressIndicator()
          : const Icon(Icons.play_arrow),
    );
  }
}
