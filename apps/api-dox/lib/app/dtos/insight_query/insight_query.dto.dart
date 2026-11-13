import 'package:dox_core/dox_core.dart';

part 'insight_query.dto.g.dart';

/// Query of GET /insights/month. No month: this month.
@Dto(source: Source.query, keyCase: KeyCase.field)
class InsightQuery {
  @DateFormatted('Y-m')
  final String? month;

  /// The app language, so Claude writes in it.
  @In(<Object>['en', 'my'])
  final String? lang;

  const InsightQuery({this.month, this.lang});

  static const DtoSchema<InsightQuery> schema = $InsightQueryDto;
}
