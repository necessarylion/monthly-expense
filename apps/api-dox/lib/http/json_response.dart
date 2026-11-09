import 'package:dox_core/dox_core.dart';

/// Every JSON body is `{ data }` on success and `{ message }` on error.
class JsonResponse {
  static Map<String, dynamic> ok(Object? data) => <String, dynamic>{
    'data': data,
  };

  static DoxResponse created(Object? data) {
    return response(<String, dynamic>{'data': data}).statusCode(201);
  }

  static DoxResponse noContent() => response().statusCode(204);

  static DoxResponse error(int status, String message) {
    return response(<String, dynamic>{'message': message}).statusCode(status);
  }
}
