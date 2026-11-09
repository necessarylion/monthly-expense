import 'package:api_dox/app/socket/live.namespace.dart';
import 'package:api_dox/config/settings.dart';
import 'package:dox_socketio/dox_socketio.dart';

/// Socket.IO at `/socket.io/`, for live updates (see `LiveService`).
///
/// - Websocket only: long-polling sends many requests, and they can reach
///   different isolates.
/// - With many isolates the provider uses the `IsolateAdapter`, so an
///   event reaches the sockets of every isolate.
/// - Only the app's own pages may connect (`APP_URL`, `FRONTEND_URLS`).
SocketIoConfig socketIoConfig = SocketIoConfig(
  options: ServerOptions(
    transports: const <String>['websocket'],
    allowedOrigins: <String>[settings.appUrl, ...settings.frontendUrls],
  ),
  namespaces: <NamespaceHandler>[LiveNamespace()],
);
