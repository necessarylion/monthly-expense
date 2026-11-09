import 'package:api_dox/config/schedule.dart';
import 'package:dox_scheduler/dox_scheduler.dart';

/// Runs `lib/config/schedule.dart` inside the server.
class ScheduleProvider extends SchedulerProvider {
  ScheduleProvider() : super(schedule: schedule, config: scheduleConfig);
}
