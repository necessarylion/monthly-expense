/// `code` of the 403 for a sign-in that still needs its two-step code.
/// The web app reads it (`stores/auth.ts`).
const String mfaRequiredCode = 'mfa_required';

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
