

import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:compmanager/domain/interfaces/icomponent.dart';

import '../../../../../note/presentation/pages/principal/create.dart';
import '../home_list.dart';

class ButtonAddNoteComponent implements IComponent<HomeListState, OpenContainer, void> {
  final HomeListState _screen;
  final double _fabDimension = 56.0;
  final ContainerTransitionType _transitionType = ContainerTransitionType.fadeThrough;

  ButtonAddNoteComponent(this._screen) {
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
  void bindings() {}

  @override
  OpenContainer constructor() {
    return OpenContainer(
      openColor: Theme.of(_screen.context).floatingActionButtonTheme.backgroundColor!,
      closedColor: Theme.of(_screen.context).floatingActionButtonTheme.backgroundColor!,
      closedElevation: 6.0,
      openElevation: 0.0,
      transitionType: _transitionType,
      transitionDuration: Duration(milliseconds: 500),
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(_fabDimension / 2)),
      ),
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return FloatingActionButton(
          tooltip: "Criar nota",
          backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
          elevation: 0.0,
          onPressed: null,
          child: Icon(Icons.add),
        );
      },
      openBuilder: (BuildContext context, VoidCallback _) {
        return CreateNote();
      }
    );
  }

  @override
  void event() {
    return;
  }

  @override
  void init() {
    _screen.addComponent(this);
  }

  @override
  void dispose() {
    return;
  }

  @override
  Future<void> loadDependencies() async {}
}