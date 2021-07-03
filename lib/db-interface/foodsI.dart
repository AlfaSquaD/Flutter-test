import 'package:hive/hive.dart';
import 'package:practice/models/food.dart';

abstract class FoodsI {
  List<Food> getFoods(bool filter(Food el));
  Future<void> createInstance();
}

class UninitializedError implements Exception {
  UninitializedError();
}
