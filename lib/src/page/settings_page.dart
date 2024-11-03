import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../pod/config_pod.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: [
        ListTile(
          title: const Text('Game Path'),
          subtitle: HookConsumer(
            builder: (context, ref, child) {
              final gamePathController = useTextEditingController(
                text: ref.watch(gamePathConfigPod).value ?? '',
              );
              final error = ref.watch(gamePathConfigErrorPod).when(
                    data: (value) => value,
                    loading: () => null,
                    error: (error, _) => error.toString(),
                  );
              return TextField(
                controller: gamePathController,
                decoration: InputDecoration(
                  hintText: 'OMORI Game Path',
                  errorText: error,
                ),
                onChanged: (value) {
                  ref.read(gamePathConfigPod.notifier).set(value);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
