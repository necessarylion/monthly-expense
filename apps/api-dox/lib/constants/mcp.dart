// `@Describe` hints on the DTO fields. The MCP tools show them to the
// model.
//
// Some DTO fields (groupId, accountId, id, ...) are for the MCP tools only.
// HTTP takes these from the URL or the X-Group-Id header and ignores the
// field.

const String groupIdHint =
    'Group ID (see list_groups). Needed by the MCP tools; HTTP uses the '
    'X-Group-Id header.';
const String accountIdHint =
    'Wallet ID (see list_wallets). Needed by the MCP tools; HTTP takes it '
    'from the URL.';
const String itemIdHint =
    'ID of the item (see the matching list tool). Needed by the MCP tools; '
    'HTTP takes it from the URL.';
const String monthHint =
    'Month in YYYY-MM format. Defaults to the current month.';
const String dateHint = 'Date in YYYY-MM-DD.';
const String noteHint = 'Optional note.';
const String clearNoteHint = 'New note. Pass null to clear it.';
const String currencyHint = '3-letter currency code, e.g. "THB" or "USD".';
const String colorHint = 'Hex color, e.g. "#3b82f6".';
const String emailHint =
    'Gmail address of the person. They join when they next sign in.';
const String iconKeyHint =
    'Icon key. One of: utensils, car, home, shopping-bag, heart-pulse, film, '
    'receipt, wallet, coffee, gift, plane, book, dumbbell, fuel, shirt, zap, '
    'tag.';
const String groupKindHint =
    '"monthly" (budget and totals per month) or "trip" (one budget, no '
    'months: every expense counts, for a one-time event).';
