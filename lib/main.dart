import 'package:financial/models/money.dart';
import 'package:financial/screens/home_screen.dart';
import 'package:financial/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async{
  await Hive.initFlutter();
  Hive.registerAdapter(MoneyAdapter());
  await Hive.openBox('moneyBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static void getData(){
    HomeScreen.moneys.clear();
    Box hiveBox = Hive.box('moneyBox');
    for (var value in hiveBox.values) {
      HomeScreen.moneys.add(value);
     }
  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData(fontFamily: 'Iransans'),
      debugShowCheckedModeBanner: false,
      title: 'Financial Management',
      home: const MainScreen(),
    );
  }
}


