import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as $path;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entity/profile.dart';
import 'config_path_pod.dart';
import 'config_pod.dart';
import 'file_pod.dart';

final profilePod = AsyncNotifierProvider.autoDispose
    .family<ProfileNotifier, Profile, File>(ProfileNotifier.new);

class ProfileNotifier extends AutoDisposeFamilyAsyncNotifier<Profile, File> {
  @override
  FutureOr<Profile> build(File arg) async {
    final body = await arg.readAsString();
    return Profile.fromJson(jsonDecode(body));
  }
}

final profileFilesPod = AsyncNotifierProvider<ProfileFilesNotifier, List<File>>(
    ProfileFilesNotifier.new);

class ProfileFilesNotifier extends AsyncNotifier<List<File>> {
  @override
  FutureOr<List<File>> build() async {
    final path = ref.watch(profilesPathPod);
    final files = await ref.watch(watchDirPod(path).future);
    final result = files
        .where((fse) => fse is File && $path.extension(fse.path) == '.json')
        .cast<File>()
        .toList();
    if (result.isEmpty) {
      final file = await create('Default', filename: '0');
      return [file];
    }
    return result;
  }

  Future<File> create(String name, {String filename = ''}) async {
    final path = ref.watch(profilesPathPod);
    if (filename.isEmpty) {
      filename = DateTime.now().millisecondsSinceEpoch.toString();
    }
    final file = File($path.join(path, '$filename.json'));
    (await file.create()).writeAsString(jsonEncode({"name": name}));
    return file;
  }
}

final currentProfileFilePod = Provider<File>((ref) {
  final id = ref.watch(currentProfileIdPod);
  final path = ref.watch(profilesPathPod);
  return File($path.join(path, '$id.json'));
});
