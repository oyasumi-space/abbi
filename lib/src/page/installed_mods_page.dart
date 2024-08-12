import 'dart:io';

import 'package:path/path.dart' as $path;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/enabled_mods_provider.dart';
import '../provider/mods_file_provider.dart';

final installedModsShowErrorProvider = StateProvider<bool>((ref) => false);

class InstalledModsPage extends ConsumerWidget {
  const InstalledModsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (ref.watch(installedModsFseProvider)) {
      case AsyncLoading():
        return const Center(child: CircularProgressIndicator());
      case AsyncError(:final error):
        return Center(child: Text(error.toString()));
      case AsyncData(:final value):
        final fses = value;
        return ListView.builder(
          itemBuilder: (context, i) {
            return _InstalledModsListItemView(fses[i]);
          },
          itemCount: fses.length,
          padding: const EdgeInsets.only(bottom: 80),
        );
    }
  }
}

class _InstalledModsListItemView extends ConsumerWidget {
  const _InstalledModsListItemView(this.fse);

  final FileSystemEntity fse;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabledMods = ref.watch(enabledModsProvider);
    final path = $path.basename(fse.path) + ((fse is Directory) ? '/' : '');
    switch (ref.watch(installedModManifestFamilyProvider(fse))) {
      case AsyncLoading():
        return const Card(
          child: ListTile(
            leading: CircularProgressIndicator(),
          ),
        );
      case AsyncError(:final error):
        return Consumer(
          builder: (context, ref, child) {
            if (ref.watch(installedModsShowErrorProvider)) {
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

      // return Card(child: Center(child: Text(error.toString())));
      case AsyncData(:final value):
        final id = value.id;
        final name = value.name;
        final version = value.version;
        return Card(
          child: ListTile(
            leading: Wrap(
              children: [
                Switch(
                  value: enabledMods.contains(fse),
                  onChanged: (enabled) {
                    ref.read(enabledModsProvider.notifier).change(fse, enabled);
                  },
                ),
              ],
            ),
            title: Text(name),
            subtitle: Text('$id - v$version - $path'),
          ),
        );
    }
  }
}
