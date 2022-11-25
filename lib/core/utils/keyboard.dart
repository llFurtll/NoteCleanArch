import 'package:flutter/services.dart';

void hideKeyboard() {
  SystemChannels.textInput.invokeMethod('TextInput.hide');
}

void showKeyboard() {
  print("CJAMPU");
  SystemChannels.textInput.invokeMethod("TextInput.show");
}