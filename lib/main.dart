import 'package:flutter/material.dart';

import './injector.dart';
import './presentation/pages/splashscreen/splash.dart';
import './routes.dart';

void main() {
  registerDependencies();
  
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Application(),
      theme: ThemeData(
        primaryColor: Color(0xFFA50044),
        scaffoldBackgroundColor: Colors.white,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0XFFA50044)
        ),
        cardColor: Color(0XFFFFFFFF),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color(0XFFA50044)
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color(0xFFA50044)),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: Color(0xFFA50044),
          circularTrackColor: Colors.white
        ),
      ),
      routes: routes(),
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