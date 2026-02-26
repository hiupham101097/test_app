// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispose_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DisposeModel _$DisposeModelFromJson(Map<String, dynamic> json) => DisposeModel(
      transactionId: json['transactionId'] as String?,
      totalPrice: (json['totalPrice'] as num?)?.toInt(),
      status: json['status'] as String?,
      paymentUrl: json['paymentUrl'] as String?,
      refCode: json['refCode'] as String?,
      paymentResponseType: json['paymentResponseType'] as String?,
      bankData: json['bankData'] == null
          ? null
          : BankDataModel.fromJson(json['bankData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DisposeModelToJson(DisposeModel instance) =>
    <String, dynamic>{
      'transactionId': instance.transactionId,
      'totalPrice': instance.totalPrice,
      'status': instance.status,
      'paymentUrl': instance.paymentUrl,
      'refCode': instance.refCode,
      'paymentResponseType': instance.paymentResponseType,
      'bankData': instance.bankData?.toJson(),
    };
