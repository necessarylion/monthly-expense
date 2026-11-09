import 'package:api_dox/app/services/file_cache.dart';
import 'package:api_dox/app/services/fx/http_fetch.dart';
import 'package:api_dox/constants/fx.dart';
import 'package:api_dox/http/http_error.dart';
import 'package:dox_core/dox_core.dart';

/// The Thai gold ornament quote, in THB per baht-gold.
class GoldQuote {
  /// THB the shop pays you per baht-gold.
  final double buyOrnament;

  /// THB you pay per baht-gold.
  final double sellOrnament;

  const GoldQuote(this.buyOrnament, this.sellOrnament);

  /// A number that is not finite is `null`, like `JSON.stringify(NaN)`.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'buyOrnament': jsonNumber(buyOrnament),
      'sellOrnament': jsonNumber(sellOrnament),
    };
  }

  /// [value] as JavaScript writes it in JSON: `null` when not finite, an
  /// `int` when whole (`43500`, not `43500.0`).
  static Object? jsonNumber(double value) {
    if (!value.isFinite) return null;
    if (value == value.truncateToDouble() && value.abs() < 9e15) {
      return value.toInt();
    }
    return value;
  }

  /// A quote from the cache or the provider. Null when it is not one.
  static GoldQuote? fromJson(Object? value) {
    if (value is! Map) return null;
    double buy = _number(value['buyOrnament']);
    double sell = _number(value['sellOrnament']);
    return GoldQuote(buy, sell);
  }

  static double _number(Object? value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? double.nan;
  }
}

const String _key = 'fx-gold';

/// Thai Gold Traders Association ornament quote, via thaigoldtoday.com.
/// Kept in the file cache for [fxTtl] (an hour). A stale quote beats an
/// error.
@Inject()
class GoldQuoteProvider {
  GoldQuoteProvider(this.cache, this.http);

  final FileCache cache;
  final HttpFetch http;

  /// When a fetch last failed (ms since epoch), per isolate.
  int _failedAt = 0;

  Future<GoldQuote> quote() async {
    CacheEntry<Object?>? hit = await cache.read(_key);
    GoldQuote? cached = GoldQuote.fromJson(hit?.value);
    if (hit != null && cached != null && _age(hit.at) < fxTtl.inMilliseconds) {
      return cached;
    }
    return _fetchAndStore(cached);
  }

  /// Fetch now, whatever the cache holds. The hourly job uses this.
  Future<void> refresh() async {
    _failedAt = 0;
    await _fetchAndStore(GoldQuote.fromJson((await cache.read(_key))?.value));
  }

  /// THB value of one baht-gold. Uses the sell price, as the user chose.
  Future<double> thbPerGold() async => (await quote()).sellOrnament;

  Future<GoldQuote> _fetchAndStore(GoldQuote? stale) async {
    // After a failure, do not make every request wait for a dead provider.
    bool recentlyFailed = _age(_failedAt) < fxRetryAfter.inMilliseconds;
    GoldQuote? current = recentlyFailed ? null : await _fetchCurrent();
    double sell = current?.sellOrnament ?? double.nan;
    if (!sell.isFinite || sell <= 0) {
      if (!recentlyFailed) _failedAt = DateTime.now().millisecondsSinceEpoch;
      if (stale != null) return stale;
      throw HttpError.badGateway('Gold price unavailable');
    }
    await cache.write(_key, current!.toJson());
    return current;
  }

  Future<GoldQuote?> _fetchCurrent() async {
    Object? json = await http.getJson(goldPriceUrl);
    return json is Map ? GoldQuote.fromJson(json['current']) : null;
  }

  static int _age(int at) => DateTime.now().millisecondsSinceEpoch - at;
}
