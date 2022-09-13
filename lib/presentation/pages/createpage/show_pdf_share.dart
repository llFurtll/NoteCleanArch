import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import './arguments/arguments_share.dart';
import 'create.dart';
import '../../components/show_message.dart';

import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';

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
          return makePdf(screen);
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

  Future<Uint8List> makePdf(CreateNoteState screen) async {
    final path = (await getApplicationDocumentsDirectory()).path;
    final dirShare = Directory("$path/share/pdf");

    if (!dirShare.existsSync()) {
      dirShare.createSync(recursive: true);
    }

    File pdfFile = File("${dirShare.path}/anotacao-${screen.id}.pdf");

    File pdf = await FlutterHtmlToPdf.convertFromHtmlContent(
      "",
      pdfFile.path,
      "anotacao-${screen.id}"
    );

    return pdf.readAsBytes();

    // final pdf = pw.Document();
    // final paragraps = arguments.anotacaoModel.observacao!.split("\n");
    // final backgroundImage = arguments.anotacaoModel.imagemFundo!;
    // final showImage = arguments.showImage;
    // dynamic image;

    // if (showImage) {
    //   try {
    //     if (backgroundImage.contains("lib")) {
    //       ByteData bytes = await rootBundle.load(backgroundImage);
    //       image = pw.MemoryImage(bytes.buffer.asUint8List());
    //     } else {
    //       image = pw.MemoryImage(
    //         File(backgroundImage).readAsBytesSync()
    //       );
    //     }
    //   } catch (e) {
    //     image = null;
    //   }
    // }

    // pdf.addPage(
    //   pw.MultiPage(
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
    //       return [
    //         pw.Container(
    //           margin: pw.EdgeInsets.all(56),
    //           child: pw.Column(
    //             crossAxisAlignment: pw.CrossAxisAlignment.stretch,
    //             mainAxisSize: pw.MainAxisSize.max,
    //             children: [
    //               ...paragraps.map((e) => pw.Paragraph(
    //                 style: pw.TextStyle(
    //                   fontSize: 18.0
    //                 ),
    //                 text: e
    //               ))
    //             ]
    //           )
    //         ),
    //       ];
    //     }
    //   )
    // );

    // return pdf.save();
  }
}