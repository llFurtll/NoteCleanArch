import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

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
          _controllerEditor.editorController!.evaluateJavascript(
            source: "document.getElementsByClassName('note-editable')[0].style.backgroundColor='transparent';"
          );
          _controllerEditor.editorController!.evaluateJavascript(
            source: "document.getElementsByClassName('note-placeholder')[0].style.backgroundColor='transparent';"
          );
        }
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
  void setText(String text) async {
    while (true) {
      bool isLoading = await _controllerEditor.editorController!.isLoading();
      if (!isLoading) {
        _controllerEditor.setText(text);
        break;
      }
    }
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
                  onButtonPressed:
                    (ButtonType type, bool? status, Function()? updateStatus) async => await _buttonPressed(type)
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
  
  Future<bool> _buttonPressed(ButtonType type) async {
    switch (type) {
      case ButtonType.picture:
      case ButtonType.video:
      case ButtonType.audio:
        await _showDialogMedia(type);
        return false;
      default:
        return true;
    }
  }

  // Image, audio and video
  Future<void> _showDialogMedia(ButtonType type) async {
    final filename = TextEditingController();
    final url = TextEditingController();
    final urlFocus = FocusNode();
    String title = "";
    if (type == ButtonType.picture) {
      title = "Inserir imagem";
    } else if (type == ButtonType.video) {
      title = "Inserir video";
    } else {
      title = "Inserir audio";
    }
    FilePickerResult? result;
    String? validateFailed;
    await showDialog(
      context: _screen.context,
      builder: (BuildContext context) {
        return PointerInterceptor(
          child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(title),
              scrollable: true,
              content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selecionar arquivos',
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                    )
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: filename,
                  readOnly: true,
                  decoration: InputDecoration(
                    prefixIcon: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context)
                              .dialogBackgroundColor,
                          padding: EdgeInsets.only(
                              left: 5, right: 5),
                          elevation: 0.0),
                      onPressed: () async {
                        result = await FilePicker.platform
                            .pickFiles(
                          type: FileType.image,
                          withData: true
                        );
                        if (result?.files.single.name !=
                            null) {
                          setState(() {
                            filename.text =
                                result!.files.single.name;
                          });
                        }
                      },
                      child: Text(
                        'Escolher imagem',
                        style: TextStyle(
                          color: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.color
                          )
                        ),
                      ),
                      suffixIcon: result != null
                        ? IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                result = null;
                                filename.text = '';
                              });
                            }
                          )
                        : Container(height: 0, width: 0),
                    errorText: validateFailed,
                    errorMaxLines: 2,
                    border: InputBorder.none,
                    )
                ),
                SizedBox(height: 20),
                Text('URL', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                TextField(
                  controller: url,
                  focusNode: urlFocus,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'URL',
                    errorText: validateFailed,
                    errorMaxLines: 2,
                  ),
                ),
              ]),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () async {
                    if (filename.text.isEmpty && url.text.isEmpty) {
                      setState(() {
                        validateFailed = 'Escolha uma imagem ou insira uma URL de imagem!';
                      });
                    } else if (filename.text.isNotEmpty && url.text.isNotEmpty) {
                      setState(() {
                        validateFailed = 'Insira uma imagem ou uma URL de imagem, não ambos!';
                      });
                    } else if (filename.text.isNotEmpty && result?.files.single.bytes != null) {
                        var base64Data = base64
                          .encode(result!.files.single.bytes!);
                        if (type == ButtonType.picture) {
                          _controllerEditor.insertHtml(
                              "<img src='data:image/${result!.files.single.extension};base64,$base64Data' data-filename='${result!.files.single.name}'/>"
                          );
                        } else if (type == ButtonType.audio) {
                           _controllerEditor.insertHtml(
                              "<audio controls src='data:audio/${result!.files.single.extension};base64,$base64Data' data-filename='${result!.files.single.name}'></audio>"
                            );
                        } else {
                          _controllerEditor.insertHtml(
                            "<video controls src='data:video/${result!.files.single.extension};base64,$base64Data' data-filename='${result!.files.single.name}'></video>"
                          );
                        }
                        Navigator.of(context).pop();
                    } else {
                        _controllerEditor.insertNetworkImage(url.text);
                        Navigator.of(context).pop();
                    }
                  },
                  child: Text('OK'),
                )
              ],
            );
          }),
        );
    });
  }
}