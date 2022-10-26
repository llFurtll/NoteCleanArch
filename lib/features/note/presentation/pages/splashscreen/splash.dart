import 'dart:async';
import 'package:flutter/material.dart';

import '../homepage/home.dart';
class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () async {
      Navigator.pushNamed(context, Home.routeHome);
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