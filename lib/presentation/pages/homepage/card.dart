import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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

  bool _visibilityButtons = false;

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

  Column _contentCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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

  Expanded _card() {
    return Expanded(
      child: Slidable(
        actionPane: SlidableScrollActionPane(),
        child: Card(
          color: Theme.of(context).cardColor,
          elevation: 0.0,
          shadowColor: Theme.of(context).scaffoldBackgroundColor,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: _contentCard()
          ),
        ),
        secondaryActions: [
          _buttonsActions()
        ],
      ),
    );
  }

  Column _buttonsActions() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.red,
            shape: CircleBorder()
          ),
          child: Icon(Icons.delete, color: Colors.white),
          onPressed: () {},
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.green,
            shape: CircleBorder()
          ),
          child: Icon(Icons.check, color: Colors.white),
          onPressed: () {},
        )
      ]
    ); 
  }

  Row _cardWithButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        _card()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _cardWithButtons();
  }
}