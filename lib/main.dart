import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:practice/db/hiveDailyData.dart';
import 'package:practice/db/hiveFoods.dart';
import 'package:practice/models/daily_data.dart';
import 'package:practice/models/food.dart';

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
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 200, // TODO: Static value!
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(DateFormat.yMMMMd("tr_TR").format(DateTime.now())),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
                maxHeight: 400,
                minHeight: 100,
                child: Container(
                  color: Colors.blue,
                )),
          ),
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
      bottomNavigationBar: Container(
        color: Colors.red,
        height: MediaQuery.of(context).size.height / 13,
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  // 2
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  // 3
  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
