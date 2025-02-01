// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saving_goal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavingGoalAdapter extends TypeAdapter<SavingGoal> {
  @override
  final int typeId = 2;

  @override
  SavingGoal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavingGoal(
      id: fields[0] as String,
      name: fields[1] as String,
      targetAmount: fields[3] as double,
      currentAmount: fields[4] as double,
      targetDate: fields[5] as DateTime,
      description: fields[2] as String,
      reminderFrequency: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SavingGoal obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.targetAmount)
      ..writeByte(4)
      ..write(obj.currentAmount)
      ..writeByte(5)
      ..write(obj.targetDate)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.reminderFrequency);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavingGoalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
