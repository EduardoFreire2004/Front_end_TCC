class AplicacaoModel {
  int? id;
  int? usuarioId;
  int agrotoxicoID;
  int lavouraID;
  String? descricao;
  DateTime dataHora;
  double qtde;

  // Campos adicionais da resposta da API
  String? lavouraNome;
  String? agrotoxicoNome;
  String? agrotoxicoUnidadeMedida;

  AplicacaoModel({
    this.id,
    this.usuarioId,
    required this.agrotoxicoID,
    required this.lavouraID,
    this.descricao,
    required this.dataHora,
    required this.qtde,
    this.lavouraNome,
    this.agrotoxicoNome,
    this.agrotoxicoUnidadeMedida,
  });

  factory AplicacaoModel.fromJson(Map<String, dynamic> map) {
    return AplicacaoModel(
      id: map['id'],
      usuarioId: map['usuarioId'],
      agrotoxicoID: map['agrotoxicoID'],
      lavouraID: map['lavouraID'],
      descricao: map['descricao'],
      dataHora: DateTime.parse(map['dataHora']),
      qtde:
          (map['qtde'] is int) ? (map['qtde'] as int).toDouble() : map['qtde'],
      lavouraNome: map['LavouraNome'],
      agrotoxicoNome: map['AgrotoxicoNome'],
      agrotoxicoUnidadeMedida: map['AgrotoxicoUnidadeMedida'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (usuarioId != null) 'usuarioId': usuarioId,
      'agrotoxicoID': agrotoxicoID,
      'lavouraID': lavouraID,
      if (descricao != null) 'descricao': descricao,
      'dataHora': dataHora.toIso8601String(),
      'qtde': qtde,
    };
  }

  // Método para criar cópia com alterações
  AplicacaoModel copyWith({
    int? id,
    int? usuarioId,
    int? agrotoxicoID,
    int? lavouraID,
    String? descricao,
    DateTime? dataHora,
    double? qtde,
    String? lavouraNome,
    String? agrotoxicoNome,
    String? agrotoxicoUnidadeMedida,
  }) {
    return AplicacaoModel(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      agrotoxicoID: agrotoxicoID ?? this.agrotoxicoID,
      lavouraID: lavouraID ?? this.lavouraID,
      descricao: descricao ?? this.descricao,
      dataHora: dataHora ?? this.dataHora,
      qtde: qtde ?? this.qtde,
      lavouraNome: lavouraNome ?? this.lavouraNome,
      agrotoxicoNome: agrotoxicoNome ?? this.agrotoxicoNome,
      agrotoxicoUnidadeMedida:
          agrotoxicoUnidadeMedida ?? this.agrotoxicoUnidadeMedida,
    );
  }

  @override
  String toString() {
    return 'AplicacaoModel(id: $id, usuarioId: $usuarioId, agrotoxicoID: $agrotoxicoID, lavouraID: $lavouraID, descricao: $descricao, dataHora: $dataHora, qtde: $qtde, lavouraNome: $lavouraNome, agrotoxicoNome: $agrotoxicoNome, agrotoxicoUnidadeMedida: $agrotoxicoUnidadeMedida)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AplicacaoModel &&
        other.id == id &&
        other.usuarioId == usuarioId &&
        other.agrotoxicoID == agrotoxicoID &&
        other.lavouraID == lavouraID &&
        other.descricao == descricao &&
        other.dataHora == dataHora &&
        other.qtde == qtde;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        usuarioId.hashCode ^
        agrotoxicoID.hashCode ^
        lavouraID.hashCode ^
        descricao.hashCode ^
        dataHora.hashCode ^
        qtde.hashCode;
  }
}
