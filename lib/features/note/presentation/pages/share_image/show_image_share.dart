import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;
import 'package:share_plus/share_plus.dart';

import '../../../../../../core/widgets/show_message.dart';
import '../../../../../../core/widgets/show_loading.dart';
import '../arguments/arguments_share.dart';
import '../principal/create.dart';

class ShowImageShare extends StatelessWidget {
  static final String routeShowImageShare = "/share/image";

  final GlobalKey _boundary = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final ArgumentsShare arguments = ModalRoute.of(context)!.settings.arguments as ArgumentsShare;

    return Scaffold(
      appBar: _buildAppBar(context, arguments),
      backgroundColor: Colors.grey[200],
      body: _buildBody(arguments),
    );
  }

  AppBar _buildAppBar(BuildContext context, ArgumentsShare arguments) {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Icon(Icons.arrow_back_ios),
        color: Colors.white,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      title: Text("Compartilhar anotação"),
      centerTitle: true,
      actions: _buildActions(arguments, context),
    );
  }

  List<Widget> _buildActions(ArgumentsShare arguments, BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          _shareFile(arguments, context);
        },
        icon: Icon(Icons.share),
      ),
    ];
  }

  Widget _buildBody(ArgumentsShare arguments) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.0),
      child: _buildCard(arguments)
    );
  }

  Widget _buildCard(ArgumentsShare arguments) {
    final screen = arguments.screen as CreateNoteState;
    final showImage = arguments.showImage;

    return RepaintBoundary(
      key: _boundary,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.0),
        elevation: 10.0,
          child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            image: !showImage ? null : DecorationImage(
              image: screen.pathImage.contains('lib') ?
                AssetImage(screen.pathImage) as ImageProvider :
                FileImage(File(screen.pathImage)),
              fit: BoxFit.cover,
            ),
          ),
          constraints: BoxConstraints(
            minHeight: 500.0
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: Colors.white.withOpacity(0.5),
            ),
            constraints: BoxConstraints(
              minHeight: 500.0
            ),
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 5.0),
                    child: Text(
                      arguments.note.titulo!,
                      style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0
                    ),
                  ),
                ),
                Html(
                  data: """
                    <html>
                      <head>
                        <style>
                          .table {
                            border-spacing: 0;
                            border-collapse: collapse;
                          }
                          
                          .table tbody tr td {
                            border: 1px solid black;
                          }
                          
                          .table tbody tr td {
                            padding: 5px;
                            max-width: auto;
                          }
                        </style>
                      </head>
                      <body>
                        ${arguments.note.observacao!}
                      </body
                    </html>
                  """
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _shareFile(ArgumentsShare arguments, BuildContext context) async {
    showLoading(context);

    final screen = arguments.screen as CreateNoteState;
    final response = await _createImageShare(screen);

    Navigator.of(context).pop();

    if (response.isNotEmpty) {
      Share.shareFiles([response]);
    } else {
      showMessage(context, "Não foi possível gerar a imagem!");
    }
  }

  Future<String> _createImageShare(CreateNoteState screen) async {
    try {
      RenderRepaintBoundary boundary = _boundary.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: MediaQuery.of(screen.context).devicePixelRatio);

      final path = (await getApplicationDocumentsDirectory()).path;
      final dirShare = Directory("$path/share/image");

      if (!dirShare.existsSync()) {
        dirShare.createSync(recursive: true);
      }

      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      File imgFile = File("${dirShare.path}/anotacao-${screen.id}.png");

      await imgFile.writeAsBytes(pngBytes);

      return imgFile.path;
    } catch (e) {
      return "";
    }
  }
}