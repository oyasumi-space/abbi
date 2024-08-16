import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../provider/preference_provider.dart';
import '../provider/profile_provider.dart';

class ProfilesPage extends ConsumerWidget {
  const ProfilesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profiles = ref.watch(profilesProvider);
    final currentProfile = ref.watch(currentProfileNameProvider);
    return ListView.builder(
      itemBuilder: (context, i) {
        if (i == profiles.length) {
          return const _AddProfileListTileCard();
        }
        final profile = profiles[i];
        return Card(
          child: RadioListTile<String>(
            value: profile.name,
            groupValue: currentProfile,
            onChanged: (name) async {
              await ref.read(prefCurrentProfileNameProvider.notifier).set(name);
            },
            title: Text(profile.name),
          ),
        );
      },
      itemCount: profiles.length + 1,
      padding: const EdgeInsets.only(bottom: 80),
    );
  }
}

class _AddProfileListTileCard extends ConsumerWidget {
  const _AddProfileListTileCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(newProfileNameProvider);
    final valid = ref.watch(isAvailableNewProfileNameProvider);
    return Card(
      child: ListTile(
        leading: IconButton(
          onPressed:
              valid ? () => ref.read(profilesProvider.notifier).add() : null,
          icon: const Icon(Icons.add),
        ),
        title: TextField(
          decoration: InputDecoration(
            hintText: 'New Profile...',
            errorText:
                valid || name.isEmpty ? null : 'Profile name is already used',
          ),
          onChanged: (name) {
            ref.read(newProfileNameProvider.notifier).state = name;
          },
        ),
      ),
    );
  }
}
