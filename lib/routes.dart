import 'package:flutter/material.dart';

import 'features/note/presentation/pages/homepage/principal/home.dart';
import 'features/note/presentation/pages/homepage/info/info.dart';
import 'features/note/presentation/pages/createpage/principal/create.dart';
import 'features/note/presentation/pages/createpage/share_image/show_image_share.dart';
import 'features/note/presentation/pages/createpage/share_pdf/show_pdf_share.dart';
import 'features/configuracao/presentation/principal/configuracao.dart';
import 'features/configuracao/presentation/edit/edit_config.dart';

Map<String, Widget Function(BuildContext)> routes() {
  return {
    Home.routeHome: (context) => Home(),
    Info.routeInfo: (context) => Info(),
    CreateNote.routeCreate: (context) => CreateNote(),
    ShowImageShare.routeShowImageShare: (context) => ShowImageShare(),
    ShowPdfShare.routeShowPdfShare: (context) => ShowPdfShare(),
    Configuracao.routeConfiguracao: (context) => Configuracao(),
    EditConfig.routeEditConfig: (context) => EditConfig()
  };
}