import 'package:hive/hive.dart';
import 'package:practice/db-interface/foodsI.dart';
import 'package:practice/models/food.dart';

class HiveFoods extends FoodsI {
  static HiveFoods? instance;
  Box<Food> foodBox;
  @override
  Future<void> createInstance() async {
    Box<Food> box = await Hive.openBox("foodBox");
    instance = HiveFoods(foodBox: box);
  }

  @override
  List<Food> getFoods(bool filter(Food el)) {
    return foodBox.values.where(filter).toList();
  }

  @override
  FoodsI? getInstance() {
    if (instance == null) throw UninitializedError();
    return instance;
  }

  HiveFoods({required this.foodBox});
}
