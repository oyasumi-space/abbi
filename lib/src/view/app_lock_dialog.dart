import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../pod/links_pod.dart';
import '../pod/win32_registry_pod.dart';

class AppLockDialog extends HookConsumerWidget {
  const AppLockDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final closing = useState(false);
    ref.listen(omoriRunningPod, (o, n) {
      if ((o ?? false) && !n) {
        _close(context, ref, closing);
      }
    });
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.app_locked),
      content: Text(AppLocalizations.of(context)!.app_locked_desc),
      actions: [
        closing.value
            ? const CircularProgressIndicator()
            : TextButton(
                onPressed: () {
                  _close(context, ref, closing);
                },
                child: Text(AppLocalizations.of(context)!.force_unlock),
              ),
      ],
    );
  }

  Future<void> _close(
      BuildContext context, WidgetRef ref, ValueNotifier<bool> closing) async {
    closing.value = true;
    await ref.read(linksPod.notifier).removeLinks();
    closing.value = false;
    if (context.mounted) {
      Navigator.pop(context);
    }
  }
}
