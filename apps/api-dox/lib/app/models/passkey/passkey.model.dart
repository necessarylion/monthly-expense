import 'package:api_dox/app/models/casts.dart';
import 'package:dox_orm/dox_orm.dart';

part 'passkey.model.g.dart';

/// A passkey (WebAuthn credential) a user can sign in with.
@DoxModel(table: 'passkeys', timestamps: false)
class Passkey extends PasskeyGenerator {
  @Column(name: 'user_id')
  int userId = 0;

  /// base64url of the credential id.
  @Column(name: 'credential_id')
  String credentialId = '';

  /// base64url of the public key (SubjectPublicKeyInfo DER, P-256).
  @Column(name: 'public_key')
  String publicKey = '';

  @Column(name: 'sign_count')
  int signCount = 0;

  /// Device name the web app guessed, like `iPhone`.
  @Column()
  String name = '';

  @Column(name: 'last_used_at', cast: TimestampText())
  String? lastUsedAt;

  @Column(name: 'created_at', cast: TimestampText())
  String createdAtText = '';

  @Column(name: 'updated_at', cast: TimestampText())
  String updatedAtText = '';

  @override
  List<String> get hidden => <String>['public_key'];

  /// Columns that `create(map)` and `update(map)` may set.
  @override
  List<String> get fillable => <String>[
    'user_id',
    'credential_id',
    'public_key',
    'sign_count',
    'name',
    'last_used_at',
    'created_at',
    'updated_at',
  ];
}
