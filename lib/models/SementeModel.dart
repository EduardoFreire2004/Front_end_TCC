class SementeModel {
  int? id;
  int fornecedorSementeID;
  String nome;
  String tipo;
  String marca;
  double qtde;

  SementeModel({
    this.id,
    required this.fornecedorSementeID,
    required this.nome,
    required this.tipo,
    required this.marca,
    required this.qtde,
  });

  factory SementeModel.fromJson(Map<String, dynamic> map) {
    return SementeModel(
      id: map['id'],
      fornecedorSementeID: map['fornecedorSementeID'],
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
      'nome': nome,
      'tipo': tipo,
      'marca': marca,
      'qtde': qtde,
    };
  }
}
