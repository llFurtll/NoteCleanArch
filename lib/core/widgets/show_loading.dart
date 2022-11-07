import 'package:flutter/material.dart';

void showLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return SimpleDialog(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        children: [
          Center(
            child: CircularProgressIndicator(),
          )
        ],
      );
    }
  );
}