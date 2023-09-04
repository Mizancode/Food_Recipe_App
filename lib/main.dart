import 'package:flutter/material.dart';
import 'package:food_recipe_9_july_2023/Pages/splash.dart';
void main(){
  runApp(MyMain());
}
class MyMain extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}