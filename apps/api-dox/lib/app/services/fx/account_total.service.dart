import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/services/account.service.dart';
import 'package:api_dox/app/services/fx/coinbase_rate_provider.dart';
import 'package:api_dox/app/services/fx/fx.service.dart';
import 'package:api_dox/app/services/fx/gold_quote_provider.dart';
import 'package:api_dox/constants/fx.dart';
import 'package:api_dox/http/http_error.dart';
import 'package:dox_core/dox_core.dart';

/// The converted total of the wallets marked "include in total".
class AccountTotal {
  final String currency;
  final int totalCents;

  /// True when any counted wallet is in another currency.
  final bool approx;

  /// 1 unit of X ≈ rates[X] of [currency].
  final Map<String, double> rates;

  /// The ornament quote in [currency] (or THB when that rate is missing).
  final Map<String, dynamic>? gold;

  const AccountTotal({
    required this.currency,
    required this.totalCents,
    required this.approx,
    required this.rates,
    required this.gold,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'currency': currency,
      'totalCents': totalCents,
      'approx': approx,
      'rates': <String, Object?>{
        for (MapEntry<String, double> e in rates.entries)
          e.key: GoldQuote.jsonNumber(e.value),
      },
      'gold': gold,
    };
  }
}

/// The server does the conversion, so every client shows the same number
/// and none needs FX math.
@Inject()
class AccountTotalService {
  AccountTotalService(this.accounts, this.fx);

  final AccountService accounts;
  final FxService fx;

  Future<AccountTotal> total(User user, String rawCurrency) async {
    String currency = rawCurrency.toUpperCase();
    if (!RegExp(r'^[A-Z]{3}$').hasMatch(currency)) {
      throw HttpError.badRequest('Invalid currency code');
    }

    List<AccountWithBalance> all = await accounts.withBalances(user);
    List<Balance> counted = <Balance>[];
    bool approx = false;
    bool needsRates = false;
    Set<String> currencies = <String>{};
    for (AccountWithBalance account in all) {
      currencies.add(account.currency);
      if (account.currency != currency) needsRates = true;
      if (!account.includeInTotal) continue;
      counted.add(Balance(account.currency, account.balanceCents));
      if (account.currency != currency) approx = true;
    }
    RateTable rates = needsRates
        ? (await fx.ratesFor(currency)).rates
        : <String, double>{};

    Map<String, double> perUnit = <String, double>{};
    for (String code in currencies) {
      double? rate = rates[code];
      if (code != currency && rate != null && rate != 0 && rate.isFinite) {
        perUnit[code] = 1 / rate;
      }
    }

    return AccountTotal(
      currency: currency,
      totalCents: FxService.convertedTotalCents(counted, currency, rates),
      approx: approx,
      rates: perUnit,
      gold: currencies.contains(gold)
          ? await _goldInCurrency(currency, rates)
          : null,
    );
  }

  /// The ornament quote in the display currency (raw THB if that rate is
  /// missing). Never throws.
  Future<Map<String, dynamic>?> _goldInCurrency(
    String currency,
    RateTable rates,
  ) async {
    GoldQuote quote;
    try {
      quote = await fx.goldQuote();
    } catch (_) {
      return null;
    }
    double? thbPerUnit = currency == 'THB' ? 1 : rates['THB'];
    if (thbPerUnit == null || thbPerUnit == 0 || !thbPerUnit.isFinite) {
      return <String, dynamic>{...quote.toJson(), 'currency': 'THB'};
    }
    return <String, dynamic>{
      'buyOrnament': GoldQuote.jsonNumber(quote.buyOrnament / thbPerUnit),
      'sellOrnament': GoldQuote.jsonNumber(quote.sellOrnament / thbPerUnit),
      'currency': currency,
    };
  }
}
