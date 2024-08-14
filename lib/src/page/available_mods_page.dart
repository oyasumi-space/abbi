import 'dart:io';

import 'package:path/path.dart' as $path;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entity/mod.dart';
import '../provider/available_mods_provider.dart';
import '../provider/enabled_mods_provider.dart';

final availableModsShowErrorProvider = StateProvider<bool>((ref) => false);

class AvailableModsPage extends ConsumerWidget {
  const AvailableModsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (ref.watch(availableModsProvider)) {
      case AsyncLoading():
        return const Center(child: CircularProgressIndicator());
      case AsyncError(:final error):
        return Center(child: Text(error.toString()));
      case AsyncData(:final value):
        final fses = value;
        return ListView.builder(
          itemBuilder: (context, i) {
            return _AvailableModsListItemView(fses[i]);
          },
          itemCount: fses.length,
          padding: const EdgeInsets.only(bottom: 80),
        );
    }
  }
}

class _AvailableModsListItemView extends ConsumerWidget {
  const _AvailableModsListItemView(this.mod);

  final Mod mod;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabledModsName = ref.watch(enabledModsNameProvider);
    final path = $path.basename(mod.fse.path);
    switch (ref.watch(availableModManifestFamilyProvider(mod.fse))) {
      case AsyncLoading():
        return const Card(
          child: ListTile(
            leading: CircularProgressIndicator(),
          ),
        );
      case AsyncError(:final error):
        return Consumer(
          builder: (context, ref, child) {
            if (ref.watch(availableModsShowErrorProvider)) {
              return Card(
                child: ListTile(
                  title: Text(path),
                  subtitle: Text('$error'),
                  leading: const Icon(Icons.error),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        );

      case AsyncData(:final value):
        final id = value.id;
        final name = value.name;
        final version = value.version;
        final isFile = mod.fse is File;
        final subtitle =
            '$id - v$version - ${isFile ? '📑' : '📂'}${mod.name}${isFile ? '' : '/'}';
        return Card(
          child: ListTile(
            leading: Wrap(
              children: [
                Switch(
                  value: enabledModsName.contains(mod.name),
                  onChanged: (enabled) {
                    ref
                        .read(enabledModsNameProvider.notifier)
                        .change(mod, enabled);
                  },
                ),
              ],
            ),
            title: Text(name),
            subtitle: Text(subtitle),
          ),
        );
    }
  }
}
