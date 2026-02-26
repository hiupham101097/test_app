import 'package:merchant/domain/data/models/product_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'promotion_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PromotionCategoryModel {
  @JsonKey(name: 'id', defaultValue: 0)
  final int id;

  @JsonKey(name: 'name', defaultValue: '')
  final String name;

  @JsonKey(name: 'slug', defaultValue: '')
  final String slug;

  const PromotionCategoryModel({this.id = 0, this.name = '', this.slug = ''});

  factory PromotionCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$PromotionCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$PromotionCategoryModelToJson(this);

  @override
  String toString() {
    return 'PromotionCategoryModel(id: ' +
        id.toString() +
        ', name: ' +
        name +
        ', slug: ' +
        slug +
        ')';
  }
}

@JsonSerializable(explicitToJson: true)
class PromotionModel {
  @JsonKey(name: 'id', defaultValue: 0)
  final int id;

  @JsonKey(name: 'name', defaultValue: '')
  final String name;

  @JsonKey(name: 'slug', defaultValue: '')
  final String slug;

  @JsonKey(name: 'description', defaultValue: '')
  final String description;

  @JsonKey(name: 'type', defaultValue: '')
  final String type;

  @JsonKey(name: 'startTime', defaultValue: '')
  final String startTime;

  @JsonKey(name: 'endTime', defaultValue: '')
  final String endTime;

  @JsonKey(name: 'start_time', defaultValue: '')
  final String startTime2;

  @JsonKey(name: 'end_time', defaultValue: '')
  final String endTime2;

  @JsonKey(name: 'number1', defaultValue: 0)
  final int number1;

  @JsonKey(name: 'promotionCategory')
  final PromotionCategoryModel? promotionCategory;

  @JsonKey(name: 'isExisted', defaultValue: false)
  final bool isExisted;

  @JsonKey(name: 'existedPromotions', defaultValue: [])
  final List<dynamic> existedPromotions;

  @JsonKey(name: 'image_url_map', defaultValue: '')
  final String imageUrlMap;

  @JsonKey(name: 'products', defaultValue: [])
  final List<ProductModel> products;
  @JsonKey(name: 'system', defaultValue: '')
  final String system;

  const PromotionModel({
    this.id = 0,
    this.name = '',
    this.slug = '',
    this.description = '',
    this.type = '',
    this.startTime = '',
    this.endTime = '',
    this.number1 = 0,
    this.promotionCategory,
    this.isExisted = false,
    this.existedPromotions = const [],
    this.imageUrlMap = '',
    this.products = const [],
    this.startTime2 = '',
    this.endTime2 = '',
    this.system = '',
  });

  factory PromotionModel.fromJson(Map<String, dynamic> json) =>
      _$PromotionModelFromJson(json);

  Map<String, dynamic> toJson() => _$PromotionModelToJson(this);

  bool get isActive {
    if (startTime.isEmpty || endTime.isEmpty) return false;
    try {
      final now = DateTime.now().toUtc();
      final start = DateTime.parse(startTime);
      final end = DateTime.parse(endTime);
      return now.isAfter(start) && now.isBefore(end);
    } catch (_) {
      return false;
    }
  }

  @override
  String toString() {
    return 'PromotionModel(id: ' +
        id.toString() +
        ', name: ' +
        name +
        ', slug: ' +
        slug +
        ', description: ' +
        description +
        ', type: ' +
        type +
        ', startTime: ' +
        startTime +
        ', endTime: ' +
        endTime +
        ', number1: ' +
        number1.toString() +
        ', promotionCategory: ' +
        promotionCategory.toString() +
        ', isExisted: ' +
        isExisted.toString() +
        ', existedPromotions: ' +
        existedPromotions.length.toString() +
        ')';
  }
}
