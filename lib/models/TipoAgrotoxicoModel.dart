class TipoAgrotoxicoModel {
  int? id;
  String descricao;

  TipoAgrotoxicoModel({
    this.id,
    required this.descricao,
  });

  factory TipoAgrotoxicoModel.fromJson(Map<String, dynamic> map) {
    return TipoAgrotoxicoModel(
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
