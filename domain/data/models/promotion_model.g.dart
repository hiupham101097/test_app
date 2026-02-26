// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotion_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PromotionCategoryModel _$PromotionCategoryModelFromJson(
  Map<String, dynamic> json,
) => PromotionCategoryModel(
  id: (json['id'] as num?)?.toInt() ?? 0,
  name: json['name'] as String? ?? '',
  slug: json['slug'] as String? ?? '',
);

Map<String, dynamic> _$PromotionCategoryModelToJson(
  PromotionCategoryModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'slug': instance.slug,
};

PromotionModel _$PromotionModelFromJson(Map<String, dynamic> json) =>
    PromotionModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      description: json['description'] as String? ?? '',
      type: json['type'] as String? ?? '',
      startTime: json['startTime'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
      number1: (json['number1'] as num?)?.toInt() ?? 0,
      promotionCategory:
          json['promotionCategory'] == null
              ? null
              : PromotionCategoryModel.fromJson(
                json['promotionCategory'] as Map<String, dynamic>,
              ),
      isExisted: json['isExisted'] as bool? ?? false,
      existedPromotions: json['existedPromotions'] as List<dynamic>? ?? [],
      imageUrlMap: json['image_url_map'] as String? ?? '',
      products:
          (json['products'] as List<dynamic>?)
              ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      startTime2: json['start_time'] as String? ?? '',
      endTime2: json['end_time'] as String? ?? '',
      system: json['system'] as String? ?? '',
    );

Map<String, dynamic> _$PromotionModelToJson(PromotionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'type': instance.type,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'start_time': instance.startTime2,
      'end_time': instance.endTime2,
      'number1': instance.number1,
      'promotionCategory': instance.promotionCategory?.toJson(),
      'isExisted': instance.isExisted,
      'existedPromotions': instance.existedPromotions,
      'image_url_map': instance.imageUrlMap,
      'products': instance.products.map((e) => e.toJson()).toList(),
      'system': instance.system,
    };
