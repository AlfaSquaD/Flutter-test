import 'package:hive/hive.dart';
import 'package:practice/Utils/date.dart';
import 'package:practice/db-interface/foodsI.dart';
import 'package:practice/models/food.dart';
import 'package:practice/models/daily_data.dart';

class HiveDailyData {
  static DailyData? currentSummary;
  static HiveDailyData? instance;
  LazyBox<DailyData> dailyBox;
  @override
  void addFoodToCurrentSummary(Food food, MealMeasure measure, double amount) {
    switch (measure) {
      case MealMeasure.grams:
        currentSummary!.totalKilocalories +=
            (food.kilocalories / food.grams) * amount;
        currentSummary!.totalFat += (food.fat / food.grams) * amount;
        currentSummary!.totalProtein += (food.protein / food.grams) * amount;
        currentSummary!.totalCarbohydrate +=
            (food.carbohydrate / food.grams) * amount;
        break;
      case MealMeasure.portion:
        currentSummary!.totalKilocalories += (food.kilocalories) * amount;
        currentSummary!.totalFat += (food.fat) * amount;
        currentSummary!.totalProtein += (food.protein) * amount;
        currentSummary!.totalCarbohydrate += (food.carbohydrate) * amount;
        break;
      default:
        break;
    }
    currentSummary!.eaten_food
        .add(FoodData(food: food, amount: amount, mealMeasure: measure));

    currentSummary!.save();
  }

  @override
  DailyData? getCurrentSummary() {
    if (currentSummary == null) throw UninitializedError();
    return currentSummary;
  }

  HiveDailyData({required this.dailyBox});

  @override
  Future<void> setCurrentSummary() async {
    currentSummary = await dailyBox.get(Date.getDateString());
    if (currentSummary == null) {
      currentSummary = DailyData(
          date: Date.getDateString(),
          targetKilocalories: 2100,
          targetCarbohydrate: 100,
          targetFat: 100,
          targetProtein: 100); // TODO: These values are placeholders!

      dailyBox.add(currentSummary!);
    }
  }
}
