import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'mods_pod.dart';
import 'omori_path_pod.dart';

final linksPod = NotifierProvider<LinksNotifier, bool>(LinksNotifier.new);

class LinksNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  final _links = <Link>[];

  Future<void> createLinks() async {
    state = true;
    final enabledMods = await ref.read(enabledModsPod.future);
    _links.addAll(await Future.wait(enabledMods.map((mod) async {
      final path = ref.read(omoriModPath(mod.name));
      final target = ref.read(modPathFamily(mod.name));
      return Link(path)..createSync(target);
    })));
  }

  Future<void> removeLinks() async {
    await Future.wait(_links.map((link) => link.delete()));
    _links.clear();
    state = false;
  }
}
