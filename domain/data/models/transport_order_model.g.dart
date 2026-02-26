// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transport_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransportOrder _$TransportOrderFromJson(Map<String, dynamic> json) =>
    TransportOrder(
      transportOrderId: json['transportOrderId'] as String?,
      transportOrderCode: json['transportOrderCode'] as String?,
      discountByVoucher: json['discountByVoucher'] as num?,
      totalPriceGross: json['totalPriceGross'] as num?,
      totalPriceNet: json['totalPriceNet'] as num?,
      tipGross: json['tipGross'] as num?,
      tipNet: json['tipNet'] as num?,
      totalCOD: json['totalCOD'] as num?,
      transports: (json['transports'] as List<dynamic>?)
          ?.map((e) => Transports.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageIdsView: json['imageIdsView'] as List<dynamic>?,
      voucherIdsView: (json['voucherIdsView'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      paymentMethod: json['paymentMethod'] as String?,
      paymentId: json['paymentId'] as String?,
      transportOrderStatus: json['transportOrderStatus'] as String?,
      note: json['note'] as String?,
      userId: json['userId'] as String?,
      driverId: json['driverId'] as String?,
      isDraft: json['isDraft'] as bool?,
      created: json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
      imageIds: (json['imageIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      voucherIds: (json['voucherIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      driverName: json['driverName'] as String?,
    );

Map<String, dynamic> _$TransportOrderToJson(TransportOrder instance) =>
    <String, dynamic>{
      'transportOrderId': instance.transportOrderId,
      'transportOrderCode': instance.transportOrderCode,
      'discountByVoucher': instance.discountByVoucher,
      'totalPriceGross': instance.totalPriceGross,
      'totalPriceNet': instance.totalPriceNet,
      'tipGross': instance.tipGross,
      'tipNet': instance.tipNet,
      'totalCOD': instance.totalCOD,
      'transports': instance.transports?.map((e) => e.toJson()).toList(),
      'imageIdsView': instance.imageIdsView,
      'voucherIdsView': instance.voucherIdsView,
      'paymentMethod': instance.paymentMethod,
      'paymentId': instance.paymentId,
      'transportOrderStatus': instance.transportOrderStatus,
      'note': instance.note,
      'userId': instance.userId,
      'driverId': instance.driverId,
      'isDraft': instance.isDraft,
      'created': instance.created?.toIso8601String(),
      'imageIds': instance.imageIds,
      'voucherIds': instance.voucherIds,
      'driverName': instance.driverName,
    };

Transports _$TransportsFromJson(Map<String, dynamic> json) => Transports(
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

Map<String, dynamic> _$TransportsToJson(Transports instance) =>
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

NextPointModel _$NextPointModelFromJson(Map<String, dynamic> json) =>
    NextPointModel(
      goingToLong: (json['goingToLong'] as num?)?.toDouble(),
      goingToLat: (json['goingToLat'] as num?)?.toDouble(),
      goingToAddress: json['goingToAddress'] as String?,
      isGoingToSender: json['isGoingToSender'] as bool?,
      driverLong: (json['driverLong'] as num?)?.toDouble(),
      driverLat: (json['driverLat'] as num?)?.toDouble(),
      driverName: json['driverName'] as String?,
      driverPhone: json['driverPhone'] as String?,
      vehicleBrand: json['vehicleBrand'] as String?,
      vehiclePlate: json['vehiclePlate'] as String?,
      totalDistance: (json['totalDistance'] as num?)?.toDouble(),
      totalTime: json['totalTime'] as String?,
      expectTimeFrom: json['expectTimeFrom'] as String?,
      expectTimeTo: json['expectTimeTo'] as String?,
      avatar: json['avatar'] as String?,
      currentTransportId: json['currentTransportId'] as String?,
      transportOrder: json['transportOrder'] == null
          ? null
          : TransportOrder.fromJson(
              json['transportOrder'] as Map<String, dynamic>),
      driverRating: (json['driverRating'] as num?)?.toDouble(),
      transportOrderId: json['transportOrderId'] as String?,
    );

Map<String, dynamic> _$NextPointModelToJson(NextPointModel instance) =>
    <String, dynamic>{
      'goingToLong': instance.goingToLong,
      'goingToLat': instance.goingToLat,
      'goingToAddress': instance.goingToAddress,
      'isGoingToSender': instance.isGoingToSender,
      'driverLong': instance.driverLong,
      'driverLat': instance.driverLat,
      'driverName': instance.driverName,
      'driverPhone': instance.driverPhone,
      'vehicleBrand': instance.vehicleBrand,
      'vehiclePlate': instance.vehiclePlate,
      'totalDistance': instance.totalDistance,
      'totalTime': instance.totalTime,
      'expectTimeFrom': instance.expectTimeFrom,
      'expectTimeTo': instance.expectTimeTo,
      'avatar': instance.avatar,
      'driverRating': instance.driverRating,
      'currentTransportId': instance.currentTransportId,
      'transportOrder': instance.transportOrder?.toJson(),
      'transportOrderId': instance.transportOrderId,
    };
