import 'package:api_dox/config/settings.dart';
import 'package:dox_core/dox_core.dart';

/// The Dox cache. The `file` store lives in `CACHE_DIR` (the Docker
/// volume), so exchange rates survive a restart and all isolates share
/// them.
CacheConfig cache = CacheConfig(
  defaultStore: 'file',
  stores: <String, Map<String, dynamic>>{
    'file': <String, dynamic>{'driver': 'file', 'path': settings.cacheDir},
  },
);
