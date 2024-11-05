import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path/path.dart' as $path;

import '../pod/config_path_pod.dart';
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
          subtitle: Text(AppLocalizations.of(context)!.language),
          onTap: () => showDialog(
            context: context,
            builder: (_) => SimpleDialog(
              children: [
                for (final locale in AppLocalizations.supportedLocales)
                  SimpleDialogOption(
                    onPressed: () {
                      ref.read(languagePod.notifier).set(locale.languageCode);
                      Navigator.pop(context);
                    },
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
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.folder),
          title: Text(AppLocalizations.of(context)!.settings_title_mods_path),
          subtitle: Text(ref.watch(modsPathPod)),
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => _SettingsPathDialog(
                title: AppLocalizations.of(context)!.settings_title_mods_path,
                defaultPath: $path.join('{omori}', 'mods'),
                pod: modsPathConfigPod,
              ),
            );
          },
        ),
      ],
    );
  }
}

class _SettingsPathDialog extends HookConsumerWidget {
  const _SettingsPathDialog(
      {required this.title, required this.defaultPath, required this.pod});

  final String title;
  final String defaultPath;
  final NotifierProvider<ConfigValueNotifier<String>, String> pod;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    controller.text = ref.watch(pod);
    final l10n = AppLocalizations.of(context)!;
    final extraDesc = [
      l10n.settings_path_extra_desc,
      '"{omori}": ${l10n.settings_path_extra_desc_omori}',
      '"{abbi}": ${l10n.settings_path_extra_desc_abii}',
    ].join('\n');
    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(extraDesc),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: defaultPath,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        TextButton(
          onPressed: () {
            ref.read(pod.notifier).set(controller.text);
            Navigator.pop(context);
          },
          child: Text(MaterialLocalizations.of(context).saveButtonLabel),
        ),
      ],
    );
  }
}