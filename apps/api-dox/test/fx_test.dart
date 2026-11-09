import 'dart:io';

import 'package:api_dox/app/services/file_cache.dart';
import 'package:api_dox/app/services/fx/coinbase_rate_provider.dart';
import 'package:api_dox/app/services/fx/fx.service.dart';
import 'package:api_dox/constants/fx.dart';
import 'package:api_dox/http/http_error.dart';
import 'package:dox_core/dox_core.dart';
import 'package:dox_core/testing.dart';
import 'package:test/test.dart';

import 'support/test_app.dart';

/// The wallets total is money math. Same-currency balances pass through
/// exactly, foreign ones divide by the rate, and a missing rate must fail.
void main() {
  group('converted accounts total', () {
    // "1 THB = rates[X] units of X"
    RateTable rates = <String, double>{'USD': 0.03, 'AUD': 0.04};

    test('same-currency balances sum exactly, no rates needed', () {
      List<Balance> accounts = <Balance>[
        const Balance('THB', 10000),
        const Balance('THB', -2500),
      ];
      expect(
        FxService.convertedTotalCents(accounts, 'THB', <String, double>{}),
        7500,
      );
    });

    test('foreign balances divide by the rate and round to cents', () {
      List<Balance> accounts = <Balance>[
        const Balance('THB', 10000),
        const Balance('USD', 300), // 300 / 0.03 = 10000
        const Balance('AUD', 100), // 100 / 0.04 = 2500
      ];
      expect(FxService.convertedTotalCents(accounts, 'THB', rates), 22500);
    });

    test('missing or non-finite rate throws instead of guessing', () {
      List<Balance> accounts = <Balance>[const Balance('MMK', 100)];
      expect(
        () => FxService.convertedTotalCents(accounts, 'THB', rates),
        throwsA(isA<HttpError>()),
      );
      expect(
        () => FxService.convertedTotalCents(accounts, 'THB', <String, double>{
          'MMK': 0,
        }),
        throwsA(isA<HttpError>()),
      );
    });
  });

  group('MMK market ratio', () {
    test('scales MMK up when MMK is a target', () {
      RateTable rates = <String, double>{'MMK': 2100, 'THB': 32};
      FxService.applyMmkMarketRatio('USD', rates);
      expect(rates['MMK'], closeTo(2100 * mmkMarketRatio, 1e-9));
      expect(rates['THB'], 32);
    });

    test('scales every other rate down when MMK is the base', () {
      RateTable rates = <String, double>{'MMK': 1, 'USD': 1 / 2100};
      FxService.applyMmkMarketRatio('MMK', rates);
      expect(rates['MMK'], 1);
      expect(1 / rates['USD']!, closeTo(2100 * mmkMarketRatio, 1e-6));
    });
  });

  /// Exchange rates live in a JSON file for an hour, then get fetched again.
  group('exchange rate file cache', () {
    Directory dir = Directory.systemTemp.createTempSync('expense-fx-cache-');
    FakeHttpFetch fetch = FakeHttpFetch();
    CacheManager manager = CacheManager(
      CacheConfig(
        defaultStore: 'file',
        stores: <String, Map<String, dynamic>>{
          'file': <String, dynamic>{'driver': 'file', 'path': dir.path},
        },
      ),
    );
    FileCache cache = FileCache.withManager(manager);
    CoinbaseRateProvider provider = CoinbaseRateProvider(cache, fetch);

    void serve(double? usd) {
      fetch.answers.clear();
      if (usd == null) return; // down
      fetch.answers[coinbaseRatesUrl] = <String, dynamic>{
        'data': <String, dynamic>{
          'rates': <String, dynamic>{'USD': '$usd'},
        },
      };
    }

    Future<void> makeOld() async {
      Map<dynamic, dynamic> entry = await Cache(
        manager: manager,
      ).get('fx-coinbase-THB') as Map<dynamic, dynamic>;
      await Cache(
        manager: manager,
      ).forever('fx-coinbase-THB', <String, Object?>{
        'at': DateTime.now().millisecondsSinceEpoch - fxTtl.inMilliseconds - 1,
        'value': entry['value'],
      });
    }

    tearDownAll(() => dir.deleteSync(recursive: true));

    test(
      'the first call fetches and writes the file; the next one reads it',
      () async {
        serve(0.03);
        expect((await provider.rates('THB')).rates['USD'], 0.03);
        expect((await provider.rates('THB')).rates['USD'], 0.03);
        expect(fetch.calls, 1);
        expect(await provider.cachedBases(), <String>['THB']);
      },
    );

    test('a table older than an hour is fetched again', () async {
      await makeOld();
      serve(0.031);
      expect((await provider.rates('THB')).rates['USD'], 0.031);
      expect(fetch.calls, 2);
    });

    test('a stale table is used when the provider is down', () async {
      await makeOld();
      serve(null);
      expect((await provider.rates('THB')).rates['USD'], 0.031);
      expect(fetch.calls, 3);
    });

    test('the entry keeps when it was written', () async {
      CacheEntry<Object?>? entry = await cache.read('fx-coinbase-THB');
      expect(entry?.value, <String, dynamic>{'USD': 0.031});
      expect(entry?.at, greaterThan(0));
    });
  });

  group('the /fx and /accounts/total routes', () {
    late TestApp app;

    setUpAll(() async {
      app = await TestApp.start();
    });

    tearDownAll(() async {
      await app.close();
      Directory('storage/test-cache').deleteSync(recursive: true);
    });

    test('rates with gold, and a total across currencies', () async {
      app.fetch.answers[coinbaseRatesUrl] = <String, dynamic>{
        'data': <String, dynamic>{
          'rates': <String, dynamic>{'USD': '0.03', 'THB': '1', 'MMK': '60'},
        },
      };
      app.fetch.answers[goldPriceUrl] = <String, dynamic>{
        'current': <String, dynamic>{
          'buyOrnament': 43500,
          'sellOrnament': '44000',
        },
      };

      TestResponse fx = await app.call('/api/v1/fx?base=THB', user: 'fx');
      fx.expectStatus(200);
      Map<String, dynamic> data = fx.json['data'] as Map<String, dynamic>;
      expect(data['base'], 'THB');
      expect(data['at'], isA<int>());
      expect(data['rates']['USD'], 0.03);
      expect(data['rates']['MMK'], closeTo(60 * mmkMarketRatio, 1e-9));
      expect(data['rates']['GLD'], closeTo(1 / 44000, 1e-12));
      expect(data['gold'], <String, dynamic>{
        'buyOrnament': 43500,
        'sellOrnament': 44000,
      });

      Future<void> wallet(String currency, num amount) async {
        TestResponse created = await app.call(
          '/api/v1/accounts',
          method: 'POST',
          user: 'fx',
          body: <String, dynamic>{
            'name': currency,
            'currency': currency,
            'color': '#000000',
          },
        );
        await app.call(
          '/api/v1/accounts/${created.json['data']['id']}/entries',
          method: 'POST',
          user: 'fx',
          body: <String, dynamic>{'amount': amount, 'occurredOn': '2026-11-01'},
        );
      }

      await wallet('THB', 100);
      await wallet('USD', 3); // 300 cents / 0.03 = 10000 cents
      TestResponse total = await app.call(
        '/api/v1/accounts/total?currency=thb',
        user: 'fx',
      );
      expect(total.json['data'], <String, dynamic>{
        'currency': 'THB',
        'totalCents': 20000,
        'approx': true,
        'rates': <String, dynamic>{'USD': closeTo(1 / 0.03, 1e-9)},
        'gold': null,
      });

      (await app.call('/api/v1/accounts/total?currency=TOOLONG', user: 'fx'))
          .expectStatus(400)
          .expectJson(<String, dynamic>{'message': 'Invalid currency code'});
    });
  });
}
