// mod file/folder entities
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as $path;

import '../entity/mod_manifest.dart';
import '../util/compute_manager.dart';
import '../util/exceptions.dart';
import 'preference_provider.dart';

final availableModsIdMapProvider =
    FutureProvider<Map<String, Set<FileSystemEntity>>>((ref) async {
  final result = <String, Set<FileSystemEntity>>{};
  final manifests = await ref.watch(avaiableModsManifestProvider.future);
  for (final pair in manifests) {
    if (!result.containsKey(pair.$1.id)) {
      result[pair.$1.id] = {};
    }
    result[pair.$1.id]!.add(pair.$2);
  }
  return result;
});

final avaiableModsManifestProvider =
    FutureProvider<List<(ModManifest, FileSystemEntity)>>((ref) async {
  final fses = await ref.watch(availableModsProvider.future);
  final result = await Future.wait(fses.map((fse) async {
    try {
      return (
        await ref.watch(availableModManifestFamilyProvider(fse).future),
        fse,
      );
    } catch (e) {
      return null;
    }
  }));
  return result.where((e) => e != null).toList().cast();
});

final availableModsManifestProvider =
    FutureProvider<List<ModManifest>>((ref) async {
  final fses = await ref.watch(availableModsProvider.future);
  final result = await Future.wait(fses.map((fse) async {
    try {
      return await ref.watch(availableModManifestFamilyProvider(fse).future);
    } catch (e) {
      return null;
    }
  }));
  return result.where((e) => e != null).toList().cast();
});

final availableModManifestFamilyProvider =
    FutureProvider.family<ModManifest, FileSystemEntity>((ref, fse) async {
  switch (fse) {
    case Directory _:
      final file = File($path.join(fse.path, 'mod.json'));
      if (!await file.exists()) throw Exceptions.notFoundManifest;
      return ModManifest.fromJson(jsonDecode(await file.readAsString()));
    case File _:
      if (!fse.path.endsWith('.zip')) {
        throw Exceptions.invalidModFile;
      }
      return await _zipModOpenerComputeManager.run(fse);
    default:
      throw Exceptions.invalidModFile;
  }
});

final availableModsProvider =
    FutureProvider<List<FileSystemEntity>>((ref) async {
  final path = ref.watch(prefModsPathProvider);
  if (path == null) {
    throw Exceptions.modsPathNotSet;
  }
  final dir = Directory(path);
  return await dir.list().toList();
});

final _zipModOpenerComputeManager = ComputeManager<File, ModManifest>((file) {
  final zip = ZipDecoder().decodeBytes(file.readAsBytesSync());
  final path = zip.files.first.name;
  final manifestFile = zip.findFile($path.join(path, 'mod.json'));
  if (manifestFile == null) throw Exceptions.notFoundManifest;

  final manifest = ModManifest.fromJson(
      jsonDecode(utf8.decode(manifestFile.content as Uint8List)));

  if ('${manifest.id}/' != path) throw Exceptions.invalidModFile;
  return manifest;
});
