const List<String> corsMethods = <String>[
  'GET',
  'HEAD',
  'POST',
  'PUT',
  'PATCH',
  'DELETE',
];

/// Request headers the web app and MCP clients send.
const List<String> corsHeaders = <String>[
  'accept',
  'authorization',
  'content-type',
  'x-group-id',
  'mcp-session-id',
  'mcp-protocol-version',
  'last-event-id',
];

const int corsMaxAgeSeconds = 90;

/// Seconds a keep-alive connection may stay idle.
const Duration idleTimeout = Duration(seconds: 120);
