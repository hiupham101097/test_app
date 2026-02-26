// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_distribution_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatingDistributionModel _$RatingDistributionModelFromJson(
        Map<String, dynamic> json) =>
    RatingDistributionModel(
      rating1: (json['1'] as num?)?.toInt() ?? 0,
      rating2: (json['2'] as num?)?.toInt() ?? 0,
      rating3: (json['3'] as num?)?.toInt() ?? 0,
      rating4: (json['4'] as num?)?.toInt() ?? 0,
      rating5: (json['5'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$RatingDistributionModelToJson(
        RatingDistributionModel instance) =>
    <String, dynamic>{
      '1': instance.rating1,
      '2': instance.rating2,
      '3': instance.rating3,
      '4': instance.rating4,
      '5': instance.rating5,
    };
