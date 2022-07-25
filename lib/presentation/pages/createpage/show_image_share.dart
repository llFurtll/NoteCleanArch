import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;
import 'package:share_plus/share_plus.dart';

import './arguments/arguments_share.dart';
import '../createpage/create.dart';
import '../../components/show_message.dart';

class ShowImageShare extends StatelessWidget {
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
            padding: EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                    child: Text(
                    arguments.anotacaoModel.titulo!,
                    style: TextStyle(
                      color: screen.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0
                    ),
                  ),
                ),
                Text(
                  arguments.anotacaoModel.observacao!,
                  style: TextStyle(
                    color: screen.color,
                    fontSize: 18.0
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLoading(BuildContext context) {
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

  void _shareFile(ArgumentsShare arguments, BuildContext context) async {
    _showLoading(context);

    final screen = arguments.screen as CreateNoteState;
    final response = await _createImageShare(screen);

    Navigator.of(context).pop();

    if (response.isNotEmpty) {
      Share.shareFiles([response]);
    } else {
      MessageDefaultSystem.showMessage(context, "Não foi possível gerar a imagem!");
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