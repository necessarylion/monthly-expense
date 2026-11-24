import 'package:dox_core/dox_core.dart';

part 'smart_add.dto.g.dart';

/// Body of POST /smart-add: what the user typed, like "lunch 5000, taxi 3000".
@Dto(keyCase: KeyCase.field)
class SmartAddText {
  @Trim()
  @Length(min: 1, max: 500)
  final String text;

  /// The user's today, so a late-night add lands on their day.
  @DateFormatted('Y-m-d')
  final String today;

  const SmartAddText({required this.text, required this.today});

  static const DtoSchema<SmartAddText> schema = $SmartAddTextDto;
}
