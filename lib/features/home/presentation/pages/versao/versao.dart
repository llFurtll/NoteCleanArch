import 'package:flutter/material.dart';

class Versao extends StatefulWidget {
  static final String routeVersao = "/versao";

  @override
  VersaoState createState() => VersaoState();
}

class VersaoState extends State<Versao> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
    );
  }

  PreferredSize _buildAppBar() {
    return PreferredSize(
      child: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Versões do EasyNote"),
        automaticallyImplyLeading: false,
        leading: _buildBack(),
      ),
      preferredSize: Size.fromHeight(56.0)
    );
  }

  Widget _buildBack() {
    return IconButton(
      tooltip: "Voltar",
      onPressed: () => Navigator.of(context).pop(),
      icon: Icon(Icons.arrow_back_ios),
    );
  }
}