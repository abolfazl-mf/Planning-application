import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do/constans.dart';
import 'package:to_do/models/todo_model.dart';
import 'package:to_do/screens/home_screen.dart';

void main() async{
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: kBackgroundColor
      ),//تم برنامه دارک هستش
      home:  HomeScreen()
    );
    }
  }

