import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/services/firebase.service.dart';
import 'package:api_dox/app/services/live.service.dart';
import 'package:api_dox/app/services/user.service.dart';
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

  /// Same checks as `AuthMiddleware`. Any failure is a refused socket.
  static Future<User?> findUser(Handshake handshake) async {
    String? token = handshake.token;
    if (token == null || token.isEmpty) return null;
    try {
      FirebaseIdentity identity = await Dox().ioc
          .get<FirebaseService>()
          .verifyIdToken(token);
      UserService users = Dox().ioc.get<UserService>();
      if (!users.isEmailAllowed(identity.email)) return null;
      return await users.findOrCreate(identity);
    } catch (error) {
      Logger.warn('[live] socket sign-in failed: $error');
      return null;
    }
  }

  @override
  void onConnection(Socket socket) {
    User user = socket.user! as User;
    socket.join(LiveService.roomOf(user.id!));
  }
}
