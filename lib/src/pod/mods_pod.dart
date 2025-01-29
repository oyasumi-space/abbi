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
import 'profile_pod.dart';

final modFamilyPod = FutureProvider.family<Mod, String>((ref, name) async {
  final path = ref.watch(modPathFamily(name));
  final type = FileSystemEntity.typeSync(path);
  late ModManifest manifest;
  switch (type) {
    case FileSystemEntityType.file:
      manifest = await compute((file) {
        final zip = ZipDecoder().decodeBytes(file.readAsBytesSync());
        final tops = zip.files
            .where((file) => $path.split(file.name).length == 1)
            .toList();
        if (tops.length != 1) {
          throw NotModEntityException.notCorrectMod;
        }
        final root = tops.first;
        if (root.isFile) {
          throw NotModEntityException.notCorrectMod;
        }
        final manifestFile = zip.files.firstWhere(
          (file) => file.name == "${root.name}mod.json",
        );
        final json = utf8.decode(manifestFile.content);
        final manifest = ModManifest.fromJson(jsonDecode(json));
        if ('${manifest.id}/' != root.name) {
          throw NotModEntityException.notCorrectMod;
        }
        return manifest;
      }, await ref.watch(watchFilePod(path).future));
    case FileSystemEntityType.directory:
      final manifestPath = $path.join(path, "mod.json");
      final file = await ref.watch(watchFilePod(manifestPath).future);
      if (!await file.exists()) {
        throw NotModEntityException.notFoundManifestFile;
      }
      final json = await file.readAsString();
      manifest = ModManifest.fromJson(jsonDecode(json));
    default:
      throw NotModEntityException.unknown;
  }
  return Mod(name, type, manifest);
});

final modPathFamily = Provider.family<String, String>((ref, name) {
  return $path.join(ref.watch(modsPathPod), name);
});

final availableModsPod = FutureProvider<List<Mod>>((ref) async {
  final names = await ref.watch(availableModsNamePod.future);
  return Future.wait(
    names.map((name) => ref.watch(modFamilyPod(name).future)),
  );
});

final availableModsNamePod = FutureProvider<List<String>>((ref) async {
  final files = await ref.watch(watchDirPod(ref.watch(modsPathPod)).future);
  return files
      .where((fse) {
        if (fse is Directory) return true;
        if (fse is File && $path.extension(fse.path) == '.zip') return true;
        return false;
      })
      .map((fse) => $path.basename(fse.path))
      .toList();
});

final sortedAvailableModsNamePod = FutureProvider((ref) async {
  final mods = await ref.watch(availableModsPod.future);

  mods.sort((a, b) {
    final c = a.manifest.priority.compareTo(b.manifest.priority);
    if (c != 0) return c;
    return a.manifest.id.compareTo(b.manifest.id);
  });
  return mods.map((mod) => mod.name).toList();
});

final enabledModsPod = FutureProvider.autoDispose((ref) async {
  final profileFile = ref.watch(currentProfileFilePod);
  final profile = await ref.watch(profilePod(profileFile).future);
  return (await Future.wait(
    profile.mods.map((name) => ref.watch(modFamilyPod(name).future)),
  ))
      .toList();
});
