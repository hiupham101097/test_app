import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'wallet_user_model.g.dart';

@HiveType(typeId: 5)
@JsonSerializable(explicitToJson: true)
class WalletUserModel extends HiveObject {
  @HiveField(0)
  @JsonKey(name: 'id')
  final int? id;

  @HiveField(1)
  @JsonKey(name: 'emailAddress')
  final String? emailAddress;

  @HiveField(2)
  @JsonKey(name: 'firstName')
  final String? firstName;

  @HiveField(3)
  @JsonKey(name: 'lastName')
  final String? lastName;

  @HiveField(4)
  @JsonKey(name: 'fullName')
  final String? fullName;

  @HiveField(5)
  @JsonKey(name: 'phoneNumber')
  final String? phoneNumber;

  @HiveField(6)
  @JsonKey(name: 'address')
  final String? address;

  @HiveField(7)
  @JsonKey(name: 'points')
  final int? points;

  @HiveField(8)
  @JsonKey(name: 'userId')
  final String? userId;

  @HiveField(9)
  @JsonKey(name: 'wallet')
  final int? wallet;

  WalletUserModel({
    this.id,
    this.emailAddress,
    this.firstName,
    this.lastName,
    this.fullName,
    this.phoneNumber,
    this.address,
    this.points,
    this.userId,
    this.wallet,
  });

  factory WalletUserModel.fromJson(Map<String, dynamic> json) =>
      _$WalletUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$WalletUserModelToJson(this);

  @override
  String toString() {
    return 'WalletUserModel(id: $id, emailAddress: $emailAddress, firstName: $firstName, lastName: $lastName, fullName: $fullName, phoneNumber: $phoneNumber, address: $address, points: $points, userId: $userId, wallet: $wallet)';
  }
}
