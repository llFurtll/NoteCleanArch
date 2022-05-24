import 'dart:async';

import 'package:flutter/material.dart';

import '../../../presentation/pages/homepage/home.dart';
import '../../../utils/init_database.dart';
import '../../../utils/route_animation.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () async {
      await initDatabase();
      Navigator.of(context).pushReplacement(createRoute(Home()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Center(
        child: Image.asset(
          "lib/images/logo.png",
          fit: BoxFit.fill,
          width: 250.0,
          height: 250.0,
        ),
      ),
    );
  }
}