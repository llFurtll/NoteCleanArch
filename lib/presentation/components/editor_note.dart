
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';

import '../domain/editor/ieditor.dart';
import '../pages/createpage/create.dart';

class HtmlEditorNote implements IEditor<CreateNoteState> {
  final CreateNoteState _screen;
  final HtmlEditorController _controllerEditor = HtmlEditorController();

  HtmlEditorNote(this._screen);

  @override
  Widget constructor() {
    return HtmlEditor(
      controller: _controllerEditor,
      callbacks: Callbacks(
        onInit: () {
          _controllerEditor.setFullScreen();
          Future.delayed((Duration(milliseconds: 500)), () {
              _controllerEditor.editorController!
              .evaluateJavascript(
              source: "document.getElementsByClassName('note-editable')[0].style.backgroundColor='transparent';"
            );
            _controllerEditor.editorController!
              .evaluateJavascript(
              source: "document.getElementsByClassName('note-placeholder')[0].style.color='black';"
            );
          });
        },
      ),
      otherOptions: OtherOptions(
        decoration: BoxDecoration(
          color: Colors.transparent
        ),
      ),
      htmlEditorOptions: HtmlEditorOptions(
        hint: "Comece a digitar aqui...",
      ),
      htmlToolbarOptions: HtmlToolbarOptions(
        toolbarPosition: ToolbarPosition.custom
      ),
    );
  }

  @override
  Future<String> getText() async {
    return await _controllerEditor.getText();
  }

  @override
  void setText(String text) {
    _controllerEditor.setText(text);
  }

  @override
  Widget options() {
    return Container(
      color: Colors.white,
      child: ToolbarWidget(
        controller: _controllerEditor,
        callbacks: null,
        htmlToolbarOptions: HtmlToolbarOptions(
          buttonSelectedColor: Theme.of(_screen.context).primaryColor,
          buttonFillColor: Theme.of(_screen.context).primaryColor.withOpacity(0.3),
          defaultToolbarButtons: [
            OtherButtons(
              redo: true,
              undo: true,
              help: false,
              codeview: false,
              fullscreen: false,
            ),
            FontSettingButtons(
              fontSizeUnit: false
            ),
            FontButtons(
              subscript: false,
              superscript: false
            ),
            ParagraphButtons(
              caseConverter: false,
              textDirection: false
            ),
            ColorButtons()
          ],
          toolbarPosition: ToolbarPosition.aboveEditor
        ),
      ),
    );
  }

  @override
  Widget optionsKeyboard() {
    return ValueListenableBuilder<bool>(
      valueListenable: _screen.keyboardVisible,
      builder: (BuildContext context, bool value, Widget? widget) {
        return Visibility(
          visible: _screen.keyboardVisible.value,
          child: Positioned(
            child: Container(
              color: Colors.white,
              child: ToolbarWidget(
                controller: _controllerEditor,
                htmlToolbarOptions: HtmlToolbarOptions(
                  defaultToolbarButtons: [
                    ListButtons(),
                    InsertButtons()
                  ],
                  toolbarPosition: ToolbarPosition.belowEditor,
                ),
                callbacks: null,
              ),
            ),
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
        );
      }
    );
  }
}