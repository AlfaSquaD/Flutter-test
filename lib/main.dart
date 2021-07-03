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
  Hive.registerAdapter(DailyDataAdapter());
  Hive.init(dir.path);
  HiveDailyData.instance =
      HiveDailyData(dailyBox: await Hive.openLazyBox("daily"));
  await HiveDailyData.instance?.setCurrentSummary();
  HiveFoods.instance = HiveFoods(foodBox: await Hive.openBox("foods"));
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  bool _firstInit = sharedPreferences.getBool("firstInit") ?? true;
  if (_firstInit) {
    var data = jsonDecode(await rootBundle.loadString("assets/data.json"));
    data["data"].forEach((el) {
      HiveFoods.instance!.foodBox.add(Food.fromJson(el));
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
            SliverFixedExtentList(
              itemExtent:
                  HiveDailyData.currentSummary?.eaten_food.length.toDouble() ??
                      0.0,
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    alignment: Alignment.center,
                    color: Colors.lightBlue[100 * (index % 9)],
                    child: Text('List Item $index'),
                  );
                },
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
    );
  }

  void _onTextChanged() {
    foods.value = HiveFoods.instance?.getFoods((el) =>
            el.name.toLowerCase().contains(controller.text.toLowerCase())) ??
        [];
  }
}
