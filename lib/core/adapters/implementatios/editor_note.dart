import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../features/config_app/domain/usecases/config_app_use_case.dart';
import '../../../features/note/presentation/pages/principal/create.dart';
import '../../dependencies/repository_injection.dart';
import '../../widgets/show_message.dart';
import '../interfaces/ieditor.dart';

class HtmlEditorNote implements IEditor<CreateNoteState> {
  final CreateNoteState _screen;
  final HtmlEditorController _controllerEditor = HtmlEditorController();
  
  late final Map<String?, int?> configs;

  Color _foreColorSelected = Colors.black;
  Color _backgroundColorSelected = Colors.yellow;
  bool _showButtonOpenKeyboardOptions = false;

  HtmlEditorNote(this._screen);

  void init() {
    return;
  }

  void loadBindings() async {
    final configAppUseCase = ConfigAppUseCase(repository: RepositoryInjection.of(_screen.context)!.configAppRepository);
    configs = await configAppUseCase.getAllConfigs(modulo: "NOTE");
    _screen.carregandoConfigs.value = false;
  }

  @override
  Widget constructor() {
    return HtmlEditor(
      controller: _controllerEditor,
      callbacks: Callbacks(
        onInit: () async {
          _controllerEditor.setFullScreen();
          _controllerEditor.execCommand('fontName', argument: 'arial');
          _controllerEditor.editorController!.evaluateJavascript(
            source: """
              var style = document.createElement('style');
              style.type = 'text/css';
              style.innerHTML = `
                table,
                table td {
                    border-color: black !important;
                    border-collapse: separate; /* This line */
                }

                .note-placeholder {
                  color: black !important;
                }

                .note-editable {
                  background-color: transparent !important;
                }

                hr {
                  border-color: black !important;
                }
              `;
              document.getElementsByTagName('head')[0].appendChild(style);
            """
          );
          if (_screen.id != null && _screen.note.observacao!.isNotEmpty) {
            setText(_screen.note.observacao!);
          }
        },
        onFocus: () {
          if (_screen.focusTitle.hasFocus) {
            _screen.focusTitle.unfocus();
          }
        },
        onChangeContent: (String? value) {
          _screen.emitComponentAutoSave();
        },
        onNavigationRequestMobile: (String url) async {
          Uri urlTo = Uri.parse(url);
          if (await canLaunchUrl(urlTo)) {
            await launchUrl(urlTo);
          } else {
            showMessage(_screen.context, "Link inserido não é válido!");
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
        customOptions: """
          popover: {
            image: [
              ['image', ['resizeFull', 'resizeHalf', 'resizeQuarter', 'resizeNone']],
              ['float', ['floatLeft', 'floatRight', 'floatNone']],
              ['remove', ['removeMedia']]
            ],
            link: [
              ['link', ['unlink']]
            ],
            table: [
              ['add', ['addRowDown', 'addRowUp', 'addColLeft', 'addColRight']],
              ['delete', ['deleteRow', 'deleteCol', 'deleteTable']],
            ],
          },
        """,
      ),
      htmlToolbarOptions: HtmlToolbarOptions(
        toolbarPosition: ToolbarPosition.custom,
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
  void insertHtml(String html) {
    _controllerEditor.insertHtml(html);
  }

  @override
  void insertText(String text) {
    _controllerEditor.insertText(text);
  }

  @override
  Widget options() {
    bool redoUndo = (configs["MOSTRAREVERTERPRODUZIRALTERACOES"] ?? 1) == 1;
    bool bold = (configs["MOSTRANEGRITO"] ?? 1) == 1;
    bool italic = (configs["MOSTRAITALICO"] ?? 1) == 1;
    bool underline = (configs["MOSTRASUBLINHADO"] ?? 1) == 1;
    bool strikethrough = (configs["MOSTRARISCADO"] ?? 1) == 1;
    bool alignLeft = (configs["MOSTRAALINHAMENTOESQUERDA"] ?? 1) == 1;
    bool alignCenter = (configs["MOSTRAALINHAMENTOCENTRO"] ?? 1) == 1;
    bool alignRight = (configs["MOSTRAALINHAMENTODIREITA"] ?? 1) == 1;
    bool alignJustify = (configs["MOSTRAJUSTIFICADO"] ?? 1) == 1;
    bool increaseIndent = (configs["MOSTRATABULACAODIREITA"] ?? 1) == 1;
    bool decreaseIndent = (configs["MOSTRATABULACAOESQUERDA"] ?? 1) == 1;
    bool lineHeight = (configs["MOSTRAESPACAMENTOLINHAS"] ?? 1) == 1;
    bool foregroundColor = (configs["MOSTRACORLETRA"] ?? 1) == 1;
    bool highlightColor = (configs["MOSTRACORFUNDOLETRA"] ?? 1) == 1;

    if (
      !redoUndo && !bold && !italic && !underline && !strikethrough &&
      !alignLeft && !alignCenter && !alignRight && !alignJustify && !increaseIndent && !decreaseIndent &&
      !lineHeight && !foregroundColor && !highlightColor
    ) {
      return SizedBox.shrink();
    }

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
              redo: redoUndo,
              undo: redoUndo,
              help: false,
              codeview: false,
              fullscreen: false,
              copy: false,
              paste: false
            ),
            FontButtons(
              bold: bold,
              italic: italic,
              underline: underline,
              strikethrough: strikethrough,
              subscript: false,
              superscript: false,
              clearAll: false
            ),
            ParagraphButtons(
              alignLeft: alignLeft,
              alignCenter: alignCenter,
              alignRight: alignRight,
              alignJustify: alignJustify,
              increaseIndent: increaseIndent,
              decreaseIndent: decreaseIndent,
              lineHeight: lineHeight,
              caseConverter: false,
              textDirection: false
            ),
            ColorButtons(
              foregroundColor: foregroundColor,
              highlightColor: highlightColor
            )
          ],
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
        if (value) {
          bool isShowOptions = !_showButtonOpenKeyboardOptions;
          return Positioned(
            child: Container(
              width: isShowOptions ? null : 40.0,
              height: isShowOptions ? null : 40.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(isShowOptions ? 0.0 : 50.0)),
                color: isShowOptions ? Colors.white : Colors.grey[300]
              ),
              child: isShowOptions ? _showOptionsKeyboard() : _iconShowOptions()
            ),
            left: isShowOptions ? 0 : null,
            right: isShowOptions ? 0 : 25,
            bottom: isShowOptions ? MediaQuery.of(context).viewInsets.bottom : 10.0,
          );
        } else {
          return SizedBox.shrink();
        }
      }
    );
  }

  void _addListIcon(List<bool> listSelected, List<Widget> icons, Icon icon, bool validate) {
    if (validate) {
      listSelected.add(false);
      icons.add(icon);
    }
  }

  Widget _showOptionsKeyboard() {
    bool mostraListaPontilhada = (configs["MOSTRALISTAPONTO"] ?? 1) == 1;
    bool mostraListaNumerica = (configs["MOSTRALINHANUMERICA"] ?? 1) == 1;
    bool mostraLink = (configs["MOSTRALINK"] ?? 1) == 1;
    bool mostraFoto = (configs["MOSTRAFOTO"] ?? 1) == 1;
    bool mostraAudio = (configs["MOSTRAAUDIO"] ?? 1) == 1;
    bool mostraVideo = (configs["MOSTRAVIDEO"] ?? 1) == 1;
    bool mostraTabela = (configs["MOSTRATABELA"] ?? 1) == 1;
    bool mostraSeparador = (configs["MOSTRASEPARADOR"] ?? 1) == 1;

    if (
      !mostraListaPontilhada && !mostraListaNumerica &&
      !mostraLink && !mostraFoto && !mostraAudio &&
      !mostraVideo && !mostraTabela && !mostraSeparador
    ) {
      return SizedBox.shrink();
    }

    List<bool> isSelectedLista = [];
    List<Widget> iconsLista = [];

    List<bool> isSelectedButtonsMedia = [];
    List<Widget> iconsButtosnMedia = [];

    _addListIcon(isSelectedLista, iconsLista, Icon(Icons.format_list_bulleted), mostraListaPontilhada);
    _addListIcon(isSelectedLista, iconsLista, Icon(Icons.format_list_numbered), mostraListaNumerica);

    _addListIcon(isSelectedButtonsMedia, iconsButtosnMedia, Icon(Icons.link), mostraLink);
    _addListIcon(isSelectedButtonsMedia, iconsButtosnMedia, Icon(Icons.image_outlined), mostraFoto);
    _addListIcon(isSelectedButtonsMedia, iconsButtosnMedia, Icon(Icons.audiotrack_outlined), mostraAudio);
    _addListIcon(isSelectedButtonsMedia, iconsButtosnMedia, Icon(Icons.videocam_outlined), mostraVideo);
    _addListIcon(isSelectedButtonsMedia, iconsButtosnMedia, Icon(Icons.table_chart_outlined), mostraTabela);
    _addListIcon(isSelectedButtonsMedia, iconsButtosnMedia, Icon(Icons.horizontal_rule), mostraSeparador);

    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          iconsLista.length > 0 ?
          ToggleButtons(
            constraints: BoxConstraints.tightFor(
              height: 34,
              width: 34
            ),
            renderBorder: false,
            isSelected: isSelectedLista,
            onPressed: (int index) {
              if (index == 0) {
                _controllerEditor.execCommand("insertUnorderedList");
              } else {
                _controllerEditor.execCommand("insertOrderedList");
              }
            },
            children: iconsLista,
          ) : SizedBox.shrink(),
          iconsLista.length > 0 ?
          SizedBox(
            height: 40.0,
            child: VerticalDivider(indent: 2, endIndent: 2, color: Colors.grey),
          ) : SizedBox.shrink(),
          iconsButtosnMedia.length > 0 ?
          ToggleButtons(
            constraints: BoxConstraints.tightFor(
              height: 34,
              width: 34
            ),
            isSelected: isSelectedButtonsMedia,
            renderBorder: false,
            onPressed: (int index) async {
              Widget widget = iconsButtosnMedia[index];
              if (widget.runtimeType == Icon) {
                ButtonType? type;
                Icon icon = widget as Icon;

                if(icon.icon == Icons.link) {
                  type = ButtonType.link;
                } else if(icon.icon == Icons.image_outlined) {
                  type = ButtonType.picture;
                } else if(icon.icon == Icons.audiotrack_outlined) {
                  type = ButtonType.audio;
                } else if(icon.icon == Icons.videocam_outlined) {
                  type = ButtonType.video;
                } else if(icon.icon == Icons.table_chart_outlined) {
                  type = ButtonType.table;
                } else if(icon.icon == Icons.horizontal_rule) {
                  type = ButtonType.hr;
                  _controllerEditor.insertHtml("<hr />");
                } else {
                  type = null;
                }

                if (type != null) {
                  await _buttonPressed(type);
                }
              }
            },
            children: iconsButtosnMedia,
          ) : SizedBox.shrink(),
          iconsButtosnMedia.length > 0 ?
          SizedBox(
            height: 40.0,
            child: VerticalDivider(indent: 2, endIndent: 2, color: Colors.grey),
          ) : SizedBox.shrink(),
          ToggleButtons(
            constraints: BoxConstraints.tightFor(
              height: 34,
              width: 34
            ),
            renderBorder: false,
            onPressed: (int index) {
              _showButtonOpenKeyboardOptions = true;
              _screen.keyboardVisible.emitChange();
            },
            children: [
              Icon(Icons.close)
            ],
            isSelected: [false]
          ),
        ],
      ),
    );
  }

  Widget _iconShowOptions() {
    return Tooltip(
      message: "Exibir barra de ferramentas",
      preferBelow: false,
      child: IconButton(
        onPressed: () {
          _showButtonOpenKeyboardOptions = false;
          _screen.keyboardVisible.emitChange();
        },
        icon: Icon(Icons.arrow_upward)
      ),
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
                      TextFormField(
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira um texto para exibição!';
                          }
                          return null;
                        },
                        controller: text,
                        focusNode: textFocus,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: "Texto",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                              color: Theme.of(_screen.context).primaryColor
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                              color: Theme.of(_screen.context).primaryColor
                            ),
                          ),
                          errorMaxLines: 2
                        ),
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
                          hintText: "URL",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                              color: Theme.of(_screen.context).primaryColor
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                              color: Theme.of(_screen.context).primaryColor
                            ),
                          ),
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
                  child: Text('Cancelar', style: TextStyle(color: Theme.of(context).primaryColor)),
                ),
                TextButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      _controllerEditor.insertLink(text.text, url.text, true);
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('OK', style: TextStyle(color: Theme.of(context).primaryColor)),
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
      barrierDismissible: false,
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
                    hintText: 'URL',
                    errorText: validateFailed,
                    errorMaxLines: 2,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                        color: Theme.of(_screen.context).primaryColor
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                        color: Theme.of(_screen.context).primaryColor
                      ),
                    ),
                  ),
                ),
              ]),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancelar', style: TextStyle(color: Theme.of(context).primaryColor)),
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
                  child: Text('OK', style: TextStyle(color: Theme.of(context).primaryColor)),
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
      barrierDismissible: false,
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
                  child: Text('Cancelar', style: TextStyle(color: Theme.of(context).primaryColor)),
                ),
                TextButton(
                  onPressed: () async {
                    await _controllerEditor.editorController!
                      .evaluateJavascript(
                        source: "\$('#summernote-2').summernote('insertTable', '${currentRows}x$currentCols');"
                      );
                    Navigator.of(context).pop();
                  },
                  child: Text('OK', style: TextStyle(color: Theme.of(context).primaryColor)),
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
      barrierDismissible: false,
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
                    child: Text('Cancelar', style: TextStyle(color: Theme.of(context).primaryColor)),
                  ),
                  TextButton(
                    onPressed: () {
                      _clearColor(isBackgroundColor);
                      Navigator.of(context).pop(1);
                    },
                    child: Text(isBackgroundColor ? 'Remover fundo' : 'Cor padrão', style: TextStyle(color: Theme.of(context).primaryColor))
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
                    child: Text('Definir cor', style: TextStyle(color: Theme.of(context).primaryColor)),
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