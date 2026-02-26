import 'package:json_annotation/json_annotation.dart';
import 'evaluation_item_model.dart';
import 'rating_distribution_model.dart';

part 'evaluate_overview_model.g.dart';

@JsonSerializable(explicitToJson: true)
class EvaluateOverviewModel {
  @JsonKey(name: 'listData', defaultValue: [])
  final List<EvaluationItemModel> listData;

  @JsonKey(name: 'total', defaultValue: 0)
  final int total;

  @JsonKey(name: 'averageRating', defaultValue: 0.0)
  final double averageRating;

  @JsonKey(name: 'totalUsersRated', defaultValue: 0)
  final int totalUsersRated;

  @JsonKey(name: 'totalRatingSum', defaultValue: 0)
  final int totalRatingSum;

  @JsonKey(name: 'totalRatingCount', defaultValue: 0)
  final int totalRatingCount;

  @JsonKey(name: 'ratingDistribution')
  final RatingDistributionModel? ratingDistribution;

  const EvaluateOverviewModel({
    this.listData = const [],
    this.total = 0,
    this.averageRating = 0.0,
    this.totalUsersRated = 0,
    this.totalRatingSum = 0,
    this.totalRatingCount = 0,
    this.ratingDistribution,
  });

  factory EvaluateOverviewModel.fromJson(Map<String, dynamic> json) =>
      _$EvaluateOverviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$EvaluateOverviewModelToJson(this);

  String get formattedAverageRating {
    return averageRating.toStringAsFixed(1);
  }

  bool get hasEvaluations => total > 0 && listData.isNotEmpty;

  int getEvaluationCountByStatus(String status) {
    return listData.where((evaluation) => evaluation.status == status).length;
  }

  List<EvaluationItemModel> get visibleEvaluations {
    return listData.where((evaluation) => evaluation.isShow).toList();
  }

  @override
  String toString() {
    return 'EvaluateOverviewModel(listData: ${listData.length} items, total: $total, averageRating: $averageRating, totalUsersRated: $totalUsersRated, totalRatingSum: $totalRatingSum, totalRatingCount: $totalRatingCount, ratingDistribution: $ratingDistribution)';
  }
}
