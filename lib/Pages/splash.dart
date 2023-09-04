import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food_recipe_9_july_2023/Pages/home.dart';
import 'package:google_fonts/google_fonts.dart';
class Splash extends StatefulWidget{
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Timer(Duration(seconds: 3),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff213a50),
              Color(0xff071938),
            ]
          )
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/food_logo.png',scale: 2,),
              Text('Food Recipe APP',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30,fontFamily: GoogleFonts.poppins().fontFamily),),
              Text('Credit Goes To:',style: TextStyle(color: Colors.white,fontSize: 20),),
              Text('Mizan Sheikh',style: TextStyle(color: Colors.white,fontSize: 18),)
            ],
          ),
        ),
      ),
    );
  }
}