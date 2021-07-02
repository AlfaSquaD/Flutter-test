// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyDataAdapter extends TypeAdapter<DailyData> {
  @override
  final int typeId = 1;

  @override
  DailyData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyData(
      date: fields[0] as String,
      targetKilocalories: fields[4] as int,
      targetCarbohydrate: fields[5] as int,
      targetFat: fields[7] as int,
      targetProtein: fields[6] as int,
    )
      ..totalCarbohydrate = fields[1] as double
      ..totalFat = fields[2] as double
      ..totalProtein = fields[3] as double
      ..eaten_food = (fields[8] as List).cast<FoodData>();
  }

  @override
  void write(BinaryWriter writer, DailyData obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.totalCarbohydrate)
      ..writeByte(2)
      ..write(obj.totalFat)
      ..writeByte(3)
      ..write(obj.totalProtein)
      ..writeByte(4)
      ..write(obj.targetKilocalories)
      ..writeByte(5)
      ..write(obj.targetCarbohydrate)
      ..writeByte(6)
      ..write(obj.targetProtein)
      ..writeByte(7)
      ..write(obj.targetFat)
      ..writeByte(8)
      ..write(obj.eaten_food);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
