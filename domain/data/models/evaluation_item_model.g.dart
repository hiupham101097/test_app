// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evaluation_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreModel _$StoreModelFromJson(Map<String, dynamic> json) => StoreModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
    );

Map<String, dynamic> _$StoreModelToJson(StoreModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
    };

EvaluationItemModel _$EvaluationItemModelFromJson(Map<String, dynamic> json) =>
    EvaluationItemModel(
      id: json['_id'] as String? ?? '',
      content: json['content'] as String? ?? '',
      status: json['status'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      storeId: json['storeId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      isShow: json['isShow'] as bool? ?? false,
      userUpdate: (json['userUpdate'] as num?)?.toInt() ?? 0,
      createDate: json['createDate'] as String? ?? '',
      updateDate: json['updateDate'] as String? ?? '',
      isDeleted: json['isDeleted'] as bool? ?? false,
      evaluationId: json['id'] as String? ?? '',
      version: (json['__v'] as num?)?.toInt() ?? 0,
      fullName: json['fullName'] as String? ?? '',
      productId: json['productId'] as String? ?? '',
      orderId: json['orderId'] as String? ?? '',
      feedBack: json['feedBack'] as String? ?? '',
      product: json['product'] == null
          ? null
          : ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      imageUrlMap: json['image_url_map'] as String? ?? '',
    );

Map<String, dynamic> _$EvaluationItemModelToJson(
        EvaluationItemModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'content': instance.content,
      'status': instance.status,
      'rating': instance.rating,
      'storeId': instance.storeId,
      'userId': instance.userId,
      'isShow': instance.isShow,
      'userUpdate': instance.userUpdate,
      'createDate': instance.createDate,
      'updateDate': instance.updateDate,
      'isDeleted': instance.isDeleted,
      'id': instance.evaluationId,
      '__v': instance.version,
      'fullName': instance.fullName,
      'productId': instance.productId,
      'orderId': instance.orderId,
      'feedBack': instance.feedBack,
      'product': instance.product?.toJson(),
      'image_url_map': instance.imageUrlMap,
    };
