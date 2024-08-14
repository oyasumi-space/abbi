import 'dart:io';

import 'package:path/path.dart' as $path;

import 'mod_manifest.dart';

class Mod {
  final ModManifest manifest;
  final FileSystemEntity fse;

  Mod({
    required this.manifest,
    required this.fse,
  });

  String get name => $path.basename(fse.path);

  @override
  operator ==(Object other) {
    if (other is! Mod) return false;
    return fse.path == other.fse.path;
  }

  @override
  int get hashCode => manifest.hashCode ^ fse.hashCode;
}
