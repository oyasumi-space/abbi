import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../pod/links_pod.dart';
import '../pod/win32_registry_pod.dart';
import 'app_lock_dialog.dart';

class LaunchOmoriFab extends HookConsumerWidget {
  const LaunchOmoriFab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);
    final installed = ref.watch(omoriInstalledPod);
    final updating = ref.watch(omoriUpdatingPod);
    final running = ref.watch(omoriRunningPod);
    final disabled = !installed || updating || running;
    final hint = !installed
        ? AppLocalizations.of(context)!.omori_status_not_installed
        : updating
            ? AppLocalizations.of(context)!.omori_status_updating
            : running
                ? AppLocalizations.of(context)!.omori_status_running
                : AppLocalizations.of(context)!.launch_omori;
    return FloatingActionButton(
      onPressed: disabled || isLoading.value
          ? null
          : () async {
              isLoading.value = true;
              ref.read(linksPod.notifier).createLinks();
              showDialog(
                context: context,
                builder: (_) => AppLockDialog(),
                barrierDismissible: false,
              );
              await launchUrlString('steam://rungameid/1150690');
              isLoading.value = false;
            },
      tooltip: hint,
      child: isLoading.value
          ? const CircularProgressIndicator()
          : const Icon(Icons.rocket_launch),
    );
  }
}
