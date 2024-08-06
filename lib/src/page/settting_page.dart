import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../provider/preference_provider.dart';

class SettingPage extends HookConsumerWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefModsPath = useTextEditingController();
    prefModsPath.text = ref.watch(prefModsPathProvider) ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: prefModsPath,
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(prefModsPathProvider.notifier).set(prefModsPath.text);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
