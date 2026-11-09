import 'package:api_dox/app/models/group_member/group_member.model.dart';
import 'package:api_dox/utils/date_util.dart';
import 'package:dox_core/dox_core.dart';

/// JSON the web app reads. Do not rename fields;
/// `test/serializer_test.dart` fails when one changes.
class GroupMemberSerializer extends Serializer<GroupMember> {
  GroupMemberSerializer(super.data);

  @override
  Map<String, dynamic> convert(GroupMember m) {
    return <String, dynamic>{
      'id': m.id,
      'groupId': m.groupId,
      'userId': m.userId,
      'email': m.email,
      'invitedByUserId': m.invitedByUserId,
      'joinedAt': DateUtil.toIso(m.joinedAt),
      'pending': m.userId == null,
    };
  }
}
