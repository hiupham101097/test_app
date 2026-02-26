import 'package:json_annotation/json_annotation.dart';

part 'revenue_stats_model.g.dart';

@JsonSerializable(explicitToJson: true)
class RevenueStatsModel {
  @JsonKey(name: 'totalRevenue', defaultValue: 0)
  final int totalRevenue;

  @JsonKey(name: 'totalOrders', defaultValue: 0)
  final int totalOrders;

  @JsonKey(name: 'successOrders', defaultValue: 0)
  final int successOrders;

  @JsonKey(name: 'failedOrders', defaultValue: 0)
  final int failedOrders;

  RevenueStatsModel({
    this.totalRevenue = 0,
    this.totalOrders = 0,
    this.successOrders = 0,
    this.failedOrders = 0,
  });

  factory RevenueStatsModel.fromJson(Map<String, dynamic> json) =>
      _$RevenueStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$RevenueStatsModelToJson(this);

  @override
  String toString() {
    return 'RevenueStatsModel(totalRevenue: $totalRevenue, totalOrders: $totalOrders, successOrders: $successOrders, failedOrders: $failedOrders)';
  }
}



