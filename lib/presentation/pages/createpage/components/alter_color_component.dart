import 'package:flutter/material.dart';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'package:compmanager/domain/interfaces/icomponent.dart';

import '../create.dart';

class AlterColorComponent implements IComponent<CreateNoteState, Container, void> {

  final CreateNoteState _screen;

  AlterColorComponent(this._screen);

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
    return Container();
  }

  @override
  void event() async {
    await showDialog(
      context: _screen.context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        contentPadding: const EdgeInsets.all(10.0),
        title: Text("Cor das letras"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ColorPicker(
              pickerColor: _screen.color,
              onColorChanged: _changeColor,
              showLabel: false,
              enableAlpha: false,
              pickerAreaBorderRadius: BorderRadius.all(Radius.circular(15.0)),
              pickerAreaHeightPercent: 0.7
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Ok"),
          ),
        ],
      ),
    );

    afterEvent();
  }

  @override
  void init() {
    return;
  }

  @override
  void dispose() {
    return;
  }

  void _changeColor(Color color) {
    _screen.color = color;
  }
  
}