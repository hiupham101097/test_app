// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StoreModelAdapter extends TypeAdapter<StoreModel> {
  @override
  final int typeId = 2;

  @override
  StoreModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StoreModel(
      id: fields[0] == null ? '' : fields[0] as String,
      name: fields[1] == null ? '' : fields[1] as String,
      slug: fields[2] == null ? '' : fields[2] as String,
      description: fields[3] == null ? '' : fields[3] as String,
      ownerEmail: fields[4] == null ? '' : fields[4] as String,
      phone: fields[5] == null ? '' : fields[5] as String,
      location: fields[6] == null ? '' : fields[6] as String,
      province: fields[7] == null ? '' : fields[7] as String,
      district: fields[8] == null ? '' : fields[8] as String,
      commune: fields[9] == null ? '' : fields[9] as String,
      status: fields[10] == null ? '' : fields[10] as String,
      minPrice: fields[11] == null ? 0 : fields[11] as int,
      maxPrice: fields[12] == null ? 0 : fields[12] as int,
      imageUrl: fields[13] == null ? '' : fields[13] as String,
      bannerImg: fields[14] == null ? '' : fields[14] as String,
      rating: fields[15] == null ? 0.0 : fields[15] as double,
      openTime: fields[16] == null ? '' : fields[16] as String,
      closeTime: fields[17] == null ? '' : fields[17] as String,
      distance: fields[18] as double?,
      lat: fields[19] == null ? 0.0 : fields[19] as double,
      lng: fields[20] == null ? 0.0 : fields[20] as double,
      closeOpenStatus: fields[21] == null ? '' : fields[21] as String,
      mongoId: fields[22] == null ? '' : fields[22] as String,
      taxCode: fields[23] == null ? '' : fields[23] as String,
      businessLicenseNumber: fields[24] == null ? '' : fields[24] as String,
      organizationId: fields[25] == null ? 0 : fields[25] as int,
      street: fields[26] == null ? '' : fields[26] as String,
      userUpdate: fields[27] == null ? 0 : fields[27] as int,
      isDeleted: fields[28] == null ? false : fields[28] as bool,
      parentId: fields[29] == null ? 0 : fields[29] as int,
      createUser: fields[30] == null ? 0 : fields[30] as int,
      menu: fields[31] == null ? '' : fields[31] as String,
      createDate: fields[32] == null ? '' : fields[32] as String,
      updateDate: fields[33] == null ? '' : fields[33] as String,
      version: fields[34] == null ? 0 : fields[34] as int,
      discountFee: fields[35] == null ? 0 : fields[35] as int,
      taxFee: fields[36] == null ? 0 : fields[36] as int,
      ratingCount: fields[37] == null ? 0 : fields[37] as int,
      storeWallet: fields[38] == null ? 0 : fields[38] as int,
      openTimes:
          fields[39] == null
              ? []
              : (fields[39] as List?)?.cast<OpenTimeModel>(),
      openDays: fields[40] == null ? [] : (fields[40] as List?)?.cast<String>(),
      imageUrlMap: fields[41] == null ? '' : fields[41] as String,
      systemCategories:
          fields[42] == null
              ? []
              : (fields[42] as List).cast<CategorySestymModel>(),
      reasonCancel: fields[43] == null ? '' : fields[43] as String,
      timeUpdateStatus: fields[44] == null ? '' : fields[44] as String,
      menuUrlMap: fields[45] == null ? '' : fields[45] as String,
      businessLicenseMap:
          fields[46] == null ? [] : (fields[46] as List).cast<String>(),
      bannerUrlMap: fields[47] == null ? '' : fields[47] as String,
      system:
          fields[48] == null
              ? []
              : (fields[48] as List?)?.cast<String>().toList() ?? [],
    );
  }

  @override
  void write(BinaryWriter writer, StoreModel obj) {
    writer
      ..writeByte(49)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.slug)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.ownerEmail)
      ..writeByte(5)
      ..write(obj.phone)
      ..writeByte(6)
      ..write(obj.location)
      ..writeByte(7)
      ..write(obj.province)
      ..writeByte(8)
      ..write(obj.district)
      ..writeByte(9)
      ..write(obj.commune)
      ..writeByte(10)
      ..write(obj.status)
      ..writeByte(11)
      ..write(obj.minPrice)
      ..writeByte(12)
      ..write(obj.maxPrice)
      ..writeByte(13)
      ..write(obj.imageUrl)
      ..writeByte(14)
      ..write(obj.bannerImg)
      ..writeByte(15)
      ..write(obj.rating)
      ..writeByte(16)
      ..write(obj.openTime)
      ..writeByte(17)
      ..write(obj.closeTime)
      ..writeByte(18)
      ..write(obj.distance)
      ..writeByte(19)
      ..write(obj.lat)
      ..writeByte(20)
      ..write(obj.lng)
      ..writeByte(21)
      ..write(obj.closeOpenStatus)
      ..writeByte(22)
      ..write(obj.mongoId)
      ..writeByte(23)
      ..write(obj.taxCode)
      ..writeByte(24)
      ..write(obj.businessLicenseNumber)
      ..writeByte(25)
      ..write(obj.organizationId)
      ..writeByte(26)
      ..write(obj.street)
      ..writeByte(27)
      ..write(obj.userUpdate)
      ..writeByte(28)
      ..write(obj.isDeleted)
      ..writeByte(29)
      ..write(obj.parentId)
      ..writeByte(30)
      ..write(obj.createUser)
      ..writeByte(31)
      ..write(obj.menu)
      ..writeByte(32)
      ..write(obj.createDate)
      ..writeByte(33)
      ..write(obj.updateDate)
      ..writeByte(34)
      ..write(obj.version)
      ..writeByte(35)
      ..write(obj.discountFee)
      ..writeByte(36)
      ..write(obj.taxFee)
      ..writeByte(37)
      ..write(obj.ratingCount)
      ..writeByte(38)
      ..write(obj.storeWallet)
      ..writeByte(39)
      ..write(obj.openTimes)
      ..writeByte(40)
      ..write(obj.openDays)
      ..writeByte(41)
      ..write(obj.imageUrlMap)
      ..writeByte(42)
      ..write(obj.systemCategories)
      ..writeByte(43)
      ..write(obj.reasonCancel)
      ..writeByte(44)
      ..write(obj.timeUpdateStatus)
      ..writeByte(45)
      ..write(obj.menuUrlMap)
      ..writeByte(46)
      ..write(obj.businessLicenseMap)
      ..writeByte(47)
      ..write(obj.bannerUrlMap)
      ..writeByte(48)
      ..write(obj.system);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoreModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreModel _$StoreModelFromJson(Map<String, dynamic> json) => StoreModel(
  id: json['id'] as String? ?? '',
  name: json['name'] as String? ?? '',
  slug: json['slug'] as String? ?? '',
  description: json['description'] as String? ?? '',
  ownerEmail: json['ownerEmail'] as String? ?? '',
  phone: json['phone'] as String? ?? '',
  location: json['location'] as String? ?? '',
  province: json['province'] as String? ?? '',
  district: json['district'] as String? ?? '',
  commune: json['commune'] as String? ?? '',
  status: json['status'] as String? ?? '',
  minPrice: (json['minPrice'] as num?)?.toInt() ?? 0,
  maxPrice: (json['maxPrice'] as num?)?.toInt() ?? 0,
  imageUrl: json['image_url'] as String? ?? '',
  bannerImg: json['banner_img'] as String? ?? '',
  rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
  openTime: json['openTime'] as String? ?? '',
  closeTime: json['closeTime'] as String? ?? '',
  distance: (json['distance'] as num?)?.toDouble(),
  lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
  lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
  closeOpenStatus: json['closeOpenStatus'] as String? ?? '',
  mongoId: json['_id'] as String? ?? '',
  taxCode: json['taxCode'] as String? ?? '',
  businessLicenseNumber: json['businessLicenseNumber'] as String? ?? '',
  organizationId: (json['organizationId'] as num?)?.toInt() ?? 0,
  street: json['street'] as String? ?? '',
  userUpdate: (json['userUpdate'] as num?)?.toInt() ?? 0,
  isDeleted: json['isDeleted'] as bool? ?? false,
  parentId: (json['parentId'] as num?)?.toInt() ?? 0,
  createUser: (json['createUser'] as num?)?.toInt() ?? 0,
  menu: json['menu'] as String? ?? '',
  createDate: json['createDate'] as String? ?? '',
  updateDate: json['updateDate'] as String? ?? '',
  version: (json['__v'] as num?)?.toInt() ?? 0,
  discountFee: (json['discountFee'] as num?)?.toInt() ?? 0,
  taxFee: (json['taxFee'] as num?)?.toInt() ?? 0,
  ratingCount: (json['ratingCount'] as num?)?.toInt() ?? 0,
  storeWallet: (json['storeWallet'] as num?)?.toInt() ?? 0,
  openTimes:
      (json['openTimes'] as List<dynamic>?)
          ?.map((e) => OpenTimeModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  openDays:
      (json['openDays'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  imageUrlMap: json['image_url_map'] as String? ?? '',
  systemCategories:
      (json['systemCategories'] as List<dynamic>?)
          ?.map((e) => CategorySestymModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  reasonCancel: json['reasonCancel'] as String? ?? '',
  timeUpdateStatus: json['timeUpdateStatus'] as String? ?? '',
  menuUrlMap: json['menu_url_map'] as String? ?? '',
  businessLicenseMap:
      (json['business_license_map'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  bannerUrlMap: json['banner_url_map'] as String? ?? '',
  system:
      (json['system'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
);

Map<String, dynamic> _$StoreModelToJson(
  StoreModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'slug': instance.slug,
  'description': instance.description,
  'ownerEmail': instance.ownerEmail,
  'phone': instance.phone,
  'location': instance.location,
  'province': instance.province,
  'district': instance.district,
  'commune': instance.commune,
  'status': instance.status,
  'minPrice': instance.minPrice,
  'maxPrice': instance.maxPrice,
  'image_url': instance.imageUrl,
  'banner_img': instance.bannerImg,
  'rating': instance.rating,
  'openTime': instance.openTime,
  'closeTime': instance.closeTime,
  'distance': instance.distance,
  'lat': instance.lat,
  'lng': instance.lng,
  'closeOpenStatus': instance.closeOpenStatus,
  '_id': instance.mongoId,
  'taxCode': instance.taxCode,
  'businessLicenseNumber': instance.businessLicenseNumber,
  'organizationId': instance.organizationId,
  'street': instance.street,
  'userUpdate': instance.userUpdate,
  'isDeleted': instance.isDeleted,
  'parentId': instance.parentId,
  'createUser': instance.createUser,
  'menu': instance.menu,
  'createDate': instance.createDate,
  'updateDate': instance.updateDate,
  '__v': instance.version,
  'discountFee': instance.discountFee,
  'taxFee': instance.taxFee,
  'ratingCount': instance.ratingCount,
  'storeWallet': instance.storeWallet,
  'openTimes': instance.openTimes.map((e) => e.toJson()).toList(),
  'openDays': instance.openDays,
  'image_url_map': instance.imageUrlMap,
  'systemCategories': instance.systemCategories.map((e) => e.toJson()).toList(),
  'reasonCancel': instance.reasonCancel,
  'timeUpdateStatus': instance.timeUpdateStatus,
  'menu_url_map': instance.menuUrlMap,
  'business_license_map': instance.businessLicenseMap,
  'banner_url_map': instance.bannerUrlMap,
  'system': instance.system,
};
