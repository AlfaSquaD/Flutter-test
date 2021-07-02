import 'package:practice/models/daily_data.dart';
import 'package:practice/models/food.dart';

abstract class FoodTrackingI {
  FoodTrackingI? instance;
  DailyData? currentSummary;
  DailyData? getCurrentSummary();
  void addFoodToCurrentSummary(Food food, MealMeasure measure, double amount);

  // Singleton
  Future<void> createInstance();
  FoodTrackingI? getInstance();
}
