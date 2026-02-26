// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'revenue_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RevenueStatsModel _$RevenueStatsModelFromJson(Map<String, dynamic> json) =>
    RevenueStatsModel(
      totalRevenue: (json['totalRevenue'] as num?)?.toInt() ?? 0,
      totalOrders: (json['totalOrders'] as num?)?.toInt() ?? 0,
      successOrders: (json['successOrders'] as num?)?.toInt() ?? 0,
      failedOrders: (json['failedOrders'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$RevenueStatsModelToJson(RevenueStatsModel instance) =>
    <String, dynamic>{
      'totalRevenue': instance.totalRevenue,
      'totalOrders': instance.totalOrders,
      'successOrders': instance.successOrders,
      'failedOrders': instance.failedOrders,
    };
