// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    TransactionModel(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      walletId: json['walletId'] as String?,
      type: json['type'] as String?,
      amount: (json['amount'] as num?)?.toInt(),
      balanceAfter: (json['balanceAfter'] as num?)?.toInt(),
      reason: json['reason'] as String?,
      status: json['status'] as String?,
      createDate: json['createDate'] == null
          ? null
          : DateTime.parse(json['createDate'] as String),
      updateDate: json['updateDate'] == null
          ? null
          : DateTime.parse(json['updateDate'] as String),
      transactionId: json['transactionId'] as String?,
      orderId: json['orderId'] as String?,
      refcode: json['refcode'] as String?,
    );

Map<String, dynamic> _$TransactionModelToJson(TransactionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'walletId': instance.walletId,
      'type': instance.type,
      'amount': instance.amount,
      'balanceAfter': instance.balanceAfter,
      'reason': instance.reason,
      'status': instance.status,
      'createDate': instance.createDate?.toIso8601String(),
      'updateDate': instance.updateDate?.toIso8601String(),
      'transactionId': instance.transactionId,
      'orderId': instance.orderId,
      'refcode': instance.refcode,
    };
