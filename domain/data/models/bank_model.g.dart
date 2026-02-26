// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BankModel _$BankModelFromJson(Map<String, dynamic> json) => BankModel(
      bankId: json['bankId'] as String?,
      imagePath: json['imagePath'] as String?,
      bankName: json['bankName'] as String?,
      shortName: json['shortName'] as String?,
      bankCode: json['bankCode'] as String?,
      description: json['description'] as String?,
      isActive: json['isActive'] as bool?,
    );

Map<String, dynamic> _$BankModelToJson(BankModel instance) => <String, dynamic>{
      'bankId': instance.bankId,
      'imagePath': instance.imagePath,
      'bankName': instance.bankName,
      'shortName': instance.shortName,
      'bankCode': instance.bankCode,
      'description': instance.description,
      'isActive': instance.isActive,
    };
