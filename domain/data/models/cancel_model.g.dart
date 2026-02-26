// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'cancel_model.dart';

// // **************************************************************************
// // JsonSerializableGenerator
// // **************************************************************************

// CancelModel _$CancelModelFromJson(Map<String, dynamic> json) => CancelModel(
//       id: (json['id'] as num?)?.toInt(),
//       name: json['name'] as String?,
//       createdAt: json['createdAt'] == null
//           ? null
//           : DateTime.parse(json['createdAt'] as String),
//       updatedAt: json['updatedAt'] == null
//           ? null
//           : DateTime.parse(json['updatedAt'] as String),
//       deletedAt: json['deletedAt'] == null
//           ? null
//           : DateTime.parse(json['deletedAt'] as String),
//       status: json['status'] as bool? ?? false,
//     );

// Map<String, dynamic> _$CancelModelToJson(CancelModel instance) =>
//     <String, dynamic>{
//       'id': instance.id,
//       'name': instance.name,
//       'status': instance.status,
//       'createdAt': instance.createdAt?.toIso8601String(),
//       'updatedAt': instance.updatedAt?.toIso8601String(),
//       'deletedAt': instance.deletedAt?.toIso8601String(),
//     };
