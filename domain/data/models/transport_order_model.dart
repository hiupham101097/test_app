import 'package:json_annotation/json_annotation.dart';
import 'transport_item_model.dart';

part 'transport_order_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TransportOrder {
  @JsonKey(name: 'transportOrderId')
  final String? transportOrderId;

  @JsonKey(name: 'transportOrderCode')
  final String? transportOrderCode;

  @JsonKey(name: 'discountByVoucher')
  final num? discountByVoucher;

  @JsonKey(name: 'totalPriceGross')
  final num? totalPriceGross;

  @JsonKey(name: 'totalPriceNet')
  final num? totalPriceNet;

  @JsonKey(name: 'tipGross')
  final num? tipGross;

  @JsonKey(name: 'tipNet')
  final num? tipNet;

  @JsonKey(name: 'totalCOD')
  final num? totalCOD;

  @JsonKey(name: 'transports')
  final List<Transports>? transports;

  @JsonKey(name: 'imageIdsView')
  final List<dynamic>? imageIdsView;

  @JsonKey(name: 'voucherIdsView')
  final List<String>? voucherIdsView;

  @JsonKey(name: 'paymentMethod')
  final String? paymentMethod;

  @JsonKey(name: 'paymentId')
  final String? paymentId;

  @JsonKey(name: 'transportOrderStatus')
  final String? transportOrderStatus;

  @JsonKey(name: 'note')
  final String? note;

  @JsonKey(name: 'userId')
  final String? userId;

  @JsonKey(name: 'driverId')
  final String? driverId;

  @JsonKey(name: 'isDraft')
  final bool? isDraft;

  @JsonKey(name: 'created')
  final DateTime? created;

  @JsonKey(name: 'imageIds')
  final List<String>? imageIds;

  @JsonKey(name: 'voucherIds')
  final List<String>? voucherIds;

  @JsonKey(name: 'driverName')
  final String? driverName;

  TransportOrder({
    this.transportOrderId,
    this.transportOrderCode,
    this.discountByVoucher,
    this.totalPriceGross,
    this.totalPriceNet,
    this.tipGross,
    this.tipNet,
    this.totalCOD,
    this.transports,
    this.imageIdsView,
    this.voucherIdsView,
    this.paymentMethod,
    this.paymentId,
    this.transportOrderStatus,
    this.note,
    this.userId,
    this.driverId,
    this.isDraft,
    this.created,
    this.imageIds,
    this.voucherIds,
    this.driverName,
  });

  factory TransportOrder.fromJson(Map<String, dynamic> json) =>
      _$TransportOrderFromJson(json);

  Map<String, dynamic> toJson() => _$TransportOrderToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Transports {
  @JsonKey(name: 'transportId')
  final String? transportId;

  @JsonKey(name: 'transportOrderId')
  final String? transportOrderId;

  @JsonKey(name: 'senderName')
  final String? senderName;

  @JsonKey(name: 'senderPhone')
  final String? senderPhone;

  @JsonKey(name: 'sendProvinceId')
  final String? sendProvinceId;

  @JsonKey(name: 'sendDistrictId')
  final String? sendDistrictId;

  @JsonKey(name: 'sendWardId')
  final String? sendWardId;

  @JsonKey(name: 'sendProvinceNewId')
  final String? sendProvinceNewId;

  @JsonKey(name: 'sendWardNewId')
  final String? sendWardNewId;

  @JsonKey(name: 'sendAddressName')
  final String? sendAddressName;

  @JsonKey(name: 'sendAddress')
  final String? sendAddress;

  @JsonKey(name: 'sendLongitude')
  final double? sendLongitude;

  @JsonKey(name: 'sendLatitude')
  final double? sendLatitude;

  @JsonKey(name: 'sendImageIds')
  final List<String>? sendImageIds;

  @JsonKey(name: 'receiverName')
  final String? receiverName;

  @JsonKey(name: 'receiverPhone')
  final String? receiverPhone;

  @JsonKey(name: 'receiveProvinceId')
  final String? receiveProvinceId;

  @JsonKey(name: 'receiveDistrictId')
  final String? receiveDistrictId;

  @JsonKey(name: 'receiveWardId')
  final String? receiveWardId;

  @JsonKey(name: 'receiveProvinceNewId')
  final String? receiveProvinceNewId;

  @JsonKey(name: 'receiveWardNewId')
  final String? receiveWardNewId;

  @JsonKey(name: 'receiveAddressName')
  final String? receiveAddressName;

  @JsonKey(name: 'receiveAddress')
  final String? receiveAddress;

  @JsonKey(name: 'receiveLongitude')
  final double? receiveLongitude;

  @JsonKey(name: 'receiveLatitude')
  final double? receiveLatitude;

  @JsonKey(name: 'distance')
  final double? distance;

  @JsonKey(name: 'feeDistance')
  final int? feeDistance;

  @JsonKey(name: 'feeDistanceGross')
  final int? feeDistanceGross;

  @JsonKey(name: 'feeDistanceNet')
  final int? feeDistanceNet;

  @JsonKey(name: 'feeOption')
  final int? feeOption;

  @JsonKey(name: 'feeService')
  final int? feeService;

  @JsonKey(name: 'feeServiceGross')
  final int? feeServiceGross;

  @JsonKey(name: 'feeServiceNet')
  final int? feeServiceNet;

  @JsonKey(name: 'tipGross')
  final int? tipGross;

  @JsonKey(name: 'tipNet')
  final int? tipNet;

  @JsonKey(name: 'cod')
  final int? cod;

  @JsonKey(name: 'index')
  final int? index;

  @JsonKey(name: 'note')
  final String? note;

  @JsonKey(name: 'optionIdsView')
  final List<TransportOption>? optionIdsView;

  @JsonKey(name: 'serviceIdsView')
  final List<ServiceIdsView>? serviceIdsView;

  @JsonKey(name: 'imageIds')
  final List<String>? imageIds;

  @JsonKey(name: 'optionIds')
  final List<String>? optionIds;

  @JsonKey(name: 'serviceIds')
  final List<String>? serviceIds;

  @JsonKey(name: 'productIds')
  final List<TransportProduct>? productIds;

  @JsonKey(name: 'transportStatus')
  final String? transportStatus;

  @JsonKey(name: 'imageIdsView')
  final List<dynamic>? imageIdsView;

  @JsonKey(name: 'created')
  final DateTime? created;

  @JsonKey(name: 'sendImageIdsView')
  final List<dynamic>? sendImageIdsView;

  Transports({
    this.transportId,
    this.transportOrderId,
    this.senderName,
    this.senderPhone,
    this.sendProvinceId,
    this.sendDistrictId,
    this.sendWardId,
    this.sendProvinceNewId,
    this.sendWardNewId,
    this.sendAddressName,
    this.sendAddress,
    this.sendLongitude,
    this.sendLatitude,
    this.sendImageIds,
    this.receiverName,
    this.receiverPhone,
    this.receiveProvinceId,
    this.receiveDistrictId,
    this.receiveWardId,
    this.receiveProvinceNewId,
    this.receiveWardNewId,
    this.receiveAddressName,
    this.receiveAddress,
    this.receiveLongitude,
    this.receiveLatitude,
    this.distance,
    this.feeDistance,
    this.feeDistanceGross,
    this.feeDistanceNet,
    this.feeOption,
    this.feeService,
    this.feeServiceGross,
    this.feeServiceNet,
    this.tipGross,
    this.tipNet,
    this.cod,
    this.index,
    this.note,
    this.imageIds,
    this.optionIds,
    this.serviceIds,
    this.productIds,
    this.transportStatus,
    this.optionIdsView,
    this.serviceIdsView,
    this.imageIdsView,
    this.created,
    this.sendImageIdsView,
  });

  factory Transports.fromJson(Map<String, dynamic> json) =>
      _$TransportsFromJson(json);

  Map<String, dynamic> toJson() => _$TransportsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NextPointModel {
  @JsonKey(name: 'goingToLong')
  final double? goingToLong;

  @JsonKey(name: 'goingToLat')
  final double? goingToLat;

  @JsonKey(name: 'goingToAddress')
  final String? goingToAddress;

  @JsonKey(name: 'isGoingToSender')
  final bool? isGoingToSender;

  @JsonKey(name: 'driverLong')
  final double? driverLong;

  @JsonKey(name: 'driverLat')
  final double? driverLat;

  @JsonKey(name: 'driverName')
  final String? driverName;

  @JsonKey(name: 'driverPhone')
  final String? driverPhone;

  @JsonKey(name: 'vehicleBrand')
  final String? vehicleBrand;

  @JsonKey(name: 'vehiclePlate')
  final String? vehiclePlate;

  @JsonKey(name: 'totalDistance')
  final double? totalDistance;

  @JsonKey(name: 'totalTime')
  final String? totalTime;

  @JsonKey(name: 'expectTimeFrom')
  final String? expectTimeFrom;

  @JsonKey(name: 'expectTimeTo')
  final String? expectTimeTo;

  @JsonKey(name: 'avatar')
  final String? avatar;

  @JsonKey(name: 'driverRating')
  final double? driverRating;

  @JsonKey(name: 'currentTransportId')
  final String? currentTransportId;

  @JsonKey(name: 'transportOrder')
  final TransportOrder? transportOrder;

  @JsonKey(name: 'transportOrderId')
  final String? transportOrderId;

  NextPointModel({
    this.goingToLong,
    this.goingToLat,
    this.goingToAddress,
    this.isGoingToSender,
    this.driverLong,
    this.driverLat,
    this.driverName,
    this.driverPhone,
    this.vehicleBrand,
    this.vehiclePlate,
    this.totalDistance,
    this.totalTime,
    this.expectTimeFrom,
    this.expectTimeTo,
    this.avatar,
    this.currentTransportId,
    this.transportOrder,
    this.driverRating,
    this.transportOrderId,
  });

  factory NextPointModel.fromJson(Map<String, dynamic> json) =>
      _$NextPointModelFromJson(json);

  Map<String, dynamic> toJson() => _$NextPointModelToJson(this);
}
