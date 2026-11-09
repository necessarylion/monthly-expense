/// Rates and the gold quote are kept in the file cache for an hour.
const Duration fxTtl = Duration(hours: 1);

/// Base fetched at boot so the first visit of the wallets tab does not wait.
const String fxWarmBase = 'THB';

/// Synthetic currency: 1 GLD = 1 Thai baht-gold (บาททอง).
const String gold = 'GLD';

const String coinbaseRatesUrl = 'https://api.coinbase.com/v2/exchange-rates';
const String goldPriceUrl = 'https://www.thaigoldtoday.com/api/gold-price';

/// A rate provider that does not answer in time is treated as failed.
const Duration fxFetchTimeout = Duration(seconds: 15);

/// After a failed fetch, wait this long before trying that provider again.
const Duration fxRetryAfter = Duration(minutes: 5);

/// Coinbase only has Myanmar's official MMK rate. The street rate is higher.
/// We multiply the Coinbase rate by this fixed ratio.
/// Measured on 2026-11-08: Bybit P2P median 4757 / Coinbase 2100 ≈ 2.265.
// ponytail: fixed ratio, drifts with the market. Update it by hand, or fetch Bybit in the background if it drifts too often.
const double mmkMarketRatio = 2.265;
