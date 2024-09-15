import 'package:gps_speed/storage/share_reference_storage.dart';

abstract class KeyValueStorage {
  KeyValueStorage();

  factory KeyValueStorage.i() {
    return SharedReferenceStorage();
  }

  Future set<T>(String key, T value);
  Future<T?> get<T>(String key, {T? Function(String value)? tryParse});
}
