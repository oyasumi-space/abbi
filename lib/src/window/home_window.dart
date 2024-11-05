import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../page/mods_page.dart';
import '../page/settings_page.dart';
import '../pod/mods_pod.dart';
import '../pod/win32_registry_pod.dart';

class HomeWidndow extends ConsumerWidget {
  const HomeWidndow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(_pagePod);
    return Scaffold(
      appBar: page.appBar(context, ref),
      body: page.body(context, ref),
      drawer: Drawer(
        child: ListView(
          children: _Page.pages
              .map(
                (page) => ListTile(
                  leading: Icon(page.icon),
                  title: Text(page.title(context)),
                  onTap: () {
                    ref.read(_pagePod.notifier).state = page;
                    Navigator.pop(context);
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

final _pagePod = StateProvider((ref) => _Page.mods);

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
            ref.invalidate(modsFSEPod);
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
    body: (context, ref) => Consumer(
      builder: (context, ref, child) {
        final o = ref.watch(omoriRunningPod);
        return Center(
          child: Text(o.toString()),
        );
      },
    ),
  );
}
