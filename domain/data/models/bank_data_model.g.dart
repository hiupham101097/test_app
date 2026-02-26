// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BankDataModel _$BankDataModelFromJson(Map<String, dynamic> json) =>
    BankDataModel(
      bankAccount: json['bankAccount'] as String?,
      bankNumber: json['bankNumber'] as String?,
      bankName: json['bankName'] as String?,
    );

Map<String, dynamic> _$BankDataModelToJson(BankDataModel instance) =>
    <String, dynamic>{
      'bankAccount': instance.bankAccount,
      'bankNumber': instance.bankNumber,
      'bankName': instance.bankName,
    };
