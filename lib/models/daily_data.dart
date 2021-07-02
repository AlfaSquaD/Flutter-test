import 'package:hive/hive.dart';
import 'package:practice/models/food.dart';

part 'daily_data.g.dart';

@HiveType(typeId: 1)
class DailyData extends HiveObject {
  @HiveField(0)
  String date;
  @HiveField(1)
  double totalCarbohydrate = 0;
  @HiveField(2)
  double totalFat = 0;
  @HiveField(3)
  double totalProtein = 0;
  @HiveField(4)
  int targetKilocalories;
  @HiveField(5)
  int targetCarbohydrate;
  @HiveField(6)
  int targetProtein;
  @HiveField(7)
  int targetFat;
  @HiveField(8)
  List<FoodData> eaten_food = [];

  DailyData(
      {required this.date,
      required this.targetKilocalories,
      required this.targetCarbohydrate,
      required this.targetFat,
      required this.targetProtein});
}

enum MealMeasure { grams, portion }

class FoodData {
  Food food;
  double amount;
  MealMeasure mealMeasure;
  FoodData(
      {required this.food, required this.amount, required this.mealMeasure});
}
