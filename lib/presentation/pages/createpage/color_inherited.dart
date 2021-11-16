import 'package:flutter/material.dart';

class SetColor extends InheritedWidget {
  SetColor({
    Key? key,
    required this.color,
    required Widget child,
  }) : super(key: key, child: child);

  Color color;

  static SetColor of(BuildContext context) {
    final SetColor? result = context.dependOnInheritedWidgetOfExactType<SetColor>();
    assert(result != null, 'Não contém cor no contexto');
    return result!;
  }

  @override
  bool updateShouldNotify(SetColor old) => color != old.color;
}