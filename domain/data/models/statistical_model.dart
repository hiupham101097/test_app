import 'package:json_annotation/json_annotation.dart';
import 'package:merchant/domain/data/models/base_model.dart';

part 'statistical_model.g.dart';

@JsonSerializable(explicitToJson: true)
class StatisticalModel extends BaseModel {
  @JsonKey(name: 'month')
  final String? month;
  @JsonKey(name: 'totalRevenue')
  final int? totalRevenue;
  @JsonKey(name: 'day')
  final String? day;

  StatisticalModel({this.month, this.totalRevenue, this.day});

  factory StatisticalModel.fromJson(Map<String, dynamic> json) =>
      _$StatisticalModelFromJson(json);

  Map<String, dynamic> toJson() => _$StatisticalModelToJson(this);
}
