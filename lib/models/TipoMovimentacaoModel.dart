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

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? 0,
      'descricao': descricao,
    };
  }
}
