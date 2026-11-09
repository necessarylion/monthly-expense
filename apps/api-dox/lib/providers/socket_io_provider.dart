import 'package:api_dox/config/socketio.dart';
import 'package:dox_socketio/dox_socketio.dart';

/// Mounts Socket.IO on the API port, in every isolate.
class AppSocketIoProvider extends SocketIoProvider {
  AppSocketIoProvider() : super(socketIoConfig);
}
