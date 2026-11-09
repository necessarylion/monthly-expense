/// Reads aggregate values (`sum`, `count`) the same way on SQLite and
/// Postgres. Model rows go through the models; only rows of a `selectRaw`
/// or `groupBy` query are plain maps.
///
/// The drivers differ: Postgres gives `numeric` (a `sum` of a bigint) as
/// text, SQLite gives `int`.
class DbRow {
  /// `int`, `double` or numeric text to an `int`. Null stays null.
  static int? toInt(Object? value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return num.tryParse(value.toString())?.toInt();
  }
}
