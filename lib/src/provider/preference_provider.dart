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
    if (v is int) {
      return _sp.setInt(key, v);
    } else if (v is double) {
      return _sp.setDouble(key, v);
    } else if (v is bool) {
      return _sp.setBool(key, v);
    } else if (v is String) {
      return _sp.setString(key, v);
    } else if (v is List<String>) {
      return _sp.setStringList(key, v);
    } else {
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
    return _sp.get(key) as V?;
  }

  SharedPreferences get _sp => ref.read(sharedPreferencesProvider);
}
