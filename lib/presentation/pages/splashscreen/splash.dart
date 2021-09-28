import 'dart:async';

import 'package:flutter/material.dart';
import 'package:note/presentation/pages/homepage/home.dart';
import 'package:note/utils/route_animation.dart';
import 'package:note/utils/init_database.dart';
import 'package:sqflite/sqflite.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.sync(() async {
      Database db = await initDatabase();

      Timer(
        Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(createRoute(Home(db: db)))
      );
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Center(
        child: Image.asset(
          "lib/assets/logo.png",
          fit: BoxFit.fill,
          width: 250.0,
          height: 250.0,
        ),
      ),
    );
  }
}