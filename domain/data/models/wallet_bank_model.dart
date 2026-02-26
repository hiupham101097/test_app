import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'wallet_bank_model.g.dart';

@HiveType(typeId: 3)
@JsonSerializable(explicitToJson: true)
class WalletBankModel extends HiveObject {
  @HiveField(0)
  @JsonKey(name: 'walletBankId')
  final String? walletBankId;

  @HiveField(1)
  @JsonKey(name: 'walletId')
  final String? walletId;

  @HiveField(2)
  @JsonKey(name: 'bankId')
  final String? bankId;

  @HiveField(3)
  @JsonKey(name: 'bankName')
  final String? bankName;

  @HiveField(4)
  @JsonKey(name: 'shortName')
  final String? shortName;

  @HiveField(5)
  @JsonKey(name: 'bankImg')
  final String? bankImg;

  @HiveField(6)
  @JsonKey(name: 'bankCode')
  final String? bankCode;

  @HiveField(7)
  @JsonKey(name: 'accountHolderName')
  final String? accountHolderName;

  @HiveField(8)
  @JsonKey(name: 'cardNumber')
  final String? cardNumber;

  @HiveField(9)
  @JsonKey(name: 'isLastPayment')
  final bool? isLastPayment;

  WalletBankModel({
    this.walletBankId,
    this.walletId,
    this.bankId,
    this.bankName,
    this.shortName,
    this.bankImg,
    this.bankCode,
    this.accountHolderName,
    this.cardNumber,
    this.isLastPayment,
  });

  factory WalletBankModel.fromJson(Map<String, dynamic> json) =>
      _$WalletBankModelFromJson(json);

  Map<String, dynamic> toJson() => _$WalletBankModelToJson(this);

  @override
  String toString() {
    return 'WalletBankModel(walletBankId: $walletBankId, walletId: $walletId, bankId: $bankId, bankName: $bankName, shortName: $shortName, bankImg: $bankImg, bankCode: $bankCode, accountHolderName: $accountHolderName, cardNumber: $cardNumber, isLastPayment: $isLastPayment)';
  }
}
