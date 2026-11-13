import 'package:api_dox/config/auth.dart';
import 'package:dox_auth/dox_auth.dart';
import 'package:dox_core/dox_core.dart';

/// Sets up dox_auth with the API token guard (see lib/config/auth.dart).
class AppAuthProvider extends DoxProvider {
  @override
  void setup() {
    Auth.initialize(authConfig);
  }
}
