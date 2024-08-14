import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

final packageInfoProvider = FutureProvider<PackageInfo>((ref) async {
  return await PackageInfo.fromPlatform();
});

final commitIdProvider = FutureProvider<String>((ref) async {
  return (await rootBundle.loadString('.git/ORIG_HEAD')).trim();
});

class AboutPage extends ConsumerWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packageInfo = ref.watch(packageInfoProvider).value;
    final commitId = ref.watch(commitIdProvider).value;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Abbi: OMORI Mod Manager',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'I am a mod manager for the game OMORI.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'App Name: ${packageInfo?.appName}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              'Version: ${packageInfo?.version}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              'Commit ID: $commitId',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Created by @aoisensi with one hundred forty-three <3',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
