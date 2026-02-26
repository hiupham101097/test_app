import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'open_time_model.g.dart';

@HiveType(typeId: 6)
@JsonSerializable(explicitToJson: true)
class OpenTimeModel extends HiveObject {
  @HiveField(0, defaultValue: '')
  @JsonKey(name: '_id', defaultValue: '')
  final String id;

  @HiveField(1, defaultValue: '')
  @JsonKey(name: 'openTime', defaultValue: '')
  final String openTime;

  @HiveField(2, defaultValue: '')
  @JsonKey(name: 'closeTime', defaultValue: '')
  final String closeTime;

  OpenTimeModel({this.id = '', this.openTime = '', this.closeTime = ''});

  factory OpenTimeModel.fromJson(Map<String, dynamic> json) =>
      _$OpenTimeModelFromJson(json);

  Map<String, dynamic> toJson() => _$OpenTimeModelToJson(this);
}
