// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 1;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as dynamic,
      emailAddress: fields[1] as String,
      privateKey: fields[2] as String,
      isEmloy: fields[3] as bool,
      userId: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.emailAddress)
      ..writeByte(2)
      ..write(obj.privateKey)
      ..writeByte(3)
      ..write(obj.isEmloy)
      ..writeByte(4)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'],
      emailAddress: json['emailAddress'] as String? ?? '',
      privateKey: json['privateKey'] as String? ?? '',
      isEmloy: json['isEmloy'] as bool? ?? false,
      userId: json['userId'] as String? ?? '',
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'emailAddress': instance.emailAddress,
      'privateKey': instance.privateKey,
      'isEmloy': instance.isEmloy,
      'userId': instance.userId,
    };
