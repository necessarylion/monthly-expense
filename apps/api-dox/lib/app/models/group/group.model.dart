import 'package:api_dox/app/models/casts.dart';
import 'package:dox_orm/dox_orm.dart';

part 'group.model.g.dart';

@DoxModel(table: 'groups', timestamps: false)
class Group extends GroupGenerator {
  @Column()
  String name = '';

  @Column()
  String currency = 'USD';

  @Column(name: 'created_by_user_id')
  int? createdByUserId;

  @Column(name: 'created_at', cast: TimestampText())
  String createdAtText = '';

  @Column(name: 'updated_at', cast: TimestampText())
  String updatedAtText = '';

  /// Columns that `create(map)` and `update(map)` may set.
  @override
  List<String> get fillable => <String>[
    'name',
    'currency',
    'created_by_user_id',
    'created_at',
    'updated_at',
  ];
}
