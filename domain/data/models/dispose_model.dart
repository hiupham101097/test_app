import 'package:merchant/domain/data/models/base_model.dart';
import 'package:merchant/domain/data/models/bank_data_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dispose_model.g.dart';

@JsonSerializable(explicitToJson: true)
class DisposeModel extends BaseModel {
  @JsonKey(name: 'transactionId')
  final String? transactionId;

  @JsonKey(name: 'totalPrice')
  final int? totalPrice;

  @JsonKey(name: 'status')
  final String? status;

  @JsonKey(name: 'paymentUrl')
  final String? paymentUrl;

  @JsonKey(name: 'refCode')
  final String? refCode;

  @JsonKey(name: 'paymentResponseType')
  final String? paymentResponseType;

  @JsonKey(name: 'bankData')
  final BankDataModel? bankData;

  DisposeModel({
    this.transactionId,
    this.totalPrice,
    this.status,
    this.paymentUrl,
    this.refCode,
    this.paymentResponseType,
    this.bankData,
  });

  factory DisposeModel.fromJson(Map<String, dynamic> json) =>
      _$DisposeModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DisposeModelToJson(this);

  @override
  String toString() {
    return 'DisposeModel(transactionId: $transactionId, totalPrice: $totalPrice, status: $status, paymentUrl: $paymentUrl, refCode: $refCode, paymentResponseType: $paymentResponseType, bankData: $bankData)';
  }
}
