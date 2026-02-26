// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailTransactionModel _$DetailTransactionModelFromJson(
        Map<String, dynamic> json) =>
    DetailTransactionModel(
      transactionId: json['transactionId'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      paymentChannel: json['paymentChannel'] as String?,
      paymentProvider: json['paymentProvider'] as String?,
      status: json['status'] as String?,
      referenceCode: json['referenceCode'] as String?,
      paymentUrl: json['paymentUrl'] as String?,
    );

Map<String, dynamic> _$DetailTransactionModelToJson(
        DetailTransactionModel instance) =>
    <String, dynamic>{
      'transactionId': instance.transactionId,
      'amount': instance.amount,
      'paymentChannel': instance.paymentChannel,
      'paymentProvider': instance.paymentProvider,
      'status': instance.status,
      'referenceCode': instance.referenceCode,
      'paymentUrl': instance.paymentUrl,
    };
