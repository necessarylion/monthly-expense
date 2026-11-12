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
    'Claude explains `?month=YYYY-MM` as A2UI v0.9 messages, for '
    '`@a2ui/react`. `?lang=en|my` picks the language.',
  )
  Future<Map<String, dynamic>> month(DoxRequest req, InsightQuery query) async {
    List<Map<String, dynamic>> messages = await insights.explain(
      req.activeGroup,
      MonthUtil.parse(query.month),
      query.lang ?? 'en',
    );
    return JsonResponse.ok(<String, dynamic>{'messages': messages});
  }
}
