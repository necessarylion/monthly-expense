import 'package:api_dox/http/http_error.dart';
import 'package:api_dox/utils/date_util.dart';

final RegExp monthRegex = RegExp(r'^(\d{4})-(0[1-9]|1[0-2])$');

/// One month: its `YYYY-MM` key, and its first and last day.
class MonthRange {
  final String key;
  final String start;
  final String end;

  const MonthRange(this.key, this.start, this.end);
}

class MonthUtil {
  /// `"2026-08"` -> first and last day of that month. No input = this month.
  static MonthRange parse([String? input]) {
    String key = (input == null || input.isEmpty)
        ? DateUtil.today().substring(0, 7)
        : input;
    RegExpMatch? match = monthRegex.firstMatch(key);
    if (match == null) {
      throw HttpError.badRequest('Invalid month, expected YYYY-MM');
    }
    int year = int.parse(match.group(1)!);
    int month = int.parse(match.group(2)!);
    // Day 0 of the next month is the last day of this month.
    int lastDay = DateTime.utc(year, month + 1, 0).day;
    return MonthRange(
      key,
      '$key-01',
      '$key-${lastDay.toString().padLeft(2, '0')}',
    );
  }
}
