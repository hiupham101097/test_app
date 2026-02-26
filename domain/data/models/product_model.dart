import 'package:merchant/domain/data/models/category_model.dart';
import 'package:merchant/domain/data/models/option_product_model.dart';
import 'package:merchant/domain/data/models/store_model.dart';
import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:merchant/domain/data/models/variant_model.dart';

part 'product_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductModel {
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

  @JsonKey(name: 'product_extend', defaultValue: '')
  final String productExtend;

  @JsonKey(name: 'priceSale', defaultValue: 0)
  final int priceSale;

  @JsonKey(name: 'sale', defaultValue: 0)
  final int sale;

  @JsonKey(name: 'sold', defaultValue: 0)
  final int sold;

  @JsonKey(name: 'organizationId', defaultValue: 0)
  final int organizationId;

  @JsonKey(name: 'tenantId', defaultValue: 0)
  final int tenantId;

  @JsonKey(name: 'unit', defaultValue: '')
  final String unit;

  @JsonKey(name: 'availability', defaultValue: false)
  final bool availability;

  @JsonKey(name: 'rating', defaultValue: 0.0)
  final double rating;

  @JsonKey(name: 'review_count', defaultValue: 0)
  final int reviewCount;

  @JsonKey(name: 'meta_title', defaultValue: '')
  final String metaTitle;

  @JsonKey(name: 'meta_keywords', defaultValue: '')
  final String metaKeywords;

  @JsonKey(name: 'meta_description', defaultValue: '')
  final String metaDescription;

  @JsonKey(name: 'meta_slug', defaultValue: '')
  final String metaSlug;

  @JsonKey(name: 'affiliateLinks', defaultValue: '')
  final String affiliateLinks;

  @JsonKey(name: 'userUpdate', defaultValue: '')
  final String userUpdate;

  @JsonKey(name: 'createDate', defaultValue: '')
  final String createDate;

  @JsonKey(name: 'isTrending', defaultValue: '')
  final String isTrending;

  @JsonKey(name: 'updateDate', defaultValue: '')
  final String updateDate;

  @JsonKey(name: 'isDeleted', defaultValue: false)
  final bool isDeleted;

  @JsonKey(name: 'status', defaultValue: '')
  final String status;

  @JsonKey(name: 'categoryId', defaultValue: '')
  final String categoryId;

  @JsonKey(name: 'storeId', defaultValue: '')
  final String storeId;

  @JsonKey(name: 'number1', defaultValue: 0)
  final int number1;

  @JsonKey(name: 'number2', defaultValue: 0)
  final int number2;

  @JsonKey(name: 'number3', defaultValue: 0)
  final int number3;

  @JsonKey(name: 'bool1', defaultValue: false)
  final bool bool1;

  @JsonKey(name: 'bool2', defaultValue: false)
  final bool bool2;

  @JsonKey(name: 'bool3', defaultValue: false)
  final bool bool3;

  @JsonKey(name: '__v', defaultValue: 0)
  final int v;

  @JsonKey(name: 'store')
  final StoreModel? store;

  @JsonKey(name: 'category')
  final CategoryModel? category;

  @JsonKey(name: 'productoptionfood', defaultValue: <OptionProductModel>[])
  final List<OptionProductModel> productOptionFood;

  @JsonKey(name: 'image_url_map', defaultValue: '')
  final String imageUrlMap;

  @JsonKey(name: 'uniformCost', defaultValue: 0)
  final int uniformCost;

  @JsonKey(name: 'quantity_promotion', defaultValue: 0)
  final int quantityPromotion;

  @JsonKey(name: 'sell_promotion', defaultValue: 0)
  final int sellPromotion;

  @JsonKey(name: 'keyPromotion', defaultValue: '')
  final String keyPromotion;

  @JsonKey(name: 'variants', defaultValue: <VariantModel>[])
  final List<VariantModel> variants;

  final selected = false.obs;
  final quantity = 0.obs;
  final priceSalePromotion = 0.obs;

  ProductModel({
    this.id = '',
    this.name = '',
    this.title = '',
    this.slug = '',
    this.description = '',
    this.imageUrl = '',
    this.price = 0,
    this.productExtend = '',
    this.priceSale = 0,
    this.sale = 0,
    this.sold = 0,
    this.organizationId = 0,
    this.tenantId = 0,
    this.unit = '',
    this.availability = false,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.metaTitle = '',
    this.metaKeywords = '',
    this.metaDescription = '',
    this.metaSlug = '',
    this.affiliateLinks = '',
    this.userUpdate = '',
    this.createDate = '',
    this.isTrending = '',
    this.updateDate = '',
    this.isDeleted = false,
    this.status = '',
    this.categoryId = '',
    this.storeId = '',
    this.number1 = 0,
    this.number2 = 0,
    this.number3 = 0,
    this.bool1 = false,
    this.bool2 = false,
    this.bool3 = false,
    this.v = 0,
    this.store,
    this.category,
    this.productOptionFood = const [],
    this.imageUrlMap = '',
    this.uniformCost = 0,
    this.quantityPromotion = 0,
    this.sellPromotion = 0,
    this.keyPromotion = '',
    this.variants = const [],
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, price: $price, status: $status)';
  }
}
