import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../pod/mods_pod.dart';
import '../pod/profile_pod.dart';

class ModsPage extends ConsumerWidget {
  const ModsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modsNameAsync = ref.watch(availableModsNamePod);
    switch (modsNameAsync) {
      case AsyncData(:final value, :final isRefreshing):
        if (isRefreshing) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.separated(
          itemBuilder: (context, index) {
            final name = value[index];
            return _ModsPageItem(name);
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: value.length,
        );
      case AsyncLoading():
        return const Center(child: CircularProgressIndicator());
      case AsyncError(:final error, :final stackTrace):
        debugPrintStack(stackTrace: stackTrace);
        return Center(child: Text("Error: $error"));
    }
  }
}

class _ModsPageItem extends ConsumerWidget {
  const _ModsPageItem(this.name);

  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modAsync = ref.watch(modFamilyPod(name));
    final profileFile = ref.watch(currentProfileFilePod);
    final profileAsync = ref.watch(profilePod(profileFile));
    final mods = profileAsync.value?.mods ?? [];
    switch (modAsync) {
      case AsyncData(:final value):
        final mod = value;
        final manifest = mod.manifest;
        var subtitle = '${manifest.id} - v${manifest.version}';
        subtitle += ' - ${mod.typeEmoji}${mod.name}';
        if (mod.type == FileSystemEntityType.directory) subtitle += '/';
        return SwitchListTile(
          title: Text(value.name),
          subtitle: Text(subtitle),
          value: false,
          onChanged: (bool? value) {},
        );
      case AsyncLoading():
        return const ListTile(
          title: Text("Loading..."),
          leading: CircularProgressIndicator(),
        );
      case AsyncError(:final error, :final stackTrace):
        debugPrintStack(stackTrace: stackTrace);
        return ListTile(
          title: Text("Error: $error"),
        );
    }
  }
}
