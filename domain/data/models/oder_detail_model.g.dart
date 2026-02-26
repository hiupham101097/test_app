// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oder_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OderDetailModel _$OderDetailModelFromJson(Map<String, dynamic> json) =>
    OderDetailModel(
      id: json['id'] as String? ?? '',
      orderId: json['orderId'] as String? ?? '',
      orderStatus: json['orderStatus'] as String? ?? '',
      createDate: json['createDate'] as String?,
      note: json['note'] as String? ?? '',
      totalOrder: (json['totalOrder'] as num?)?.toInt() ?? 0,
      paymentMethod: json['paymentMethod'] as String? ?? '',
      totalOrderPrice: (json['totalOrderPrice'] as num?)?.toDouble() ?? 0,
      discountedVoucherAmount:
          (json['discountedVoucherAmount'] as num?)?.toDouble() ?? 0,
      priceAfterVoucher: (json['priceAfterVoucher'] as num?)?.toDouble() ?? 0,
      vatAmount: (json['vatAmount'] as num?)?.toDouble() ?? 0,
      vatPercent: (json['vatPercent'] as num?)?.toDouble() ?? 0,
      userAddress: json['userAddress'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      productList: (json['productList'] as List<dynamic>?)
              ?.map((e) =>
                  OderProductItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      deliveryShip: (json['deliveryShip'] as num?)?.toDouble() ?? 0,
      userId: json['userId'] as String? ?? '',
      transportOrderId: json['transportOrderId'] as String? ?? '',
      orderStatusHistory: json['orderStatusHistory'] == null
          ? null
          : OrderStatusHistoryModel.fromJson(
              json['orderStatusHistory'] as Map<String, dynamic>),
      driverInfo: json['driverInfo'] == null
          ? null
          : DriverInfoModel.fromJson(
              json['driverInfo'] as Map<String, dynamic>),
      statusDriver: json['statusDriver'] as String? ?? '',
      predictDeliveryDate: json['predictDeliveryDate'] as String? ?? '',
    );

Map<String, dynamic> _$OderDetailModelToJson(OderDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'userId': instance.userId,
      'orderStatus': instance.orderStatus,
      'createDate': instance.createDate,
      'note': instance.note,
      'totalOrder': instance.totalOrder,
      'paymentMethod': instance.paymentMethod,
      'totalOrderPrice': instance.totalOrderPrice,
      'discountedVoucherAmount': instance.discountedVoucherAmount,
      'priceAfterVoucher': instance.priceAfterVoucher,
      'vatAmount': instance.vatAmount,
      'vatPercent': instance.vatPercent,
      'userAddress': instance.userAddress,
      'userName': instance.userName,
      'phoneNumber': instance.phoneNumber,
      'productList': instance.productList.map((e) => e.toJson()).toList(),
      'deliveryShip': instance.deliveryShip,
      'transportOrderId': instance.transportOrderId,
      'orderStatusHistory': instance.orderStatusHistory?.toJson(),
      'driverInfo': instance.driverInfo?.toJson(),
      'statusDriver': instance.statusDriver,
      'predictDeliveryDate': instance.predictDeliveryDate,
    };

OderProductItemModel _$OderProductItemModelFromJson(
        Map<String, dynamic> json) =>
    OderProductItemModel(
      name: json['name'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      unit: json['unit'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      id: json['id'] as String? ?? '',
      priceSale: (json['priceSale'] as num?)?.toDouble() ?? 0,
      productOptionFoods: (json['productOptionFoods'] as List<dynamic>?)
              ?.map(
                  (e) => OptionProductModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$OderProductItemModelToJson(
        OderProductItemModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
      'unit': instance.unit,
      'quantity': instance.quantity,
      'id': instance.id,
      'priceSale': instance.priceSale,
      'productOptionFoods': instance.productOptionFoods,
    };

OrderStatusHistoryModel _$OrderStatusHistoryModelFromJson(
        Map<String, dynamic> json) =>
    OrderStatusHistoryModel(
      fromType: json['fromType'] as String? ?? '',
      reasonCancel: json['reasonCancel'] as String? ?? '',
      createDate: json['createDate'] as String? ?? '',
    );

Map<String, dynamic> _$OrderStatusHistoryModelToJson(
        OrderStatusHistoryModel instance) =>
    <String, dynamic>{
      'fromType': instance.fromType,
      'reasonCancel': instance.reasonCancel,
      'createDate': instance.createDate,
    };

DriverInfoModel _$DriverInfoModelFromJson(Map<String, dynamic> json) =>
    DriverInfoModel(
      driverId: json['driverId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      vehicle: json['vehicle'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$DriverInfoModelToJson(DriverInfoModel instance) =>
    <String, dynamic>{
      'driverId': instance.driverId,
      'name': instance.name,
      'phone': instance.phone,
      'vehicle': instance.vehicle,
      'avatar': instance.avatar,
      'rating': instance.rating,
    };
