import 'package:compmanager/domain/interfaces/icomponent.dart';
import 'package:flutter/material.dart';

import '../create.dart';
import '../arguments/arguments_share.dart';

class ShareComponent implements IComponent<CreateNoteState, AlertDialog, void> {

  final CreateNoteState _screen;

  ShareComponent(this._screen);

  @override
  void afterEvent() {
    return;
  }

  @override
  void beforeEvent() {
    return;
  }

  @override
  AlertDialog constructor() {
    return AlertDialog(
      title: Text("Como deseja compartilhar a anotação?"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () {
              Navigator.of(_screen.context).pop(0);
            },
            child: Text(
              "Compartilhar anotação como PDF",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black
              )
            ),
          ),
          Container(height: 1.0, color: Colors.black),
          TextButton(
            onPressed: () async {
              Navigator.of(_screen.context).pop(1);
            },
            child: Text(
              "Compartilhar anotação como imagem",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black
              )
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
   return;
  }

  @override
  void event() async {
    int? selecionou = await showDialog<int>(
      context: _screen.context,
      builder: (BuildContext context) {
        return constructor();
      }
    );

    if (selecionou == 1) {
      Navigator.of(_screen.context).pushNamed(
        "/share/image",
        arguments:
          ArgumentsShare(anotacaoModel: _screen.anotacao!, screen: _screen)
      );
    }
  }

  @override
  void init() {
    return;
  }  
}