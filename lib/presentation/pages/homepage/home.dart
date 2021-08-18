import 'package:flutter/material.dart';
import 'package:note/presentation/pages/createpage/create.dart';
import 'package:note/presentation/pages/homepage/appbar.dart';
import 'package:note/presentation/pages/homepage/card.dart';
import 'package:note/utils/route_animation.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {

  Widget _home() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: CardNote(data: DateTime.now(), conteudo: "Legal", titulo: "Teste",),
    );
  }

  FloatingActionButton _button() {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
      onPressed: () => Navigator.of(context).push(createRoute(CreateNote())),
      child: Icon(Icons.add),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBarHome(titulo: "Note"),
        preferredSize: Size.fromHeight(56.0),
      ),
      body: _home(),
      floatingActionButton: _button(),
    );
  }
}