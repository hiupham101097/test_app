import 'package:merchant/domain/data/models/product_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'evaluation_item_model.g.dart';

@JsonSerializable(explicitToJson: true)
class StoreModel {
  @JsonKey(name: 'id', defaultValue: '')
  final String id;

  @JsonKey(name: 'name', defaultValue: '')
  final String name;

  @JsonKey(name: 'slug', defaultValue: '')
  final String slug;

  const StoreModel({this.id = '', this.name = '', this.slug = ''});

  factory StoreModel.fromJson(Map<String, dynamic> json) =>
      _$StoreModelFromJson(json);

  Map<String, dynamic> toJson() => _$StoreModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class EvaluationItemModel {
  @JsonKey(name: '_id', defaultValue: '')
  final String id;

  @JsonKey(name: 'content', defaultValue: '')
  final String content;

  @JsonKey(name: 'status', defaultValue: '')
  final String status;

  @JsonKey(name: 'rating', defaultValue: 0)
  final double rating;

  @JsonKey(name: 'storeId', defaultValue: '')
  final String storeId;

  @JsonKey(name: 'userId', defaultValue: '')
  final String userId;

  @JsonKey(name: 'isShow', defaultValue: false)
  final bool isShow;

  @JsonKey(name: 'userUpdate', defaultValue: 0)
  final int userUpdate;

  @JsonKey(name: 'createDate', defaultValue: '')
  final String createDate;

  @JsonKey(name: 'updateDate', defaultValue: '')
  final String updateDate;

  @JsonKey(name: 'isDeleted', defaultValue: false)
  final bool isDeleted;

  @JsonKey(name: 'id', defaultValue: '')
  final String evaluationId;

  @JsonKey(name: '__v', defaultValue: 0)
  final int version;

  @JsonKey(name: 'fullName', defaultValue: '')
  final String fullName;

  @JsonKey(name: 'productId', defaultValue: '')
  final String productId;

  @JsonKey(name: 'orderId', defaultValue: '')
  final String orderId;

  @JsonKey(name: 'feedBack', defaultValue: '')
  final String feedBack;

  @JsonKey(name: 'product')
  final ProductModel? product;

  @JsonKey(name: 'image_url_map', defaultValue: '')
  final String imageUrlMap;

  const EvaluationItemModel({
    this.id = '',
    this.content = '',
    this.status = '',
    this.rating = 0,
    this.storeId = '',
    this.userId = '',
    this.isShow = false,
    this.userUpdate = 0,
    this.createDate = '',
    this.updateDate = '',
    this.isDeleted = false,
    this.evaluationId = '',
    this.version = 0,
    this.fullName = '',
    this.productId = '',
    this.orderId = '',
    this.feedBack = '',
    this.product,
    this.imageUrlMap = '',
  });

  factory EvaluationItemModel.fromJson(Map<String, dynamic> json) =>
      _$EvaluationItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$EvaluationItemModelToJson(this);

  @override
  String toString() {
    return 'EvaluationItemModel(id: $id, content: $content, status: $status, rating: $rating, storeId: $storeId, userId: $userId, isShow: $isShow, userUpdate: $userUpdate, createDate: $createDate, updateDate: $updateDate, isDeleted: $isDeleted, evaluationId: $evaluationId, version: $version, fullName: $fullName, productId: $productId, orderId: $orderId, feedBack: $feedBack, product: $product)';
  }
}
