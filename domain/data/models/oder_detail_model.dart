import 'package:get/get.dart';
import 'package:merchant/domain/data/models/base_model.dart';
import 'package:merchant/domain/data/models/option_product_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'oder_detail_model.g.dart';

@JsonSerializable(explicitToJson: true)
class OderDetailModel {
  @JsonKey(name: 'id', defaultValue: '')
  final String id;

  @JsonKey(name: 'orderId', defaultValue: '')
  final String orderId;

  @JsonKey(name: 'userId', defaultValue: '')
  final String userId;

  @JsonKey(name: 'orderStatus', defaultValue: '')
  final String orderStatus;

  @JsonKey(name: 'createDate')
  final String? createDate;

  @JsonKey(name: 'note', defaultValue: '')
  final String note;

  @JsonKey(name: 'totalOrder', defaultValue: 0)
  final int totalOrder;

  @JsonKey(name: 'paymentMethod', defaultValue: '')
  final String paymentMethod;

  @JsonKey(name: 'totalOrderPrice', defaultValue: 0)
  final double totalOrderPrice;

  @JsonKey(name: 'discountedVoucherAmount', defaultValue: 0)
  final double discountedVoucherAmount;

  @JsonKey(name: 'priceAfterVoucher', defaultValue: 0)
  final double priceAfterVoucher;

  @JsonKey(name: 'vatAmount', defaultValue: 0)
  final double vatAmount;

  @JsonKey(name: 'vatPercent', defaultValue: 0)
  final double vatPercent;

  @JsonKey(name: 'userAddress', defaultValue: '')
  final String userAddress;

  @JsonKey(name: 'userName', defaultValue: '')
  final String userName;

  @JsonKey(name: 'phoneNumber', defaultValue: '')
  final String phoneNumber;

  @JsonKey(name: 'productList', defaultValue: [])
  final List<OderProductItemModel> productList;

  @JsonKey(name: 'deliveryShip', defaultValue: 0)
  final double deliveryShip;

  @JsonKey(name: 'transportOrderId', defaultValue: '')
  final String transportOrderId;

  @JsonKey(name: 'orderStatusHistory', defaultValue: null)
  final OrderStatusHistoryModel? orderStatusHistory;

  @JsonKey(name: 'driverInfo', defaultValue: null)
  final DriverInfoModel? driverInfo;

  @JsonKey(name: 'statusDriver', defaultValue: '')
  final String statusDriver;

  @JsonKey(name: 'predictDeliveryDate', defaultValue: '')
  final String predictDeliveryDate;

  const OderDetailModel({
    this.id = '',
    this.orderId = '',
    this.orderStatus = '',
    this.createDate,
    this.note = '',
    this.totalOrder = 0,
    this.paymentMethod = '',
    this.totalOrderPrice = 0,
    this.discountedVoucherAmount = 0,
    this.priceAfterVoucher = 0,
    this.vatAmount = 0,
    this.vatPercent = 0,
    this.userAddress = '',
    this.userName = '',
    this.phoneNumber = '',
    this.productList = const [],
    this.deliveryShip = 0,
    this.userId = '',
    this.transportOrderId = '',
    this.orderStatusHistory,
    this.driverInfo,
    this.statusDriver = '',
    this.predictDeliveryDate = '',
  });

  factory OderDetailModel.fromJson(Map<String, dynamic> json) =>
      _$OderDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$OderDetailModelToJson(this);
}

@JsonSerializable()
class OderProductItemModel {
  @JsonKey(name: 'name', defaultValue: '')
  final String name;

  @JsonKey(name: 'price', defaultValue: 0)
  final double price;

  @JsonKey(name: 'unit', defaultValue: '')
  final String unit;

  @JsonKey(name: 'quantity', defaultValue: 0)
  final int quantity;

  @JsonKey(name: 'id', defaultValue: '')
  final String id;

  @JsonKey(name: 'priceSale', defaultValue: 0)
  final double? priceSale;

  @JsonKey(name: 'productOptionFoods', defaultValue: [])
  final List<OptionProductModel> productOptionFoods;

  final isDone = false.obs;
  OderProductItemModel({
    this.name = '',
    this.price = 0,
    this.unit = '',
    this.quantity = 0,
    this.id = '',
    this.priceSale = 0,
    this.productOptionFoods = const [],
  });

  factory OderProductItemModel.fromJson(Map<String, dynamic> json) =>
      _$OderProductItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$OderProductItemModelToJson(this);
}

@JsonSerializable()
class OrderStatusHistoryModel {
  @JsonKey(defaultValue: '')
  final String fromType;

  @JsonKey(defaultValue: '')
  final String reasonCancel;

  @JsonKey(defaultValue: '')
  final String createDate;

  OrderStatusHistoryModel({
    this.fromType = '',
    this.reasonCancel = '',
    this.createDate = '',
  });

  factory OrderStatusHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$OrderStatusHistoryModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$OrderStatusHistoryModelToJson(this);
}

@JsonSerializable()
class DriverInfoModel {
  @JsonKey(defaultValue: '')
  final String driverId;

  @JsonKey(defaultValue: '')
  final String name;

  @JsonKey(defaultValue: '')
  final String phone;

  @JsonKey(defaultValue: '')
  final String vehicle;

  @JsonKey(defaultValue: '', name: 'avatar')
  final String avatar;

  @JsonKey(defaultValue: 0)
  final double rating;

  DriverInfoModel({
    this.driverId = '',
    this.name = '',
    this.phone = '',
    this.vehicle = '',
    this.avatar = '',
    this.rating = 0,
  });

  factory DriverInfoModel.fromJson(Map<String, dynamic> json) =>
      _$DriverInfoModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DriverInfoModelToJson(this);
}
