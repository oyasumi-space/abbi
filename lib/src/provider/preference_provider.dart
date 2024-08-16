import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final prefModsPathProvider =
    NotifierProvider<PreferenceNotifier<String?, String>, String?>(
        () => PreferenceNotifier<String?, String>('mods_path'));

final prefGamePathProvider =
    NotifierProvider<PreferenceNotifier<String?, String>, String?>(
        () => PreferenceNotifier<String?, String>('game_path'));

final prefCurrentProfileNameProvider =
    NotifierProvider<PreferenceNotifier<String?, String>, String?>(
        () => PreferenceNotifier<String?, String>('current_profile'));

// S is state, V is encoded saved value
class PreferenceNotifier<S, V> extends Notifier<S> {
  final String key;

  PreferenceNotifier(this.key);

  @override
  S build() {
    return decode(_read());
  }

  Future<void> set(S s) {
    state = s;
    final v = encode(s);
    if (v == null) {
      return _sp.remove(key);
    }
    switch (v) {
      case int _:
        return _sp.setInt(key, v as int);
      case double _:
        return _sp.setDouble(key, v as double);
      case bool _:
        return _sp.setBool(key, v as bool);
      case String _:
        return _sp.setString(key, v as String);
      case List<String> _:
        return _sp.setStringList(key, v as List<String>);
      default:
        throw UnimplementedError();
    }
  }

  S decode(V? s) {
    return s as S;
  }

  V? encode(S s) {
    return s as V?;
  }

  V? _read() {
    switch (V) {
      case const (int):
        return _sp.getInt(key) as V?;
      case const (double):
        return _sp.getDouble(key) as V?;
      case const (bool):
        return _sp.getBool(key) as V?;
      case const (String):
        return _sp.getString(key) as V?;
      case const (List<String>):
        return _sp.getStringList(key) as V?;
      default:
        throw UnimplementedError();
    }
  }

  SharedPreferences get _sp => ref.read(sharedPreferencesProvider);
}
