// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_group_month_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderGroupMonthModel _$OrderGroupMonthModelFromJson(
        Map<String, dynamic> json) =>
    OrderGroupMonthModel(
      month: json['month'] as String? ?? '',
      orders: (json['orders'] as List<dynamic>?)
              ?.map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$OrderGroupMonthModelToJson(
        OrderGroupMonthModel instance) =>
    <String, dynamic>{
      'month': instance.month,
      'orders': instance.orders,
    };
