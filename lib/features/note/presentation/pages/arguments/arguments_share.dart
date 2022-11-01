import 'package:compmanager/domain/interfaces/iscreen.dart';

import '../../../data/model/note_model.dart';
class ArgumentsShare {
  final NoteModel noteModel;
  final IScreen screen;
  final bool showImage;

  ArgumentsShare({
    required this.noteModel,
    required this.screen,
    required this.showImage
  });
}