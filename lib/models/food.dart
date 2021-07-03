import 'package:hive/hive.dart';

part 'food.g.dart';

@HiveType(typeId: 0)
class Food extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  double kilocalories;
  @HiveField(3)
  double carbohydrate;
  @HiveField(4)
  double fat;
  @HiveField(5)
  double protein;
  @HiveField(6)
  int grams;
  // ctor.
  Food(
      {required this.id,
      required this.name,
      required this.kilocalories,
      required this.carbohydrate,
      required this.fat,
      required this.protein,
      required this.grams});

  factory Food.fromJson(Map<dynamic, dynamic> json) {
    return Food(
        id: json["index"].toString(),
        name: json["Product_description"],
        kilocalories: json["ENERCC_kcal"]?.toDouble() ?? 0,
        carbohydrate: json["SUGAR_g"]?.toDouble() ?? 0,
        fat: json["FAT_g"]?.toDouble() ?? 0.0,
        protein: json["PROT_g"]?.toDouble() ?? 0.0,
        grams: 100);
  }
}
