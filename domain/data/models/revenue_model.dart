import 'package:json_annotation/json_annotation.dart';
import 'package:merchant/domain/data/models/revenue_stats_model.dart';

part 'revenue_model.g.dart';

@JsonSerializable(explicitToJson: true)
class RevenueModel {
  @JsonKey(name: 'current')
  final RevenueStatsModel? current;

  @JsonKey(name: 'compare')
  final RevenueCompareModel? compare;

  RevenueModel({this.current, this.compare});

  factory RevenueModel.fromJson(Map<String, dynamic> json) =>
      _$RevenueModelFromJson(json);

  Map<String, dynamic> toJson() => _$RevenueModelToJson(this);

  @override
  String toString() {
    return 'RevenueModel(current: $current, compare: $compare)';
  }
}

@JsonSerializable(explicitToJson: true)
class RevenueCompareModel {
  @JsonKey(name: '_id')
  final String? id;

  @JsonKey(name: 'totalRevenue', defaultValue: 0)
  final int totalRevenue;

  @JsonKey(name: 'totalOrders', defaultValue: 0)
  final int totalOrders;

  @JsonKey(name: 'successOrders', defaultValue: 0)
  final int successOrders;

  @JsonKey(name: 'failedOrders', defaultValue: 0)
  final int failedOrders;

  RevenueCompareModel({
    this.id,
    this.totalRevenue = 0,
    this.totalOrders = 0,
    this.successOrders = 0,
    this.failedOrders = 0,
  });

  factory RevenueCompareModel.fromJson(Map<String, dynamic> json) =>
      _$RevenueCompareModelFromJson(json);

  Map<String, dynamic> toJson() => _$RevenueCompareModelToJson(this);

  @override
  String toString() {
    return 'RevenueCompareModel(id: $id, totalRevenue: $totalRevenue, totalOrders: $totalOrders, successOrders: $successOrders, failedOrders: $failedOrders)';
  }
}
