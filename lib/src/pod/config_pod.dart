import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as $path;
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final gamePathConfigPod =
    AsyncNotifierProvider<ConfigNotifier<String?>, String?>(
        () => ConfigNotifier<String?>('game_path'));

final gamePathConfigErrorPod = FutureProvider<String?>((ref) async {
  final gamePath = await ref.watch(gamePathConfigPod.future);
  if (gamePath == '') {
    return 'Game Path is required.';
  }
  final exe = File($path.join(gamePath ?? '', 'OMORI.exe'));
  if (!await exe.exists()) {
    return 'OMORI.exe not found in game path.';
  }
  return null;
});

class ConfigNotifier<T> extends AsyncNotifier<T> {
  static final _configFileName = './config.json';

  ConfigNotifier(this.key);

  final String key;

  @override
  FutureOr<T> build() async {
    final json = await ref.watch(jsonFilePod(_configFileName).future);
    return json[key] as T;
  }

  Future<void> set(T value) async {
    final json = await ref.read(jsonFilePod(_configFileName).future);
    json[key] = value;
    return await ref
        .read(plainTextFilePod(_configFileName).notifier)
        .write(_jsonEncoder.convert(json));
  }
}

final jsonFilePod =
    FutureProvider.family<Map<String, dynamic>, String>((ref, arg) async {
  final content = await ref.watch(plainTextFilePod(arg).future);
  if (content == '') {
    return {};
  }
  return jsonDecode(content);
});

final plainTextFilePod =
    AsyncNotifierProvider.family<PlainTextConfigNotifier, String, String>(
        PlainTextConfigNotifier.new);

class PlainTextConfigNotifier extends FamilyAsyncNotifier<String, String> {
  PlainTextConfigNotifier();

  @override
  FutureOr<String> build(String arg) async {
    var file = File(_path);
    if (!await file.exists()) {
      await file.create();
    }
    return file.readAsString();
  }

  Future<void> write(String content) async {
    update((cb) {
      final file = File(_path);
      file.writeAsString(content);
      return content;
    });
  }

  String get _path => $path.join(Directory.current.path, arg);
}

final _jsonEncoder = JsonEncoder.withIndent('  ');
