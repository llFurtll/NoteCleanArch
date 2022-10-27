import 'package:flutter/material.dart';

abstract class IEditor<T extends State> {
  Widget constructor();
  Widget options();
  Widget optionsKeyboard();
  Future<String> getText();
  void setText(String text);
  void insertHtml(String html);
  void insertText(String text);
}