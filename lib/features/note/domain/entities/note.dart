class Note {
  int? id;
  String? titulo;
  String? data;
  int? situacao;
  String? imagemFundo;
  String? observacao;
  @deprecated
  String? cor;
  
  Note(
    {
      this.id,
      this.titulo,
      this.data,
      this.situacao,
      this.imagemFundo,
      this.observacao
    }
  );
}