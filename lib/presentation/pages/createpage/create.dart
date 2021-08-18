import 'package:flutter/material.dart';
import 'package:note/presentation/pages/createpage/appbar.dart';

class CreateNote extends StatefulWidget {
  @override
  CreateNoteState createState() => CreateNoteState();
}

class CreateNoteState extends State<CreateNote> {

  TextFormField _titulo() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: "Título",
        hintStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20.0
        ),
        border: InputBorder.none,
      ),
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 20.0
      ),
      minLines: 1,
      maxLines: null,
      keyboardType: TextInputType.multiline,
    );
  }

  TextFormField _descricao() {
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
      ),
      style: TextStyle(
        color: Colors.black,
        fontSize: 18.0
      ),
      minLines: 20,
      maxLines: null,
      keyboardType: TextInputType.multiline,
    );
  }

  Widget _home() {
    return Container(
      padding: EdgeInsets.all(25.0),
      child: SingleChildScrollView(
        child: Builder(
          builder: (BuildContext context) {
            return Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _titulo(),
                  _descricao(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  FloatingActionButton _button() {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
      onPressed: null,
      child: Icon(Icons.save),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        child: AppBarCreate(),
        preferredSize: Size.fromHeight(56.0),
      ),
      body: _home(),
      floatingActionButton: _button(),
    );
  }
}