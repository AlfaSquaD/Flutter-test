import 'package:hive/hive.dart';
import 'package:practice/Utils/date.dart';
import 'package:practice/models/food.dart';
import 'package:practice/models/daily_data.dart';

class HiveDailyData {
  static DailyData? currentSummary;
  static HiveDailyData? instance;
  Box<DailyData> dailyBox;

  void addFoodToCurrentSummary(Food food, MealMeasure measure, double amount) {
    currentSummary!.addFood(food, measure, amount);
  }

  DailyData? getCurrentSummary() {
    if (currentSummary == null) throw UninitializedError();
    return currentSummary;
  }

  HiveDailyData({required this.dailyBox});

  Future<void> setCurrentSummary() async {
    currentSummary = dailyBox.get(Date.getDateString());

    if (currentSummary == null) {
      currentSummary = DailyData(
          date: Date.getDateString(),
          targetKilocalories: 2100,
          targetCarbohydrate: 100,
          targetFat: 100,
          targetProtein: 100); // TODO: These values are placeholders!

      dailyBox.put(Date.getDateString(), currentSummary!);
    }
  }
}

class UninitializedError implements Exception {}
