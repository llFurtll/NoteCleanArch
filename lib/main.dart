import 'package:flutter/material.dart';
import 'package:note/data/datasources/sqlite.dart';
import 'package:note/presentation/pages/createpage/config_app.dart';
import 'package:note/presentation/pages/splashscreen/splash.dart';

void main() => runApp(
  ConfigApp(
    color: Color(0xFF000000),
    removeBackground: false,
    datasourceBase: SqliteDatasource(),
    child: MaterialApp(
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
        accentColor: Color(0xFFA50044)
      ),
    )
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