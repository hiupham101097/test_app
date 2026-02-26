import 'package:json_annotation/json_annotation.dart';

part 'notifi_model.g.dart';

@JsonSerializable(explicitToJson: true)
class NotifiModel {
  @JsonKey(name: 'notificationId')
  final String? notificationId;

  @JsonKey(name: 'type')
  final String? type;

  @JsonKey(name: 'title')
  final String? title;

  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'receiverId')
  final String? receiverId;

  @JsonKey(name: 'receiverType')
  final String? receiverType;

  @JsonKey(name: 'senderId')
  final String? senderId;

  @JsonKey(name: 'image')
  final String? image;

  @JsonKey(name: 'payload')
  final NotifiPayload? payload;

  @JsonKey(name: 'isRead')
  final bool? isRead;

  @JsonKey(name: 'priority')
  final String? priority;

  @JsonKey(name: 'isDeleted')
  final bool? isDeleted;

  @JsonKey(name: 'expiredAt')
  final String? expiredAt;

  @JsonKey(name: 'createDate')
  final String? createDate;

  @JsonKey(name: 'updateDate')
  final String? updateDate;

  const NotifiModel({
    this.notificationId,
    this.type,
    this.title,
    this.message,
    this.receiverId,
    this.receiverType,
    this.senderId,
    this.image,
    this.payload,
    this.isRead,
    this.priority,
    this.isDeleted,
    this.expiredAt,
    this.createDate,
    this.updateDate,
  });

  factory NotifiModel.fromJson(Map<String, dynamic> json) =>
      _$NotifiModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotifiModelToJson(this);
}

@JsonSerializable()
class NotifiPayload {
  @JsonKey(name: 'orderId')
  final String? orderId;

  const NotifiPayload({this.orderId});

  factory NotifiPayload.fromJson(Map<String, dynamic> json) =>
      _$NotifiPayloadFromJson(json);

  Map<String, dynamic> toJson() => _$NotifiPayloadToJson(this);
}
