import 'package:api_dox/app/models/casts.dart';
import 'package:dox_orm/dox_orm.dart';

part 'category.model.g.dart';

/// The table has no `updated_at`.
@DoxModel(table: 'categories', timestamps: false)
class Category extends CategoryGenerator {
  @Column(name: 'group_id')
  int groupId = 0;

  @Column()
  String name = '';

  @Column()
  String slug = '';

  @Column(name: 'icon_key')
  String iconKey = '';

  @Column()
  String color = '';

  /// Monthly budget for this category. Null: no budget.
  @Column(name: 'budget_cents')
  int? budgetCents;

  @Column(name: 'created_at', cast: TimestampText())
  String createdAtText = '';

  /// Columns that `create(map)` and `update(map)` may set.
  @override
  List<String> get fillable => <String>[
    'group_id',
    'name',
    'slug',
    'icon_key',
    'color',
    'budget_cents',
    'created_at',
  ];
}
