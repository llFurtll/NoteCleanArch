import 'dart:async';

import 'package:flutter/material.dart';
import 'package:compmanager/domain/interfaces/icomponent.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../create.dart';
import '../components/app_bar_create_component.dart';
import '../../../../../../../core/notifiers/change_notifier_global.dart';

class SpeakMicComponent implements IComponent<CreateNoteState, ValueListenableBuilder, void> {

  final CreateNoteState _screen;
  final SpeechToText _speechToText = SpeechToText();
  final ChangeNotifierGlobal<bool> _isListen = ChangeNotifierGlobal<bool>(false);

  late final AppBarCreateComponent _appBarCreateComponent;

  bool _speechEnable = false;
  String _textSpeak = "";
  String _info = "Segure o botão para falar!";

  SpeakMicComponent(this._screen) {
    init();
  }
 
  @override
  void afterEvent() {
    _textSpeak = "";
    _info = "Segure o botão para falar!";
  }

  @override
  void beforeEvent() {
    return;
  }

  @override
  ValueListenableBuilder constructor() {
    return ValueListenableBuilder(
      valueListenable: _isListen,
      builder: (BuildContext context, dynamic value, Widget? widget) {
        return _buildDialog();
      }
    );
  }

  @override
  void dispose() {
    return;
  }

  @override
  void event() async {
    bool response = false;

    bool isFocusTitle = _screen.focusTitle.hasFocus;

    response = await _showDialogListen();
    if (isFocusTitle) {
      _screen.title.text += _textSpeak;
    } else {
      _screen.editor.insertText(_textSpeak);
    }

    if (response) {
      afterEvent();
    }
  }

  @override
  void init() {
    _appBarCreateComponent = _screen.getComponent(AppBarCreateComponent) as AppBarCreateComponent;
    _initSpeech();
  }

  void _initSpeech() async {
    try {
      _speechEnable = await _speechToText.initialize();
    } on Exception {
      _speechEnable = false;
    }

    _appBarCreateComponent.disableSpeak = !_speechEnable;
  }

  void _startListening() async {
    await _speechToText.listen(
      onResult: (SpeechRecognitionResult result) => _onSpeechResult(result)
    );
  }

  void _stopListening() {
    Future.delayed(Duration(seconds: 1), () async {
      await _speechToText.stop();
      Navigator.of(_screen.context).pop(false);
    });
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    _textSpeak = result.recognizedWords;
  }

  Future<bool> _showDialogListen() async {
    return await showDialog(
      context: _screen.context,
      builder: (BuildContext context) {
        return constructor();
      }
    ) == null || false ? false : true;
  }

  AlertDialog _buildDialog() {
    return AlertDialog(
      title: Text(_info),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onLongPress: () {
              _info = "Ouvindo...";
              _isListen.value = true;
              _startListening();
            },
            onLongPressUp: () {
              _info = "Carregando...";
              _isListen.value = false;
              _stopListening();
            },
            child: AnimatedContainer(
              width: _isListen.value ? 100.0 : 70.0,
              height: _isListen.value ? 100.0 : 70.0,
              curve: Curves.ease,
              duration: Duration(milliseconds: 500),
              child: Icon(Icons.mic, color: Colors.white, size: 30.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(_screen.context).primaryColor
              ),
            ),
          ),
        ]
      )
    );
  }
}