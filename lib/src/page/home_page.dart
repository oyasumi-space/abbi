import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/mods_file_provider.dart';
import '../view/run_with_mods_floating_action_button.dart';
import 'settting_page.dart';
import '../view/installed_mods_list_view.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isShowErrorMods = ref.watch(installedModsShowErrorProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Abbi The OMORI Mod Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return const SettingPage();
                },
              ));
            },
          ),
          IconButton(
            onPressed: () {
              ref.invalidate(installedModsFseProvider);
            },
            icon: const Icon(Icons.refresh),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              CheckedPopupMenuItem(
                checked: isShowErrorMods,
                onTap: () {
                  ref.read(installedModsShowErrorProvider.notifier).state =
                      !isShowErrorMods;
                },
                child: const Text('Show errored mods'),
              ),
            ],
          ),
        ],
      ),
      body: const InstalledModsListView(),
      floatingActionButton: const RunWithModsFloatingActionButton(),
    );
  }
}
