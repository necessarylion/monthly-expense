/// The Socket.IO event that tells the app what changed. Its data is
/// `{topic, groupId?}`. The web app has the same names in `lib/live.ts`.
const String liveEvent = 'changed';

/// Expenses of a group (with `groupId`).
const String liveTopicExpenses = 'expenses';

/// Shopping items of a group (with `groupId`).
const String liveTopicShopping = 'shopping';

/// Wallets and their entries of the user.
const String liveTopicAccounts = 'accounts';

/// Exchange rates.
const String liveTopicRates = 'rates';
