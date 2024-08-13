import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../provider/available_mods_provider.dart';
import '../view/run_with_mods_floating_action_button.dart';
import '../page/settting_page.dart';
import '../page/installed_mods_page.dart';

class MainWindow extends HookConsumerWidget {
  const MainWindow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = usePageController();

    final isSmallScreen = MediaQuery.of(context).size.width <= 768;
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
              ref.invalidate(availableModsProvider);
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
      body: Row(
        children: [
          isSmallScreen ? const SizedBox.shrink() : _MainWindowDrawer(page),
          Expanded(
            child: PageView(
              controller: page,
              children: const [
                InstalledModsPage(),
                SettingPage(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: const RunWithModsFloatingActionButton(),
      drawer: isSmallScreen ? _MainWindowDrawer(page) : null,
    );
  }
}

class _MainWindowDrawer extends ConsumerWidget {
  const _MainWindowDrawer(this.page);

  final PageController page;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Mods'),
            onTap: () {
              page.jumpToPage(0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              page.jumpToPage(1);
            },
          ),
        ],
      ),
    );
  }
}
