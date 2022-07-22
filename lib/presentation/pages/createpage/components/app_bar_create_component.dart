import 'package:flutter/material.dart';

import 'package:compmanager/domain/interfaces/icomponent.dart';

import '../create.dart';
import 'change_image_background_component.dart';
import 'alter_color_component.dart';
import 'speak_mic_component.dart';
import '../../../../core/change_notifier_global.dart';
import 'share_component.dart';

class AppBarCreateComponent implements IComponent<CreateNoteState, PreferredSize, void> {

  final CreateNoteState _screen;
  final ChangeNotifierGlobal<bool> _removeBackgroundNotifier = ChangeNotifierGlobal(false);
  final ChangeNotifierGlobal<bool> _disableSpeak = ChangeNotifierGlobal(true);
  final ChangeNotifierGlobal<bool> _showContainer = ChangeNotifierGlobal(false);
  final ChangeNotifierGlobal<bool> _showShare = ChangeNotifierGlobal(false);

  late final ChangeImageBackgroundComponent _changeImageBackgroundComponent;
  late final AlterColorComponent _alterColorComponent;
  late final SpeakMicComponent _speakMicComponent;
  late final ShareComponent _shareComponent;

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
      child: ValueListenableBuilder(
        valueListenable: _screen.colorNotifier,
        builder: (BuildContext context, Color value, Widget? widget) {
          return AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: _actions(),
            leading: _iconLeading(),
          );
        },
      ),
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
    _alterColorComponent = AlterColorComponent(_screen);
    _speakMicComponent = SpeakMicComponent(_screen);
    _shareComponent = ShareComponent(_screen);
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
      onPressed: () => close ? _showContainer.value = false : _showContainer.value = true,
      icon: Icon(close ? Icons.arrow_forward_outlined : Icons.arrow_back_outlined),
      color: _screen.color,
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
              onPressed: () => _screen.emitScreen(_shareComponent),
              icon: Icon(
                Icons.ios_share_outlined,
              ),
              color: _screen.color,
              disabledColor: Colors.grey,
              padding: EdgeInsets.zero,
              splashRadius: 25.0,
            ),
          );  
        }
      ),
      IconButton(
        onPressed: _disableSpeak.value ? null : () => _screen.emitScreen(_speakMicComponent),
        icon: Icon(
          Icons.mic,
        ),
        color: _screen.color,
        disabledColor: Colors.grey,
        padding: EdgeInsets.zero,
        splashRadius: 25.0,
      ),
      IconButton(
        icon: Icon(Icons.color_lens),
        color: _screen.color,
        onPressed: () => _screen.emitScreen(_alterColorComponent),
        padding: EdgeInsets.zero,
        splashRadius: 25.0,
      ),
      ValueListenableBuilder(
        valueListenable: _removeBackgroundNotifier,
        builder: (BuildContext context, bool value, Widget? widget) {
          return Visibility(
            visible: _removeBackgroundNotifier.value,
            child: IconButton(
              color: _screen.color,
              onPressed: () {
                _screen.pathImage = "";
                _removeBackgroundNotifier.value = false;
                _changeImageBackgroundComponent.imageSelected = -1;
                changeMenuItens();
              },
              icon: const Icon(Icons.close),
              padding: EdgeInsets.zero,
              splashRadius: 25.0,
            )
          );
        },
      ),
      IconButton(
        onPressed: () => _screen.emitScreen(_changeImageBackgroundComponent),
        icon: Icon(
          Icons.photo,
          color: _screen.color,
        ),
        padding: EdgeInsets.zero,
        splashRadius: 25.0,
      )
    ];
  }

  IconButton _iconLeading() {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        color: _screen.color
      ),
      onPressed: () {
        Navigator.pop(_screen.context);
      },
    );
  }

  double _returnSizeContainer() {
    double baseSize = 48.0;
    int qtdIcones = 4;

    if (!_showContainer.value) {
      return baseSize;
    }

    if (_removeBackgroundNotifier.value) {
      qtdIcones++;
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
}