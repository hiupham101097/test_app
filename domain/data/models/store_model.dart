import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';
import 'package:merchant/domain/data/models/category_sestym_model.dart';
import 'open_time_model.dart';

part 'store_model.g.dart';

@HiveType(typeId: 2)
@JsonSerializable(explicitToJson: true)
class StoreModel extends HiveObject {
  @HiveField(0, defaultValue: '')
  @JsonKey(name: 'id', defaultValue: '')
  final String id;

  @HiveField(1, defaultValue: '')
  @JsonKey(name: 'name', defaultValue: '')
  final String name;

  @HiveField(2, defaultValue: '')
  @JsonKey(name: 'slug', defaultValue: '')
  final String slug;

  @HiveField(3, defaultValue: '')
  @JsonKey(name: 'description', defaultValue: '')
  final String description;

  @HiveField(4, defaultValue: '')
  @JsonKey(name: 'ownerEmail', defaultValue: '')
  final String ownerEmail;

  @HiveField(5, defaultValue: '')
  @JsonKey(name: 'phone', defaultValue: '')
  final String phone;

  @HiveField(6, defaultValue: '')
  @JsonKey(name: 'location', defaultValue: '')
  final String location;

  @HiveField(7, defaultValue: '')
  @JsonKey(name: 'province', defaultValue: '')
  final String province;

  @HiveField(8, defaultValue: '')
  @JsonKey(name: 'district', defaultValue: '')
  final String district;

  @HiveField(9, defaultValue: '')
  @JsonKey(name: 'commune', defaultValue: '')
  final String commune;

  @HiveField(10, defaultValue: '')
  @JsonKey(name: 'status', defaultValue: '')
  final String status;

  @HiveField(11, defaultValue: 0)
  @JsonKey(name: 'minPrice', defaultValue: 0)
  final int minPrice;

  @HiveField(12, defaultValue: 0)
  @JsonKey(name: 'maxPrice', defaultValue: 0)
  final int maxPrice;

  @HiveField(13, defaultValue: '')
  @JsonKey(name: 'image_url', defaultValue: '')
  final String imageUrl;

  @HiveField(14, defaultValue: '')
  @JsonKey(name: 'banner_img', defaultValue: '')
  final String bannerImg;

  @HiveField(15, defaultValue: 0.0)
  @JsonKey(name: 'rating', defaultValue: 0.0)
  final double rating;

  @HiveField(16, defaultValue: '')
  @JsonKey(name: 'openTime', defaultValue: '')
  final String openTime;

  @HiveField(17, defaultValue: '')
  @JsonKey(name: 'closeTime', defaultValue: '')
  final String closeTime;

  @HiveField(18)
  @JsonKey(name: 'distance')
  final double? distance;

  @HiveField(19, defaultValue: 0.0)
  @JsonKey(name: 'lat', defaultValue: 0.0)
  final double lat;

  @HiveField(20, defaultValue: 0.0)
  @JsonKey(name: 'lng', defaultValue: 0.0)
  final double lng;

  @HiveField(21, defaultValue: '')
  @JsonKey(name: 'closeOpenStatus', defaultValue: '')
  final String closeOpenStatus;

  // Extended fields from API response
  @HiveField(22, defaultValue: '')
  @JsonKey(name: '_id', defaultValue: '')
  final String mongoId;

  @HiveField(23, defaultValue: '')
  @JsonKey(name: 'taxCode', defaultValue: '')
  final String taxCode;

  @HiveField(24, defaultValue: '')
  @JsonKey(name: 'businessLicenseNumber', defaultValue: '')
  final String businessLicenseNumber;

  @HiveField(25, defaultValue: 0)
  @JsonKey(name: 'organizationId', defaultValue: 0)
  final int organizationId;

  @HiveField(26, defaultValue: '')
  @JsonKey(name: 'street', defaultValue: '')
  final String street;

  @HiveField(27, defaultValue: 0)
  @JsonKey(name: 'userUpdate', defaultValue: 0)
  final int userUpdate;

  @HiveField(28, defaultValue: false)
  @JsonKey(name: 'isDeleted', defaultValue: false)
  final bool isDeleted;

  @HiveField(29, defaultValue: 0)
  @JsonKey(name: 'parentId', defaultValue: 0)
  final int parentId;

