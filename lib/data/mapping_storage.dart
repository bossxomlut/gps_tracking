abstract class MappingStorage<K, V> {
  final Map<String, V> _mapping = {};

  void setValue(K key, V value) {
    _mapping[getKey(key)] = value;
  }

  bool checkContains(K key) {
    return _mapping.containsKey(key);
  }

  String getKey(K key);

  V? getValue(K key) {
    return _mapping[getKey(key)];
  }

  void clear() {
    _mapping.clear();
  }
}
