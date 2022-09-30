import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

import '../domain/editor/ieditor.dart';
import '../pages/createpage/create.dart';
import '../components/show_message.dart';

class HtmlEditorNote implements IEditor<CreateNoteState> {
  final CreateNoteState _screen;
  final HtmlEditorController _controllerEditor = HtmlEditorController();
  
  Color _foreColorSelected = Colors.black;
  Color _backgroundColorSelected = Colors.yellow;

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
            source: "document.getElementsByClassName('note-placeholder')[0].style.color='black';"
          );
          if (_screen.id != null) {
            setText(_screen.anotacao!.observacao!);
          }
        },
        onNavigationRequestMobile: (String url) async {
          Uri urlTo = Uri.parse(url);
          if (await canLaunchUrl(urlTo)) {
            await launchUrl(urlTo);
          } else {
            MessageDefaultSystem.showMessage(_screen.context, "Link inserido não é válido!");
          }

          return NavigationActionPolicy.CANCEL;
        },
      ),
      otherOptions: OtherOptions(
        decoration: BoxDecoration(
          color: Colors.transparent
        ),
      ),
      htmlEditorOptions: HtmlEditorOptions(
        hint: "<p>Comece a digitar aqui...</p>",
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
          toolbarPosition: ToolbarPosition.aboveEditor,
          onButtonPressed: (ButtonType type, bool? status, Function()? updateStatus) async {
            if (type == ButtonType.foregroundColor || type == ButtonType.highlightColor) {
              bool isBackgroundColor = type == ButtonType.highlightColor;
              if (status!) {
                updateStatus!();
                _clearColor(isBackgroundColor);
                return false;
              }

              int selected = await _showColorText(isBackgroundColor);

              if (selected == 0) {
                return false;
              } else if (selected == 1) {
                _clearColor(isBackgroundColor);
              } else {
                updateStatus!();
              }

              return false;
            } else {
              return await _buttonPressed(type);
            }
          }
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
                  buttonSelectedColor: Theme.of(_screen.context).primaryColor,
                  buttonFillColor: Theme.of(_screen.context).primaryColor.withOpacity(0.3),
                  defaultToolbarButtons: [
                    ListButtons(),
                    InsertButtons()
                  ],
                  toolbarPosition: ToolbarPosition.belowEditor,
                  onButtonPressed: (ButtonType type, bool? status, Function()? updateStatus) async => await _buttonPressed(type)
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
      case ButtonType.link:
        await _showDialogLink();
        return false;
      case ButtonType.table:
        await _showTable();
        return false;
      default:
        return true;
    }
  }

  // Link
  Future<void> _showDialogLink() async {
    final text = TextEditingController();
    final url = TextEditingController();
    final textFocus = FocusNode();
    final urlFocus = FocusNode();
    final formKey = GlobalKey<FormState>();
    await showDialog(
      context: _screen.context,
      builder: (BuildContext context) {
        return PointerInterceptor(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: Text('Inserir link'),
                scrollable: true,
                content: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Texto de exibição',
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        )
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: text,
                        focusNode: textFocus,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Texto',
                        ),
                        onSubmitted: (_) {
                          urlFocus.requestFocus();
                        },
                      ),
                      SizedBox(height: 20),
                      Text(
                        'URL',
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        )
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: url,
                        focusNode: urlFocus,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'URL',
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira uma URL!';
                          } else if (!value.contains("http")) {
                            return 'Por favor, insira uma URL válida!';
                          }
                          return null;
                        }
                      )
                    ]),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      _controllerEditor.insertHtml(
                        """
                          <a href="${url.text}" target="new">${text.text}</a><br>
                        """
                      );
                      // _controllerEditor.insertLink(text.text, url.text, true);
                      Navigator.of(context).pop();
                      print(await getText());
                    }
                  },
                  child: Text('OK'),
                )
              ],
            );
          }),
        );
      }
    );
  }

  // Image, audio and video
  Future<void> _showDialogMedia(ButtonType type) async {
    final filename = TextEditingController();
    final url = TextEditingController();
    final urlFocus = FocusNode();
    String title = "";
    String escolherArquivo = "";
    String? validateFailed;
    if (type == ButtonType.picture) {
      title = "Inserir imagem";
      escolherArquivo = "Escolher imagem";
    } else if (type == ButtonType.video) {
      title = "Inserir video";
      escolherArquivo = "Escolher video";
    } else {
      title = "Inserir audio";
      escolherArquivo = "Escolher audio";
    }
    FilePickerResult? result;
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
                        primary: Theme.of(context).dialogBackgroundColor,
                        padding: EdgeInsets.only(left: 0, right: 0),
                        elevation: 0.0
                      ),
                      onPressed: () async {
                        if (type == ButtonType.picture) {
                          result = await FilePicker.platform
                            .pickFiles(
                              type: FileType.image,
                              withData: true
                            );
                        } else if (type == ButtonType.video) {
                          result = await FilePicker.platform
                            .pickFiles(
                              type: FileType.video,
                              withData: true
                            );
                        } else {
                          result = await FilePicker.platform
                            .pickFiles(
                              type: FileType.audio,
                              withData: true
                            );
                        }
                        if (result?.files.single.name != null) {
                          setState(() {
                            filename.text = result!.files.single.name;
                          });
                        }
                      },
                      child: Padding(
                          padding: EdgeInsets.zero,
                          child: Text(
                            escolherArquivo,
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodyText1?.color,
                            )
                          ),
                        ),
                      ),
                      suffixIcon: result != null ? 
                        IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                result = null;
                                filename.text = '';
                              });
                            }
                          )
                        : SizedBox.shrink(),
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
                        if (type == ButtonType.picture) {
                          validateFailed = "Escolha uma imagem ou insira uma URL de imagem!";
                        } else if (type == ButtonType.video) {
                          validateFailed = "Escolha um arquivo de video ou insira uma URL de video!";
                        } else {
                          validateFailed = "Escolha um arquivo de audio ou insira uma URL de audio!";
                        }
                      });
                    } else if (filename.text.isNotEmpty && url.text.isNotEmpty) {
                      setState(() {
                        if (type == ButtonType.picture) {
                          validateFailed = "Insira uma imagem ou uma URL de imagem, não ambos!";
                        } else if (type == ButtonType.video) {
                          validateFailed = "Insira um arquivo de video ou uma URL de video, não ambos!";
                        } else {
                          validateFailed = "Insira um arquivo de audio ou uma URL de audio, não ambos!";
                        }
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

  // Table
  Future<void> _showTable() async {
    var currentRows = 1;
    var currentCols = 1;
    await showDialog(
      context: _screen.context,
      builder: (BuildContext context) {
        return PointerInterceptor(
          child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Inserir tabela'),
              scrollable: true,
              content: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  NumberPicker(
                    value: currentRows,
                    minValue: 1,
                    maxValue: 10,
                    onChanged: (value) => setState(() => currentRows = value),
                  ),
                  Text('x'),
                  NumberPicker(
                    value: currentCols,
                    minValue: 1,
                    maxValue: 10,
                    onChanged: (value) => setState(() => currentCols = value),
                  ),
                ]
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () async {
                    await _controllerEditor.editorController!
                      .evaluateJavascript(
                        source: "\$('#summernote-2').summernote('insertTable', '${currentRows}x$currentCols');"
                      );
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                )
              ],
            );
          }),
        );
      }
    );
  }

  Future<int> _showColorText(bool isBackgroundColor) async {
    Color newColor;
    if (isBackgroundColor) {
      newColor = _backgroundColorSelected;
    } else {
      newColor = _foreColorSelected;
    }
    return await showDialog(
      context: _screen.context,
      builder: (BuildContext context) {
        return PointerInterceptor(
          child: AlertDialog(
            title: Text('Escolher a cor', style: Theme.of(context).textTheme.headline6),
            scrollable: true,
            content: ColorPicker(
              color: newColor,
              onColorChanged: (color) {
                newColor = color;
              },
              spacing: 0,
              padding: EdgeInsets.only(bottom: 0.0),
              runSpacing: 0,
              borderRadius: 0,
              wheelDiameter: 165,
              enableOpacity: false,
              showColorCode: false,
              colorCodeHasColor: false,
              enableShadesSelection: false,
              pickersEnabled: <ColorPickerType, bool>{
                ColorPickerType.wheel: true,
                ColorPickerType.primary: false,
                ColorPickerType.accent: false,
              }
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(0);
                    },
                    child: Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () {
                      _clearColor(isBackgroundColor);
                      Navigator.of(context).pop(1);
                    },
                    child: Text(isBackgroundColor ? 'Remover fundo' : 'Cor padrão')
                  ),
                  TextButton(
                    onPressed: () {
                      if (isBackgroundColor) {
                        _controllerEditor.execCommand('hiliteColor',
                          argument: (newColor.value & 0xFFFFFF)
                            .toRadixString(16)
                            .padLeft(6, '0')
                            .toUpperCase()
                          );
                          _backgroundColorSelected = newColor;
                      } else {
                        _controllerEditor.execCommand(
                          'foreColor',
                          argument: (newColor.value & 0xFFFFFF)
                            .toRadixString(16)
                            .padLeft(6, '0')
                            .toUpperCase()
                        );
                        _foreColorSelected = newColor;
                      }
                      Navigator.of(context).pop(2);
                    },
                    child: Text('Definir cor'),
                  )
                ],
              )
            ],
          ),
        );
      }
    );
  }

  void _clearColor(bool isBackgroundColor) {
    if (isBackgroundColor) {
      _backgroundColorSelected = Colors.yellow;
      _controllerEditor.execCommand(
        'removeFormat',
        argument: 'hiliteColor'
      );
      _controllerEditor.execCommand(
        'hiliteColor',
        argument: 'initial'
      );
    } else {
      _foreColorSelected = Colors.black;
      _controllerEditor.execCommand(
        'removeFormat',
        argument: 'foreColor'
      );
      _controllerEditor.execCommand(
        'foreColor',
        argument: (_foreColorSelected.value & 0xFFFFFF)
          .toRadixString(16)
          .padLeft(6, '0')
          .toUpperCase()
      );
    }
  }
}