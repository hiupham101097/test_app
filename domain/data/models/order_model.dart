import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../commons/types/status_oder_enum.dart';

part 'order_model.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderModel {
  @JsonKey(name: 'id', defaultValue: '')
  final String id;

  @JsonKey(name: 'orderStatus')
  final String orderStatus;

  @JsonKey(name: 'totalOrderPrice', defaultValue: 0)
  final double totalOrderPrice;

  @JsonKey(name: 'orderId', defaultValue: '')
  final String orderId;

  @JsonKey(name: 'paymentMethod', defaultValue: '')
  final String paymentMethod;

  @JsonKey(name: 'createDate')
  final String? createDate;

  @JsonKey(name: 'name', defaultValue: '')
  final String name;

  @JsonKey(name: 'image_url', defaultValue: '')
  final String imageUrl;

  @JsonKey(name: 'userAddress', defaultValue: '')
  final String userAddress;

  @JsonKey(name: 'userName', defaultValue: '')
  final String userName;

  @JsonKey(name: 'totalOrder', defaultValue: 0)
  final int totalOrder;

  @JsonKey(name: 'refundStatus', defaultValue: '')
  final String refundStatus;

  @JsonKey(name: 'reasonCancel', defaultValue: '')
  final String reasonCancel;

  @JsonKey(name: 'userId', defaultValue: '')
  final String userId;

  @JsonKey(name: 'quantityFirstOrder', defaultValue: 0)
  final int quantityFirstOrder;

  @JsonKey(name: 'statusDriver', defaultValue: '')
  final String statusDriver;

  @JsonKey(name: 'transportOrderId', defaultValue: '')
  final String transportOrderId;

  final selected = false.obs;

  OrderModel({
    this.id = '',
    this.orderStatus = '',
    this.totalOrderPrice = 0,
    this.orderId = '',
    this.createDate,
    this.name = '',
    this.imageUrl = '',
    this.userAddress = '',
    this.userName = '',
    this.totalOrder = 0,
    this.paymentMethod = '',
    this.refundStatus = '',
    this.reasonCancel = '',
    this.userId = '',
    this.quantityFirstOrder = 0,
    this.statusDriver = '',
    this.transportOrderId = '',
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}
