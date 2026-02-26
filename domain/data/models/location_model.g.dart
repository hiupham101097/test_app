// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModelLocation _$ModelLocationFromJson(Map<String, dynamic> json) =>
    ModelLocation(
      fullAddress: json['fullAddress'] as String? ?? '',
      location:
          json['location'] == null
              ? null
              : LocationCoordinates.fromJson(
                json['location'] as Map<String, dynamic>,
              ),
      placeId: (json['place_id'] as num?)?.toInt() ?? 0,
      province: json['province'] as String? ?? '',
      district: json['district'] as String? ?? '',
      ward: json['ward'] as String? ?? '',
      street: json['street'] as String? ?? '',
      fullNewAddress: json['fullNewAddress'] as String? ?? '',
    );

Map<String, dynamic> _$ModelLocationToJson(ModelLocation instance) =>
    <String, dynamic>{
      'fullAddress': instance.fullAddress,
      'location': instance.location?.toJson(),
      'place_id': instance.placeId,
      'province': instance.province,
      'district': instance.district,
      'ward': instance.ward,
      'street': instance.street,
      'fullNewAddress': instance.fullNewAddress,
    };

LocationCoordinates _$LocationCoordinatesFromJson(Map<String, dynamic> json) =>
    LocationCoordinates(
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$LocationCoordinatesToJson(
  LocationCoordinates instance,
) => <String, dynamic>{'lat': instance.lat, 'lng': instance.lng};
