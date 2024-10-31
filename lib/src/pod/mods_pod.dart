import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as $path;

import '../entity/mod.dart';
import '../entity/mod_manifest.dart';
import '../exception/exception.dart';

final modManifestFamily =
    FutureProvider.family<ModManifest, FileSystemEntity>((ref, fse) async {
  switch (fse) {
    case File file:
      if ($path.extension(file.path) != ".zip") {
        throw NotModEntityException.notZipExtension;
      }
      return await compute((file) {
        final zip = ZipDecoder().decodeBytes(file.readAsBytesSync());
        final manifestFile = zip.files.firstWhere((file) {
          final sp = $path.split(file.name);
          return sp.length == 2 && sp[1] == "mod.json";
        });
        final json = utf8.decode(manifestFile.content as List<int>);
        return ModManifest.fromJson(jsonDecode(json));
      }, file);
    case Directory dir:
      final file = File($path.join(dir.path, "mod.json"));
      if (!await file.exists()) {
        throw NotModEntityException.notFoundManifestFile;
      }
      final json = await file.readAsString();
      return ModManifest.fromJson(jsonDecode(json));
  }
  throw NotModEntityException.unknown;
});

final modsFSEPod =
    AsyncNotifierProvider<ModsFSENotifier, List<FileSystemEntity>>(
        ModsFSENotifier.new);

class ModsFSENotifier extends AsyncNotifier<List<FileSystemEntity>> {
  @override
  FutureOr<List<FileSystemEntity>> build() async {
    final dir = Directory("G:/SteamLibrary/steamapps/common/OMORI/mods");
    final sub = dir.watch(events: FileSystemEvent.all).listen((event) async {
      state = AsyncValue.loading();
      state = AsyncValue.data(await dir.list().toList());
    });
    ref.onDispose(sub.cancel);
    return await dir.list().toList();
  }
}

final modFamily = Provider.family<Mod, FileSystemEntity>((ref, fse) {
  if (fse is File) {
    return Mod($path.basename(fse.path), true);
  }
  if (fse is Directory) {
    return Mod($path.basename(fse.path), false);
  }
  throw NotModEntityException.unknown;
});
