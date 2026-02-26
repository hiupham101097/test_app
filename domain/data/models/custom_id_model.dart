import 'package:json_annotation/json_annotation.dart';

part 'custom_id_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CustomIdModel {
  @JsonKey(name: 'mongoId', defaultValue: '')
  final String mongoId;

  @JsonKey(name: 'orderRefundId', defaultValue: '')
  final String orderRefundId;

  const CustomIdModel({this.mongoId = '', this.orderRefundId = ''});

  factory CustomIdModel.fromJson(Map<String, dynamic> json) =>
      _$CustomIdModelFromJson(json);

  Map<String, dynamic> toJson() => _$CustomIdModelToJson(this);
}
