import 'package:practice/models/daily_data.dart';
import 'package:practice/models/food.dart';

abstract class FoodTrackingI {
  FoodTrackingI? instance;
  Object? currentSummary;
  Future<Object> getCurrentSummary();
  Future<bool> addFoodToCurrentSummary(
      Food food, MealMeasure measure, double amount);

  // Singleton
  Future<void> createInstance();
  Future<FoodTrackingI> getInstance();
}
