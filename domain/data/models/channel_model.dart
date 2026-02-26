import 'package:merchant/domain/data/models/base_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'channel_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ChannelModel extends BaseModel {
  @JsonKey(name: 'brandId')
  final String? brandId;

  @JsonKey(name: 'isProduction')
  final bool? isProduction;

  @JsonKey(name: 'accessKey')
  final String? accessKey;

  @JsonKey(name: 'groupCode')
  final String? groupCode;

  @JsonKey(name: 'brandName')
  final String? brandName;

  @JsonKey(name: 'brandCode')
  final String? brandCode;

  @JsonKey(name: 'imagePath')
  final String? imagePath;

  @JsonKey(name: 'discountRate')
  final double? discountRate;

  ChannelModel({
    this.brandId,
    this.isProduction,
    this.accessKey,
    this.groupCode,
    this.brandName,
    this.brandCode,
    this.imagePath,
    this.discountRate,
  });

  factory ChannelModel.fromJson(Map<String, dynamic> json) =>
      _$ChannelModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ChannelModelToJson(this);

  @override
  String toString() {
    return 'ChannelModel(brandId: '
        '$brandId, isProduction: $isProduction, accessKey: $accessKey, groupCode: $groupCode, brandName: $brandName, brandCode: $brandCode, imagePath: $imagePath, discountRate: $discountRate)';
  }
}
