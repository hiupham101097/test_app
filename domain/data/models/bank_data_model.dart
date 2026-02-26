import 'package:json_annotation/json_annotation.dart';

part 'bank_data_model.g.dart';

@JsonSerializable(explicitToJson: true)
class BankDataModel {
  @JsonKey(name: 'bankAccount')
  final String? bankAccount;

  @JsonKey(name: 'bankNumber')
  final String? bankNumber;

  @JsonKey(name: 'bankName')
  final String? bankName;

  BankDataModel({this.bankAccount, this.bankNumber, this.bankName});

  factory BankDataModel.fromJson(Map<String, dynamic> json) =>
      _$BankDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$BankDataModelToJson(this);

  @override
  String toString() {
    return 'BankDataModel(bankAccount: $bankAccount, bankNumber: $bankNumber, bankName: $bankName)';
  }
}
