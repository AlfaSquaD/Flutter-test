// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MealMeasureAdapter extends TypeAdapter<MealMeasure> {
  @override
  final int typeId = 3;

  @override
  MealMeasure read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MealMeasure.grams;
      case 1:
        return MealMeasure.portion;
      default:
        return MealMeasure.grams;
    }
  }

  @override
  void write(BinaryWriter writer, MealMeasure obj) {
    switch (obj) {
      case MealMeasure.grams:
        writer.writeByte(0);
        break;
      case MealMeasure.portion:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealMeasureAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
      ..eaten_food = (fields[8] as List).cast<FoodData>()
      ..totalKilocalories = fields[9] as double;
  }

  @override
  void write(BinaryWriter writer, DailyData obj) {
    writer
      ..writeByte(10)
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
      ..write(obj.eaten_food)
      ..writeByte(9)
      ..write(obj.totalKilocalories);
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

class FoodDataAdapter extends TypeAdapter<FoodData> {
  @override
  final int typeId = 2;

  @override
  FoodData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FoodData(
      food: fields[0] as Food,
      amount: fields[1] as double,
      mealMeasure: fields[2] as MealMeasure,
    );
  }

  @override
  void write(BinaryWriter writer, FoodData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.food)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.mealMeasure);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
