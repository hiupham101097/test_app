import 'package:merchant/domain/data/models/base_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'detail_transaction_model.g.dart';

@JsonSerializable(explicitToJson: true)
class DetailTransactionModel extends BaseModel {
  @JsonKey(name: 'transactionId')
  final String? transactionId;

  @JsonKey(name: 'amount')
  final double? amount;

  @JsonKey(name: 'paymentChannel')
  final String? paymentChannel;

  @JsonKey(name: 'paymentProvider')
  final String? paymentProvider;

  @JsonKey(name: 'status')
  final String? status;

  @JsonKey(name: 'referenceCode')
  final String? referenceCode;

  @JsonKey(name: 'paymentUrl')
  final String? paymentUrl;

  DetailTransactionModel({
    this.transactionId,
    this.amount,
    this.paymentChannel,
    this.paymentProvider,
    this.status,
    this.referenceCode,
    this.paymentUrl,
  });

  factory DetailTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$DetailTransactionModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DetailTransactionModelToJson(this);

  @override
  String toString() {
    return 'DetailTransactionModel(transactionId: '
        '$transactionId, amount: $amount, paymentChannel: $paymentChannel, paymentProvider: $paymentProvider, status: $status, referenceCode: $referenceCode, paymentUrl: $paymentUrl)';
  }
}
