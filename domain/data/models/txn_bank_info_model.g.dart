// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'txn_bank_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TxnBankInfoModel _$TxnBankInfoModelFromJson(Map<String, dynamic> json) =>
    TxnBankInfoModel(
      bankCode: json['bankCode'] as String?,
      bankName: json['bankName'] as String?,
      accountNumber: json['accountNumber'] as String?,
      accountHolderName: json['accountHolderName'] as String?,
    );

Map<String, dynamic> _$TxnBankInfoModelToJson(TxnBankInfoModel instance) =>
    <String, dynamic>{
      'bankCode': instance.bankCode,
      'bankName': instance.bankName,
      'accountNumber': instance.accountNumber,
      'accountHolderName': instance.accountHolderName,
    };
