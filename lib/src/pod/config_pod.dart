import 'dart:io';
import 'package:path/path.dart' as $path;
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final modsPathConfigPod = NotifierProvider<ConfigValueNotifier<String>, String>(
  () => ConfigValueNotifier('mods_path', $path.join('{omori}', 'mods')),
);

final languagePod = NotifierProvider<ConfigValueNotifier<String>, String>(
  () => ConfigValueNotifier('language', 'en'),
);

class ConfigValueNotifier<T> extends Notifier<T> {
  ConfigValueNotifier(this._key, this._defaultValue);

  final String _key;
  final T _defaultValue;

  @override
  T build() {
    final config = ref.watch(configPod);
    return config[_key] as T? ?? _defaultValue;
  }

  void set(T? value) {
    ref.read(configPod.notifier).write(_key, value);
    ref.invalidateSelf();
  }
}

final configPod =
    NotifierProvider<ConfigNotifier, Map<String, dynamic>>(ConfigNotifier.new);

class ConfigNotifier extends Notifier<Map<String, dynamic>> {
  static final _fileName = 'config.json';

  static final _jsonEncoder = JsonEncoder.withIndent('  ');

  @override
  Map<String, dynamic> build() {
    final file = _getFile();
    var string = utf8.decode(file.readAsBytesSync());
    if (string.isEmpty) {
      string = '{}';
    }
    return jsonDecode(string) as Map<String, dynamic>;
  }

  Future<void> write(String key, dynamic value) async {
    state = {
      ...state,
      key: value,
    };
    final file = _getFile();
    await file.writeAsString(_jsonEncoder.convert(state));
  }

  File _getFile() {
    final file = File(_path);
    if (!file.existsSync()) {
      file.createSync();
    }
    return file;
  }

  String get _path =>
      $path.join($path.dirname(Platform.resolvedExecutable), _fileName);
}
