import 'package:json_annotation/json_annotation.dart';

part 'option_product_model.g.dart';

@JsonSerializable(explicitToJson: true)
class OptionProductModel {
  @JsonKey(name: 'id', defaultValue: '')
  final String id;

  @JsonKey(name: 'name', defaultValue: '')
  final String name;

  @JsonKey(name: 'title', defaultValue: '')
  final String title;

  @JsonKey(name: 'slug', defaultValue: '')
  final String slug;

  @JsonKey(name: 'description', defaultValue: '')
  final String description;

  @JsonKey(name: 'image_url', defaultValue: '')
  final String imageUrl;

  @JsonKey(name: 'price', defaultValue: 0)
  final int price;

  @JsonKey(name: 'priceSale', defaultValue: 0)
  final int priceSale;

  const OptionProductModel({
    this.id = '',
    this.name = '',
    this.title = '',
    this.slug = '',
    this.description = '',
    this.imageUrl = '',
    this.price = 0,
    this.priceSale = 0,
  });

  factory OptionProductModel.fromJson(Map<String, dynamic> json) =>
      _$OptionProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$OptionProductModelToJson(this);
}
