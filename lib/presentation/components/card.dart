import 'package:flutter/material.dart';

class CardNote extends StatefulWidget {
  final String titulo;
  final String conteudo;
  final DateTime data;

  CardNote({
    required this.titulo,
    required this.conteudo,
    required this.data
  });
  
  @override
  CardNoteState createState() => CardNoteState();
}

class CardNoteState extends State<CardNote> {

  Map _months = {
    1: "janeiro",
    2: "fevereiro",
    3: "março",
    4: "abril",
    5: "maio",
    6: "junho",
    7: "julho",
    8: "agosto",
    9: "setembro",
    10: "outubro",
    11: "novembro",
    12: "dezembro"
  };
  
  String _formatDate(String data) {
    DateTime date = DateTime.parse(data);

    return "${date.day.toString().padLeft(2,'0')} de ${_months[date.month]} de ${date.year}";
  }

  Column _body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.titulo,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.bold
          ),
        ),
        Text(
          widget.conteudo,
          style: TextStyle(
            color: Color(0XFF808080),
            fontSize: 15.0
          ),
        ),
        Text(
          _formatDate(widget.data.toIso8601String()),
          style: TextStyle(
            color: Color(0XFF808080),
            fontSize: 14.0
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      elevation: 0.0,
      shadowColor: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: _body()
      ),
    );
  }
}