import 'package:flutter/material.dart';

class AppBarHome extends StatefulWidget {

  final String? titulo;

  AppBarHome({required this.titulo});

  @override
  AppBarHomeState createState() => AppBarHomeState();
}

class AppBarHomeState extends State<AppBarHome> {

  final GlobalKey<PopupMenuButtonState<int>> _menuPopup = GlobalKey();

  final String menuItemGrade = "Visualização em grade";
  final String menuItemLista = "Visualização em Lista";
  int opcao = 0;

  PopupMenuButton _createMenuItens() {
    return PopupMenuButton<int>(
      child: IconButton(
        icon: Icon(Icons.more_vert, color: Theme.of(context).appBarTheme.iconTheme!.color,),
        tooltip: "Alterar exibição",
        onPressed: () => _menuPopup.currentState!.showButtonMenu(),
        splashColor: Color(0xFF004D98),
      ),
      key: _menuPopup,
      onSelected: (int result) {
        setState(() {
          opcao = opcao == 0 ? opcao = 1 : opcao = 0;
        });
      },
      itemBuilder: (context) {
        return List.generate(1, (index) {
          return PopupMenuItem(
            value: opcao,
            child: Container(
              child: Text(opcao == 0 ? menuItemGrade : menuItemLista),
            ),
          );
        });
      },
    );
  }

  List<Widget> _actions() {
    return [
      _createMenuItens()
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
      //actions: _actions(),
    );
  }
}