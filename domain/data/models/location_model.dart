import 'package:json_annotation/json_annotation.dart';

part 'location_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ModelLocation {
  @JsonKey(name: 'fullAddress', defaultValue: '')
  final String fullAddress;

  @JsonKey(name: 'location')
  final LocationCoordinates? location;

  @JsonKey(name: 'place_id', defaultValue: 0)
  final int placeId;

  @JsonKey(name: 'province', defaultValue: '')
  final String province;

  @JsonKey(name: 'district', defaultValue: '')
  final String district;

  @JsonKey(name: 'ward', defaultValue: '')
  final String ward;

  @JsonKey(name: 'street', defaultValue: '')
  final String street;

  @JsonKey(name: 'fullNewAddress', defaultValue: '')
  final String fullNewAddress;

  ModelLocation({
    this.fullAddress = '',
    this.location,
    this.placeId = 0,
    this.province = '',
    this.district = '',
    this.ward = '',
    this.street = '',
    this.fullNewAddress = '',
  });

  factory ModelLocation.fromJson(Map<String, dynamic> json) =>
      _$ModelLocationFromJson(json);

  Map<String, dynamic> toJson() => _$ModelLocationToJson(this);

  @override
  String toString() {
    return 'ModelLocation(fullAddress: $fullAddress, location: $location, placeId: $placeId, province: $province, district: $district, ward: $ward, street: $street)';
  }
}

@JsonSerializable(explicitToJson: true)
class LocationCoordinates {
  @JsonKey(name: 'lat', defaultValue: 0.0)
  final double lat;

  @JsonKey(name: 'lng', defaultValue: 0.0)
  final double lng;

  LocationCoordinates({this.lat = 0.0, this.lng = 0.0});

  factory LocationCoordinates.fromJson(Map<String, dynamic> json) =>
      _$LocationCoordinatesFromJson(json);

  Map<String, dynamic> toJson() => _$LocationCoordinatesToJson(this);

  @override
  String toString() {
    return 'LocationCoordinates(lat: $lat, lng: $lng)';
  }
}
