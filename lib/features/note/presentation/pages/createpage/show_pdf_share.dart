import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note/features/note/data/model/anotacao_model.dart';
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import './arguments/arguments_share.dart';
import 'create.dart';
import '../../components/show_message.dart';

// ignore: must_be_immutable
class ShowPdfShare extends StatelessWidget {
  static String routeShowPdfShare = "/share/pdf";

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as ArgumentsShare;
    final screen = arguments.screen as CreateNoteState;
    
    return Scaffold(
      appBar: _buildAppBar(arguments, context),
      body: PdfPreview(
        useActions: false,
        build: (context) async {
          return makePdf(arguments, screen);
        },
      ),
    );
  }

  AppBar _buildAppBar(ArgumentsShare arguments, BuildContext context) {
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
        onPressed: () async {
          _showLoading(context);

          final response = await _shareFile(arguments.screen as CreateNoteState);

          Navigator.of(context).pop();

          if (response.isNotEmpty) {
            Share.shareFiles([response]);
          } else {
            MessageDefaultSystem.showMessage(context, "Não foi possível gerar o pdf!");
          }
        },
        icon: Icon(Icons.share),
      ),
    ];
  }

  Future<String> _shareFile(CreateNoteState screen) async {
    try {
      final path = (await getApplicationDocumentsDirectory()).path;
      final dirShare = Directory("$path/share/pdf");

      if (!dirShare.existsSync()) {
        dirShare.createSync(recursive: true);
      }

      File pdfFile = File("${dirShare.path}/anotacao-${screen.id}.pdf");

      return pdfFile.path;
    } catch (e) {
      return "";
    }
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

  Future<Uint8List> makePdf(ArgumentsShare arguments, CreateNoteState screen) async {
    final path = (await getApplicationDocumentsDirectory()).path;
    final dirShare = Directory("$path/share/pdf");

    if (!dirShare.existsSync()) {
      dirShare.createSync(recursive: true);
    }

    final backgroundImage = arguments.anotacaoModel.imagemFundo!;
    final showImage = arguments.showImage;
    String image = "";

    if (showImage) {
      try {
        if (backgroundImage.contains("lib")) {
          ByteData bytes = await rootBundle.load(backgroundImage);
          image = base64Encode(pw.MemoryImage(bytes.buffer.asUint8List()).bytes);
        } else {
          image = base64Encode(pw.MemoryImage(
            File(backgroundImage).readAsBytesSync()
          ).bytes);
        }
      } catch (e) {
        image = "";
      }
    }

    String html = _generateHtml(showImage && image.isNotEmpty, image, arguments.anotacaoModel);

    File pdf = await FlutterHtmlToPdf.convertFromHtmlContent(
      html,
      dirShare.path,
      "anotacao-${screen.id}"
    );

    return pdf.readAsBytes();
  }

  String _generateHtml(bool showImage, String image, AnotacaoModel anotacaoModel) {
    String title = anotacaoModel.titulo!;
    String observacao = anotacaoModel.observacao!;
    return """
      <!DOCTYPE html>
      <html>
        <head>
          <style>
            body {
              padding: 0;
              margin: 0;
            }

            .banner {
              position: relative;
              z-index: 5;
              ${showImage ? "min-height: 100vh;" : ""}
              max-height: 99999px;
              width: 100vw;
            }
            
            .banner .bg {
              position: absolute;
              z-index: -1;
              top: 0;
              bottom: 0;
              left: 0;
              right: 0;
              ${showImage ? "background: url('data:image/png;base64, $image');" : ""}
              opacity: .4;
              width: 100%;
              height: 100%;
            }

            .banner .content {
              padding: ${showImage ? "25px" : "0px"};
            }

            .title {
              color: black;
              font-size: 25px;
              font-weight: bold;
            }

            .banner .content .table {
              border-collapse: collapse;
            }
             
            .banner .content .table tbody tr td {
              border: 1px solid black;
            }
             
            .banner .content .table tbody tr td {
              padding: 3px;
              min-width: 100px;
              max-width: auto;
            }

            hr {
              border-color: black;
            }
          </style>
        </head>
        <body>
          <div class='banner'>
            <div class='bg'></div>
            <div class='content'>
              <span class="title">$title</span>
              $observacao
            </div>
          </div>
        </body>
        </html>
    """;
  }
}