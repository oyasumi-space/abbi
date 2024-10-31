import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../pod/mods_pod.dart';

class ModsPage extends ConsumerWidget {
  const ModsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modsFSEAsync = ref.watch(modsFSEPod);

    switch (modsFSEAsync) {
      case AsyncData(:final value):
        return ListView.separated(
          itemBuilder: (context, index) {
            final fse = value[index];
            return _ModsPageItem(fse);
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
  const _ModsPageItem(this.fse);

  final FileSystemEntity fse;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modManifestAsync = ref.watch(modManifestFamily(fse));
    final mod = ref.watch(modFamily(fse));
    switch (modManifestAsync) {
      case AsyncData(:final value):
        var subtitle = value.id;
        subtitle += ' - v${value.version}';
        subtitle +=
            ' - ${mod.isFile ? '🗒️' : '📁'}${mod.name}${mod.isFile ? '' : '/'}';
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
