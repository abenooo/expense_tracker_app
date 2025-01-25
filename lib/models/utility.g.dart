// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'utility.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UtilityAdapter extends TypeAdapter<Utility> {
  @override
  final int typeId = 1;

  @override
  Utility read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Utility(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      startDate: fields[3] as DateTime,
      endDate: fields[4] as DateTime,
      amount: fields[5] as double,
      iconName: fields[7] as String,
      logoPath: fields[8] as String,
      isPaid: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Utility obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.startDate)
      ..writeByte(4)
      ..write(obj.endDate)
      ..writeByte(5)
      ..write(obj.amount)
      ..writeByte(6)
      ..write(obj.isPaid)
      ..writeByte(7)
      ..write(obj.iconName)
      ..writeByte(8)
      ..write(obj.logoPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UtilityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
