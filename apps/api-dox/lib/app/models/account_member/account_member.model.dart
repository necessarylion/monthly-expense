import 'package:api_dox/app/models/casts.dart';
import 'package:dox_orm/dox_orm.dart';

part 'account_member.model.g.dart';

/// A person a wallet is shared with. `userId` is null while the invite is
/// pending.
@DoxModel(table: 'account_members', timestamps: false)
class AccountMember extends AccountMemberGenerator {
  @Column(name: 'account_id')
  int accountId = 0;

  @Column(name: 'user_id')
  int? userId;

  @Column()
  String email = '';

  @Column(name: 'invited_by_user_id')
  int? invitedByUserId;

  @Column(name: 'joined_at', cast: TimestampText())
  String? joinedAt;

  @Column(name: 'created_at', cast: TimestampText())
  String createdAtText = '';

  @Column(name: 'updated_at', cast: TimestampText())
  String updatedAtText = '';

  /// Columns that `create(map)` and `update(map)` may set.
  @override
  List<String> get fillable => <String>[
    'account_id',
    'user_id',
    'email',
    'invited_by_user_id',
    'joined_at',
    'created_at',
    'updated_at',
  ];
}
