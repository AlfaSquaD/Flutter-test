import 'package:hive/hive.dart';

part 'food.g.dart';

@HiveType(typeId: 0)
class Food extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  double kilocalories;
  @HiveField(3)
  double carbohydrate;
  @HiveField(4)
  double fat;
  @HiveField(5)
  double protein;
  @HiveField(6)
  int grams;
  // ctor.
  Food(
      {required this.id,
      required this.name,
      required this.kilocalories,
      required this.carbohydrate,
      required this.fat,
      required this.protein,
      required this.grams});
}
