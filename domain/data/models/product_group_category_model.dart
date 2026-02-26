import 'package:merchant/domain/data/models/product_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:merchant/domain/data/models/base_model.dart';

part 'product_group_category_model.g.dart';

@JsonSerializable()
class ProductGroupCategoryModel extends BaseModel {
  @JsonKey(defaultValue: '')
  final String category;

  @JsonKey(defaultValue: 0)
  final int categoryLength;

  @JsonKey(defaultValue: [])
  final List<ProductModel> products;

  ProductGroupCategoryModel({
    this.category = '',
    this.categoryLength = 0,
    this.products = const [],
  });

  factory ProductGroupCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$ProductGroupCategoryModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProductGroupCategoryModelToJson(this);
}
