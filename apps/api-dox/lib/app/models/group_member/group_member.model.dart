import 'package:api_dox/app/models/casts.dart';
import 'package:dox_orm/dox_orm.dart';

part 'group_member.model.g.dart';

/// `userId` is null while the invite is pending.
@DoxModel(table: 'group_members', timestamps: false)
class GroupMember extends GroupMemberGenerator {
  @Column(name: 'group_id')
  int groupId = 0;

  @Column(name: 'user_id')
  int? userId;

  @Column()
  String email = '';

  @Column(name: 'invited_by_user_id')
  int? invitedByUserId;

  @Column(name: 'joined_at', cast: TimestampText())
  String? joinedAt;

  /// This member's pay-from account for expenses in this group.
  @Column(name: 'default_account_id')
  int? defaultAccountId;

  @Column(name: 'created_at', cast: TimestampText())
  String createdAtText = '';

  @Column(name: 'updated_at', cast: TimestampText())
  String updatedAtText = '';

  /// Columns that `create(map)` and `update(map)` may set.
  @override
  List<String> get fillable => <String>[
    'group_id',
    'user_id',
    'email',
    'invited_by_user_id',
    'joined_at',
    'default_account_id',
    'created_at',
    'updated_at',
  ];
}