  @HiveField(30, defaultValue: 0)
  @JsonKey(name: 'createUser', defaultValue: 0)
  final int createUser;

  @HiveField(31, defaultValue: '')
  @JsonKey(name: 'menu', defaultValue: '')
  final String menu;

  @HiveField(32, defaultValue: '')
  @JsonKey(name: 'createDate', defaultValue: '')
  final String createDate;

  @HiveField(33, defaultValue: '')
  @JsonKey(name: 'updateDate', defaultValue: '')
  final String updateDate;

  @HiveField(34, defaultValue: 0)
  @JsonKey(name: '__v', defaultValue: 0)
  final int version;

  @HiveField(35, defaultValue: 0)
  @JsonKey(name: 'discountFee', defaultValue: 0)
  final int discountFee;

  @HiveField(36, defaultValue: 0)
  @JsonKey(name: 'taxFee', defaultValue: 0)
  final int taxFee;

  @HiveField(37, defaultValue: 0)
  @JsonKey(name: 'ratingCount', defaultValue: 0)
  final int ratingCount;

  @HiveField(38, defaultValue: 0)
  @JsonKey(name: 'storeWallet', defaultValue: 0)
  final int storeWallet;

  @HiveField(39, defaultValue: [])
  @JsonKey(name: 'openTimes', defaultValue: [])
  final List<OpenTimeModel> openTimes;

  @HiveField(40, defaultValue: [])
  @JsonKey(name: 'openDays', defaultValue: [])
  final List<String> openDays;

  @HiveField(41, defaultValue: '')
  @JsonKey(name: 'image_url_map', defaultValue: '')
  final String imageUrlMap;

  @HiveField(42, defaultValue: [])
  @JsonKey(name: 'systemCategories', defaultValue: [])
  final List<CategorySestymModel> systemCategories;

  @HiveField(43, defaultValue: '')
  @JsonKey(name: 'reasonCancel', defaultValue: '')
  final String reasonCancel;

  @HiveField(44, defaultValue: '')
  @JsonKey(name: 'timeUpdateStatus', defaultValue: '')
  final String timeUpdateStatus;

  @HiveField(45, defaultValue: '')
  @JsonKey(name: 'menu_url_map', defaultValue: '')
  final String menuUrlMap;

  @HiveField(46, defaultValue: [])
  @JsonKey(name: 'business_license_map', defaultValue: [])
  final List<String> businessLicenseMap;

  @HiveField(47, defaultValue: '')
  @JsonKey(name: 'banner_url_map', defaultValue: '')
  final String bannerUrlMap;

  @HiveField(48, defaultValue: '')
  @JsonKey(name: 'system', defaultValue: [])
  final List<String> system;

  StoreModel({
    this.id = '',
    this.name = '',
    this.slug = '',
    this.description = '',
    this.ownerEmail = '',
    this.phone = '',
    this.location = '',
    this.province = '',
    this.district = '',
    this.commune = '',
    this.status = '',
    this.minPrice = 0,
    this.maxPrice = 0,
    this.imageUrl = '',
    this.bannerImg = '',
    this.rating = 0.0,
    this.openTime = '',
    this.closeTime = '',
    this.distance,
    this.lat = 0.0,
    this.lng = 0.0,
    this.closeOpenStatus = '',
    this.mongoId = '',
    this.taxCode = '',
    this.businessLicenseNumber = '',
    this.organizationId = 0,
    this.street = '',
    this.userUpdate = 0,
    this.isDeleted = false,
    this.parentId = 0,
    this.createUser = 0,
    this.menu = '',
    this.createDate = '',
    this.updateDate = '',
    this.version = 0,
    this.discountFee = 0,
    this.taxFee = 0,
    this.ratingCount = 0,
    this.storeWallet = 0,
    List<OpenTimeModel>? openTimes,
    List<String>? openDays,
    this.imageUrlMap = '',
    this.systemCategories = const [],
    this.reasonCancel = '',
    this.timeUpdateStatus = '',
    this.menuUrlMap = '',
    this.businessLicenseMap = const [],
    this.bannerUrlMap = '',
    this.system = const [],
  }) : openTimes = openTimes ?? const [],
       openDays = openDays ?? const [];

  factory StoreModel.fromJson(Map<String, dynamic> json) =>
      _$StoreModelFromJson(json);

  Map<String, dynamic> toJson() => _$StoreModelToJson(this);
}
