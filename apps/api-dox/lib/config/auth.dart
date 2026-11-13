import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/constants/limits.dart';
import 'package:dox_auth/dox_auth.dart';

/// Makes a new User model for dox_auth.
User makeAuthUser() {
  return User();
}

/// One guard: the web app's API tokens (`oat_<id>.<secret>`), kept in
/// `auth_access_tokens`. See `ApiTokenService`.
AuthConfig authConfig = AuthConfig(
  defaultGuard: apiGuard,
  guards: <String, AuthGuard>{
    apiGuard: AuthGuard(
      driver: AccessTokenAuthDriver(
        expiresIn: apiTokenLife,
        // A database error is a 503, not a 401: the web app logs the user
        // out on every 401.
        throwOnError: true,
      ),
      provider: AuthProvider(model: makeAuthUser),
    ),
  },
);
