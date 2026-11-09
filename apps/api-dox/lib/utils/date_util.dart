/// Dates are stored as text, the same way the old APIs stored them:
/// - DATE columns: `YYYY-MM-DD`
/// - TIMESTAMP columns: `YYYY-MM-DD HH:MM:SS`, in UTC
///
/// The database drivers read these columns back as `DateTime`. The
/// repositories turn them into this text again with [dateText] and
/// [timestampText], so the rest of the app only sees text.
class DateUtil {
  /// The current time in the TIMESTAMP column format.
  static String nowSql() => timestampText(DateTime.now().toUtc())!;

  /// Today as `YYYY-MM-DD` (UTC).
  static String today() => _date(DateTime.now().toUtc());

  /// `YYYY-MM-DD` moved by [days] (negative goes back).
  static String addDays(String iso, int days) {
    DateTime date = DateTime.parse('${iso}T00:00:00Z');
    return _date(DateTime.utc(date.year, date.month, date.day + days));
  }

  /// A TIMESTAMP column value as an ISO 8601 string for JSON, like
  /// `2026-08-18T10:00:00.000Z`. Text that is not a date is sent as it is.
  static String? toIso(String? value) {
    if (value == null || value.isEmpty) return null;
    DateTime? date = DateTime.tryParse('${value.replaceFirst(' ', 'T')}Z');
    return date == null ? value : date.toIso8601String();
  }

  /// A DATE column value, as the driver gives it, to `YYYY-MM-DD`.
  static String? dateText(Object? value) {
    if (value == null) return null;
    if (value is DateTime) return _date(_asUtc(value));
    String text = value.toString();
    return text.length >= 10 ? text.substring(0, 10) : text;
  }

  /// A TIMESTAMP column value, as the driver gives it, to
  /// `YYYY-MM-DD HH:MM:SS`.
  static String? timestampText(Object? value) {
    if (value == null) return null;
    if (value is DateTime) {
      DateTime utc = _asUtc(value);
      return '${_date(utc)} ${_two(utc.hour)}:${_two(utc.minute)}:${_two(utc.second)}';
    }
    String text = value.toString().replaceFirst('T', ' ');
    if (text.endsWith('Z')) text = text.substring(0, text.length - 1);
    int dot = text.indexOf('.');
    return dot > 0 ? text.substring(0, dot) : text;
  }

  /// The drivers read a column with no zone as local time. The server runs
  /// with TZ=UTC, but tests may not, so take the parts as UTC.
  static DateTime _asUtc(DateTime value) {
    if (value.isUtc) return value;
    return DateTime.utc(
      value.year,
      value.month,
      value.day,
      value.hour,
      value.minute,
      value.second,
    );
  }

  static String _date(DateTime d) {
    return '${d.year.toString().padLeft(4, '0')}-${_two(d.month)}-${_two(d.day)}';
  }

  static String _two(int n) => n.toString().padLeft(2, '0');
}
