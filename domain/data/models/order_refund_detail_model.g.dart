// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_refund_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderRefundDetailModel _$OrderRefundDetailModelFromJson(
        Map<String, dynamic> json) =>
    OrderRefundDetailModel(
      customId: json['customId'] == null
          ? null
          : CustomIdModel.fromJson(json['customId'] as Map<String, dynamic>),
      orderId: json['orderId'] as String? ?? '',
      storeId: json['storeId'] as String? ?? '',
      systemType: (json['system_type'] as num?)?.toInt() ?? 0,
      problem: json['problem'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      status: json['status'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      refundAmount: (json['refundAmount'] as num?)?.toInt() ?? 0,
      refundMethod: json['refundMethod'] as String? ?? '',
      createDate: json['createDate'] as String?,
      updateDate: json['updateDate'] as String?,
    );

Map<String, dynamic> _$OrderRefundDetailModelToJson(
        OrderRefundDetailModel instance) =>
    <String, dynamic>{
      'customId': instance.customId?.toJson(),
      'orderId': instance.orderId,
      'storeId': instance.storeId,
      'system_type': instance.systemType,
      'problem': instance.problem,
      'title': instance.title,
      'description': instance.description,
      'images': instance.images,
      'status': instance.status,
      'userId': instance.userId,
      'refundAmount': instance.refundAmount,
      'refundMethod': instance.refundMethod,
      'createDate': instance.createDate,
      'updateDate': instance.updateDate,
    };
