import 'package:api_dox/utils/date_util.dart';
import 'package:dox_orm/dox_orm.dart';

/// A TIMESTAMP column as `YYYY-MM-DD HH:MM:SS` text (UTC). The drivers read
/// the column as `DateTime`; this turns it back into the stored text, and
/// saves text as it is (never a `DateTime`, which SQLite would store with
/// a `T`).
class TimestampText extends Cast<String> {
  const TimestampText();

  @override
  String? get(dynamic value) => DateUtil.timestampText(value);

  @override
  dynamic set(String? value) => value;
}

/// A DATE column as `YYYY-MM-DD` text.
class DateText extends Cast<String> {
  const DateText();

  @override
  String? get(dynamic value) => DateUtil.dateText(value);

  @override
  dynamic set(String? value) => value;
}
