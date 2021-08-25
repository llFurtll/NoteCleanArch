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

  bool _visibilityButtons = false;
  double _offset = 0.0;
  double _opacity = 0.0;

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
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.delta.direction > 0) {
            setState(() {
              if (_offset > -60.0) {
                _offset--;
                _opacity = _offset.abs() / 60.0;
                _visibilityButtons = true;
              }
            });
          } else {
            setState(() {
              if (_offset < 0.0) {
                _offset++;
                _opacity = _offset.abs() / 60;
                if (_offset == 0.0) {
                  _visibilityButtons = false;
                }
              }
            });
          }
        },
        child: Transform.translate(
          offset: Offset(_offset, 0.0),
          child: Card(
            color: Theme.of(context).cardColor,
            elevation: 0.0,
            shadowColor: Theme.of(context).scaffoldBackgroundColor,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: _contentCard()
            ),
          ),
        ),
      ),
    );
  }

  Opacity _buttonsActions() {
    return Opacity(
      opacity: _opacity,
      child: Visibility(
      visible: _visibilityButtons,
      child:  Column(
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
        ),
      ),
    );
  }

  Row _cardWithButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        _card(),
        _buttonsActions()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _cardWithButtons();
  }
}