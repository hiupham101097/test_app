// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
      id: json['id'] as String? ?? '',
      orderStatus: json['orderStatus'] as String? ?? '',
      totalOrderPrice: (json['totalOrderPrice'] as num?)?.toDouble() ?? 0,
      orderId: json['orderId'] as String? ?? '',
      createDate: json['createDate'] as String?,
      name: json['name'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      userAddress: json['userAddress'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      totalOrder: (json['totalOrder'] as num?)?.toInt() ?? 0,
      paymentMethod: json['paymentMethod'] as String? ?? '',
      refundStatus: json['refundStatus'] as String? ?? '',
      reasonCancel: json['reasonCancel'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      quantityFirstOrder: (json['quantityFirstOrder'] as num?)?.toInt() ?? 0,
      statusDriver: json['statusDriver'] as String? ?? '',
      transportOrderId: json['transportOrderId'] as String? ?? '',
    );

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderStatus': instance.orderStatus,
      'totalOrderPrice': instance.totalOrderPrice,
      'orderId': instance.orderId,
      'paymentMethod': instance.paymentMethod,
      'createDate': instance.createDate,
      'name': instance.name,
      'image_url': instance.imageUrl,
      'userAddress': instance.userAddress,
      'userName': instance.userName,
      'totalOrder': instance.totalOrder,
      'refundStatus': instance.refundStatus,
      'reasonCancel': instance.reasonCancel,
      'userId': instance.userId,
      'quantityFirstOrder': instance.quantityFirstOrder,
      'statusDriver': instance.statusDriver,
      'transportOrderId': instance.transportOrderId,
    };
