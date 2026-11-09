import 'package:api_dox/app/models/casts.dart';
import 'package:dox_orm/dox_orm.dart';

part 'shopping_item.model.g.dart';

@DoxModel(table: 'shopping_items', timestamps: false)
class ShoppingItem extends ShoppingItemGenerator {
  @Column(name: 'group_id')
  int groupId = 0;

  @Column()
  String name = '';

  /// When it was bought; null while still on the list.
  @Column(name: 'done_at', cast: TimestampText())
  String? doneAt;

  @Column(name: 'created_by_user_id')
  int? createdByUserId;

  @Column(name: 'created_at', cast: TimestampText())
  String createdAtText = '';

  @Column(name: 'updated_at', cast: TimestampText())
  String updatedAtText = '';

  /// Columns that `create(map)` and `update(map)` may set.
  @override
  List<String> get fillable => <String>[
    'group_id',
    'name',
    'done_at',
    'created_by_user_id',
    'created_at',
    'updated_at',
  ];
}
