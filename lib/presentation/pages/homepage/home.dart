import 'package:flutter/material.dart';
import 'package:note/presentation/components/card.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {

  String _title = "Note";
  double _height = 56.0;

  List<Widget> _actions() {
    return [
      IconButton(
        onPressed: null,
        icon: Icon(
          Icons.more_vert,
          color: Theme.of(context).appBarTheme.titleTextStyle!.color,
        ),
      )
    ];
  }

  PreferredSize? _appBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(_height),
      child: AppBar(
        title: Text(
          _title,
          style: TextStyle(
            color: Theme.of(context).appBarTheme.titleTextStyle!.color
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: _actions(),
      ),
    );
  }

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
      appBar: _appBar(),
      body: _home(),
      floatingActionButton: _button(),
    );
  }
}