/// One category every new group starts with.
class DefaultCategory {
  final String name;
  final String slug;
  final String iconKey;
  final String color;

  const DefaultCategory(this.name, this.slug, this.iconKey, this.color);
}

/// Categories every new group starts with.
const List<DefaultCategory> defaultCategories = <DefaultCategory>[
  DefaultCategory('Food', 'food', 'utensils', '#f97316'),
  DefaultCategory('Transport', 'transport', 'car', '#3b82f6'),
  DefaultCategory('Rent', 'rent', 'home', '#10b981'),
  DefaultCategory('Shopping', 'shopping', 'shopping-bag', '#ec4899'),
  DefaultCategory('Health', 'health', 'heart-pulse', '#ef4444'),
  DefaultCategory('Entertainment', 'entertainment', 'film', '#a855f7'),
  DefaultCategory('Bills', 'bills', 'receipt', '#eab308'),
  DefaultCategory('Other', 'other', 'wallet', '#6b7280'),
];

/// Icon keys the MCP tools accept. They match the icons the web app maps.
const List<String> iconKeys = <String>[
  'utensils',
  'car',
  'home',
  'shopping-bag',
  'heart-pulse',
  'film',
  'receipt',
  'wallet',
  'coffee',
  'gift',
  'plane',
  'book',
  'dumbbell',
  'fuel',
  'shirt',
  'zap',
  'tag',
];

const String defaultMcpIconKey = 'tag';
const String defaultMcpColor = '#6b7280';
