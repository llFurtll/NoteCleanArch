import 'dart:async';

import 'package:flutter/material.dart';
import 'package:compmanager/domain/interfaces/icomponent.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../components/show_message.dart';
import '../create.dart';
import '../components/app_bar_create_component.dart';

class SpeakMicComponent implements IComponent<CreateNoteState, Container, void> {

  final CreateNoteState _screen;
  final SpeechToText _speechToText = SpeechToText();

  late final AppBarCreateComponent _appBarCreateComponent;

  bool _speechEnable = false;
  Timer? _debounce;

  SpeakMicComponent(this._screen) {
    init();
  }

  @override
  void afterEvent() {
    return;
  }

  @override
  void beforeEvent() {
    if (_speechToText.isListening) {
      _stopListening();
    }
  }

  @override
  Container constructor() {
    return Container();
  }

  @override
  void dispose() {
    if (_debounce != null) {
      _debounce!.cancel();
    }
  }

  @override
  void event() {
    beforeEvent();

    if (_screen.focusTitle.hasFocus) {
      _startListening(_screen.controllerTitle);
    } else if (_screen.focusDesc.hasFocus) {
      _startListening(_screen.controllerDesc);
    } else {
      MessageDefaultSystem.showMessage(
        _screen.context,
        "Selecione algum campo para utilizar o microfone!"
      );
    }
  }

  @override
  void init() {
    _appBarCreateComponent = _screen.getComponent(AppBarCreateComponent) as AppBarCreateComponent;
    _initSpeech();
  }

  void _initSpeech() async {
    _speechEnable = await _speechToText.initialize();
    _appBarCreateComponent.disableSpeak = !_speechEnable;
  }

  void _startListening(TextEditingController controller) async {
    _appBarCreateComponent.listening = true;
    await _speechToText.listen(
      onResult: (SpeechRecognitionResult result) => _onSpeechResult(result, controller)
    );
  }

  void _stopListening() async {
    await _speechToText.stop();
    _appBarCreateComponent.listening = false;
  }

  void _onSpeechResult(SpeechRecognitionResult result, TextEditingController controller) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () {
        if (controller.text.isEmpty) {
          controller.text = result.recognizedWords;
        } else {
          controller.text += " " + result.recognizedWords;
        }

        _appBarCreateComponent.listening = false;
    });
  }
}