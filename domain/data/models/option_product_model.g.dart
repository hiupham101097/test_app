// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'option_product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OptionProductModel _$OptionProductModelFromJson(Map<String, dynamic> json) =>
    OptionProductModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      title: json['title'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      price: (json['price'] as num?)?.toInt() ?? 0,
      priceSale: (json['priceSale'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$OptionProductModelToJson(OptionProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'title': instance.title,
      'slug': instance.slug,
      'description': instance.description,
      'image_url': instance.imageUrl,
      'price': instance.price,
      'priceSale': instance.priceSale,
    };
