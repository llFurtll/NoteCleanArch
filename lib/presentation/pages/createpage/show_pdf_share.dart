import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import './arguments/arguments_share.dart';
import 'create.dart';
import '../../components/show_message.dart';

// ignore: must_be_immutable
class ShowPdfShare extends StatelessWidget {

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

    String html;
    if (showImage && image.isNotEmpty) {
      html = """
        <div style="background-image: url('data:image/png;base64, $image'); width: 100%; height: 100%; opacity: 0.5;">
          <div style='height: 100%; width: 100%; opacity: 1;'>
            ${arguments.anotacaoModel.observacao}
          </div>
        </div>
      """;
    } else {
      html = arguments.anotacaoModel.observacao!;
    }

    print(html);

    File pdf = await FlutterHtmlToPdf.convertFromHtmlContent(
      html,
      dirShare.path,
      "anotacao-${screen.id}"
    );
    
    // final pdfDocument = pw.Document();
    // final backgroundImage = arguments.anotacaoModel.imagemFundo!;
    // final showImage = arguments.showImage;
    // dynamic image;

    

    // print("PASOU 2");

    // pdfDocument.addPage(
    //   pw.Page(
    //     pageTheme: pw.PageTheme(
    //       margin: pw.EdgeInsets.zero,
    //       buildBackground: (context) {
    //         return image == null || !showImage ? pw.Container() : pw.Opacity(
    //           opacity: 0.5,
    //           child: pw.Container(
    //             child: pw.Image(image, fit: pw.BoxFit.cover)
    //           ),
    //         );
    //       },
    //       pageFormat: PdfPageFormat.a4,
    //     ),
    //     build: (context) {
    //       return pw.Container();
    //     }
    //   )
    // );

    // print("PASOU 3");

    // final bytes = await pdfDocument.save();

    // pdf.writeAsBytes(bytes);

    return pdf.readAsBytes();
  }
}