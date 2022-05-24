import 'package:flutter/material.dart';

import '../injector.dart';
import '../presentation/pages/splashscreen/splash.dart';

void main() {
  registerDependencies();
  
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Application(),
      theme: ThemeData(
        primaryColor: Color(0xFFA50044),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFE6E6E6),
          titleTextStyle: TextStyle(
            color: Color(0xFF004D98)
          ),
          iconTheme: IconThemeData(
            color: Color(0xFF004D98)
          )
        ),
        scaffoldBackgroundColor: Colors.white,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0XFFA50044)
        ),
        cardColor: Color(0XFFFFFFFF),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color(0XFFA50044)
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color(0xFFA50044)),
      ),
    )
  );
}

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