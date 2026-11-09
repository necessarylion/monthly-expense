import 'package:api_dox/app/models/casts.dart';
import 'package:dox_orm/dox_orm.dart';

part 'mcp_token.model.g.dart';

/// An MCP client that signed in with OAuth. Only the hash of its token is
/// kept.
@DoxModel(table: 'mcp_tokens', timestamps: false)
class McpToken extends McpTokenGenerator {
  @Column(name: 'user_id')
  int userId = 0;

  /// `<client name> (<redirect host>)`, like `Claude (claude.ai)`.
  @Column()
  String name = '';

  /// SHA-256 hex of the token.
  @Column(name: 'token_hash')
  String tokenHash = '';

  @Column(name: 'last_used_at', cast: TimestampText())
  String? lastUsedAt;

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
    'name',
    'token_hash',
    'last_used_at',
    'created_at',
    'updated_at',
  ];
}
