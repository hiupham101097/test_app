import 'package:json_annotation/json_annotation.dart';

part 'rating_distribution_model.g.dart';

@JsonSerializable(explicitToJson: true)
class RatingDistributionModel {
  @JsonKey(name: '1', defaultValue: 0)
  final int rating1;

  @JsonKey(name: '2', defaultValue: 0)
  final int rating2;

  @JsonKey(name: '3', defaultValue: 0)
  final int rating3;

  @JsonKey(name: '4', defaultValue: 0)
  final int rating4;

  @JsonKey(name: '5', defaultValue: 0)
  final int rating5;

  const RatingDistributionModel({
    this.rating1 = 0,
    this.rating2 = 0,
    this.rating3 = 0,
    this.rating4 = 0,
    this.rating5 = 0,
  });

  factory RatingDistributionModel.fromJson(Map<String, dynamic> json) =>
      _$RatingDistributionModelFromJson(json);

  Map<String, dynamic> toJson() => _$RatingDistributionModelToJson(this);

  int getRatingCount(int stars) {
    switch (stars) {
      case 1:
        return rating1;
      case 2:
        return rating2;
      case 3:
        return rating3;
      case 4:
        return rating4;
      case 5:
        return rating5;
      default:
        return 0;
    }
  }

  String getTitle(int stars) {
    switch (stars) {
      case 1:
        return "1";
      case 2:
        return "2";
      case 3:
        return "3";
      case 4:
        return "4";
      case 5:
        return "5";
      default:
        return "";
    }
  }

  int get totalRatings => rating1 + rating2 + rating3 + rating4 + rating5;

  double getPercentage(int stars) {
    if (totalRatings == 0) return 0.0;
    return (getRatingCount(stars) / totalRatings) * 100;
  }

  @override
  String toString() {
    return 'RatingDistributionModel(rating1: $rating1, rating2: $rating2, rating3: $rating3, rating4: $rating4, rating5: $rating5)';
  }
}
