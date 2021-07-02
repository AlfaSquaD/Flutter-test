import 'package:hive/hive.dart';
import 'package:practice/models/food.dart';

abstract class FoodsI {
  FoodsI? instance;
  List<Food> getFoods(bool filter(Food el));
  FoodsI? getInstance();
  Future<void> createInstance();
}

class UninitializedError implements Exception {
  UninitializedError();
}
