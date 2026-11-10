/// Rates and the gold quote are kept in the file cache for an hour.
const Duration fxTtl = Duration(hours: 1);

/// Base fetched at boot so the first visit of the wallets tab does not wait.
const String fxWarmBase = 'THB';

/// Synthetic currency: 1 GLD = 1 Thai baht-gold (บาททอง).
const String gold = 'GLD';

const String coinbaseRatesUrl = 'https://api.coinbase.com/v2/exchange-rates';

/// Hua Seng Heng's price list. Its `JEWEL` row is the 96.5% ornament quote
/// per baht-gold: what a shop pays you (Buy) and what you pay (Sell).
/// (thaigoldtoday.com was the source before; it got too slow.)
const String goldShopUrl =
    'https://apicheckprice.huasengheng.com/api/values/getprice/';

/// The shop answers in about 2 seconds. Past this, use the spot price.
const Duration goldShopTimeout = Duration(seconds: 5);

/// Fallback when the shop fails. PAXG is a token for one troy ounce of
/// gold. Its THB rate gives the spot price, with no shop spread.
const String goldTokenUrl = '$coinbaseRatesUrl?currency=PAXG';

/// One baht-gold is 15.244 g of 96.5% gold. A troy ounce is 31.1035 g.
/// So one baht-gold is this many troy ounces of pure gold.
const double ouncesPerBahtGold = 15.244 * 0.965 / 31.1035;

/// A rate provider that does not answer in time is treated as failed.
const Duration fxFetchTimeout = Duration(seconds: 15);

/// After a failed fetch, wait this long before trying that provider again.
const Duration fxRetryAfter = Duration(minutes: 5);

/// Coinbase only has Myanmar's official MMK rate. The street rate is higher.
/// We multiply the Coinbase rate by this fixed ratio.
/// Measured on 2026-11-08: Bybit P2P median 4757 / Coinbase 2100 ≈ 2.265.
// ponytail: fixed ratio, drifts with the market. Update it by hand, or fetch Bybit in the background if it drifts too often.
const double mmkMarketRatio = 2.265;
