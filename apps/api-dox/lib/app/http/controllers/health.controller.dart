import 'package:dox_core/dox_core.dart';

@Inject()
class HealthController {
  Map<String, String> show(DoxRequest req) {
    return <String, String>{'name': 'monthly-expense-api', 'status': 'ok'};
  }
}
