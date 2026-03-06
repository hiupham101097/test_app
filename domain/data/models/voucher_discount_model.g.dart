// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voucher_discount_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VoucherDiscountModel _$VoucherDiscountModelFromJson(
  Map<String, dynamic> json,
) => VoucherDiscountModel(
  id: json['id'] as String? ?? '',
  name: json['name'] as String? ?? '',
  type: json['type'] as String? ?? '',
  startDate:
      json['startDate'] != null
          ? DateTime.parse(json['startDate'] as String)
          : null,
  usageCount: json['usageCount'] as int? ?? 0,
  usedCount: json['usedCount'] as int? ?? 0,
  usagePerUser: json['usagePerUser'] as int? ?? 0,
  minOrderValue: json['minOrderValue'] as int? ?? 0,
  discountAmount: json['discountAmount'] as int? ?? 0,
  discountPercent: json['discountPercent'] as int? ?? 0,
  maxDiscountValue: json['maxDiscountValue'] as int? ?? 0,
  storeId: json['storeId'] as String? ?? '',
  system: json['system'] as String? ?? '',
  color:
      json['color'] != null
          ? VoucherColorModel.fromJson(json['color'] as Map<String, dynamic>)
          : null,
);

Map<String, dynamic> _$VoucherDiscountModelToJson(
  VoucherDiscountModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'type': instance.type,
  'startDate': instance.startDate?.toIso8601String(),
  'usageCount': instance.usageCount,
  'usedCount': instance.usedCount,
  'usagePerUser': instance.usagePerUser,
  'minOrderValue': instance.minOrderValue,
  'discountAmount': instance.discountAmount,
  'discountPercent': instance.discountPercent,
  'maxDiscountValue': instance.maxDiscountValue,
  'storeId': instance.storeId,
  'system': instance.system,
  'color': instance.color?.toJson(),
};

VoucherColorModel _$VoucherColorModelFromJson(Map<String, dynamic> json) =>
    VoucherColorModel(
      wild: json['wild'] as String? ?? '',
      medium: json['medium'] as String? ?? '',
    );

Map<String, dynamic> _$VoucherColorModelToJson(VoucherColorModel instance) =>
    <String, dynamic>{'wild': instance.wild, 'medium': instance.medium};
