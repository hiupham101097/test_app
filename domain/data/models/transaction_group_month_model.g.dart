// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_group_month_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionGroupMonthModel _$TransactionGroupMonthModelFromJson(
        Map<String, dynamic> json) =>
    TransactionGroupMonthModel(
      month: json['month'] as String? ?? '',
      transactions: (json['transactions'] as List<dynamic>?)
              ?.map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$TransactionGroupMonthModelToJson(
        TransactionGroupMonthModel instance) =>
    <String, dynamic>{
      'month': instance.month,
      'transactions': instance.transactions,
    };
