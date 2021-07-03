import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:practice/db/hiveDailyData.dart';
import 'package:practice/db/hiveFoods.dart';
import 'package:practice/models/daily_data.dart';
import 'package:practice/models/food.dart';
import 'package:practice/widgets/customPercentIndicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Before any other process wait for Flutters' init.
  Directory dir = await getApplicationDocumentsDirectory();
  Hive.registerAdapter(FoodAdapter());
  Hive.registerAdapter(FoodDataAdapter());
  Hive.registerAdapter(DailyDataAdapter());
  Hive.registerAdapter(MealMeasureAdapter());
  Hive.init(dir.path);
  HiveDailyData.instance = HiveDailyData(dailyBox: await Hive.openBox("daily"));
  await HiveDailyData.instance!.setCurrentSummary();
  HiveFoods.instance = HiveFoods(foodBox: await Hive.openBox("foods"));
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  bool _firstInit = sharedPreferences.getBool("firstInit") ?? true;
  if (_firstInit) {
    var data = jsonDecode(await rootBundle.loadString("assets/data.json"));
    data["data"].forEach((el) {
      HiveFoods.instance!.foodBox.add(Food.fromJson(el));
      sharedPreferences.setBool("firstInit", false);
    });
  }
  initializeDateFormatting("tr_TR", null).then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<DailyData?>.value(
        value: HiveDailyData.currentSummary,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              expandedHeight: 300, // TODO: Static value!
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(DateFormat.yMMMMd("tr_TR").format(DateTime.now())),
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer<DailyData?>(
                  builder: (context, value, child) =>
                      CustomCircularPercentageIndicator(
                          targetName: "Kilokalori",
                          target: value!.targetKilocalories,
                          current: value.totalKilocalories.toInt(),
                          normalColor: Colors.green,
                          exceedColor: Colors.red),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer<DailyData?>(
                  builder: (context, value, child) =>
                      CustomCircularPercentageIndicator(
                          targetName: "Karbonhidrat",
                          target: value!.targetCarbohydrate,
                          current: value.totalCarbohydrate.toInt(),
                          normalColor: Colors.green,
                          exceedColor: Colors.red),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer<DailyData?>(
                  builder: (context, value, child) =>
                      CustomCircularPercentageIndicator(
                          targetName: "Protein",
                          target: value!.targetProtein,
                          current: value.totalProtein.toInt(),
                          normalColor: Colors.green,
                          exceedColor: Colors.red),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer<DailyData?>(
                  builder: (context, value, child) =>
                      CustomCircularPercentageIndicator(
                          targetName: "Yağ",
                          target: value!.targetFat,
                          current: value.totalFat.toInt(),
                          normalColor: Colors.green,
                          exceedColor: Colors.red),
                ),
              )
            ])),
            Consumer<DailyData?>(
              builder: (context, value, child) => value!.eaten_food.length != 0
                  ? SliverFixedExtentList(
                      itemExtent: 70.0,
                      delegate: SliverChildListDelegate([
                        for (int i = 0; i < value.eaten_food.length; i++)
                          ListTile(
                            title: Text(value.eaten_food[i].food.name),
                            subtitle: Text(
                                "${value.eaten_food[i].amount} ${MealMeasureToString(value.eaten_food[i].mealMeasure)}"),
                            trailing: IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(25.0))),
                                    builder: (context) => Container(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("Eminmisiniz",
                                                style: const TextStyle(
                                                    fontSize: 20)),
                                          ),
                                          Divider(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextButton(
                                                onPressed: () {
                                                  value.removeFood(i);
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("Sil",
                                                    style: const TextStyle(
                                                        fontSize: 20))),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                          )
                      ]),
                    )
                  : SliverFillRemaining(
                      child: Center(
                        child: Text("Bir şey kaydedilmedi"),
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        child: FittedBox(
          child: Row(
            children: [
              InkWell(
                child: Icon(Icons.add),
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SearchPage())),
              )
            ],
          ),
        ),
        color: Colors.blue,
        height: MediaQuery.of(context).size.height / 17,
      ),
    );
  }
}

class SearchPage extends StatelessWidget {
  SearchPage({Key? key}) : super(key: key);
  final TextEditingController controller = TextEditingController();
  ValueNotifier<List<Food>> foods =
      ValueNotifier(HiveFoods.instance?.getFoods((el) => true) ?? []);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: TextField(
                controller: controller,
                cursorColor: Colors.blueGrey,
                decoration: const InputDecoration(
                  labelText: "Ara",
                ),
                onChanged: (e) => _onTextChanged()),
            centerTitle: true),
        body: ValueListenableBuilder(
          valueListenable: foods,
          builder: (context, value, child) => foods.value.length != 0
              ? ListView.builder(
                  itemBuilder: (context, index) => _builderFunc(context, index),
                  itemCount: foods.value.length,
                )
              : Container(
                  alignment: Alignment.center,
                  child: Text("Nothing Found in database"),
                ),
        ));
  }

  ListTile _builderFunc(BuildContext context, int index) {
    return ListTile(
      title: Text(foods.value[index].name),
      subtitle: Text("${foods.value[index].kilocalories} KCal"),
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        builder: (context) => FoodBottomSheetModal(food: foods.value[index]),
      ),
    );
  }

  void _onTextChanged() {
    foods.value = HiveFoods.instance?.getFoods((el) =>
            el.name.toLowerCase().contains(controller.text.toLowerCase())) ??
        [];
  }
}

class FoodBottomSheetModal extends StatefulWidget {
  final Food food;
  FoodBottomSheetModal({Key? key, required this.food}) : super(key: key);

  @override
  _FoodBottomSheetModalState createState() => _FoodBottomSheetModalState();
}

class _FoodBottomSheetModalState extends State<FoodBottomSheetModal> {
  MealMeasure selected = MealMeasure.portion;
  final TextEditingController controller = TextEditingController(text: "1");
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Adı: ${widget.food.name}",
              style: const TextStyle(fontSize: 30),
            ),
            Text(
              "Kalori: ${widget.food.kilocalories} kcal",
              style: const TextStyle(fontSize: 20),
            ),
            Text("Şeker: ${widget.food.carbohydrate} gr",
                style: const TextStyle(fontSize: 20)),
            Text("Yağ: ${widget.food.fat} gr",
                style: const TextStyle(fontSize: 20)),
            Text("Protein: ${widget.food.protein} gr",
                style: const TextStyle(fontSize: 20)),
            Divider(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Porsiyon"),
                Switch(
                    activeTrackColor: Colors.grey,
                    inactiveTrackColor: Colors.grey,
                    inactiveThumbColor: Colors.blue,
                    value: selected == MealMeasure.grams,
                    onChanged: (value) {
                      setState(() {
                        selected =
                            value ? MealMeasure.grams : MealMeasure.portion;
                      });
                    }),
                Text("Gram")
              ],
            ),
            TextField(
                autofocus: true,
                controller: controller,
                cursorColor: Colors.blueGrey,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Miktar",
                )),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  0, 20, 0, MediaQuery.of(context).viewInsets.bottom),
              child: TextButton(
                child: Text("Ekle", style: const TextStyle(fontSize: 20)),
                onPressed: () {
                  _addFood(widget.food, selected,
                      double.tryParse(controller.text) ?? 0);
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => MyHomePage(),
                      ),
                      (route) => false);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _addFood(Food food, MealMeasure mealMeasure, double amount) {
    HiveDailyData.currentSummary!.addFood(food, mealMeasure, amount);
  }
}
