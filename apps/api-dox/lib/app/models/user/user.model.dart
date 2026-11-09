import 'package:api_dox/app/models/casts.dart';
import 'package:dox_orm/dox_orm.dart';

part 'user.model.g.dart';

@DoxModel(table: 'users', timestamps: false)
class User extends UserGenerator {
  @Column(name: 'firebase_uid')
  String firebaseUid = '';

  @Column()
  String email = '';

  @Column(name: 'display_name')
  String? displayName;

  @Column(name: 'photo_url')
  String? photoUrl;

  @Column(name: 'created_at', cast: TimestampText())
  String createdAtText = '';

  @Column(name: 'updated_at', cast: TimestampText())
  String updatedAtText = '';

  /// Columns that `create(map)` and `update(map)` may set.
  @override
  List<String> get fillable => <String>[
    'firebase_uid',
    'email',
    'display_name',
    'photo_url',
    'created_at',
    'updated_at',
  ];

  // `users.mcp_token` (the old MCP link) is retired: not mapped here, but
  // the column stays, because a table rebuild would cascade.
}
