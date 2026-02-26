import 'package:json_annotation/json_annotation.dart';

part 'transport_item_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TransportItem {
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

  TransportItem({
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

  factory TransportItem.fromJson(Map<String, dynamic> json) =>
      _$TransportItemFromJson(json);

  Map<String, dynamic> toJson() => _$TransportItemToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TransportOption {
  @JsonKey(name: 'transportOptionId')
  final String? transportOptionId;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'minWeight')
  final int? minWeight;

  @JsonKey(name: 'maxWeight')
  final int? maxWeight;

  @JsonKey(name: 'minLength')
  final int? minLength;

  @JsonKey(name: 'maxLength')
  final int? maxLength;

  @JsonKey(name: 'minWidth')
  final int? minWidth;

  @JsonKey(name: 'maxWidth')
  final int? maxWidth;

  @JsonKey(name: 'minHeight')
  final int? minHeight;

  @JsonKey(name: 'maxHeight')
  final int? maxHeight;

  @JsonKey(name: 'price')
  final int? price;

  @JsonKey(name: 'status')
  final String? status;

  @JsonKey(name: 'applicableLocations')
  final List<String>? applicableLocations;

  TransportOption({
    this.transportOptionId,
    this.name,
    this.minWeight,
    this.maxWeight,
    this.minLength,
    this.maxLength,
    this.minWidth,
    this.maxWidth,
    this.minHeight,
    this.maxHeight,
    this.price,
    this.status,
    this.applicableLocations,
  });

  factory TransportOption.fromJson(Map<String, dynamic> json) =>
      _$TransportOptionFromJson(json);

  Map<String, dynamic> toJson() => _$TransportOptionToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ServiceIdsView {
  @JsonKey(name: 'serviceId')
  final String? serviceId;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'price')
  final int? price;

  @JsonKey(name: 'description')
  final String? description;

  ServiceIdsView({this.serviceId, this.name, this.price, this.description});

  factory ServiceIdsView.fromJson(Map<String, dynamic> json) =>
      _$ServiceIdsViewFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceIdsViewToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TransportProduct {
  @JsonKey(name: 'productId')
  final String? productId;

  @JsonKey(name: 'productName')
  final String? productName;

  @JsonKey(name: 'productDes')
  final String? productDes;

  @JsonKey(name: 'quantity')
  final int? quantity;

  @JsonKey(name: 'note')
  final String? note;

  TransportProduct({
    this.productId,
    this.productName,
    this.productDes,
    this.quantity,
    this.note,
  });

  factory TransportProduct.fromJson(Map<String, dynamic> json) =>
      _$TransportProductFromJson(json);

  Map<String, dynamic> toJson() => _$TransportProductToJson(this);
}
