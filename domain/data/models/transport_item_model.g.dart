// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transport_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransportItem _$TransportItemFromJson(Map<String, dynamic> json) =>
    TransportItem(
      transportId: json['transportId'] as String?,
      transportOrderId: json['transportOrderId'] as String?,
      senderName: json['senderName'] as String?,
      senderPhone: json['senderPhone'] as String?,
      sendProvinceId: json['sendProvinceId'] as String?,
      sendDistrictId: json['sendDistrictId'] as String?,
      sendWardId: json['sendWardId'] as String?,
      sendProvinceNewId: json['sendProvinceNewId'] as String?,
      sendWardNewId: json['sendWardNewId'] as String?,
      sendAddressName: json['sendAddressName'] as String?,
      sendAddress: json['sendAddress'] as String?,
      sendLongitude: (json['sendLongitude'] as num?)?.toDouble(),
      sendLatitude: (json['sendLatitude'] as num?)?.toDouble(),
      sendImageIds: (json['sendImageIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      receiverName: json['receiverName'] as String?,
      receiverPhone: json['receiverPhone'] as String?,
      receiveProvinceId: json['receiveProvinceId'] as String?,
      receiveDistrictId: json['receiveDistrictId'] as String?,
      receiveWardId: json['receiveWardId'] as String?,
      receiveProvinceNewId: json['receiveProvinceNewId'] as String?,
      receiveWardNewId: json['receiveWardNewId'] as String?,
      receiveAddressName: json['receiveAddressName'] as String?,
      receiveAddress: json['receiveAddress'] as String?,
      receiveLongitude: (json['receiveLongitude'] as num?)?.toDouble(),
      receiveLatitude: (json['receiveLatitude'] as num?)?.toDouble(),
      distance: (json['distance'] as num?)?.toDouble(),
      feeDistance: (json['feeDistance'] as num?)?.toInt(),
      feeDistanceGross: (json['feeDistanceGross'] as num?)?.toInt(),
      feeDistanceNet: (json['feeDistanceNet'] as num?)?.toInt(),
      feeOption: (json['feeOption'] as num?)?.toInt(),
      feeService: (json['feeService'] as num?)?.toInt(),
      feeServiceGross: (json['feeServiceGross'] as num?)?.toInt(),
      feeServiceNet: (json['feeServiceNet'] as num?)?.toInt(),
      tipGross: (json['tipGross'] as num?)?.toInt(),
      tipNet: (json['tipNet'] as num?)?.toInt(),
      cod: (json['cod'] as num?)?.toInt(),
      index: (json['index'] as num?)?.toInt(),
      note: json['note'] as String?,
      imageIds: (json['imageIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      optionIds: (json['optionIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      serviceIds: (json['serviceIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      productIds: (json['productIds'] as List<dynamic>?)
          ?.map((e) => TransportProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      transportStatus: json['transportStatus'] as String?,
      optionIdsView: (json['optionIdsView'] as List<dynamic>?)
          ?.map((e) => TransportOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      serviceIdsView: (json['serviceIdsView'] as List<dynamic>?)
          ?.map((e) => ServiceIdsView.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageIdsView: json['imageIdsView'] as List<dynamic>?,
      created: json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
      sendImageIdsView: json['sendImageIdsView'] as List<dynamic>?,
    );

Map<String, dynamic> _$TransportItemToJson(TransportItem instance) =>
    <String, dynamic>{
      'transportId': instance.transportId,
      'transportOrderId': instance.transportOrderId,
      'senderName': instance.senderName,
      'senderPhone': instance.senderPhone,
      'sendProvinceId': instance.sendProvinceId,
      'sendDistrictId': instance.sendDistrictId,
      'sendWardId': instance.sendWardId,
      'sendProvinceNewId': instance.sendProvinceNewId,
      'sendWardNewId': instance.sendWardNewId,
      'sendAddressName': instance.sendAddressName,
      'sendAddress': instance.sendAddress,
      'sendLongitude': instance.sendLongitude,
      'sendLatitude': instance.sendLatitude,
      'sendImageIds': instance.sendImageIds,
      'receiverName': instance.receiverName,
      'receiverPhone': instance.receiverPhone,
      'receiveProvinceId': instance.receiveProvinceId,
      'receiveDistrictId': instance.receiveDistrictId,
      'receiveWardId': instance.receiveWardId,
      'receiveProvinceNewId': instance.receiveProvinceNewId,
      'receiveWardNewId': instance.receiveWardNewId,
      'receiveAddressName': instance.receiveAddressName,
      'receiveAddress': instance.receiveAddress,
      'receiveLongitude': instance.receiveLongitude,
      'receiveLatitude': instance.receiveLatitude,
      'distance': instance.distance,
      'feeDistance': instance.feeDistance,
      'feeDistanceGross': instance.feeDistanceGross,
      'feeDistanceNet': instance.feeDistanceNet,
      'feeOption': instance.feeOption,
      'feeService': instance.feeService,
      'feeServiceGross': instance.feeServiceGross,
      'feeServiceNet': instance.feeServiceNet,
      'tipGross': instance.tipGross,
      'tipNet': instance.tipNet,
      'cod': instance.cod,
      'index': instance.index,
      'note': instance.note,
      'optionIdsView': instance.optionIdsView?.map((e) => e.toJson()).toList(),
      'serviceIdsView':
          instance.serviceIdsView?.map((e) => e.toJson()).toList(),
      'imageIds': instance.imageIds,
      'optionIds': instance.optionIds,
      'serviceIds': instance.serviceIds,
      'productIds': instance.productIds?.map((e) => e.toJson()).toList(),
      'transportStatus': instance.transportStatus,
      'imageIdsView': instance.imageIdsView,
      'created': instance.created?.toIso8601String(),
      'sendImageIdsView': instance.sendImageIdsView,
    };

TransportOption _$TransportOptionFromJson(Map<String, dynamic> json) =>
    TransportOption(
      transportOptionId: json['transportOptionId'] as String?,
      name: json['name'] as String?,
      minWeight: (json['minWeight'] as num?)?.toInt(),
      maxWeight: (json['maxWeight'] as num?)?.toInt(),
      minLength: (json['minLength'] as num?)?.toInt(),
      maxLength: (json['maxLength'] as num?)?.toInt(),
      minWidth: (json['minWidth'] as num?)?.toInt(),
      maxWidth: (json['maxWidth'] as num?)?.toInt(),
      minHeight: (json['minHeight'] as num?)?.toInt(),
      maxHeight: (json['maxHeight'] as num?)?.toInt(),
      price: (json['price'] as num?)?.toInt(),
      status: json['status'] as String?,
      applicableLocations: (json['applicableLocations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$TransportOptionToJson(TransportOption instance) =>
    <String, dynamic>{
      'transportOptionId': instance.transportOptionId,
      'name': instance.name,
      'minWeight': instance.minWeight,
      'maxWeight': instance.maxWeight,
      'minLength': instance.minLength,
      'maxLength': instance.maxLength,
      'minWidth': instance.minWidth,
      'maxWidth': instance.maxWidth,
      'minHeight': instance.minHeight,
      'maxHeight': instance.maxHeight,
      'price': instance.price,
      'status': instance.status,
      'applicableLocations': instance.applicableLocations,
    };

ServiceIdsView _$ServiceIdsViewFromJson(Map<String, dynamic> json) =>
    ServiceIdsView(
      serviceId: json['serviceId'] as String?,
      name: json['name'] as String?,
      price: (json['price'] as num?)?.toInt(),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$ServiceIdsViewToJson(ServiceIdsView instance) =>
    <String, dynamic>{
      'serviceId': instance.serviceId,
      'name': instance.name,
      'price': instance.price,
      'description': instance.description,
    };

TransportProduct _$TransportProductFromJson(Map<String, dynamic> json) =>
    TransportProduct(
      productId: json['productId'] as String?,
      productName: json['productName'] as String?,
      productDes: json['productDes'] as String?,
      quantity: (json['quantity'] as num?)?.toInt(),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$TransportProductToJson(TransportProduct instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'productName': instance.productName,
      'productDes': instance.productDes,
      'quantity': instance.quantity,
      'note': instance.note,
    };
