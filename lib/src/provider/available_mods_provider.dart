import 'dart:convert' as $convert;
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as $path;

import '../entity/mod.dart';
import '../entity/mod_manifest.dart';
import '../util/compute_manager.dart';
import '../util/exceptions.dart';
import 'preference_provider.dart';

final availableModsIdMapProvider =
    FutureProvider<Map<String, List<Mod>>>((ref) async {
  final result = <String, List<Mod>>{};
  final mods = await ref.watch(availableModsProvider.future);
  for (final mod in mods) {
    if (!result.containsKey(mod.manifest.id)) {
      result[mod.manifest.id] = [mod];
    } else {
      result[mod.manifest.id]!.add(mod);
    }
  }
  return result;
});

final availableModsProvider = FutureProvider<List<Mod>>((ref) async {
  final fses = await ref.watch(availableModsFseProvider.future);
  return await Future.wait(fses.map((fse) async {
    return ref.watch(availableModsFamilyProvider(fse).future);
  }));
});

final availableModsFamilyProvider =
    FutureProvider.family<Mod, FileSystemEntity>((ref, fse) async {
  final manifest =
      await ref.watch(availableModManifestFamilyProvider(fse).future);
  return Mod(manifest: manifest, fse: fse);
});

final availableModManifestFamilyProvider =
    FutureProvider.family<ModManifest, FileSystemEntity>((ref, fse) async {
  switch (fse) {
    case Directory _:
      final file = File($path.join(fse.path, 'mod.json'));
      if (!await file.exists()) throw Exceptions.notFoundManifest;
      return ModManifest.fromJson(
          $convert.json.decode(await file.readAsString()));
    case File _:
      if (!fse.path.endsWith('.zip')) {
        throw Exceptions.invalidModFile;
      }
      return await _zipModOpenerComputeManager.run(fse);
    default:
      throw Exceptions.invalidModFile;
  }
});

final availableModsFseProvider =
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

  final manifest = ModManifest.fromJson($convert.json
      .decode($convert.utf8.decode(manifestFile.content as Uint8List)));

  if ('${manifest.id}/' != path) throw Exceptions.invalidModFile;
  return manifest;
});
