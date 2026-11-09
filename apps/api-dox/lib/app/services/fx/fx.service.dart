import 'package:api_dox/app/services/fx/coinbase_rate_provider.dart';
import 'package:api_dox/app/services/fx/gold_quote_provider.dart';
import 'package:api_dox/constants/fx.dart';
import 'package:api_dox/http/http_error.dart';
import 'package:api_dox/utils/money_util.dart';
import 'package:dox_core/dox_core.dart';

/// A rate table for one base currency.
class RatesResult {
  final String base;
  final int at;
  final RateTable rates;

  const RatesResult(this.base, this.at, this.rates);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'base': base,
      'at': at,
      'rates': <String, Object?>{
        for (MapEntry<String, double> e in rates.entries)
          e.key: GoldQuote.jsonNumber(e.value),
      },
    };
  }
}

/// One amount in one currency, for [FxService.convertedTotalCents].
class Balance {
  final String currency;
  final int balanceCents;

  const Balance(this.currency, this.balanceCents);
}

final RegExp _currencyCode = RegExp(r'^[A-Z]{3}$');

/// FX rates for the wallets total. The backend proxies them so every
/// client shares one cache. Coinbase gives every rate. Its MMK rate is the
/// official one, so we scale it by [mmkMarketRatio]. Gold (GLD) comes from
/// its own provider.
@Inject()
class FxService {
  FxService(this.coinbase, this.goldProvider);

  final CoinbaseRateProvider coinbase;
  final GoldQuoteProvider goldProvider;

  Future<GoldQuote> goldQuote() => goldProvider.quote();

  /// Rates as "1 unit of [base] = rates[X] units of X".
  Future<RatesResult> ratesFor(String base) async {
    String key = base.toUpperCase();
    if (!_currencyCode.hasMatch(key)) {
      throw HttpError.badRequest('Invalid currency code');
    }
    if (key == gold) return _goldBase();

    TimedRates table = await coinbase.rates(key);
    applyMmkMarketRatio(key, table.rates);
    return RatesResult(key, table.at, await _withOverrides(table.rates));
  }

  /// Fetch the gold quote and every cached base again. A failure keeps the
  /// old entry; the next request retries.
  Future<void> refreshCachedBases() async {
    try {
      await goldProvider.refresh();
    } catch (_) {
      // provider hiccup
    }
    for (String base in await coinbase.cachedBases()) {
      try {
        await coinbase.refresh(base);
      } catch (_) {
        // provider hiccup
      }
    }
  }

  /// Sum balances into [currency] cents using [rates] ("1 unit of currency
  /// = rates[X] units of X"). Throws 502 when a needed rate is missing: an
  /// honest error beats a wrong total.
  static int convertedTotalCents(
    List<Balance> accounts,
    String currency,
    RateTable rates,
  ) {
    double sum = 0;
    for (Balance account in accounts) {
      if (account.currency == currency) {
        sum += account.balanceCents;
        continue;
      }
      double? rate = rates[account.currency];
      if (rate == null || rate == 0 || !rate.isFinite) {
        throw HttpError.badGateway('No exchange rate for ${account.currency}');
      }
      sum += account.balanceCents / rate;
    }
    return MoneyUtil.jsRound(sum);
  }

  /// Turn Coinbase's official MMK rate into the street rate. With base MMK,
  /// 1 MMK buys less of everything else, so every other rate is divided.
  /// [rates] is a fresh copy from the provider, so changing it is safe.
  static void applyMmkMarketRatio(String base, RateTable rates) {
    if (base != 'MMK') {
      double? mmk = rates['MMK'];
      if (mmk != null && mmk != 0 && !mmk.isNaN) {
        rates['MMK'] = mmk * mmkMarketRatio;
      }
      return;
    }
    for (String code in rates.keys.toList()) {
      if (code != 'MMK') rates[code] = rates[code]! / mmkMarketRatio;
    }
  }

  /// 1 GLD = thbPerGold THB, then fan out through the THB table.
  Future<RatesResult> _goldBase() async {
    RatesResult thbTable = await ratesFor('THB');
    double thbPerGold = await goldProvider.thbPerGold();
    RateTable rates = <String, double>{gold: 1};
    thbTable.rates.forEach((String code, double value) {
      if (code != gold) rates[code] = value * thbPerGold;
    });
    return RatesResult(gold, thbTable.at, rates);
  }

  /// Add GLD to a Coinbase table. A failed gold quote leaves GLD out, so
  /// only requests that need it fail.
  Future<RateTable> _withOverrides(RateTable rates) async {
    try {
      double? thb = rates['THB'];
      if (thb != null && thb != 0 && !thb.isNaN) {
        rates[gold] = thb / await goldProvider.thbPerGold();
      }
    } catch (_) {
      // gold provider hiccup
    }
    return rates;
  }
}
