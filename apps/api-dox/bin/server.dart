import 'package:api_dox/app/services/firebase.service.dart';
import 'package:api_dox/app/services/fx/fx.service.dart';
import 'package:api_dox/config/app.dart';
import 'package:api_dox/constants/fx.dart';
import 'package:api_dox/db/migrate.dart';
import 'package:dox_core/dox_core.dart';

import '../db/migration/migrations.dart';

Future<void> main() async {
  Dox().initialize(appConfig);

  /// Run pending migrations once, before the server starts. On SQLite a
  /// backup of the file is written first.
  await DbMigrator(migrations).run();

  await Dox().startServer();

  /// This is the main isolate (isolate 1). Only it warms up Firebase and
  /// the FX cache (a file all isolates read). The hourly refresh is in
  /// `lib/config/schedule.dart`.
  Dox().ioc.get<FirebaseService>().warmUp();
  await _warmFx();
}

/// One base at boot, so the first visit of the wallets tab does not wait.
Future<void> _warmFx() async {
  try {
    await Dox().ioc.get<FxService>().ratesFor(fxWarmBase);
  } catch (error) {
    Logger.warn('[fx] warm-up failed: $error');
  }
}
