import 'dart:io';

import 'mod_manifest.dart';

class Mod {
  final String name;
  final FileSystemEntityType type;
  final ModManifest manifest;

  Mod(this.name, this.type, this.manifest);

  String get typeEmoji =>
      {
        FileSystemEntityType.file: '🗒️',
        FileSystemEntityType.directory: '📁',
      }[type] ??
      '❔';
}
