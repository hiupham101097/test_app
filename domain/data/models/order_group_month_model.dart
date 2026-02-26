import 'package:merchant/domain/data/models/order_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:merchant/domain/data/models/base_model.dart';

part 'order_group_month_model.g.dart';

@JsonSerializable()
class OrderGroupMonthModel extends BaseModel {
  @JsonKey(defaultValue: '')
  final String month;
  @JsonKey(defaultValue: [])
  final List<OrderModel> orders;

  OrderGroupMonthModel({this.month = '', this.orders = const []});

  factory OrderGroupMonthModel.fromJson(Map<String, dynamic> json) =>
      _$OrderGroupMonthModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$OrderGroupMonthModelToJson(this);
}
