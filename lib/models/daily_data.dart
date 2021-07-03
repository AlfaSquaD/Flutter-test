import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:practice/models/food.dart';

part 'daily_data.g.dart';

@HiveType(typeId: 1)
class DailyData extends HiveObject with ChangeNotifier {
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
  @HiveField(9)
  double totalKilocalories = 0;

  DailyData(
      {required this.date,
      required this.targetKilocalories,
      required this.targetCarbohydrate,
      required this.targetFat,
      required this.targetProtein});

  void addFood(Food food, MealMeasure measure, double amount) {
    switch (measure) {
      case MealMeasure.grams:
        this.totalKilocalories += (food.kilocalories / food.grams) * amount;
        this.totalFat += (food.fat / food.grams) * amount;
        this.totalProtein += (food.protein / food.grams) * amount;
        this.totalCarbohydrate += (food.carbohydrate / food.grams) * amount;
        break;
      case MealMeasure.portion:
        this.totalKilocalories += (food.kilocalories) * amount;
        this.totalFat += (food.fat) * amount;
        this.totalProtein += (food.protein) * amount;
        this.totalCarbohydrate += (food.carbohydrate) * amount;
        break;
      default:
        break;
    }
    this
        .eaten_food
        .add(FoodData(food: food, amount: amount, mealMeasure: measure));
    notifyListeners();
  }
}

enum MealMeasure { grams, portion }

class FoodData {
  Food food;
  double amount;
  MealMeasure mealMeasure;
  FoodData(
      {required this.food, required this.amount, required this.mealMeasure});
}
