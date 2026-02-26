// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistical_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatisticalModel _$StatisticalModelFromJson(Map<String, dynamic> json) =>
    StatisticalModel(
      month: json['month'] as String?,
      totalRevenue: (json['totalRevenue'] as num?)?.toInt(),
      day: json['day'] as String?,
    );

Map<String, dynamic> _$StatisticalModelToJson(StatisticalModel instance) =>
    <String, dynamic>{
      'month': instance.month,
      'totalRevenue': instance.totalRevenue,
      'day': instance.day,
    };
