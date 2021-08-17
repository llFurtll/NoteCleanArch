import 'package:flutter/material.dart';
import 'package:note/presentation/components/appbar.dart';
import 'package:note/presentation/components/card.dart';

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
      onPressed: null,
      child: Icon(Icons.add),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(
        child: AppBarComponent(titulo: "Note"),
        preferredSize: Size.fromHeight(56.0),
      ),
      body: _home(),
      floatingActionButton: _button(),
    );
  }
}