import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';
import 'store_model.dart';

part 'category_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CategoryModel {
  @JsonKey(name: '_id')
  final String? mongoId;

  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'slug')
  final String? slug;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'image_url')
  final String? imageUrl;

  @JsonKey(name: 'organizationId')
  final int? organizationId;

  @JsonKey(name: 'meta_title')
  final String? metaTitle;

  @JsonKey(name: 'meta_keywords')
  final String? metaKeywords;

  @JsonKey(name: 'meta_description')
  final String? metaDescription;

  @JsonKey(name: 'meta_slug')
  final String? metaSlug;

  @JsonKey(name: 'userUpdate')
  final int? userUpdate;

  @JsonKey(name: 'isDeleted')
  final bool? isDeleted;

  @JsonKey(name: 'parentId')
  final int? parentId;

  @JsonKey(name: 'storeId')
  final StoreModel? store;

  @JsonKey(name: 'systemcategoryId')
  final int? systemCategoryId;

  @JsonKey(name: 'index')
  final int? index;

  @JsonKey(name: 'order')
  final int? order;

  @JsonKey(name: 'createUser')
  final int? createUser;

  @JsonKey(name: 'createDate')
  final String? createDate;

  @JsonKey(name: 'updateDate')
  final String? updateDate;

  @JsonKey(name: '__v')
  final int? v;

  @JsonKey(name: 'system')
  final String? system;

  CategoryModel({
    this.mongoId,
    this.id,
    this.name,
    this.slug,
    this.description,
    this.imageUrl,
    this.organizationId,
    this.metaTitle,
    this.metaKeywords,
    this.metaDescription,
    this.metaSlug,
    this.userUpdate,
    this.isDeleted,
    this.parentId,
    this.store,
    this.systemCategoryId,
    this.index,
    this.order,
    this.createUser,
    this.createDate,
    this.updateDate,
    this.v,
    this.system,
  });

  final showSubCategory = false.obs;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}
