import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../page/mods_page.dart';
import '../page/settings_page.dart';
import '../page/test_page.dart';
import '../pod/mods_pod.dart';
import '../view/launch_omori_fab.dart';

class HomeWidndow extends HookConsumerWidget {
  const HomeWidndow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageIndex = useState(0);
    final page = _Page.pages[pageIndex.value];
    return Scaffold(
      appBar: page.appBar(context, ref),
      body: Row(
        children: [
          NavigationRail(
            leading: Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: LaunchOmoriFab(),
            ),
            destinations: _Page.pages
                .map(
                  (page) => NavigationRailDestination(
                    icon: Icon(page.icon),
                    label: Text(page.title(context)),
                  ),
                )
                .toList(),
            selectedIndex: pageIndex.value,
            onDestinationSelected: (index) {
              pageIndex.value = index;
            },
            labelType: NavigationRailLabelType.all,
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: page.body(context, ref)),
        ],
      ),
    );
  }
}

class _Page {
  final String Function(BuildContext) title;
  final IconData icon;
  final AppBar Function(BuildContext context, WidgetRef ref) appBar;
  final Widget Function(BuildContext context, WidgetRef ref) body;

  _Page({
    required this.title,
    required this.icon,
    required this.appBar,
    required this.body,
  });

  static final pages = [mods, settings, test];

  static final mods = _Page(
    title: (context) => AppLocalizations.of(context)!.page_mods,
    icon: Icons.extension,
    appBar: (context, ref) => AppBar(
      title: Text(AppLocalizations.of(context)!.page_mods),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            ref.invalidate(availableModsNamePod);
          },
        ),
      ],
    ),
    body: (context, ref) => ModsPage(),
  );

  static final settings = _Page(
    title: (context) => AppLocalizations.of(context)!.page_settings,
    icon: Icons.settings,
    appBar: (context, ref) => AppBar(
      title: Text(AppLocalizations.of(context)!.page_settings),
    ),
    body: (context, ref) => const SettingsPage(),
  );

  static final test = _Page(
    title: (context) => "Test",
    icon: Icons.bug_report,
    appBar: (context, ref) => AppBar(),
    body: (context, ref) => const TestPage(),
  );
}
