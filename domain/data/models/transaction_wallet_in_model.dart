import 'package:merchant/domain/data/models/base_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction_wallet_in_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TransactionWalletInModel extends BaseModel {
  @JsonKey(name: 'historyId')
  final String? historyId;

  @JsonKey(name: 'walletId')
  final String? walletId;

  @JsonKey(name: 'type')
  final String? type;

  @JsonKey(name: 'orderId')
  final String? orderId;

  @JsonKey(name: 'transId')
  final String? transId;

  @JsonKey(name: 'amount')
  final int? amount;

  @JsonKey(name: 'walletBankId')
  final String? walletBankId;

  @JsonKey(name: 'bankId')
  final String? bankId;

  @JsonKey(name: 'bankAccount')
  final String? bankAccount;

  @JsonKey(name: 'bankNumber')
  final String? bankNumber;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'notes')
  final String? notes;

  @JsonKey(name: 'status')
  final String? status;

  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;

  @JsonKey(name: 'refcode')
  final String? refcode;

  TransactionWalletInModel({
    this.historyId,
    this.walletId,
    this.type,
    this.orderId,
    this.transId,
    this.amount,
    this.walletBankId,
    this.bankId,
    this.bankAccount,
    this.bankNumber,
    this.description,
    this.notes,
    this.status,
    this.createdAt,
    this.refcode,
  });

  factory TransactionWalletInModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionWalletInModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TransactionWalletInModelToJson(this);
}
