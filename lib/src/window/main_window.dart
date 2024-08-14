import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../page/about_page.dart';
import '../provider/available_mods_provider.dart';
import '../view/run_with_mods_floating_action_button.dart';
import '../page/settting_page.dart';
import '../page/available_mods_page.dart';

class MainWindow extends HookConsumerWidget {
  const MainWindow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = usePageController();

    final isSmallScreen = MediaQuery.of(context).size.width <= 768;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Abbi'),
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
              ref.invalidate(availableModsFseProvider);
            },
            icon: const Icon(Icons.refresh),
          ),
          const _MainWindowPopupShowButton(),
        ],
      ),
      body: Row(
        children: [
          isSmallScreen ? const SizedBox.shrink() : _MainWindowDrawer(page),
          Expanded(
            child: PageView(
              controller: page,
              children: const [
                AvailableModsPage(),
                SettingPage(),
                AboutPage(),
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

class _MainWindowPopupShowButton extends ConsumerWidget {
  const _MainWindowPopupShowButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isShowErrorMods = ref.watch(availableModsShowErrorProvider);
    return PopupMenuButton(
      itemBuilder: (context) => [
        CheckedPopupMenuItem(
          checked: isShowErrorMods,
          onTap: () {
            ref.read(availableModsShowErrorProvider.notifier).state =
                ref.read(availableModsShowErrorProvider);
          },
          child: const Text('Show errored mods'),
        ),
      ],
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
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {
              page.jumpToPage(2);
            },
          )
        ],
      ),
    );
  }
}
