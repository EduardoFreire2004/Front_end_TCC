class AplicacaoInsumoModel {
  int? id;
  int? usuarioId;
  int insumoID;
  int lavouraID;
  String? descricao;
  DateTime dataHora;
  double qtde;

  String? lavouraNome;
  String? insumoNome;
  String? insumoUnidadeMedida;

  AplicacaoInsumoModel({
    this.id,
    this.usuarioId,
    required this.insumoID,
    required this.lavouraID,
    this.descricao,
    required this.dataHora,
    required this.qtde,
    this.lavouraNome,
    this.insumoNome,
    this.insumoUnidadeMedida,
  });

  factory AplicacaoInsumoModel.fromJson(Map<String, dynamic> map) {
    return AplicacaoInsumoModel(
      id: map['id'],
      usuarioId: map['usuarioId'],
      insumoID: map['insumoID'],
      lavouraID: map['lavouraID'],
      descricao: map['descricao'],
      dataHora: DateTime.parse(map['dataHora']),
      qtde:
          (map['qtde'] is int) ? (map['qtde'] as int).toDouble() : map['qtde'],
      lavouraNome: map['LavouraNome'],
      insumoNome: map['InsumoNome'],
      insumoUnidadeMedida: map['InsumoUnidadeMedida'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (usuarioId != null) 'usuarioId': usuarioId,
      'insumoID': insumoID,
      'lavouraID': lavouraID,
      if (descricao != null) 'descricao': descricao,
      'dataHora': dataHora.toIso8601String(),
      'qtde': qtde,
    };
  }

  AplicacaoInsumoModel copyWith({
    int? id,
    int? usuarioId,
    int? insumoID,
    int? lavouraID,
    String? descricao,
    DateTime? dataHora,
    double? qtde,
    String? lavouraNome,
    String? insumoNome,
    String? insumoUnidadeMedida,
  }) {
    return AplicacaoInsumoModel(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      insumoID: insumoID ?? this.insumoID,
      lavouraID: lavouraID ?? this.lavouraID,
      descricao: descricao ?? this.descricao,
      dataHora: dataHora ?? this.dataHora,
      qtde: qtde ?? this.qtde,
      lavouraNome: lavouraNome ?? this.lavouraNome,
      insumoNome: insumoNome ?? this.insumoNome,
      insumoUnidadeMedida: insumoUnidadeMedida ?? this.insumoUnidadeMedida,
    );
  }

  @override
  String toString() {
    return 'AplicacaoInsumoModel(id: $id, usuarioId: $usuarioId, insumoID: $insumoID, lavouraID: $lavouraID, descricao: $descricao, dataHora: $dataHora, qtde: $qtde, lavouraNome: $lavouraNome, insumoNome: $insumoNome, insumoUnidadeMedida: $insumoUnidadeMedida)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AplicacaoInsumoModel &&
        other.id == id &&
        other.usuarioId == usuarioId &&
        other.insumoID == insumoID &&
        other.lavouraID == lavouraID &&
        other.descricao == descricao &&
        other.dataHora == dataHora &&
        other.qtde == qtde;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        usuarioId.hashCode ^
        insumoID.hashCode ^
        lavouraID.hashCode ^
        descricao.hashCode ^
        dataHora.hashCode ^
        qtde.hashCode;
  }
}

