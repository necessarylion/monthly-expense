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

  /// A number, or a string like `"63,308.16"`. NaN when it is neither.
  static double _number(Object? value) {
    if (value is num) return value.toDouble();
    String text = (value?.toString() ?? '').replaceAll(',', '');
    return double.tryParse(text) ?? double.nan;
  }
}

const String _key = 'fx-gold';

/// The baht-gold ornament quote from Hua Seng Heng, or the PAXG spot price
/// of Coinbase when the shop fails. Kept in the file cache for [fxTtl] (an hour). A stale quote beats an
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

  Future<GoldQuote?> _fetchCurrent() async =>
      await _fetchShop() ?? await _fetchSpot();

  /// The shop's `JEWEL` row (96.5% ornament gold), with its own buy and sell.
  Future<GoldQuote?> _fetchShop() async {
    Object? json = await http.getJson(goldShopUrl, timeout: goldShopTimeout);
    if (json is! List) return null;
    for (Object? row in json) {
      if (row is! Map || row['GoldType'] != 'JEWEL') continue;
      double buy = GoldQuote._number(row['Buy']);
      double sell = GoldQuote._number(row['Sell']);
      if (buy.isFinite && sell.isFinite && buy > 0 && sell >= buy) {
        return GoldQuote(buy, sell);
      }
    }
    return null;
  }

  /// THB per ounce from the PAXG rates, turned into THB per baht-gold.
  /// The spot price has no shop spread, so buy and sell are the same.
  Future<GoldQuote?> _fetchSpot() async {
    Object? json = await http.getJson(goldTokenUrl);
    Object? data = json is Map ? json['data'] : null;
    Object? rates = data is Map ? data['rates'] : null;
    if (rates is! Map) return null;
    double perOunce = GoldQuote._number(rates['THB']);
    double price = (perOunce * ouncesPerBahtGold).roundToDouble();
    return GoldQuote(price, price);
  }

  static int _age(int at) => DateTime.now().millisecondsSinceEpoch - at;
}
