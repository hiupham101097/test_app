// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WalletUserModelAdapter extends TypeAdapter<WalletUserModel> {
  @override
  final int typeId = 5;

  @override
  WalletUserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WalletUserModel(
      id: fields[0] as int?,
      emailAddress: fields[1] as String?,
      firstName: fields[2] as String?,
      lastName: fields[3] as String?,
      fullName: fields[4] as String?,
      phoneNumber: fields[5] as String?,
      address: fields[6] as String?,
      points: fields[7] as int?,
      userId: fields[8] as String?,
      wallet: fields[9] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, WalletUserModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.emailAddress)
      ..writeByte(2)
      ..write(obj.firstName)
      ..writeByte(3)
      ..write(obj.lastName)
      ..writeByte(4)
      ..write(obj.fullName)
      ..writeByte(5)
      ..write(obj.phoneNumber)
      ..writeByte(6)
      ..write(obj.address)
      ..writeByte(7)
      ..write(obj.points)
      ..writeByte(8)
      ..write(obj.userId)
      ..writeByte(9)
      ..write(obj.wallet);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletUserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletUserModel _$WalletUserModelFromJson(Map<String, dynamic> json) =>
    WalletUserModel(
      id: (json['id'] as num?)?.toInt(),
      emailAddress: json['emailAddress'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      fullName: json['fullName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      address: json['address'] as String?,
      points: (json['points'] as num?)?.toInt(),
      userId: json['userId'] as String?,
      wallet: (json['wallet'] as num?)?.toInt(),
    );

Map<String, dynamic> _$WalletUserModelToJson(WalletUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'emailAddress': instance.emailAddress,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'fullName': instance.fullName,
      'phoneNumber': instance.phoneNumber,
      'address': instance.address,
      'points': instance.points,
      'userId': instance.userId,
      'wallet': instance.wallet,
    };
