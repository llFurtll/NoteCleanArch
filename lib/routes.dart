import 'package:flutter/material.dart';

import 'features/note/presentation/pages/homepage/home.dart';
import 'features/note/presentation/pages/homepage/info.dart';
import 'features/note/presentation/pages/createpage/create.dart';
import 'features/note/presentation/pages/createpage/show_image_share.dart';
import 'features/note/presentation/pages/createpage/show_pdf_share.dart';

Map<String, Widget Function(BuildContext)> routes() {
  return {
    Home.routeHome: (context) => Home(),
    Info.routeInfo: (context) => Info(),
    CreateNote.routeCreate: (context) => CreateNote(),
    ShowImageShare.routeShowImageShare: (context) => ShowImageShare(),
    ShowPdfShare.routeShowPdfShare: (context) => ShowPdfShare()
  };
}