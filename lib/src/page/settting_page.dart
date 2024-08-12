import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../provider/game_provider.dart';
import '../provider/preference_provider.dart';

class SettingPage extends HookConsumerWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefModsPath = useTextEditingController();
    final prefGamePath = useTextEditingController();
    prefModsPath.text = ref.watch(prefModsPathProvider) ?? '';
    prefGamePath.text = ref.watch(prefGamePathProvider) ?? '';
    final prefModsForcusNode = useFocusNode();
    final prefGameForcusNode = useFocusNode();
    const savedSnackbar = SnackBar(content: Text('Saved'));

    useEffect(() {
      prefModsForcusNode.addListener(() async {
        if (!prefModsForcusNode.hasFocus) {
          await ref.read(prefModsPathProvider.notifier).set(prefModsPath.text);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(savedSnackbar);
          }
        }
      });
      prefGameForcusNode.addListener(() async {
        if (!prefGameForcusNode.hasFocus) {
          await ref.read(prefGamePathProvider.notifier).set(prefGamePath.text);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(savedSnackbar);
          }
        }
      });
      return null;
    }, []);

    return ListView(
      children: [
        ListTile(
          title: const Text('Mods Path'),
          subtitle: TextField(
            focusNode: prefModsForcusNode,
            controller: prefModsPath,
          ),
        ),
        ListTile(
          title: const Text('Game Path'),
          subtitle: TextField(
            focusNode: prefGameForcusNode,
            controller: prefGamePath,
            decoration: InputDecoration(
              hintText: 'Please set OMORI game path',
              errorText: ref.watch(omoriExcutableErrorProvider).value,
            ),
          ),
        ),
      ],
    );
  }
}
