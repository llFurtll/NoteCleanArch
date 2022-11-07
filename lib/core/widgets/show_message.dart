import 'package:flutter/material.dart';

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Theme.of(context).primaryColor,
      content: Text(message),
      action: SnackBarAction(
        label: "Fechar",
        textColor: Colors.white,
        onPressed: () {},
      ),
    )
  );
}