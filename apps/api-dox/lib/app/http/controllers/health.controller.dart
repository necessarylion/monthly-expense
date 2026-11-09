import 'package:dox_core/dox_core.dart';

@Inject()
@Tags(<String>['System'])
class HealthController {
  @Summary('Health check')
  @Description('For Docker and uptime monitors. No token needed.')
  Map<String, String> show(DoxRequest req) {
    return <String, String>{'name': 'monthly-expense-api', 'status': 'ok'};
  }
}
