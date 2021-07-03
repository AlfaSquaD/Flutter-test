import 'package:hive/hive.dart';
import 'package:practice/models/food.dart';

class HiveFoods {
  static HiveFoods? instance;
  Box<Food> foodBox;
  Future<void> createInstance() async {
    Box<Food> box = await Hive.openBox("foodBox");
    instance = HiveFoods(foodBox: box);
  }

  List<Food> getFoods(bool filter(Food el)) {
    return foodBox.values.where(filter).toList();
  }

  HiveFoods? getInstance() {
    if (instance == null) throw UninitializedError();
    return instance;
  }

  HiveFoods({required this.foodBox});
}

class UninitializedError implements Exception {}
