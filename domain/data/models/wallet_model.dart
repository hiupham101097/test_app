import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';
import 'wallet_bank_model.dart';

part 'wallet_model.g.dart';

@HiveType(typeId: 4)
@JsonSerializable(explicitToJson: true)
class WalletModel extends HiveObject {
  @HiveField(0)
  @JsonKey(name: 'walletId')
  final String? walletId;

  @HiveField(1)
  @JsonKey(name: 'fullName')
  final String? fullName;

  @HiveField(2)
  @JsonKey(name: 'email')
  final String? email;

  @HiveField(3)
  @JsonKey(name: 'phoneNumber')
  final String? phoneNumber;

  @HiveField(4)
  @JsonKey(name: 'status')
  final String? status;

  @HiveField(5)
  @JsonKey(name: 'realBalance')
  final double? realBalance;

  @HiveField(6)
  @JsonKey(name: 'pendingBalance')
  final double? pendingBalance;

  @HiveField(7)
  @JsonKey(name: 'withdrawableBalance')
  final double? withdrawableBalance;

  @HiveField(8)
  @JsonKey(name: 'bonusBalance')
  final double? bonusBalance;

  @HiveField(9)
  @JsonKey(name: 'createdFromSystem')
  final String? createdFromSystem;

  @HiveField(10)
  @JsonKey(name: 'bankList')
  final List<WalletBankModel>? bankList;

  WalletModel({
    this.walletId,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.status,
    this.realBalance,
    this.pendingBalance,
    this.withdrawableBalance,
    this.bonusBalance,
    this.createdFromSystem,
    this.bankList,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) =>
      _$WalletModelFromJson(json);

  Map<String, dynamic> toJson() => _$WalletModelToJson(this);

  @override
  String toString() {
    return 'WalletModel(walletId: $walletId, fullName: $fullName, email: $email, phoneNumber: $phoneNumber, status: $status, realBalance: $realBalance, pendingBalance: $pendingBalance, withdrawableBalance: $withdrawableBalance, bonusBalance: $bonusBalance, createdFromSystem: $createdFromSystem, bankList: $bankList)';
  }
}
