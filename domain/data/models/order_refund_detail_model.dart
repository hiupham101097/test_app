import 'package:json_annotation/json_annotation.dart';
import 'custom_id_model.dart';

part 'order_refund_detail_model.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderRefundDetailModel {
  @JsonKey(name: 'customId')
  final CustomIdModel? customId;

  @JsonKey(name: 'orderId', defaultValue: '')
  final String orderId;

  @JsonKey(name: 'storeId', defaultValue: '')
  final String storeId;

  @JsonKey(name: 'system_type', defaultValue: 0)
  final int systemType;

  @JsonKey(name: 'problem', defaultValue: '')
  final String problem;

  @JsonKey(name: 'title', defaultValue: '')
  final String title;

  @JsonKey(name: 'description', defaultValue: '')
  final String description;

  @JsonKey(name: 'images', defaultValue: [])
  final List<String> images;

  @JsonKey(name: 'status', defaultValue: '')
  final String status;

  @JsonKey(name: 'userId', defaultValue: '')
  final String userId;

  @JsonKey(name: 'refundAmount', defaultValue: 0)
  final int refundAmount;

  @JsonKey(name: 'refundMethod', defaultValue: '')
  final String refundMethod;

  @JsonKey(name: 'createDate')
  final String? createDate;

  @JsonKey(name: 'updateDate')
  final String? updateDate;

  const OrderRefundDetailModel({
    this.customId,
    this.orderId = '',
    this.storeId = '',
    this.systemType = 0,
    this.problem = '',
    this.title = '',
    this.description = '',
    this.images = const [],
    this.status = '',
    this.userId = '',
    this.refundAmount = 0,
    this.refundMethod = '',
    this.createDate,
    this.updateDate,
  });

  factory OrderRefundDetailModel.fromJson(Map<String, dynamic> json) =>
      _$OrderRefundDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderRefundDetailModelToJson(this);
}
