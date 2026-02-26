import 'package:json_annotation/json_annotation.dart';

part 'driver_model.g.dart';

@JsonSerializable(explicitToJson: true)
class DriverModel {
  @JsonKey(name: 'driverId', defaultValue: '')
  final String driverId;

  @JsonKey(name: 'name', defaultValue: '')
  final String name;

  @JsonKey(name: 'phone', defaultValue: '')
  final String phone;

  DriverModel({this.driverId = '', this.name = '', this.phone = ''});

  factory DriverModel.fromJson(Map<String, dynamic> json) =>
      _$DriverModelFromJson(json);

  Map<String, dynamic> toJson() => _$DriverModelToJson(this);

  @override
  String toString() {
    return 'DriverModel(driverId: $driverId, name: $name, phone: $phone)';
  }
}
