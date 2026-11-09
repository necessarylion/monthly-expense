import 'dart:io';

import 'package:api_dox/config/env.dart';
import 'package:api_dox/http/http_error.dart';
import 'package:dox_core/dox_core.dart';

/// Turns any thrown error into `{ "message": ... }`, the shape the Bun API
/// sent. Dox's own errors (no route, body too big) get the same shape.
class AppExceptionHandler extends ExceptionHandler {
  const AppExceptionHandler();

  @override
  dynamic render(Object error, HttpRequest req) {
    // its message is already `{ message, ...extra }`
    if (error is HttpError) return error;

    if (error is ValidationException) return _validation(error);

    if (error is IHttpException) {
      DoxResponse res = response(<String, dynamic>{
        'message': _message(error, req),
      }).statusCode(error.code);
      if (error is HttpStatusException) {
        error.headers.forEach((String key, String value) {
          res.header(key, value);
        });
      }
      return res;
    }

    String message = env.isProduction ? 'Internal server error' : '$error';
    return response(<String, dynamic>{'message': message}).statusCode(500);
  }

  /// A failed DTO check: 422 with the body the Bun API sent, which the
  /// clients read: `{ message: "FIELD: TEXT", errors: [{ field,
  /// message, rule }] }`. `message` is the first error.
  static DoxResponse _validation(ValidationException error) {
    List<Map<String, String>> errors = <Map<String, String>>[
      for (ValidationIssue issue in error.issues)
        <String, String>{
          'field': issue.dottedPath,
          'message': issue.dottedPath.isEmpty
              ? issue.message
              : '${issue.dottedPath}: ${issue.message}',
          'rule': issue.code,
        },
    ];
    // made by hand (like "too many items"): only `{path: text}`
    Object? flat = error.message;
    if (errors.isEmpty && flat is Map) {
      for (MapEntry<dynamic, dynamic> e in flat.entries) {
        errors.add(<String, String>{
          'field': '${e.key}',
          'message': '${e.key}: ${e.value}',
          'rule': error.errorCode,
        });
      }
    }
    return response(<String, dynamic>{
      'message': errors.isEmpty ? 'Validation failed' : errors.first['message'],
      'errors': errors,
    }).statusCode(error.code);
  }

  static String _message(IHttpException error, HttpRequest req) {
    if (error is NotFoundHttpException) {
      return 'Cannot ${req.method} ${req.uri.path}';
    }
    Object? message = error.message;
    if (message is Map && message['message'] != null) {
      return message['message'].toString();
    }
    return message.toString();
  }
}
