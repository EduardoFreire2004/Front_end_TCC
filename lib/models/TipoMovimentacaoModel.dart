enum TipoMovimentacao {
  entrada(1, 'Entrada'),
  saida(2, 'Saída');

  const TipoMovimentacao(this.value, this.descricao);

  final int value;
  final String descricao;

  static TipoMovimentacao fromValue(int value) {
    return TipoMovimentacao.values.firstWhere(
      (tipo) => tipo.value == value,
      orElse: () => TipoMovimentacao.entrada,
    );
  }

  static List<TipoMovimentacao> get all => TipoMovimentacao.values.toList();

  static List<Map<String, dynamic>> get dropdownItems =>
      TipoMovimentacao.values
          .map((tipo) => {'value': tipo.value, 'label': tipo.descricao})
          .toList();
}

class TipoMovimentacaoModel {
  int? id;
  String descricao;

  TipoMovimentacaoModel({this.id, required this.descricao});

  factory TipoMovimentacaoModel.fromJson(Map<String, dynamic> map) {
    return TipoMovimentacaoModel(id: map['id'], descricao: map['descricao']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id ?? 0, 'descricao': descricao};
  }
}

