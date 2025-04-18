class TipoMovimentacaoModel {
  int? id;
  String descricao;

  TipoMovimentacaoModel({
    this.id,
    required this.descricao,
  });

  factory TipoMovimentacaoModel.fromJson(Map<String, dynamic> map) {
    return TipoMovimentacaoModel(
      id: map['id'],
      descricao: map['descricao'],
    );
  }

  Map<String, dynamic> toJsonForCreate() {
    return {
      'descricao': descricao,
    };
  }
  Map<String, dynamic> toJsonForUpdate() {
    return {
      'id':id,
      'descricao': descricao,
    };
  }
}
