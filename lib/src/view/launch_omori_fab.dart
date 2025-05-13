import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:url_launcher/url_launcher_string.dart';

import '../../l10n/app_localizations.dart';
import '../pod/installer_pod.dart';
import '../pod/win32_registry_pod.dart';
import 'app_lock_dialog.dart';

class LaunchOmoriFab extends HookConsumerWidget {
  const LaunchOmoriFab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appL10n = AppLocalizations.of(context)!;
    final isLoading = useState(false);
    final installed = ref.watch(omoriInstalledPod);
    final updating = ref.watch(omoriUpdatingPod);
    final running = ref.watch(omoriRunningPod);
    final disabled = !installed || updating || running;
    final hint = !installed
        ? appL10n.omori_status_not_installed
        : updating
            ? appL10n.omori_status_updating
            : running
                ? appL10n.omori_status_running
                : appL10n.launch_omori;
    return FloatingActionButton(
      onPressed: disabled || isLoading.value
          ? null
          : () async {
              isLoading.value = true;

              showDialog(
                context: context,
                builder: (_) => AppLockDialog(),
                barrierDismissible: false,
              );
              await ref.read(installerPod.notifier).install();
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
