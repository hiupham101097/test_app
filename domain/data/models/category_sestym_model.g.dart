// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_sestym_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategorySestymModelAdapter extends TypeAdapter<CategorySestymModel> {
  @override
  final int typeId = 7;

  @override
  CategorySestymModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategorySestymModel(
      id: fields[0] as int?,
      name: fields[1] as String?,
      slug: fields[2] as String?,
      description: fields[3] as String?,
      organizationId: fields[4] as int?,
      imageUrl: fields[5] as String?,
      userUpdate: fields[6] as int?,
      createDate: fields[7] as String?,
      updateDate: fields[8] as String?,
      isDeleted: fields[9] as bool?,
      parentId: fields[10] as int?,
      index: fields[11] as int?,
      order: fields[12] as int?,
      createUser: fields[13] as int?,
      imageUrlMap: fields[14] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CategorySestymModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.slug)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.organizationId)
      ..writeByte(5)
      ..write(obj.imageUrl)
      ..writeByte(6)
      ..write(obj.userUpdate)
      ..writeByte(7)
      ..write(obj.createDate)
      ..writeByte(8)
      ..write(obj.updateDate)
      ..writeByte(9)
      ..write(obj.isDeleted)
      ..writeByte(10)
      ..write(obj.parentId)
      ..writeByte(11)
      ..write(obj.index)
      ..writeByte(12)
      ..write(obj.order)
      ..writeByte(13)
      ..write(obj.createUser)
      ..writeByte(14)
      ..write(obj.imageUrlMap);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategorySestymModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategorySestymModel _$CategorySestymModelFromJson(Map<String, dynamic> json) =>
    CategorySestymModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      slug: json['slug'] as String?,
      description: json['description'] as String?,
      organizationId: (json['organizationId'] as num?)?.toInt(),
      imageUrl: json['image_url'] as String?,
      userUpdate: (json['userUpdate'] as num?)?.toInt(),
      createDate: json['createDate'] as String?,
      updateDate: json['updateDate'] as String?,
      isDeleted: json['isDeleted'] as bool?,
      parentId: (json['parentId'] as num?)?.toInt(),
      index: (json['index'] as num?)?.toInt(),
      order: (json['order'] as num?)?.toInt(),
      createUser: (json['createUser'] as num?)?.toInt(),
      imageUrlMap: json['image_url_map'] as String?,
    );

Map<String, dynamic> _$CategorySestymModelToJson(
        CategorySestymModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'organizationId': instance.organizationId,
      'image_url': instance.imageUrl,
      'userUpdate': instance.userUpdate,
      'createDate': instance.createDate,
      'updateDate': instance.updateDate,
      'isDeleted': instance.isDeleted,
      'parentId': instance.parentId,
      'index': instance.index,
      'order': instance.order,
      'createUser': instance.createUser,
      'image_url_map': instance.imageUrlMap,
    };
