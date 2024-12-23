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
import 'config_path_pod.dart';
import 'file_pod.dart';

final modFamilyPod = FutureProvider.family<Mod, String>((ref, name) async {
  final path = ref.watch(modPathFamily(name));
  final type = FileSystemEntity.typeSync(path);
  switch (type) {
    case FileSystemEntityType.file:
      return Mod(
          name, type, await ref.watch(_fileModManifestFamily(path).future));
    case FileSystemEntityType.directory:
      return Mod(
          name, type, await ref.watch(_dirModManifestFamily(path).future));
    default:
      throw NotModEntityException.unknown;
  }
});

final _fileModManifestFamily =
    FutureProvider.family<ModManifest, String>((ref, path) async {
  return await compute((file) {
    final zip = ZipDecoder().decodeBytes(file.readAsBytesSync());
    final manifestFile = zip.files.firstWhere((file) {
      final sp = $path.split(file.name);
      return sp.length == 2 && sp[1] == "mod.json";
    });
    final json = utf8.decode(manifestFile.content as List<int>);
    return ModManifest.fromJson(jsonDecode(json));
  }, await ref.watch(watchFilePod(path).future));
});

final _dirModManifestFamily =
    FutureProvider.family<ModManifest, String>((ref, path) async {
  final file =
      await ref.watch(watchFilePod($path.join(path, "mod.json")).future);
  if (!await file.exists()) {
    throw NotModEntityException.notFoundManifestFile;
  }
  final json = await file.readAsString();
  return ModManifest.fromJson(jsonDecode(json));
});

final modPathFamily = Provider.family<String, String>((ref, name) {
  return $path.join(ref.watch(modsPathPod), name);
});

final availableModsNamePod =
    AsyncNotifierProvider<AvailableModsNamesNotifier, List<String>>(
        AvailableModsNamesNotifier.new);

final availableModsPod = FutureProvider<List<Mod>>((ref) async {
  final names = await ref.watch(availableModsNamePod.future);
  return Future.wait(
    names.map((name) => ref.watch(modFamilyPod(name).future)),
  );
});

class AvailableModsNamesNotifier extends AsyncNotifier<List<String>> {
  @override
  FutureOr<List<String>> build() async {
    final files = await ref.watch(watchDirPod(ref.watch(modsPathPod)).future);
    return files
        .where((fse) {
          if (fse is Directory) return true;
          if (fse is File && $path.extension(fse.path) == '.zip') return true;
          return false;
        })
        .map((fse) => $path.basename(fse.path))
        .toList();
  }
}
