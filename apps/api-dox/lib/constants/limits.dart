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

/// The name an authenticator app shows for a two-step sign-in entry.
const String totpIssuer = 'Monthly Expense';

/// A two-step code is remembered this long, so it works once. Longer than
/// the 90 seconds a code can pass.
const Duration totpCodeLife = Duration(minutes: 2);

/// Code tries per user in one minute. A code has 6 digits, so guessing is
/// hopeless at this rate.
const int totpTriesPerMinute = 5;

/// Search returns at most this many expenses, newest first.
const int searchResultLimit = 2000;

/// Recurring expenses one group may have.
const int recurringPerGroupMax = 100;

/// Group kinds. A trip has one budget and no months.
const String groupKindMonthly = 'monthly';
const String groupKindTrip = 'trip';

/// A trip's budget row uses this in place of a `YYYY-MM` month key.
const String tripBudgetKey = 'trip';

/// The dox_auth guard of the web app's API tokens (lib/config/auth.dart).
const String apiGuard = 'api';

/// The ability of an API token that passed the two-step code, or was made
/// with a passkey. See `TwoFactorMiddleware`.
const String secondFactorAbility = '2fa';

/// An API token works this long. The web app trades it for a new one
/// (`POST /auth/token/refresh`) well before, so a user who opens the app
/// within this time never signs in again.
const Duration apiTokenLife = Duration(days: 30);

/// After a refresh the old token still works this long, for calls already
/// on the way and other tabs that have not read the new one yet.
const Duration apiTokenRefreshGrace = Duration(minutes: 2);
