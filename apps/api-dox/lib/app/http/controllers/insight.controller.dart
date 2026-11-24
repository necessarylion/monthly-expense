import 'package:api_dox/app/dtos/insight_query/insight_query.dto.dart';
import 'package:api_dox/app/services/ai/month_insight.service.dart';
import 'package:api_dox/http/json_response.dart';
import 'package:api_dox/http/request_context.dart';
import 'package:api_dox/utils/month_util.dart';
import 'package:dox_core/dox_core.dart';

@Inject()
@Tags(<String>['Insights'])
class InsightController {
  InsightController(this.insights);

  final MonthInsightService insights;

  @Summary('Explain a month')
  @Description(
    'The numbers of `?month=YYYY-MM` (`facts`), with a short `summary` and '
    '`tips` that Claude writes. `?lang=en|my` picks the language.',
  )
  Future<Map<String, dynamic>> month(DoxRequest req, InsightQuery query) async {
    Map<String, Object?> insight = await insights.explain(
      req.activeGroup,
      MonthUtil.parse(query.month),
      query.lang ?? 'en',
    );
    return JsonResponse.ok(insight);
  }
}
