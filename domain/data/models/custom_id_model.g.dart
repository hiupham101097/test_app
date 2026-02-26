// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_id_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomIdModel _$CustomIdModelFromJson(Map<String, dynamic> json) =>
    CustomIdModel(
      mongoId: json['mongoId'] as String? ?? '',
      orderRefundId: json['orderRefundId'] as String? ?? '',
    );

Map<String, dynamic> _$CustomIdModelToJson(CustomIdModel instance) =>
    <String, dynamic>{
      'mongoId': instance.mongoId,
      'orderRefundId': instance.orderRefundId,
    };
