# Implementação de UsuarioId nos Modelos

## Visão Geral
Todos os modelos do sistema FGL devem incluir o atributo `usuarioId` para garantir o isolamento de dados entre usuários.

## Padrão de Implementação

### 1. Adicionar o Atributo
```dart
class ExemploModel {
  int? id;
  String nome;
  // ... outros campos
  int usuarioId; // NOVO - Obrigatório
}
```

### 2. Atualizar o Construtor
```dart
ExemploModel({
  this.id,
  required this.nome,
  // ... outros campos
  required this.usuarioId, // NOVO - Obrigatório
});
```

### 3. Atualizar fromJson
```dart
factory ExemploModel.fromJson(Map<String, dynamic> map) {
  return ExemploModel(
    id: map['id'],
    nome: map['nome'],
    // ... outros campos
    usuarioId: map['usuarioId'] ?? 0, // NOVO
  );
}
```

### 4. Atualizar toJson
```dart
Map<String, dynamic> toJson() {
  return {
    'id': id ?? 0,
    'nome': nome,
    // ... outros campos
    'usuarioId': usuarioId, // NOVO
  };
}
```

## Modelos Atualizados
- ✅ LavouraModel
- ✅ InsumoModel
- ✅ SementeModel
- ✅ AgrotoxicoModel
- ✅ PlantioModel
- ✅ ColheitaModel

## Modelos Pendentes
- ⏳ AplicacaoModel
- ⏳ AplicacaoInsumoModel
- ⏳ CategoriaInsumoModel
- ⏳ CustosModel
- ⏳ ForneAgrotoxicoModel
- ⏳ ForneInsumoModel
- ⏳ ForneSementeModel
- ⏳ MovimentacaoEstoqueModel
- ⏳ RendimentoColheitaModel
- ⏳ TipoAgrotoxicoModel
- ⏳ TipoMovimentacaoModel

## Importante
- O `usuarioId` é automaticamente adicionado pelo `ApiService`
- Não é necessário passar o `usuarioId` manualmente nas requisições
- O valor padrão é 0 se não for fornecido pelo back-end
- Todos os modelos devem seguir este padrão para funcionar corretamente

