import 'package:merchant/domain/data/models/base_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TransactionModel extends BaseModel {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'userId')
  final String? userId;

  @JsonKey(name: 'walletId')
  final String? walletId;

  @JsonKey(name: 'type')
  final String? type;

  @JsonKey(name: 'amount')
  final int? amount;

  @JsonKey(name: 'balanceAfter')
  final int? balanceAfter;

  @JsonKey(name: 'reason')
  final String? reason;

  @JsonKey(name: 'status')
  final String? status;

  @JsonKey(name: 'createDate')
  final DateTime? createDate;

  @JsonKey(name: 'updateDate')
  final DateTime? updateDate;

  @JsonKey(name: 'transactionId')
  final String? transactionId;

  @JsonKey(name: 'orderId')
  final String? orderId;

  @JsonKey(name: 'refcode')
  final String? refcode;

  TransactionModel({
    this.id,
    this.userId,
    this.walletId,
    this.type,
    this.amount,
    this.balanceAfter,
    this.reason,
    this.status,
    this.createDate,
    this.updateDate,
    this.transactionId,
    this.orderId,
    this.refcode,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);
}
