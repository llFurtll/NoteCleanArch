import 'dart:io';
import 'dart:typed_data';

import 'package:compmanager/domain/interfaces/icomponent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui' as ui;

import '../create.dart';
import '../../../components/show_message.dart';

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
      final response = await _createImageShare();

      if (response.isNotEmpty) {
        Share.shareFiles([response]);
      } else {
        MessageDefaultSystem.showMessage(_screen.context, "Não foi possível criar a imagem!");
      }
    }
  }

  @override
  void init() {
    return;
  }

  Future<String> _createImageShare() async {
    try {
      RenderRepaintBoundary boundary = _screen.boundary.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 1.1);

      final path = (await getApplicationDocumentsDirectory()).path;
      final dirShare = Directory("$path/share");

      if (!dirShare.existsSync()) {
        dirShare.createSync(recursive: true);
      }

      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      File imgFile = File("${dirShare.path}/anotacao-${_screen.id}.png");

      await imgFile.writeAsBytes(pngBytes);

      return imgFile.path;
    } catch (e) {
      return "";
    }
  }
}