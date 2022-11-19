class Note {
  int? id;
  String? titulo;
  String? data;
  int? situacao;
  String? imagemFundo;
  String? observacao;
  @deprecated
  String? cor;
  String? ultimaAtualizacao;
  
  Note(
    {
      this.id,
      this.titulo,
      this.data,
      this.situacao,
      this.imagemFundo,
      this.observacao,
      this.ultimaAtualizacao
    }
  );
}