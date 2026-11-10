const int maxPageLimit = 500;
const int recentEntriesDefaultLimit = 20;
const int accountEntriesDefaultLimit = 500;

/// Only these addresses can be invited to a group or a wallet.
const String inviteEmailDomain = '@gmail.com';

const String defaultGroupCurrency = 'THB';
const String defaultTotalCurrency = 'THB';
const String defaultFxBase = 'USD';

/// Note on an adjustment entry when the user gives none.
const String balanceAdjustmentNote = 'Balance adjustment';

/// Quick-add suggestions: look this many days back, need this many
/// repeats, return at most this many. Claude picks the final list from
/// up to [frequentCandidateLimit] rows.
const int frequentExpenseDays = 90;
const int frequentExpenseMinUses = 2;
const int frequentExpenseLimit = 8;
const int frequentCandidateLimit = 30;

/// Balance history for the wallet cards.
const int balanceHistoryDefaultDays = 30;
const int balanceHistoryMaxDays = 365;

/// A first sign-in holds its lock at most this long (also the wait).
const Duration firstSignInLockTtl = Duration(seconds: 15);

/// Outgoing calls to Google (Firebase public keys) give up after this.
const Duration firebaseVerifyTimeout = Duration(seconds: 10);

/// MCP clients (OAuth sign-ins) one user may have at once.
const int mcpClientsMax = 20;

/// MCP access tokens start with this, so a leaked one is easy to spot.
const String mcpTokenPrefix = 'mex_';

/// `mcp_tokens.last_used_at` is written at most this often.
const Duration mcpTouchEvery = Duration(minutes: 1);

/// Passkeys one user may have at once.
const int passkeysMax = 20;

/// A passkey challenge works once, for this long.
const Duration passkeyChallengeTtl = Duration(minutes: 5);

/// Search returns at most this many expenses, newest first.
const int searchResultLimit = 2000;

/// Recurring expenses one group may have.
const int recurringPerGroupMax = 100;

/// Group kinds. A trip has one budget and no months.
const String groupKindMonthly = 'monthly';
const String groupKindTrip = 'trip';

/// A trip's budget row uses this in place of a `YYYY-MM` month key.
const String tripBudgetKey = 'trip';
