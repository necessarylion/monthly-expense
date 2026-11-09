import 'package:api_dox/app/models/casts.dart';
import 'package:dox_orm/dox_orm.dart';

part 'account.model.g.dart';

/// A standalone balance owned by one user. It has no group.
@DoxModel(table: 'accounts', timestamps: false)
class Account extends AccountGenerator {
  @Column(name: 'user_id')
  int userId = 0;

  @Column()
  String name = '';

  /// ISO 4217 code, or the synthetic GLD.
  @Column()
  String currency = '';

  @Column()
  String color = '#3b82f6';

  /// A real boolean on both databases (clients read a real bool, not 0/1).
  @Column(name: 'include_in_total')
  bool includeInTotal = true;

  @Column(name: 'created_at', cast: TimestampText())
  String createdAtText = '';

  @Column(name: 'updated_at', cast: TimestampText())
  String updatedAtText = '';

  /// Columns that `create(map)` and `update(map)` may set.
  @override
  List<String> get fillable => <String>[
    'user_id',
    'name',
    'currency',
    'color',
    'include_in_total',
    'created_at',
    'updated_at',
  ];
}
