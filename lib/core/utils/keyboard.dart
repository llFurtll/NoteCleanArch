import 'package:flutter/services.dart';

void hideKeyboard() {
  SystemChannels.textInput.invokeMethod('TextInput.hide');
}

void showKeyboard() {
  SystemChannels.textInput.invokeMethod("TextInput.show");
}