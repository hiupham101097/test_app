// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifi_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotifiModel _$NotifiModelFromJson(Map<String, dynamic> json) => NotifiModel(
      notificationId: json['notificationId'] as String?,
      type: json['type'] as String?,
      title: json['title'] as String?,
      message: json['message'] as String?,
      receiverId: json['receiverId'] as String?,
      receiverType: json['receiverType'] as String?,
      senderId: json['senderId'] as String?,
      image: json['image'] as String?,
      payload: json['payload'] == null
          ? null
          : NotifiPayload.fromJson(json['payload'] as Map<String, dynamic>),
      isRead: json['isRead'] as bool?,
      priority: json['priority'] as String?,
      isDeleted: json['isDeleted'] as bool?,
      expiredAt: json['expiredAt'] as String?,
      createDate: json['createDate'] as String?,
      updateDate: json['updateDate'] as String?,
    );

Map<String, dynamic> _$NotifiModelToJson(NotifiModel instance) =>
    <String, dynamic>{
      'notificationId': instance.notificationId,
      'type': instance.type,
      'title': instance.title,
      'message': instance.message,
      'receiverId': instance.receiverId,
      'receiverType': instance.receiverType,
      'senderId': instance.senderId,
      'image': instance.image,
      'payload': instance.payload?.toJson(),
      'isRead': instance.isRead,
      'priority': instance.priority,
      'isDeleted': instance.isDeleted,
      'expiredAt': instance.expiredAt,
      'createDate': instance.createDate,
      'updateDate': instance.updateDate,
    };

NotifiPayload _$NotifiPayloadFromJson(Map<String, dynamic> json) =>
    NotifiPayload(
      orderId: json['orderId'] as String?,
    );

Map<String, dynamic> _$NotifiPayloadToJson(NotifiPayload instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
    };
