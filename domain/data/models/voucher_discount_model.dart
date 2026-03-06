import 'package:merchant/domain/data/models/base_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'voucher_discount_model.g.dart';

@JsonSerializable(explicitToJson: true)
class VoucherDiscountModel extends BaseModel {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'type')
  final String? type;

  @JsonKey(name: 'startDate')
  final DateTime? startDate;

  @JsonKey(name: 'usageCount')
  final int? usageCount;

  @JsonKey(name: 'usedCount')
  final int? usedCount;

  @JsonKey(name: 'usagePerUser')
  final int? usagePerUser;

  @JsonKey(name: 'minOrderValue')
  final int? minOrderValue;

  @JsonKey(name: 'discountAmount')
  final int? discountAmount;

  @JsonKey(name: 'discountPercent')
  final int? discountPercent;

  @JsonKey(name: 'maxDiscountValue')
  final int? maxDiscountValue;

  @JsonKey(name: 'storeId')
  final String? storeId;

  @JsonKey(name: 'system')
  final String? system;

  @JsonKey(name: 'color')
  final VoucherColorModel? color;

  VoucherDiscountModel({
    this.id,
    this.name,
    this.type,
    this.startDate,
    this.usageCount,
    this.usedCount,
    this.usagePerUser,
    this.minOrderValue,
    this.discountAmount,
    this.discountPercent,
    this.maxDiscountValue,
    this.storeId,
    this.system,
    this.color,
  });

  factory VoucherDiscountModel.fromJson(Map<String, dynamic> json) =>
      _$VoucherDiscountModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$VoucherDiscountModelToJson(this);
}

@JsonSerializable()
class VoucherColorModel {
  @JsonKey(name: 'wild')
  final String? wild;

  @JsonKey(name: 'medium')
  final String? medium;

  VoucherColorModel({
    this.wild,
    this.medium,
  });

  factory VoucherColorModel.fromJson(Map<String, dynamic> json) =>
      _$VoucherColorModelFromJson(json);

  Map<String, dynamic> toJson() => _$VoucherColorModelToJson(this);
}