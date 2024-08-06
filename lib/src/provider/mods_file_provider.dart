import 'dart:convert';
import 'dart:io';

import '../util/compute_manager.dart';
import 'preference_provider.dart';
import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as $path;

import '../entity/mod_manifest.dart';

final installedModsIdMapProvider =
    FutureProvider<Map<String, Set<FileSystemEntity>>>((ref) async {
  final result = <String, Set<FileSystemEntity>>{};
  final manifests = await ref.watch(installedModsManifestProvider.future);
  for (final pair in manifests) {
    if (!result.containsKey(pair.$1.id)) {
      result[pair.$1.id] = {};
    }
    result[pair.$1.id]!.add(pair.$2);
  }
  return result;
});

final installedModsManifestProvider =
    FutureProvider<List<(ModManifest, FileSystemEntity)>>((ref) async {
  final fses = await ref.watch(installedModsFseProvider.future);
  final result = await Future.wait(fses.map((fse) async {
    try {
      return (
        await ref.watch(installedModManifestFamilyProvider(fse).future),
        fse,
      );
    } catch (e) {
      return null;
    }
  }));
  return result.where((e) => e != null).toList().cast();
});

final installedModManifestFamilyProvider =
    FutureProvider.family<ModManifest, FileSystemEntity>((ref, fse) async {
  if (fse is Directory) {
    final file = File($path.join(fse.path, 'mod.json'));
    if (!await file.exists()) throw Exception('Manifest not found');
    return ModManifest.fromJson(jsonDecode(await file.readAsString()));
  }

  if (fse is File) {
    if (!fse.path.endsWith('.zip')) {
      return throw Exception('Invalid mod file');
    }
    return await _zipModOpenerComputeManager.run(fse);
  }

  throw UnimplementedError('unreachable');
});

// mod file/folder entities
final installedModsFseProvider =
    FutureProvider<List<FileSystemEntity>>((ref) async {
  final path = ref.watch(prefModsPathProvider);
  if (path == null) {
    throw Exception('Mods path is not set');
  }
  final dir = Directory(path);
  return await dir.list().toList();
});

final _zipModOpenerComputeManager = ComputeManager<File, ModManifest>((file) {
  final zip = ZipDecoder().decodeBytes(file.readAsBytesSync());
  final path = zip.files.first.name;
  final manifestFile = zip.findFile($path.join(path, 'mod.json'));
  if (manifestFile == null) throw Exception('Manifest not found');

  final manifest = ModManifest.fromJson(
      jsonDecode(utf8.decode(manifestFile.content as Uint8List)));

  if ('${manifest.id}/' != path) throw Exception('Invalid mod zip file');
  return manifest;
});
