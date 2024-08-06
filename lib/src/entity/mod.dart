import 'dart:io';

import 'mod_manifest.dart';

class Mod {
  final ModManifest manifest;
  final FileSystemEntity fse;

  Mod({
    required this.manifest,
    required this.fse,
  });
}
