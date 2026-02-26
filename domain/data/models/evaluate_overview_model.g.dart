// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evaluate_overview_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EvaluateOverviewModel _$EvaluateOverviewModelFromJson(
        Map<String, dynamic> json) =>
    EvaluateOverviewModel(
      listData: (json['listData'] as List<dynamic>?)
              ?.map((e) =>
                  EvaluationItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      total: (json['total'] as num?)?.toInt() ?? 0,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalUsersRated: (json['totalUsersRated'] as num?)?.toInt() ?? 0,
      totalRatingSum: (json['totalRatingSum'] as num?)?.toInt() ?? 0,
      totalRatingCount: (json['totalRatingCount'] as num?)?.toInt() ?? 0,
      ratingDistribution: json['ratingDistribution'] == null
          ? null
          : RatingDistributionModel.fromJson(
              json['ratingDistribution'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EvaluateOverviewModelToJson(
        EvaluateOverviewModel instance) =>
    <String, dynamic>{
      'listData': instance.listData.map((e) => e.toJson()).toList(),
      'total': instance.total,
      'averageRating': instance.averageRating,
      'totalUsersRated': instance.totalUsersRated,
      'totalRatingSum': instance.totalRatingSum,
      'totalRatingCount': instance.totalRatingCount,
      'ratingDistribution': instance.ratingDistribution?.toJson(),
    };
