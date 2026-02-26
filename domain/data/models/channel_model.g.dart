// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelModel _$ChannelModelFromJson(Map<String, dynamic> json) => ChannelModel(
      brandId: json['brandId'] as String?,
      isProduction: json['isProduction'] as bool?,
      accessKey: json['accessKey'] as String?,
      groupCode: json['groupCode'] as String?,
      brandName: json['brandName'] as String?,
      brandCode: json['brandCode'] as String?,
      imagePath: json['imagePath'] as String?,
      discountRate: (json['discountRate'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ChannelModelToJson(ChannelModel instance) =>
    <String, dynamic>{
      'brandId': instance.brandId,
      'isProduction': instance.isProduction,
      'accessKey': instance.accessKey,
      'groupCode': instance.groupCode,
      'brandName': instance.brandName,
      'brandCode': instance.brandCode,
      'imagePath': instance.imagePath,
      'discountRate': instance.discountRate,
    };
