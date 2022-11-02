import 'package:compmanager/domain/interfaces/iscreen.dart';

import '../../../domain/entities/note.dart';

class ArgumentsShare {
  final Note note;
  final IScreen screen;
  final bool showImage;

  ArgumentsShare({
    required this.note,
    required this.screen,
    required this.showImage
  });
}