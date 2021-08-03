import 'package:flutter/material.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Application(),
    theme: ThemeData(
      primaryColor: Colors.red
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
      appBar: AppBar(
        title: Text("Note"),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor
        ),
        child: Center(
          child: Text("Eu amo Flutter!"),
        ),
      ),
    );
  }
}