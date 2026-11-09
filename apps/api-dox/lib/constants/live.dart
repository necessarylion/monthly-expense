/// The Socket.IO event that tells the app what changed. Its data is
/// `{topic, groupId?}`. The web app has the same names in `lib/live.ts`.
const String liveEvent = 'changed';

/// The `connect_error` message when the server can not check the token
/// now. The app tries again later.
const String liveUnavailable = 'Unavailable';

/// Expenses of a group (with `groupId`).
const String liveTopicExpenses = 'expenses';

/// Shopping items of a group (with `groupId`).
const String liveTopicShopping = 'shopping';

/// Wallets and their entries of the user.
const String liveTopicAccounts = 'accounts';

/// Categories, settings (budget, split, trip dates) or members of a group
/// (with `groupId`).
const String liveTopicGroup = 'group';

/// Exchange rates.
const String liveTopicRates = 'rates';
