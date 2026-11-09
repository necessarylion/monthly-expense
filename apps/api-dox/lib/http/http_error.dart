import 'package:dox_core/dox_core.dart';

/// An error with an HTTP status. The client gets `{ "message": ... }`.
///
/// The message is a map, so Dox sends it as it is (see
/// `IHttpException.toResponse`). The web app reads `message`.
class HttpError extends IHttpException {
  HttpError(int status, String text, [Map<String, dynamic>? extra]) {
    code = status;
    errorCode = 'http_error';
    message = <String, dynamic>{'message': text, ...?extra};
  }

  /// The text of the error.
  String get text => (message as Map<String, dynamic>)['message'] as String;

  factory HttpError.badRequest(String text) => HttpError(400, text);

  factory HttpError.unauthorized(String text) => HttpError(401, text);

  factory HttpError.notFound(String text) => HttpError(404, text);

  factory HttpError.unprocessable(String text) => HttpError(422, text);

  factory HttpError.badGateway(String text) => HttpError(502, text);

  @override
  String toString() => 'HttpError($code): $text';
}
