import 'package:dox_core/dox_core.dart';

/// One stored value and when it was written.
class CacheEntry<T> {
  /// When the value was written (ms since epoch).
  final int at;
  final T value;

  const CacheEntry(this.at, this.value);
}

/// Values that outlive their freshness, on the Dox cache.
///
/// The store is the `file` store of `lib/config/cache.dart` (`CACHE_DIR`,
/// the Docker volume), so values survive a restart and all isolates share
/// them. Values are kept with no expiry: callers decide what "fresh" means
/// from `at`, and an old value stays readable as a fallback. Every failure
/// is swallowed: a broken cache only means a fetch.
@Inject()
class FileCache {
  FileCache();

  /// A cache on [manager] instead of `Dox().cache`, for tests.
  FileCache.withManager(CacheManager this._manager);

  CacheManager? _manager;

  Cache get _cache => Cache(manager: _manager);

  /// The stored entry, however old. Null when missing or unreadable.
  Future<CacheEntry<Object?>?> read(String key) async {
    try {
      Object? json = await _cache.get(key);
      if (json is! Map || json['at'] is! num) return null;
      return CacheEntry<Object?>((json['at'] as num).toInt(), json['value']);
    } catch (_) {
      return null;
    }
  }

  /// Store [value] under [key], with the time. [index] also lists the key
  /// under that name, so [keys] can find it again.
  Future<CacheEntry<T>> write<T>(String key, T value, {String? index}) async {
    CacheEntry<T> entry = CacheEntry<T>(
      DateTime.now().millisecondsSinceEpoch,
      value,
    );
    try {
      await _cache.forever(key, <String, Object?>{
        'at': entry.at,
        'value': value,
      });
      if (index != null) await _addToIndex(index, key);
    } catch (_) {
      // read-only or full disk: run without the cache
    }
    return entry;
  }

  /// Read, add, write back, under a lock: two isolates that add two keys at
  /// once would each write their own list, and one key would be lost.
  Future<void> _addToIndex(String index, String key) async {
    CacheLock lock = _cache.lock('$index:keys-lock', _indexLockTtl);
    if (!await lock.block(_indexLockTtl)) return;
    try {
      List<String> listed = await keys(index);
      if (!listed.contains(key)) {
        await _cache.forever('$index:keys', <String>[...listed, key]);
      }
    } finally {
      await lock.release();
    }
  }

  static const Duration _indexLockTtl = Duration(seconds: 5);

  /// The keys written with this [index].
  Future<List<String>> keys(String index) async {
    try {
      Object? list = await _cache.get('$index:keys');
      return list is List ? <String>[for (Object? k in list) '$k'] : <String>[];
    } catch (_) {
      return <String>[];
    }
  }
}
