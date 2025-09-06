class MovimentacaoEstoqueModel {
  int? id;
  int? usuarioId;
  int? agrotoxicoID;
  int? insumoID;
  int? sementeID;
  int lavouraID;
  double qtde;
  DateTime dataHora;
  int movimentacao; // 1 = Entrada, 2 = Saída
  String? descricao;

  MovimentacaoEstoqueModel({
    this.id,
    this.usuarioId,
    this.agrotoxicoID,
    this.insumoID,
    this.sementeID,
    required this.lavouraID,
    required this.qtde,
    required this.dataHora,
    required this.movimentacao,
    this.descricao,
  });

  factory MovimentacaoEstoqueModel.fromJson(Map<String, dynamic> json) {
    return MovimentacaoEstoqueModel(
      id: json['id'],
      usuarioId: json['usuarioId'],
      agrotoxicoID: json['agrotoxicoID'],
      insumoID: json['insumoID'],
      sementeID: json['sementeID'],
      lavouraID: json['lavouraID'],
      qtde: json['qtde'].toDouble(),
      dataHora: DateTime.parse(json['dataHora']),
      movimentacao: json['movimentacao'],
      descricao: json['descricao'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'usuarioId': usuarioId,
    'agrotoxicoID': agrotoxicoID,
    'insumoID': insumoID,
    'sementeID': sementeID,
    'lavouraID': lavouraID,
    'qtde': qtde,
    'dataHora': dataHora.toIso8601String(),
    'movimentacao': movimentacao,
    'descricao': descricao,
  };

  // Validação seguindo as regras da API
  bool isValid() {
    // Verifica se apenas um tipo de item foi informado
    int tiposInformados = 0;
    if (agrotoxicoID != null) tiposInformados++;
    if (sementeID != null) tiposInformados++;
    if (insumoID != null) tiposInformados++;

    if (tiposInformados != 1) {
      return false;
    }

    // Verifica se a quantidade é positiva
    if (qtde <= 0) {
      return false;
    }

    // Verifica se a lavoura foi informada
    if (lavouraID <= 0) {
      return false;
    }

    // Verifica se o tipo de movimentação é válido
    if (movimentacao != 1 && movimentacao != 2) {
      return false;
    }

    return true;
  }

  // Retorna o tipo de item selecionado
  String getTipoItem() {
    if (agrotoxicoID != null) return 'Agrotóxico';
    if (sementeID != null) return 'Semente';
    if (insumoID != null) return 'Insumo';
    return 'N/A';
  }

  // Retorna o ID do item selecionado
  int? getItemId() {
    return agrotoxicoID ?? sementeID ?? insumoID;
  }

  // Retorna o nome do tipo de movimentação
  String getTipoMovimentacao() {
    return movimentacao == 1 ? 'Entrada' : 'Saída';
  }
}
