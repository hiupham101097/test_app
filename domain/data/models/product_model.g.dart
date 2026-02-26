// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      title: json['title'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      price: (json['price'] as num?)?.toInt() ?? 0,
      productExtend: json['product_extend'] as String? ?? '',
      priceSale: (json['priceSale'] as num?)?.toInt() ?? 0,
      sale: (json['sale'] as num?)?.toInt() ?? 0,
      sold: (json['sold'] as num?)?.toInt() ?? 0,
      organizationId: (json['organizationId'] as num?)?.toInt() ?? 0,
      tenantId: (json['tenantId'] as num?)?.toInt() ?? 0,
      unit: json['unit'] as String? ?? '',
      availability: json['availability'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['review_count'] as num?)?.toInt() ?? 0,
      metaTitle: json['meta_title'] as String? ?? '',
      metaKeywords: json['meta_keywords'] as String? ?? '',
      metaDescription: json['meta_description'] as String? ?? '',
      metaSlug: json['meta_slug'] as String? ?? '',
      affiliateLinks: json['affiliateLinks'] as String? ?? '',
      userUpdate: json['userUpdate'] as String? ?? '',
      createDate: json['createDate'] as String? ?? '',
      isTrending: json['isTrending'] as String? ?? '',
      updateDate: json['updateDate'] as String? ?? '',
      isDeleted: json['isDeleted'] as bool? ?? false,
      status: json['status'] as String? ?? '',
      categoryId: json['categoryId'] as String? ?? '',
      storeId: json['storeId'] as String? ?? '',
      number1: (json['number1'] as num?)?.toInt() ?? 0,
      number2: (json['number2'] as num?)?.toInt() ?? 0,
      number3: (json['number3'] as num?)?.toInt() ?? 0,
      bool1: json['bool1'] as bool? ?? false,
      bool2: json['bool2'] as bool? ?? false,
      bool3: json['bool3'] as bool? ?? false,
      v: (json['__v'] as num?)?.toInt() ?? 0,
      store: json['store'] == null
          ? null
          : StoreModel.fromJson(json['store'] as Map<String, dynamic>),
      category: json['category'] == null
          ? null
          : CategoryModel.fromJson(json['category'] as Map<String, dynamic>),
      productOptionFood: (json['productoptionfood'] as List<dynamic>?)
              ?.map(
                  (e) => OptionProductModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      imageUrlMap: json['image_url_map'] as String? ?? '',
      uniformCost: (json['uniformCost'] as num?)?.toInt() ?? 0,
      quantityPromotion: (json['quantity_promotion'] as num?)?.toInt() ?? 0,
      sellPromotion: (json['sell_promotion'] as num?)?.toInt() ?? 0,
      keyPromotion: json['keyPromotion'] as String? ?? '',
      variants: (json['variants'] as List<dynamic>?)
              ?.map((e) => VariantModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'title': instance.title,
      'slug': instance.slug,
      'description': instance.description,
      'image_url': instance.imageUrl,
      'price': instance.price,
      'product_extend': instance.productExtend,
      'priceSale': instance.priceSale,
      'sale': instance.sale,
      'sold': instance.sold,
      'organizationId': instance.organizationId,
      'tenantId': instance.tenantId,
      'unit': instance.unit,
      'availability': instance.availability,
      'rating': instance.rating,
      'review_count': instance.reviewCount,
      'meta_title': instance.metaTitle,
      'meta_keywords': instance.metaKeywords,
      'meta_description': instance.metaDescription,
      'meta_slug': instance.metaSlug,
      'affiliateLinks': instance.affiliateLinks,
      'userUpdate': instance.userUpdate,
      'createDate': instance.createDate,
      'isTrending': instance.isTrending,
      'updateDate': instance.updateDate,
      'isDeleted': instance.isDeleted,
      'status': instance.status,
      'categoryId': instance.categoryId,
      'storeId': instance.storeId,
      'number1': instance.number1,
      'number2': instance.number2,
      'number3': instance.number3,
      'bool1': instance.bool1,
      'bool2': instance.bool2,
      'bool3': instance.bool3,
      '__v': instance.v,
      'store': instance.store?.toJson(),
      'category': instance.category?.toJson(),
      'productoptionfood':
          instance.productOptionFood.map((e) => e.toJson()).toList(),
      'image_url_map': instance.imageUrlMap,
      'uniformCost': instance.uniformCost,
      'quantity_promotion': instance.quantityPromotion,
      'sell_promotion': instance.sellPromotion,
      'keyPromotion': instance.keyPromotion,
      'variants': instance.variants.map((e) => e.toJson()).toList(),
    };
