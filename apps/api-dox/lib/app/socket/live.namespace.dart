import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/services/firebase.service.dart';
import 'package:api_dox/app/services/live.service.dart';
import 'package:api_dox/app/services/user.service.dart';
import 'package:api_dox/constants/live.dart';
import 'package:dox_core/dox_core.dart';
import 'package:dox_socketio/dox_socketio.dart';

/// The default namespace `/`. The app connects with its Firebase ID token
/// in `auth.token`, and the socket joins the room of its user. The server
/// only sends here (see `LiveService`); the app sends nothing.
///
/// The token is checked once, at connect. The app sends a fresh one on
/// each reconnect.
class LiveNamespace extends NamespaceHandler {
  @override
  String get path => '/';

  @override
  List<Middleware> get middleware => <Middleware>[SocketAuth(findUser).handle];

  /// Same checks as `AuthMiddleware`. A bad token or a not allowed email
  /// gives null (`Unauthorized`). Anything else (Firebase or the database
  /// is down) throws [liveUnavailable], so the app knows to try again.
  static Future<User?> findUser(Handshake handshake) async {
    String? token = handshake.token;
    if (token == null || token.isEmpty) return null;
    FirebaseIdentity identity;
    try {
      identity = await Dox().ioc.get<FirebaseService>().verifyIdToken(token);
    } on InvalidIdTokenException {
      return null;
    } catch (error) {
      Logger.warn('[live] Firebase is not reachable: $error');
      throw SocketIoException(liveUnavailable);
    }
    UserService users = Dox().ioc.get<UserService>();
    if (!users.isEmailAllowed(identity.email)) return null;
    try {
      User user = await users.findOrCreate(identity);
      // same rule as `TwoFactorMiddleware`
      if (user.totpEnabled == true && !identity.secondFactor) return null;
      return user;
    } catch (error) {
      Logger.warn('[live] user setup failed: $error');
      throw SocketIoException(liveUnavailable);
    }
  }

  @override
  void onConnection(Socket socket) {
    User user = socket.user! as User;
    socket.join(LiveService.roomOf(user.id!));
  }
}
