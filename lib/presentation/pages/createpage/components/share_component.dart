import 'package:compmanager/domain/interfaces/icomponent.dart';
import 'package:flutter/material.dart';

import '../create.dart';
import '../arguments/arguments_share.dart';

class ShareComponent implements IComponent<CreateNoteState, Container, void> {

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
  Container constructor() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: Icon(Icons.drag_handle, color: Colors.grey, size: 40.0),
          ), 
          TextButton(
            onPressed: () {
              Navigator.of(_screen.context).pushNamed(
                "/share/pdf",
                arguments:
                  ArgumentsShare(anotacaoModel: _screen.anotacao!, screen: _screen)
              );
            },
            child: Text("Compartilhar anotação como PDF", style: TextStyle(fontSize: 16.0)),
            style: TextButton.styleFrom(
              padding: EdgeInsets.all(15),
              primary: Colors.black,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(_screen.context).pushNamed(
                "/share/image",
                arguments:
                  ArgumentsShare(anotacaoModel: _screen.anotacao!, screen: _screen)
              );
            },
            child: Text("Compartilhar anotação como imagem", style: TextStyle(fontSize: 16.0)),
            style: TextButton.styleFrom(
              padding: EdgeInsets.all(15),
              primary: Colors.black,
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            height: 50.0,
            margin: EdgeInsets.only(bottom: 25.0, top: 15.0),
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(_screen.context).primaryColor,
              ),
              onPressed: () => Navigator.of(_screen.context).pop(),
              child: Text("Cancelar")
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
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: _screen.context,
      builder: (BuildContext context) => constructor()
    );
  }

  @override
  void init() {
    return;
  }  
}