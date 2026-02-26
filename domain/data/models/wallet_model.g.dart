// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WalletModelAdapter extends TypeAdapter<WalletModel> {
  @override
  final int typeId = 4;

  @override
  WalletModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WalletModel(
      walletId: fields[0] as String?,
      fullName: fields[1] as String?,
      email: fields[2] as String?,
      phoneNumber: fields[3] as String?,
      status: fields[4] as String?,
      realBalance: fields[5] as double?,
      pendingBalance: fields[6] as double?,
      withdrawableBalance: fields[7] as double?,
      bonusBalance: fields[8] as double?,
      createdFromSystem: fields[9] as String?,
      bankList: (fields[10] as List?)?.cast<WalletBankModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, WalletModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.walletId)
      ..writeByte(1)
      ..write(obj.fullName)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.phoneNumber)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.realBalance)
      ..writeByte(6)
      ..write(obj.pendingBalance)
      ..writeByte(7)
      ..write(obj.withdrawableBalance)
      ..writeByte(8)
      ..write(obj.bonusBalance)
      ..writeByte(9)
      ..write(obj.createdFromSystem)
      ..writeByte(10)
      ..write(obj.bankList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletModel _$WalletModelFromJson(Map<String, dynamic> json) => WalletModel(
      walletId: json['walletId'] as String?,
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      status: json['status'] as String?,
      realBalance: (json['realBalance'] as num?)?.toDouble(),
      pendingBalance: (json['pendingBalance'] as num?)?.toDouble(),
      withdrawableBalance: (json['withdrawableBalance'] as num?)?.toDouble(),
      bonusBalance: (json['bonusBalance'] as num?)?.toDouble(),
      createdFromSystem: json['createdFromSystem'] as String?,
      bankList: (json['bankList'] as List<dynamic>?)
          ?.map((e) => WalletBankModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WalletModelToJson(WalletModel instance) =>
    <String, dynamic>{
      'walletId': instance.walletId,
      'fullName': instance.fullName,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'status': instance.status,
      'realBalance': instance.realBalance,
      'pendingBalance': instance.pendingBalance,
      'withdrawableBalance': instance.withdrawableBalance,
      'bonusBalance': instance.bonusBalance,
      'createdFromSystem': instance.createdFromSystem,
      'bankList': instance.bankList?.map((e) => e.toJson()).toList(),
    };
