import 'package:flutter/material.dart';

class AppBarComponent extends StatefulWidget {

  final String? titulo;

  AppBarComponent({required this.titulo});

  @override
  AppBarComponentState createState() => AppBarComponentState();
}

class AppBarComponentState extends State<AppBarComponent> {

  final String menuItemGrade = "Visualização em grade";
  final String menuItemLista = "Visualização em Lista";
  int opcao = 0;

  PopupMenuButton createMenuItens() {
    return PopupMenuButton<int>(
      icon: Icon(Icons.more_vert, color:  Theme.of(context).appBarTheme.titleTextStyle!.color),
      tooltip: "Alterar exibição",
      onSelected: (int result) {
        setState(() {
          opcao = opcao == 0 ? opcao = 1 : opcao = 0;
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        PopupMenuItem(
          value: opcao,
          child: Text(opcao == 0 ? menuItemGrade : menuItemLista),
        ),
      ],
    );
  }

  List<Widget> _actions() {
    return [
      createMenuItens()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        widget.titulo!,
        style: TextStyle(
          color: Theme.of(context).appBarTheme.titleTextStyle!.color
        ),
      ),
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      actions: _actions(),
    );
  }
}