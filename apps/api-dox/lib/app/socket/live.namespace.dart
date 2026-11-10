import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/services/api_token.service.dart';
import 'package:api_dox/app/services/live.service.dart';
import 'package:api_dox/constants/live.dart';
import 'package:dox_core/dox_core.dart';
import 'package:dox_socketio/dox_socketio.dart';

/// The default namespace `/`. The app connects with its API token in
/// `auth.token`, and the socket joins the room of its user. The server
/// only sends here (see `LiveService`); the app sends nothing.
///
/// The token is checked once, at connect, and again on each reconnect.
class LiveNamespace extends NamespaceHandler {
  @override
  String get path => '/';

  @override
  List<Middleware> get middleware => <Middleware>[SocketAuth(findUser).handle];

  /// Same checks as `AuthMiddleware` and `TwoFactorMiddleware`. A bad
  /// token gives null (`Unauthorized`). Anything else (the database is
  /// down) throws [liveUnavailable], so the app knows to try again.
  static Future<User?> findUser(Handshake handshake) async {
    String? token = handshake.token;
    if (token == null || token.isEmpty) return null;
    ApiSession? session;
    try {
      session = await Dox().ioc.get<ApiTokenService>().verify(token);
    } catch (error) {
      Logger.warn('[live] token check failed: $error');
      throw SocketIoException(liveUnavailable);
    }
    if (session == null) return null;
    User user = session.user;
    if (user.totpEnabled == true && !session.secondFactor) return null;
    return user;
  }

  @override
  void onConnection(Socket socket) {
    User user = socket.user! as User;
    socket.join(LiveService.roomOf(user.id!));
  }
}
