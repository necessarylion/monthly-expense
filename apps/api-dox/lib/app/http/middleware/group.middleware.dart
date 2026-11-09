import 'package:api_dox/app/services/group.service.dart';
import 'package:api_dox/http/http_error.dart';
import 'package:api_dox/http/request_context.dart';
import 'package:dox_core/dox_core.dart';

/// The active group comes from the `X-Group-Id` header (or `group_id` in
/// the query or body, for tools that cannot set headers). The user must be
/// a member. Runs after `AuthMiddleware`.
@Inject()
class GroupMiddleware implements IDoxMiddleware {
  GroupMiddleware(this.groups);

  final GroupService groups;

  @override
  Future<dynamic> handle(IDoxRequest request) async {
    DoxRequest req = request as DoxRequest;
    String raw = (req.header('x-group-id') ?? req.input('group_id') ?? '')
        .toString()
        .trim();
    num? id = num.tryParse(raw);
    if (raw.isEmpty || id == null || !id.isFinite || id <= 0) {
      throw HttpError.badRequest('Missing or invalid X-Group-Id');
    }
    // `1.5` is no group: 404, the same as an id of another group.
    int? groupId = id == id.truncate() ? id.toInt() : null;
    req.activeGroup = await groups.assertMembership(req.authUser, groupId);
    return req;
  }
}
