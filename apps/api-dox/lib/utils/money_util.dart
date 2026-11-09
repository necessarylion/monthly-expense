/// Money is integer cents in the DB. Convert only at the edges.
class MoneyUtil {
  static int toCents(num amount) => jsRound(amount * 100);

  static double fromCents(int cents) => cents / 100;

  /// `1250` -> `"12.50"`
  static String format(int cents) => fixed2(fromCents(cents));

  /// `12.5` -> `"12.50"`, like JavaScript's `toFixed(2)`.
  static String fixed2(num value) => value.toStringAsFixed(2);

  /// JavaScript's `Math.round`: halves go up (`-0.5` -> `0`). Dart's
  /// `round()` moves halves away from zero, so `-0.5` would be `-1`.
  static int jsRound(num value) => (value + 0.5).floor();
}
