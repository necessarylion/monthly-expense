import 'package:api_dox/app/models/casts.dart';
import 'package:dox_orm/dox_orm.dart';

part 'expense.model.g.dart';

@DoxModel(table: 'expenses', timestamps: false)
class Expense extends ExpenseGenerator {
  @Column(name: 'group_id')
  int groupId = 0;

  @Column(name: 'created_by_user_id')
  int? createdByUserId;

  @Column(name: 'category_id')
  int? categoryId;

  @Column(name: 'amount_cents')
  int amountCents = 0;

  /// `YYYY-MM-DD`
  @Column(name: 'occurred_on', cast: DateText())
  String occurredOn = '';

  @Column()
  String? note;

  @Column(name: 'created_at', cast: TimestampText())
  String createdAtText = '';

  @Column(name: 'updated_at', cast: TimestampText())
  String updatedAtText = '';

  /// Owner of the wallet it was paid from. Not a column: the repository
  /// fills it (`attachWalletOwners`). The `paid_by_user_id` column is
  /// retired and stays unused.
  int? walletOwnerId;

  /// The wallet it was paid from. Not a column: filled together with
  /// [walletOwnerId].
  int? walletAccountId;

  /// Who paid: the owner of the wallet it was paid from, else the person
  /// who added it.
  int? get payerId => walletOwnerId ?? createdByUserId;

  /// Columns that `create(map)` and `update(map)` may set.
  @override
  List<String> get fillable => <String>[
    'group_id',
    'created_by_user_id',
    'category_id',
    'amount_cents',
    'occurred_on',
    'note',
    'created_at',
    'updated_at',
  ];
}
