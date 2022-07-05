import 'package:flutter/material.dart';
import 'package:compmanager/domain/interfaces/icomponent.dart';

import '../../../components/show_message.dart';
import '../create.dart';

class SpeakMicComponent implements IComponent<CreateNoteState, Container, void> {

  final CreateNoteState _screen;

  SpeakMicComponent(this._screen);

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
  void dispose() {
    return;
  }

  @override
  void event() {
    if (_screen.focusTitle.hasFocus) {
      
    } else if (_screen.focusDesc.hasFocus) {
      
    } else {
      MessageDefaultSystem.showMessage(
        _screen.context,
        "Selecione algum campo para utilizar o microfone!"
      );
    }
  }

  @override
  void init() {
    return;
  }
  
}