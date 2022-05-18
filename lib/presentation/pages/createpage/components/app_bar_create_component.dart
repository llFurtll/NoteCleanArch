import 'package:flutter/material.dart';

import 'package:compmanager/domain/interfaces/icomponent.dart';

import '../create.dart';
import 'change_image_background_component.dart';
import 'alter_color_component.dart';

class AppBarCreateComponent implements IComponent<CreateNoteState, PreferredSize, void> {

  final CreateNoteState _screen;
  final ValueNotifier<bool> _removeBackgroundNotifier = ValueNotifier(false);

  late final ChangeImageBackgroundComponent _changeImageBackgroundComponent;
  late final AlterColorComponent _alterColorComponent;

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
      preferredSize: Size.fromHeight(56.0),
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
    _changeImageBackgroundComponent = ChangeImageBackgroundComponent(_screen);
    _alterColorComponent = AlterColorComponent(_screen);
  }

  bool get removeBackground {
    return _removeBackgroundNotifier.value;
  }

  set removeBackground(bool remove) {
    _removeBackgroundNotifier.value = remove;
  }

  List<Widget> _actions() {
    return [
      IconButton(
        icon: Icon(Icons.color_lens),
        padding: const EdgeInsets.fromLTRB(0, 25, 0, 25),
        color: _screen.color,
        onPressed: () => _screen.emitScreen(_alterColorComponent),
      ),
      ValueListenableBuilder(
        valueListenable: _removeBackgroundNotifier,
        builder: (BuildContext context, bool value, Widget? widget) {
          return Visibility(
            visible: _removeBackgroundNotifier.value,
            child: IconButton(
              color: _screen.color,
              padding: const EdgeInsets.fromLTRB(0, 25, 0, 25),
              onPressed: () {
                _screen.pathImage = "";
                _removeBackgroundNotifier.value = false;
              },
              icon: const Icon(Icons.close)
            )
          );
        },
      ),
      IconButton(
        padding: const EdgeInsets.fromLTRB(0, 25, 10, 25),
        onPressed: () => _screen.emitScreen(_changeImageBackgroundComponent),
        icon: Icon(
          Icons.photo,
          color: _screen.color,
        ),
      ),
    ];
  }

  IconButton _iconLeading() {
    return IconButton(
      padding: const EdgeInsets.all(25.0),
      icon: Icon(
        Icons.arrow_back_ios,
        color: _screen.color
      ),
      onPressed: () {
        Navigator.pop(_screen.context);
      },
    );
  }
}