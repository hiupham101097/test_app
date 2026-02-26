import 'package:json_annotation/json_annotation.dart';
import 'package:merchant/domain/data/models/base_model.dart';

part 'meta_data_model.g.dart';

@JsonSerializable()
class MetaDataModel extends BaseModel {
  @JsonKey(defaultValue: 0)
  final int total;

  MetaDataModel({this.total = 0});

  factory MetaDataModel.fromJson(Map<String, dynamic> json) =>
      _$MetaDataModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MetaDataModelToJson(this);

  @override
  String toString() {
    return 'MetaDataModel(total: $total)';
  }
}
