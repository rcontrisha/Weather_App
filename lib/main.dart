import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'boxes.dart';
import 'city_hive.dart';
import 'home.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(CityAdapter());
  await Hive.openBox<Kota>(HiveBoxes.city);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: WeatherApp(),
    );
  }
}