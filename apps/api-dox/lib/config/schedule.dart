import 'package:api_dox/app/services/fx/fx.service.dart';
import 'package:dox_core/dox_core.dart';
import 'package:dox_scheduler/dox_scheduler.dart';

/// Runs inside the server (`ScheduleProvider`), on the first isolate only.
/// The once-per-tick locks use the `file` cache store: fine for one host.
ScheduleConfig scheduleConfig = const ScheduleConfig(
  inProcess: true,
  store: 'file',
);

void schedule(Schedule s) {
  // Fetches every base seen so far again, so the wallets tab never waits.
  // onEveryServer: a second server refreshing too is harmless, so no shared
  // (Redis) lock is needed. It also stops the "file store" warning.
  s
      .call('fx-refresh', refreshFxRates)
      .everyFifteenMinutes()
      .onEveryServer()
      .withoutOverlapping();
}

Future<void> refreshFxRates() {
  return Dox().ioc.get<FxService>().refreshCachedBases();
}
