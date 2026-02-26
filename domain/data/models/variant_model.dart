import 'package:json_annotation/json_annotation.dart';

part 'variant_model.g.dart';

@JsonSerializable(explicitToJson: true)
class VariantModel {
  @JsonKey(name: 'title', defaultValue: '')
  final String title;

  @JsonKey(name: 'price', defaultValue: 0)
  final double price;

  VariantModel({required this.title, required this.price});

  factory VariantModel.fromJson(Map<String, dynamic> json) =>
      _$VariantModelFromJson(json);

  Map<String, dynamic> toJson() => _$VariantModelToJson(this);

  @override
  String toString() {
    return 'VariantModel(title: $title, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VariantModel &&
        other.title == title &&
        other.price == price;
  }

  @override
  int get hashCode => title.hashCode ^ price.hashCode;
}
