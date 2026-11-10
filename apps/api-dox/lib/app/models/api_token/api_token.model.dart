import 'package:api_dox/app/models/casts.dart';
import 'package:dox_orm/dox_orm.dart';

part 'api_token.model.g.dart';

/// A signed-in browser of the web app. Only the hash of its token is kept.
@DoxModel(table: 'api_tokens', timestamps: false)
class ApiToken extends ApiTokenGenerator {
  @Column(name: 'user_id')
  int userId = 0;

  /// SHA-256 hex of the token.
  @Column(name: 'token_hash')
  String tokenHash = '';

  /// The browser's User-Agent, cut short.
  @Column()
  String name = '';

  /// This sign-in gave the two-step code, or used a passkey.
  @Column(name: 'second_factor')
  bool? secondFactor;

  @Column(name: 'last_used_at', cast: TimestampText())
  String? lastUsedAt;

  /// Moves forward on use: a browser left alone this long is signed out.
  @Column(name: 'expires_at', cast: TimestampText())
  String expiresAt = '';

  @Column(name: 'created_at', cast: TimestampText())
  String createdAtText = '';

  @Column(name: 'updated_at', cast: TimestampText())
  String updatedAtText = '';

  @override
  List<String> get hidden => <String>['token_hash'];

  /// Columns that `create(map)` and `update(map)` may set.
  @override
  List<String> get fillable => <String>[
    'user_id',
    'token_hash',
    'name',
    'second_factor',
    'last_used_at',
    'expires_at',
    'created_at',
    'updated_at',
  ];
}
