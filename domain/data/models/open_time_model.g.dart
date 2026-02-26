// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_time_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OpenTimeModelAdapter extends TypeAdapter<OpenTimeModel> {
  @override
  final int typeId = 6;

  @override
  OpenTimeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OpenTimeModel(
      id: fields[0] == null ? '' : fields[0] as String,
      openTime: fields[1] == null ? '' : fields[1] as String,
      closeTime: fields[2] == null ? '' : fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, OpenTimeModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.openTime)
      ..writeByte(2)
      ..write(obj.closeTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OpenTimeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenTimeModel _$OpenTimeModelFromJson(Map<String, dynamic> json) =>
    OpenTimeModel(
      id: json['_id'] as String? ?? '',
      openTime: json['openTime'] as String? ?? '',
      closeTime: json['closeTime'] as String? ?? '',
    );

Map<String, dynamic> _$OpenTimeModelToJson(OpenTimeModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'openTime': instance.openTime,
      'closeTime': instance.closeTime,
    };
