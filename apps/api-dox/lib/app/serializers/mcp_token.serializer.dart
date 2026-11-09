import 'package:api_dox/app/models/mcp_token/mcp_token.model.dart';
import 'package:api_dox/utils/date_util.dart';
import 'package:dox_core/dox_core.dart';

/// One connected MCP client on the Me page. The token hash never leaves.
class McpTokenSerializer extends Serializer<McpToken> {
  McpTokenSerializer(super.data);

  @override
  Map<String, dynamic> convert(McpToken m) {
    return <String, dynamic>{
      'id': m.id,
      'name': m.name,
      'lastUsedAt': DateUtil.toIso(m.lastUsedAt),
      'createdAt': DateUtil.toIso(m.createdAtText),
    };
  }
}
