import 'package:flutter/material.dart';

import 'package:compmanager/domain/interfaces/icomponent.dart';

import '../create.dart';
import 'change_image_background_component.dart';
import 'alter_color_component.dart';
import 'speak_mic_component.dart';
import '../../../../core/change_notifier_global.dart';

class AppBarCreateComponent implements IComponent<CreateNoteState, PreferredSize, void> {

  final CreateNoteState _screen;
  final ValueNotifier<bool> _removeBackgroundNotifier = ValueNotifier(false);
  final ValueNotifier<bool> _disableSpeak = ValueNotifier(true);
  final ChangeNotifierGlobal<bool> _showContainer = ChangeNotifierGlobal(false);

  late final ChangeImageBackgroundComponent _changeImageBackgroundComponent;
  late final AlterColorComponent _alterColorComponent;
  late final SpeakMicComponent _speakMicComponent;

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
    _screen.receive("addComponent", this);
    _changeImageBackgroundComponent = ChangeImageBackgroundComponent(_screen);
    _alterColorComponent = AlterColorComponent(_screen);
    _speakMicComponent = SpeakMicComponent(_screen);
  }

  @override
  void dispose() {
    _speakMicComponent.dispose();
  }

  List<Widget> _actions() {
    return [
      Container(
        child: Row(
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
                      width:
                        _showContainer.value &&
                        _removeBackgroundNotifier.value ? 240.0  :
                        _showContainer.value && !_removeBackgroundNotifier.value ? 200.0 : 48.0,
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
      onPressed: () {
        close ? _showContainer.value = false : _showContainer.value = true;
      },
      icon: Icon(close ? Icons.keyboard_arrow_right : Icons.keyboard_arrow_left),
      color: _screen.color,
      iconSize: 30.0,
      padding: EdgeInsets.zero,
      splashRadius: 25.0,
    );
  }

  List<Widget> _iconsActions() {
    return [
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
}