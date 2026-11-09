import 'dart:convert';

import 'package:api_dox/config/settings.dart';
import 'package:dox_core/dox_core.dart';

/// `/config.js`: the Firebase Web SDK config from the env, for the SPA.
/// `index.html` loads it before the app, so a self-hosted image uses its
/// own Firebase project without a rebuild.
@Inject()
class ConfigController {
  ConfigController(this.settings);

  final AppSettings settings;

  DoxResponse script(DoxRequest req) {
    String config = jsonEncode(<String, String?>{
      'apiKey': settings.firebaseApiKey,
      'authDomain': settings.firebaseAuthDomain,
      'projectId': settings.firebaseProjectId,
      'appId': settings.firebaseAppId,
    });
    return response('window.__APP_CONFIG__ = $config;\n')
        .withHeaders(<String, String>{
          'Content-Type': 'application/javascript; charset=utf-8',
          'Cache-Control': 'no-cache',
        });
  }
}
