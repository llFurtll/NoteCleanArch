import '../../domain/entities/note.dart';

class NoteModel extends Note {
  NoteModel({
    int? id,
    String? titulo,
    String? data,
    String? imagemFundo,
    String? observacao,
    int? situacao,
    String? ultimaAtaulizacao
  }) : super(
    id: id,
    data: data,
    imagemFundo: imagemFundo,
    observacao: observacao,
    situacao: situacao,
    titulo: titulo,
    ultimaAtualizacao: ultimaAtaulizacao
  );

  factory NoteModel.fromJson(Map json) {
    return NoteModel(
      id: json["id"],
      titulo: json["titulo"],
      data: json["data"],
      imagemFundo: json["imagem_fundo"],
      observacao: json["observacao"],
      situacao: json["situacao"],
      ultimaAtaulizacao: json["ultima_atualizacao"]
    );
  }

  Note fromModel(NoteModel noteModel) {
    return Note(
      id: noteModel.id,
      titulo: noteModel.titulo,
      data: noteModel.data,
      imagemFundo: noteModel.imagemFundo,
      observacao: noteModel.observacao,
      situacao: noteModel.situacao,
      ultimaAtualizacao: noteModel.ultimaAtualizacao
    );
  }

  NoteModel fromNote(Note note) {
    return NoteModel(
      id: note.id,
      titulo: note.titulo,
      data: note.data,
      imagemFundo: note.imagemFundo,
      observacao: note.observacao,
      situacao: note.situacao,
      ultimaAtaulizacao: note.ultimaAtualizacao
    );
  }
}