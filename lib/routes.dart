import 'package:flutter/material.dart';

import 'features/home/presentation/pages/principal/home_list.dart';
import 'features/home/presentation/pages/info/info.dart';
import 'features/note/presentation/pages/principal/create.dart';
import 'features/note/presentation/pages/share_image/show_image_share.dart';
import 'features/note/presentation/pages/share_pdf/show_pdf_share.dart';
import 'features/config_app/presentation/pages/principal/configuracao.dart';
import 'features/config_app/presentation/pages/edit/edit_config.dart';

Map<String, Widget Function(BuildContext)> routes() {
  return {
    HomeList.routeHome: (context) => HomeList(),
    Info.routeInfo: (context) => Info(),
    CreateNote.routeCreate: (context) => CreateNote(),
    ShowImageShare.routeShowImageShare: (context) => ShowImageShare(),
    ShowPdfShare.routeShowPdfShare: (context) => ShowPdfShare(),
    Configuracao.routeConfiguracao: (context) => Configuracao(),
    EditConfig.routeEditConfig: (context) => EditConfig()
  };
}