import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart' as $path;

import '../entity/profile.dart';
import '../pod/config_pod.dart';
import '../pod/profile_pod.dart';

class ProfilesPage extends ConsumerWidget {
  const ProfilesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileFilesAsync = ref.watch(profileFilesPod);
    switch (profileFilesAsync) {
      case AsyncData(:final value, :final isRefreshing):
        if (isRefreshing) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.separated(
          itemBuilder: (context, index) {
            final file = value[index];
            return _ProfilesPageItemAsync(file);
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

class _ProfilesPageItemAsync extends ConsumerWidget {
  const _ProfilesPageItemAsync(this.file);

  final File file;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profilePod(file));
    // final profileNotifier = ref.watch(profilePod(file).notifier);

    switch (profileAsync) {
      case AsyncData(:final value):
        final profile = value;
        return _ProfilesPageItem(file, profile);
      case AsyncLoading():
        return const ListTile(
          title: Text("Loading..."),
          leading: CircularProgressIndicator(),
        );
      case AsyncError(:final error, :final stackTrace):
        debugPrintStack(stackTrace: stackTrace);
        return ListTile(
          title: Text("Error: $error"),
          leading: const Icon(Icons.error),
        );
    }
  }
}

class _ProfilesPageItem extends HookConsumerWidget {
  const _ProfilesPageItem(this.file, this.profile);

  final File file;
  final Profile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final expanded = useState(false);

    return ListTile(
      title: Text(profile.name),
      leading: Radio(
        value: $path.basenameWithoutExtension(file.path),
        groupValue: ref.watch(currentProfileIdPod),
        onChanged: (String? value) {
          if (value != null) {
            ref.read(currentProfileIdPod.notifier).set(value);
          }
        },
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              file.delete();
            },
          ),
          /*
          IconButton(
            icon: Icon(expanded.value ? Icons.expand_less : Icons.expand_more),
            onPressed: () {
              expanded.value = !expanded.value;
            },
          ),
          */
        ],
      ),
    );
  }
}
