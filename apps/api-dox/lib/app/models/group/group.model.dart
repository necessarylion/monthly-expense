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

  /// The group splits costs: who paid, settle up. Null is off.
  @Column(name: 'split_enabled')
  bool? splitEnabled;

  /// `monthly` (null) or `trip`. Use [isTrip].
  @Column()
  String? kind;

  /// A trip has one budget and no months: every expense counts.
  bool get isTrip => kind == 'trip';

  /// A trip's first day, `YYYY-MM-DD`. Text, like every date here.
  @Column(name: 'trip_start')
  String? tripStart;

  /// How many days the trip lasts.
  @Column(name: 'trip_days')
  int? tripDays;

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
    'split_enabled',
    'kind',
    'trip_start',
    'trip_days',
    'created_at',
    'updated_at',
  ];
}
