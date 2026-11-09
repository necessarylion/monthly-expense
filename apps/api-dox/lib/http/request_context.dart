import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/http/http_error.dart';
import 'package:dox_core/dox_core.dart';

const String _userKey = 'app.user';
const String _groupKey = 'app.group';

/// What the middleware found for one request. `AuthMiddleware` sets the
/// user, `GroupMiddleware` the group. Both live on the request
/// (`boundValues`), so nothing is shared between requests.
extension RequestContext on DoxRequest {
  /// The signed-in user. Only use on routes behind the auth middleware.
  User get authUser {
    Object? user = boundValues[_userKey];
    if (user is! User) throw HttpError.unauthorized('Not authenticated');
    return user;
  }

  set authUser(User user) => boundValues[_userKey] = user;

  /// The active group. Only use on routes behind the group middleware.
  Group get activeGroup {
    Object? group = boundValues[_groupKey];
    if (group is! Group) {
      throw HttpError.badRequest('Missing or invalid X-Group-Id');
    }
    return group;
  }

  set activeGroup(Group group) => boundValues[_groupKey] = group;
}
