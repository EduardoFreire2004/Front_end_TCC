class SementeModel {
  int? id;
  int fornecedorSementeID;
  DateTime data_Cadastro;
  String nome;
  String tipo;
  String marca;
  double qtde;

  SementeModel({
    this.id,
    required this.fornecedorSementeID,
    required this.data_Cadastro,
    required this.nome,
    required this.tipo,
    required this.marca,
    required this.qtde,
  });

  factory SementeModel.fromJson(Map<String, dynamic> map) {
    return SementeModel(
      id: map['id'],
      fornecedorSementeID: map['fornecedorSementeID'],
      data_Cadastro: DateTime.parse(map['data_Cadastro']),
      nome: map['nome'],
      tipo: map['tipo'],
      marca: map['marca'],
      qtde: map['qtde'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? 0,
      'fornecedorSementeID': fornecedorSementeID,
      'data_Cadastro': data_Cadastro.toIso8601String(),
      'nome': nome,
      'tipo': tipo,
      'marca': marca,
      'qtde': qtde,
    };
  }
}
