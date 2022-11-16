import 'package:flutter/material.dart';

import 'package:compmanager/domain/interfaces/icomponent.dart';

import '../../../../../../../core/notifiers/change_notifier_global.dart';
import '../create.dart';
import 'change_image_background_component.dart';
import 'speak_mic_component.dart';
import 'share_component.dart';
import 'auto_save_note_component.dart';

class AppBarCreateComponent implements IComponent<CreateNoteState, PreferredSize, void> {

  final CreateNoteState _screen;
  final ChangeNotifierGlobal<bool> _removeBackgroundNotifier = ChangeNotifierGlobal(false);
  final ChangeNotifierGlobal<bool> _disableSpeak = ChangeNotifierGlobal(true);
  final ChangeNotifierGlobal<bool> _showContainer = ChangeNotifierGlobal(false);
  final ChangeNotifierGlobal<bool> _showShare = ChangeNotifierGlobal(false);

  late final ChangeImageBackgroundComponent _changeImageBackgroundComponent;
  late final SpeakMicComponent _speakMicComponent;
  late final ShareComponent _shareComponent;
  late final AutoSaveNoteComponent _autoSaveNoteComponent;

  AppBarCreateComponent(this._screen) {
    init();
  }

  @override
  void afterEvent() {
    return;
  }

  @override
  void beforeEvent() {
    return;
  }

  @override
  PreferredSize constructor() {
    return PreferredSize(
      preferredSize: Size.fromHeight(60.0),
      child: AppBar(
        backgroundColor: Colors.transparent,
        title: _autoSaveNoteComponent.constructor(),
        elevation: 0,
        actions: _actions(),
        leading: _iconLeading(),
      )
    );
  }

  @override
  void event() {
    return;
  }

  @override
  void init() {
    _screen.addComponent(this);
    _changeImageBackgroundComponent = ChangeImageBackgroundComponent(_screen);
    _speakMicComponent = SpeakMicComponent(_screen);
    _shareComponent = ShareComponent(_screen);
    _autoSaveNoteComponent = AutoSaveNoteComponent(_screen);
  }

  void loadBindings() {
    _autoSaveNoteComponent.loadBindings();
  }

  @override
  void dispose() {
    _speakMicComponent.dispose();
  }

  List<Widget> _actions() {
    return [
      Container(
        child: Wrap(
          children: [
            ValueListenableBuilder(
              valueListenable: _showContainer,
              builder: (BuildContext context, bool value, Widget? widget) {
                return Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    elevation: 3.0,
                    child: AnimatedContainer(
                      height: 50.0,
                      width: _returnSizeContainer(),
                      curve: Curves.ease,
                      child: Wrap(
                        children: [
                          _iconOpenItens(_showContainer.value),
                          ..._iconsActions().map((e) => _showContainer.value ? e : SizedBox(height: 0.0, width: 0.0))
                        ],
                      ),
                      duration: Duration(milliseconds: 500),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ];
  }

  IconButton _iconOpenItens(bool close) {
    return IconButton(
      tooltip: close ? "Fechar menu" : "Abrir menu",
      onPressed: () => close ? _showContainer.value = false : _showContainer.value = true,
      icon: Icon(close ? Icons.close : Icons.menu),
      color: Colors.black,
      padding: EdgeInsets.zero,
      splashRadius: 25.0,
    );
  }

  List<Widget> _iconsActions() {
    return [
      ValueListenableBuilder(
        valueListenable: _showShare,
        builder: (BuildContext context, bool value, Widget? widget) {
          return Visibility(
            visible: _showShare.value,
            child: IconButton(
              tooltip: "Compartilhar",
              onPressed: () => _screen.emitScreen(_shareComponent),
              icon: Icon(
                Icons.ios_share_outlined,
              ),
              color: Colors.black,
              disabledColor: Colors.grey,
              padding: EdgeInsets.zero,
              splashRadius: 25.0,
            ),
          );  
        }
      ),
      IconButton(
        tooltip: _disableSpeak.value ? "Permissão negada" : "Usar microfone",
        onPressed: _disableSpeak.value ? null : () => _screen.emitScreen(_speakMicComponent),
        icon: Icon(
          _disableSpeak.value ? Icons.mic_off : Icons.mic,
        ),
        color: Colors.black,
        disabledColor: Colors.grey,
        padding: EdgeInsets.zero,
        splashRadius: 25.0,
      ),
      ValueListenableBuilder(
        valueListenable: _removeBackgroundNotifier,
        builder: (BuildContext context, bool value, Widget? widget) {
          bool containPhoto = _removeBackgroundNotifier.value;
          return IconButton(
            tooltip: containPhoto ? "Remover imagem de fundo" : "Adicionar imagem de fundo",
            color: Colors.black,
            onPressed: () {
              if (containPhoto) {
                _screen.pathImage = "";
                _removeBackgroundNotifier.value = false;
                _changeImageBackgroundComponent.imageSelected = -1;
                changeMenuItens();
              } else {
                _screen.emitScreen(_changeImageBackgroundComponent);
              }
            },
            icon: Icon(containPhoto ? Icons.no_photography : Icons.photo),
            padding: EdgeInsets.zero,
            splashRadius: 25.0,
          );
        },
      ),
    ];
  }

  IconButton _iconLeading() {
    return IconButton(
      tooltip: "Voltar",
      icon: Icon(
        Icons.arrow_back_ios,
        color: Colors.black
      ),
      onPressed: () {
        Navigator.pop(_screen.context);
      },
    );
  }

  double _returnSizeContainer() {
    double baseSize = 48.0;
    int qtdIcones = 3;

    if (!_showContainer.value) {
      return baseSize;
    }
    
    if (_screen.id != null) {
      qtdIcones++;
    }

    return baseSize * qtdIcones;
  }

  bool get removeBackground {
    return _removeBackgroundNotifier.value;
  }

  set removeBackground(bool remove) {
    _removeBackgroundNotifier.value = remove;
  }

  set disableSpeak(bool disable) {
    _disableSpeak.value = disable;
  }

  void changeMenuItens() {
    _showContainer.emitChange();
  }

  set showShare(bool show) {
    _showShare.value = show;
  }

  void emitComponentAutoSave() {
    _autoSaveNoteComponent.event();
  }
}