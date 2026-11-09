import 'package:api_dox/app/services/file_cache.dart';
import 'package:api_dox/app/services/fx/http_fetch.dart';
import 'package:api_dox/constants/fx.dart';
import 'package:api_dox/http/http_error.dart';
import 'package:dox_core/dox_core.dart';

/// "1 unit of base = rates[X] units of X".
typedef RateTable = Map<String, double>;

/// A rate table and when it was fetched (ms since epoch).
class TimedRates {
  final int at;
  final RateTable rates;

  const TimedRates(this.at, this.rates);
}

const String _keyPrefix = 'fx-coinbase-';

/// Rates from Coinbase's free public endpoint. Each base's table is kept in
/// the file cache for [fxTtl] (an hour).
@Inject()
class CoinbaseRateProvider {
  CoinbaseRateProvider(this.cache, this.http);

  final FileCache cache;
  final HttpFetch http;

  Future<TimedRates> rates(String base) async {
    CacheEntry<Object?>? hit = await cache.read(_keyPrefix + base);
    RateTable? table = _table(hit?.value);
    if (hit != null && table != null && _fresh(hit.at)) {
      return TimedRates(hit.at, table);
    }
    return _fetchAndStore(base, hit);
  }

  /// Fetch now, whatever the cache holds. The hourly job uses this.
  Future<void> refresh(String base) async {
    await _fetchAndStore(base, await cache.read(_keyPrefix + base));
  }

  /// Bases in the cache. The hourly job refreshes these.
  Future<List<String>> cachedBases() async {
    return <String>[
      for (String key in await cache.keys(_keyPrefix))
        key.substring(_keyPrefix.length),
    ];
  }

  Future<TimedRates> _fetchAndStore(
    String base,
    CacheEntry<Object?>? stale,
  ) async {
    RateTable? rates = await _fetchTable(base);
    if (rates == null) {
      // A stale table beats an error. The total is approximate anyway.
      RateTable? old = _table(stale?.value);
      if (stale != null && old != null) return TimedRates(stale.at, old);
      throw HttpError.badGateway('Exchange rates unavailable');
    }
    CacheEntry<RateTable> entry = await cache.write(
      _keyPrefix + base,
      rates,
      index: _keyPrefix,
    );
    return TimedRates(entry.at, RateTable.of(rates));
  }

  Future<RateTable?> _fetchTable(String base) async {
    Object? json = await http.getJson('$coinbaseRatesUrl?currency=$base');
    Object? data = json is Map ? json['data'] : null;
    Object? raw = data is Map ? data['rates'] : null;
    if (raw is! Map) return null;
    RateTable rates = <String, double>{
      for (MapEntry<dynamic, dynamic> e in raw.entries)
        e.key.toString(): _number(e.value),
    };
    return rates.isEmpty ? null : rates;
  }

  /// A cached table, as a fresh copy (callers change it in place).
  static RateTable? _table(Object? value) {
    if (value is! Map) return null;
    return <String, double>{
      for (MapEntry<dynamic, dynamic> e in value.entries)
        e.key.toString(): _number(e.value),
    };
  }

  /// JavaScript `Number(value)`: text or a number, else NaN.
  static double _number(Object? value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? double.nan;
  }

  static bool _fresh(int at) {
    return DateTime.now().millisecondsSinceEpoch - at < fxTtl.inMilliseconds;
  }
}
