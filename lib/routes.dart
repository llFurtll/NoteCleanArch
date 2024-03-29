import 'package:flutter/material.dart';

import 'features/atualizacao/presentation/arguments/arguments_info_atualizacao.dart';
import 'features/atualizacao/presentation/principal/info_atualizacao.dart';
import 'features/config_app/presentation/pages/edit/config_app_edit.dart';
import 'features/config_app/presentation/pages/principal/config_app_list.dart';
import 'features/home/presentation/pages/info/info.dart';
import 'features/home/presentation/pages/principal/home_list.dart';
import 'features/home/presentation/pages/versao/list_versao.dart';
import 'features/note/presentation/pages/principal/create.dart';
import 'features/note/presentation/pages/share_image/show_image_share.dart';
import 'features/note/presentation/pages/share_pdf/show_pdf_share.dart';

Map<String, Widget Function(BuildContext)> routes() {
  return {
    HomeList.routeHome: (context) => HomeList(),
    Info.routeInfo: (context) => Info(),
    CreateNote.routeCreate: (context) => CreateNote(),
    ShowImageShare.routeShowImageShare: (context) => ShowImageShare(),
    ShowPdfShare.routeShowPdfShare: (context) => ShowPdfShare(),
    ConfigAppList.routeConfigAppList: (context) => ConfigAppList(),
    ConfigAppEdit.routeConfigAppEdit: (context) => ConfigAppEdit(
      ModalRoute.of(context)!.settings.arguments as String,
    ),
    InfoAtualizacao.routeInfoAtualizacao: (context) => InfoAtualizacao(
      ModalRoute.of(context)!.settings.arguments as ArgumentsInfoAtualizacao
    ),
    ListaVersao.routeListaVersao: (context) => ListaVersao()
  };
}