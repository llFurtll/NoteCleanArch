import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import './arguments/arguments_share.dart';
import 'create.dart';
import '../../components/show_message.dart';

// ignore: must_be_immutable
class ShowPdfShare extends StatelessWidget {
  Future<Uint8List>? pdf;

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as ArgumentsShare;
    final screen = arguments.screen as CreateNoteState;
    
    return Scaffold(
      appBar: _buildAppBar(arguments, context),
      body: PdfPreview(
        useActions: false,
        pdfFileName: "anotacao-${screen.id}",
        build: (context) async {
          pdf = makePdf(arguments);
          return pdf!;
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

          final tempPdf = await pdf;

          final response = await _shareFile(tempPdf!, arguments.screen as CreateNoteState);

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

  Future<String> _shareFile(Uint8List list, CreateNoteState screen) async {
    try {
      final path = (await getApplicationDocumentsDirectory()).path;
      final dirShare = Directory("$path/share/pdf");

      if (!dirShare.existsSync()) {
        dirShare.createSync(recursive: true);
      }

      File pdfFile = File("${dirShare.path}/anotacao-${screen.id}.pdf");

      await pdfFile.writeAsBytes(list);

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

  Future<Uint8List> makePdf(ArgumentsShare arguments) async {
    final pdf = pw.Document();
    final paragraps = arguments.anotacaoModel.observacao!.split("\n");

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              mainAxisSize: pw.MainAxisSize.max,
              children: [
                pw.Header(
                  padding: pw.EdgeInsets.only(bottom: 1.0),
                  level: 1,
                  text: arguments.anotacaoModel.titulo,
                  textStyle: pw.TextStyle(
                    fontSize: 25.0,
                    fontWeight: pw.FontWeight.bold,
                  )
                ),
                ...paragraps.map((e) => pw.Paragraph(
                  text: e
                ))
              ]
            ),
          ];
        }
      )
    );

    return pdf.save();
  }
}