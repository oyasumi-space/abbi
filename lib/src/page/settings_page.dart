import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../pod/config_pod.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.language),
          title: Text(AppLocalizations.of(context)!.settings_title_language),
          trailing: DropdownButton<String>(
            value: ref.watch(languagePod),
            onChanged: (value) {
              ref.read(languagePod.notifier).set(value);
            },
            items: [
              for (final locale in AppLocalizations.supportedLocales)
                DropdownMenuItem(
                  value: locale.languageCode,
                  child: Localizations.override(
                    context: context,
                    locale: locale,
                    child: Builder(
                      builder: (context) =>
                          Text(AppLocalizations.of(context)!.language),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Divider(),
        ListTile(),
      ],
    );
  }
}
