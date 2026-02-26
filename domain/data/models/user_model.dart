import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
@JsonSerializable(explicitToJson: true)
class UserModel extends HiveObject {
  @HiveField(0)
  @JsonKey(name: 'id')
  final dynamic id;

  @HiveField(1)
  @JsonKey(name: 'emailAddress', defaultValue: '')
  final String emailAddress;

  @HiveField(2)
  @JsonKey(name: 'privateKey', defaultValue: '')
  final String privateKey;

  @HiveField(3)
  @JsonKey(name: 'isEmloy', defaultValue: false)
  final bool isEmloy;

  @HiveField(4)
  @JsonKey(name: 'userId', defaultValue: '')
  final String userId;

  UserModel({
    this.id,
    this.emailAddress = '',
    this.privateKey = '',
    this.isEmloy = false,
    this.userId = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  String toString() {
    return 'UserModel(id: $id, emailAddress: $emailAddress, privateKey: $privateKey, isEmloy: $isEmloy)';
  }
}
