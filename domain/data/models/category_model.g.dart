// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    CategoryModel(
      mongoId: json['_id'] as String?,
      id: json['id'] as String?,
      name: json['name'] as String?,
      slug: json['slug'] as String?,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      organizationId: (json['organizationId'] as num?)?.toInt(),
      metaTitle: json['meta_title'] as String?,
      metaKeywords: json['meta_keywords'] as String?,
      metaDescription: json['meta_description'] as String?,
      metaSlug: json['meta_slug'] as String?,
      userUpdate: (json['userUpdate'] as num?)?.toInt(),
      isDeleted: json['isDeleted'] as bool?,
      parentId: (json['parentId'] as num?)?.toInt(),
      store:
          json['storeId'] == null
              ? null
              : StoreModel.fromJson(json['storeId'] as Map<String, dynamic>),
      systemCategoryId: (json['systemcategoryId'] as num?)?.toInt(),
      index: (json['index'] as num?)?.toInt(),
      order: (json['order'] as num?)?.toInt(),
      createUser: (json['createUser'] as num?)?.toInt(),
      createDate: json['createDate'] as String?,
      updateDate: json['updateDate'] as String?,
      v: (json['__v'] as num?)?.toInt(),
      system: json['system'] as String?,
    );

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      '_id': instance.mongoId,
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'image_url': instance.imageUrl,
      'organizationId': instance.organizationId,
      'meta_title': instance.metaTitle,
      'meta_keywords': instance.metaKeywords,
      'meta_description': instance.metaDescription,
      'meta_slug': instance.metaSlug,
      'userUpdate': instance.userUpdate,
      'isDeleted': instance.isDeleted,
      'parentId': instance.parentId,
      'storeId': instance.store?.toJson(),
      'systemcategoryId': instance.systemCategoryId,
      'index': instance.index,
      'order': instance.order,
      'createUser': instance.createUser,
      'createDate': instance.createDate,
      'updateDate': instance.updateDate,
      '__v': instance.v,
      'system': instance.system,
    };
