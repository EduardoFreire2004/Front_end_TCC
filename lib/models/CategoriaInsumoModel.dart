class CategoriaInsumoModel {
  int? id;
  String descricao;

  CategoriaInsumoModel({
    this.id,
    required this.descricao,
  });

  factory CategoriaInsumoModel.fromJson(Map<String, dynamic> map) {
    return CategoriaInsumoModel(
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
