// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_group_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductGroupCategoryModel _$ProductGroupCategoryModelFromJson(
        Map<String, dynamic> json) =>
    ProductGroupCategoryModel(
      category: json['category'] as String? ?? '',
      categoryLength: (json['categoryLength'] as num?)?.toInt() ?? 0,
      products: (json['products'] as List<dynamic>?)
              ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$ProductGroupCategoryModelToJson(
        ProductGroupCategoryModel instance) =>
    <String, dynamic>{
      'category': instance.category,
      'categoryLength': instance.categoryLength,
      'products': instance.products,
    };
