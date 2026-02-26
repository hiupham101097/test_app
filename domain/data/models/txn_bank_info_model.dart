import 'package:json_annotation/json_annotation.dart';

part 'txn_bank_info_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TxnBankInfoModel {
  @JsonKey(name: 'bankCode')
  final String? bankCode;

  @JsonKey(name: 'bankName')
  final String? bankName;

  @JsonKey(name: 'accountNumber')
  final String? accountNumber;

  @JsonKey(name: 'accountHolderName')
  final String? accountHolderName;

  TxnBankInfoModel({
    this.bankCode,
    this.bankName,
    this.accountNumber,
    this.accountHolderName,
  });

  factory TxnBankInfoModel.fromJson(Map<String, dynamic> json) =>
      _$TxnBankInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$TxnBankInfoModelToJson(this);
}
