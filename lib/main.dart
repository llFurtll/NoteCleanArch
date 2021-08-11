import 'package:flutter/material.dart';
import 'package:note/presentation/pages/splashscreen/splash.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Application(),
    theme: ThemeData(
      splashColor: Color(0xFFA50044)
    ),
  )
);

class Application extends StatefulWidget {
  @override
  ApplicationState createState() => ApplicationState();
}

class ApplicationState extends State<Application> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreen(),
    );
  }
}