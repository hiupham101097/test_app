import 'package:merchant/domain/data/models/base_model.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_sestym_model.g.dart';

@HiveType(typeId: 7)
@JsonSerializable(explicitToJson: true)
class CategorySestymModel extends HiveObject implements BaseModel {
  @HiveField(0)
  @JsonKey(name: 'id')
  final int? id;

  @HiveField(1)
  @JsonKey(name: 'name')
  final String? name;

  @HiveField(2)
  @JsonKey(name: 'slug')
  final String? slug;

  @HiveField(3)
  @JsonKey(name: 'description')
  final String? description;

  @HiveField(4)
  @JsonKey(name: 'organizationId')
  final int? organizationId;

  @HiveField(5)
  @JsonKey(name: 'image_url')
  final String? imageUrl;

  @HiveField(6)
  @JsonKey(name: 'userUpdate')
  final int? userUpdate;

  @HiveField(7)
  @JsonKey(name: 'createDate')
  final String? createDate;

  @HiveField(8)
  @JsonKey(name: 'updateDate')
  final String? updateDate;

  @HiveField(9)
  @JsonKey(name: 'isDeleted')
  final bool? isDeleted;

  @HiveField(10)
  @JsonKey(name: 'parentId')
  final int? parentId;

  @HiveField(11)
  @JsonKey(name: 'index')
  final int? index;

  @HiveField(12)
  @JsonKey(name: 'order')
  final int? order;

  @HiveField(13)
  @JsonKey(name: 'createUser')
  final int? createUser;

  @HiveField(14)
  @JsonKey(name: 'image_url_map')
  final String? imageUrlMap;

  CategorySestymModel({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.organizationId,
    this.imageUrl,
    this.userUpdate,
    this.createDate,
    this.updateDate,
    this.isDeleted,
    this.parentId,
    this.index,
    this.order,
    this.createUser,
    this.imageUrlMap,
  });

  factory CategorySestymModel.fromJson(Map<String, dynamic> json) =>
      _$CategorySestymModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CategorySestymModelToJson(this);

  @override
  String toString() {
    return 'CategorySestymModel(id: $id, name: $name, slug: $slug, description: $description, organizationId: $organizationId, imageUrl: $imageUrl, userUpdate: $userUpdate, createDate: $createDate, updateDate: $updateDate, isDeleted: $isDeleted, parentId: $parentId, index: $index, order: $order, createUser: $createUser, imageUrlMap: $imageUrlMap)';
  }
}
