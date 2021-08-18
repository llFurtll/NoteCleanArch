import 'package:flutter/material.dart';

class AppBarCreate extends StatefulWidget {
  @override
  AppBarCreateState createState() => AppBarCreateState();
}

class AppBarCreateState extends State<AppBarCreate> {

  List<Widget> _actions() {
    return [
      IconButton(
        splashColor: Color(0xFF004D98),
        padding: EdgeInsets.all(25.0),
        onPressed: () => {},
        icon: Icon(
          Icons.photo,
          color: Theme.of(context).appBarTheme.titleTextStyle!.color,
        ),
      ),
    ];
  }

  Builder _iconLeading() {
    return Builder(
      builder: (BuildContext context) {
        return IconButton(
            splashColor:  Color(0xFF004D98),
            padding: EdgeInsets.all(25.0),
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).appBarTheme.titleTextStyle!.color
            ),
            onPressed: () => Navigator.of(context).pop(),
          );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      actions: _actions(),
      leading: _iconLeading(),
    );
  }
}