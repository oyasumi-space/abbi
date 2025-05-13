import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart' as $path;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../app.dart';
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
            icon: Icon(Icons.edit),
            onPressed: () async {
              showDialog(
                context: context,
                builder: (context) => _ProfileNameEditDialog(file),
              );
            },
          ),
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

class _ProfileNameEditDialog extends HookConsumerWidget {
  const _ProfileNameEditDialog(this.file);

  final File file;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name =
        useTextEditingController(text: ref.watch(profilePod(file)).value!.name);
    final appL10n = AppLocalizations.of(context)!;
    final materialL10n = MaterialLocalizations.of(context);
    final ee = ([
      appL10n.ee_omori,
      appL10n.ee_sunny,
      appL10n.ee_aubrey,
      appL10n.ee_kel,
      appL10n.ee_hero,
      appL10n.ee_basil,
      appL10n.ee_mari,
    ]..shuffle())
        .first;
    return AlertDialog(
      title: Text(appL10n.action_edit_profile_name),
      content: TextField(
        controller: name,
        decoration: InputDecoration(hintText: ee),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(materialL10n.cancelButtonLabel),
        ),
        TextButton(
          onPressed: () {
            ref.read(profilePod(file).notifier).rename(name.text);
            Navigator.of(context).pop();
          },
          child: Text(materialL10n.okButtonLabel),
        ),
      ],
    );
  }
}
