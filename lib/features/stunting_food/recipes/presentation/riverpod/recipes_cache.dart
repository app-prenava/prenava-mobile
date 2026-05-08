class _CacheEntry<T> {
  final T value;
  final DateTime expiresAt;
  const _CacheEntry(this.value, this.expiresAt);
  bool get expired => DateTime.now().isAfter(expiresAt);
}

class RecipesMemoryCache {
  final Duration ttl;
  final _map = <String, _CacheEntry<dynamic>>{};

  RecipesMemoryCache({this.ttl = const Duration(minutes: 10)});

  T? get<T>(String key) {
    final entry = _map[key];
    if (entry == null) return null;
    if (entry.expired) {
      _map.remove(key);
      return null;
    }
    return entry.value as T;
  }

  void put<T>(String key, T value) {
    _map[key] = _CacheEntry(value, DateTime.now().add(ttl));
  }

  void clear() => _map.clear();
}

