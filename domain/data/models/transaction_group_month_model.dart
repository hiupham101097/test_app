import 'package:merchant/domain/data/models/transaction_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:merchant/domain/data/models/base_model.dart';

part 'transaction_group_month_model.g.dart';

@JsonSerializable()
class TransactionGroupMonthModel extends BaseModel {
  @JsonKey(defaultValue: '')
  final String month;
  @JsonKey(defaultValue: [])
  final List<TransactionModel> transactions;

  TransactionGroupMonthModel({this.month = '', this.transactions = const []});

  factory TransactionGroupMonthModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionGroupMonthModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TransactionGroupMonthModelToJson(this);
}
