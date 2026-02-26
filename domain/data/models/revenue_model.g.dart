// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'revenue_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RevenueModel _$RevenueModelFromJson(Map<String, dynamic> json) => RevenueModel(
      current: json['current'] == null
          ? null
          : RevenueStatsModel.fromJson(json['current'] as Map<String, dynamic>),
      compare: json['compare'] == null
          ? null
          : RevenueCompareModel.fromJson(
              json['compare'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RevenueModelToJson(RevenueModel instance) =>
    <String, dynamic>{
      'current': instance.current?.toJson(),
      'compare': instance.compare?.toJson(),
    };

RevenueCompareModel _$RevenueCompareModelFromJson(Map<String, dynamic> json) =>
    RevenueCompareModel(
      id: json['_id'] as String?,
      totalRevenue: (json['totalRevenue'] as num?)?.toInt() ?? 0,
      totalOrders: (json['totalOrders'] as num?)?.toInt() ?? 0,
      successOrders: (json['successOrders'] as num?)?.toInt() ?? 0,
      failedOrders: (json['failedOrders'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$RevenueCompareModelToJson(
        RevenueCompareModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'totalRevenue': instance.totalRevenue,
      'totalOrders': instance.totalOrders,
      'successOrders': instance.successOrders,
      'failedOrders': instance.failedOrders,
    };
