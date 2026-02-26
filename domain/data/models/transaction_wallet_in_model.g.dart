// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_wallet_in_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionWalletInModel _$TransactionWalletInModelFromJson(
        Map<String, dynamic> json) =>
    TransactionWalletInModel(
      historyId: json['historyId'] as String?,
      walletId: json['walletId'] as String?,
      type: json['type'] as String?,
      orderId: json['orderId'] as String?,
      transId: json['transId'] as String?,
      amount: (json['amount'] as num?)?.toInt(),
      walletBankId: json['walletBankId'] as String?,
      bankId: json['bankId'] as String?,
      bankAccount: json['bankAccount'] as String?,
      bankNumber: json['bankNumber'] as String?,
      description: json['description'] as String?,
      notes: json['notes'] as String?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      refcode: json['refcode'] as String?,
    );

Map<String, dynamic> _$TransactionWalletInModelToJson(
        TransactionWalletInModel instance) =>
    <String, dynamic>{
      'historyId': instance.historyId,
      'walletId': instance.walletId,
      'type': instance.type,
      'orderId': instance.orderId,
      'transId': instance.transId,
      'amount': instance.amount,
      'walletBankId': instance.walletBankId,
      'bankId': instance.bankId,
      'bankAccount': instance.bankAccount,
      'bankNumber': instance.bankNumber,
      'description': instance.description,
      'notes': instance.notes,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
      'refcode': instance.refcode,
    };
