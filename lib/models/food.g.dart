// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FoodAdapter extends TypeAdapter<Food> {
  @override
  final int typeId = 0;

  @override
  Food read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Food(
      id: fields[0] as String,
      name: fields[1] as String,
      kilocalories: fields[2] as double,
      carbohydrate: fields[3] as double,
      fat: fields[4] as double,
      protein: fields[5] as double,
      grams: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Food obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.kilocalories)
      ..writeByte(3)
      ..write(obj.carbohydrate)
      ..writeByte(4)
      ..write(obj.fat)
      ..writeByte(5)
      ..write(obj.protein)
      ..writeByte(6)
      ..write(obj.grams);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
