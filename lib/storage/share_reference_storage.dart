import 'dart:developer';

import 'package:gps_speed/storage/key_value_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedReferenceStorage extends KeyValueStorage {
  SharedReferenceStorage();

  static SharedPreferences? _prefs;

  Future<SharedPreferences> _init() {
    if (_prefs == null) {
      return SharedPreferences.getInstance().then((value) => _prefs = value);
    }

    return Future(() => _prefs!);
  }

  @override
  Future<T?> get<T>(String key, {T? Function(String value)? tryParse}) {
    return _init().then((prefs) {
      final value = prefs.getString(key);
      if (value == null) {
        return null;
      }

      if (tryParse != null) {
        return tryParse(value);
      }

      return value as T;
    }).onError((error, stackTrace) {
      log('error: $error', error: error, stackTrace: stackTrace);
      return null;
    });
  }

  @override
  Future set<T>(String key, T value) {
    return _init()
        .then((prefs) => prefs.setString(key, value.toString()).then((value) => null))
        .onError((error, stackTrace) {
      log('error: $error', error: error, stackTrace: stackTrace);
    });
  }
}
