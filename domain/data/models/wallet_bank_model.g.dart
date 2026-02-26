// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_bank_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WalletBankModelAdapter extends TypeAdapter<WalletBankModel> {
  @override
  final int typeId = 3;

  @override
  WalletBankModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WalletBankModel(
      walletBankId: fields[0] as String?,
      walletId: fields[1] as String?,
      bankId: fields[2] as String?,
      bankName: fields[3] as String?,
      shortName: fields[4] as String?,
      bankImg: fields[5] as String?,
      bankCode: fields[6] as String?,
      accountHolderName: fields[7] as String?,
      cardNumber: fields[8] as String?,
      isLastPayment: fields[9] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, WalletBankModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.walletBankId)
      ..writeByte(1)
      ..write(obj.walletId)
      ..writeByte(2)
      ..write(obj.bankId)
      ..writeByte(3)
      ..write(obj.bankName)
      ..writeByte(4)
      ..write(obj.shortName)
      ..writeByte(5)
      ..write(obj.bankImg)
      ..writeByte(6)
      ..write(obj.bankCode)
      ..writeByte(7)
      ..write(obj.accountHolderName)
      ..writeByte(8)
      ..write(obj.cardNumber)
      ..writeByte(9)
      ..write(obj.isLastPayment);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletBankModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletBankModel _$WalletBankModelFromJson(Map<String, dynamic> json) =>
    WalletBankModel(
      walletBankId: json['walletBankId'] as String?,
      walletId: json['walletId'] as String?,
      bankId: json['bankId'] as String?,
      bankName: json['bankName'] as String?,
      shortName: json['shortName'] as String?,
      bankImg: json['bankImg'] as String?,
      bankCode: json['bankCode'] as String?,
      accountHolderName: json['accountHolderName'] as String?,
      cardNumber: json['cardNumber'] as String?,
      isLastPayment: json['isLastPayment'] as bool?,
    );

Map<String, dynamic> _$WalletBankModelToJson(WalletBankModel instance) =>
    <String, dynamic>{
      'walletBankId': instance.walletBankId,
      'walletId': instance.walletId,
      'bankId': instance.bankId,
      'bankName': instance.bankName,
      'shortName': instance.shortName,
      'bankImg': instance.bankImg,
      'bankCode': instance.bankCode,
      'accountHolderName': instance.accountHolderName,
      'cardNumber': instance.cardNumber,
      'isLastPayment': instance.isLastPayment,
    };
