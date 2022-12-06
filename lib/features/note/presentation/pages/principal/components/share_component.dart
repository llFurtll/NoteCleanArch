import 'package:compmanager/domain/interfaces/icomponent.dart';
import 'package:flutter/material.dart';

import '../../arguments/arguments_share.dart';
import '../../share_image/show_image_share.dart';
import '../../share_pdf/show_pdf_share.dart';
import '../create.dart';

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
  void bindings() {}

  @override
  Future<void> loadDependencies() async {}

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
            onPressed: () async {
              final showImage = await _showDialogImage();

              Navigator.of(_screen.context).pushNamed(
                ShowPdfShare.routeShowPdfShare,
                arguments:
                  ArgumentsShare(note: _screen.note, screen: _screen, showImage: showImage!)
              );
            },
            child: Text("Compartilhar anotação como PDF", style: TextStyle(fontSize: 16.0)),
            style: TextButton.styleFrom(
              padding: EdgeInsets.all(15),
              backgroundColor: Colors.black,
            ),
          ),
          TextButton(
            onPressed: () async {
              final showImage = await _showDialogImage();

              Navigator.of(_screen.context).pushNamed(
                ShowImageShare.routeShowImageShare,
                arguments:
                  ArgumentsShare(note: _screen.note, screen: _screen, showImage: showImage!)
              );
            },
            child: Text("Compartilhar anotação como imagem", style: TextStyle(fontSize: 16.0)),
            style: TextButton.styleFrom(
              padding: EdgeInsets.all(15),
              backgroundColor: Colors.black,
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
                backgroundColor: Theme.of(_screen.context).primaryColor,
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

  Future<bool?> _showDialogImage() async {

    if (_screen.note.imagemFundo!.isEmpty) {
      return false;
    }

    bool? decision = await showDialog(
      barrierDismissible: false,
      context: _screen.context,
      builder: (BuildContext context) {
        return AlertDialog(
          buttonPadding: EdgeInsets.zero,
          title: Text("Deseja compartilhar com a imagem de fundo?"),
          content: Text("Define se a imagem da anotação será exibida no compartilhamento!"),
          actions: [
            TextButton(
              child: Text("Sim", style: TextStyle(fontSize: 18.0)),
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                minimumSize: Size(double.infinity, 45.0),
                side: BorderSide(color: Colors.grey.shade300, width: 0.5),
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
            ),
            TextButton(
              child: Text("Não", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal)),
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: Size(double.infinity, 45.0),
                side: BorderSide(color: Colors.grey.shade300, width: 0.5),
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: 
                  RoundedRectangleBorder(
                    borderRadius:
                      BorderRadius.only(
                        bottomLeft: Radius.circular(5.0),
                        bottomRight: Radius.circular(5.0),
                      )
                  )
              ),
            ),
          ],
        );
      }
    );

    return decision == null || decision == false ? false : true;
  }
}