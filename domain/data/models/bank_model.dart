import 'package:merchant/domain/data/models/base_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bank_model.g.dart';

@JsonSerializable(explicitToJson: true)
class BankModel extends BaseModel {
  @JsonKey(name: 'bankId')
  final String? bankId;

  @JsonKey(name: 'imagePath')
  final String? imagePath;

  @JsonKey(name: 'bankName')
  final String? bankName;

  @JsonKey(name: 'shortName')
  final String? shortName;

  @JsonKey(name: 'bankCode')
  final String? bankCode;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'isActive')
  final bool? isActive;

  BankModel({
    this.bankId,
    this.imagePath,
    this.bankName,
    this.shortName,
    this.bankCode,
    this.description,
    this.isActive,
  });

  factory BankModel.fromJson(Map<String, dynamic> json) =>
      _$BankModelFromJson(json);

  Map<String, dynamic> toJson() => _$BankModelToJson(this);

  @override
  String toString() {
    return 'BankModel(bankId: '
        '$bankId, imagePath: $imagePath, bankName: $bankName, shortName: $shortName, bankCode: $bankCode, description: $description, isActive: $isActive)';
  }
}
