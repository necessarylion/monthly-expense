/// Claude (Anthropic Messages API). Picks expense categories and cleans up
/// the quick-add list.
const String claudeMessagesUrl = 'https://api.anthropic.com/v1/messages';
const String claudeApiVersion = '2026-10-21';

/// A declined request runs again on the model Anthropic picks.
const String claudeFallbackBeta = 'server-side-fallback-2026-07-01';

/// Claude must answer in this time. Home waits for it.
const Duration claudeTimeout = Duration(seconds: 20);

/// After Claude fails, show the plain list for this long before we ask again.
const Duration claudeRetryAfter = Duration(minutes: 5);
