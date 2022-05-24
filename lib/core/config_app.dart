import 'package:flutter/material.dart';

import '../data/datasources/datasource.dart';
import '../data/model/anotacao_model.dart';

class ConfigApp extends InheritedWidget {
  ConfigApp({
    Key? key,
    required this.color,
    required this.removeBackground,
    required Widget child,
    required this.datasourceBase
  }) : super(key: key, child: child);

  Color color;
  bool removeBackground;
  DatasourceBase<AnotacaoModel> datasourceBase;

  static ConfigApp of(BuildContext context) {
    final ConfigApp? result = context.dependOnInheritedWidgetOfExactType<ConfigApp>();
    assert(result != null, 'Não contém cor no contexto');
    return result!;
  }

  @override
  bool updateShouldNotify(ConfigApp old) =>
    color != old.color || removeBackground != old.removeBackground || datasourceBase != old.datasourceBase;
}