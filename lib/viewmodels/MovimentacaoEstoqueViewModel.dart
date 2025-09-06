import '../models/MovimentacaoEstoqueModel.dart';
import '../repositories/MovimentacaoEstoqueRepo.dart';
import '../services/viewmodel_manager.dart';

class MovimentacaoEstoqueViewModel extends RefreshableViewModel {
  final MovimentacaoEstoqueRepo _repo = MovimentacaoEstoqueRepo();
  List<MovimentacaoEstoqueModel> _lista = [];
  bool _isLoading = false;
  String? _errorMessage;
  MovimentacaoEstoqueModel? _currentMovimentacao;

  // Getters
  List<MovimentacaoEstoqueModel> get lista => _lista;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  MovimentacaoEstoqueModel? get currentMovimentacao => _currentMovimentacao;
  bool get hasError => _errorMessage != null;
  bool get hasData => _lista.isNotEmpty;

  // Setters
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set errorMessage(String? value) {
    _errorMessage = value;
    notifyListeners();
  }

  // Limpar erro
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // GET /api/MovimentacaoEstoques
  Future<bool> fetch() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _lista = await _repo.getAll();
      return true;
    } catch (e) {
      _lista = [];
      _errorMessage = 'Erro ao carregar movimentações: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void clearData() {
    _lista = [];
    _currentMovimentacao = null;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }

  // Método para recarregar dados após login
  Future<void> refreshAfterLogin() async {
    await fetch();
  }

  // POST /api/MovimentacaoEstoques
  Future<bool> add(MovimentacaoEstoqueModel model) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Validação do modelo
      if (!model.isValid()) {
        _errorMessage =
            'Dados inválidos: verifique se apenas um tipo de item foi selecionado e se a quantidade é positiva.';
        return false;
      }

      // Criar movimentação
      final createdMovimentacao = await _repo.create(model);

      // Adicionar à lista local
      _lista.add(createdMovimentacao);

      return true;
    } catch (e) {
      _errorMessage = 'Erro ao adicionar movimentação: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // PUT /api/MovimentacaoEstoques/{id}
  Future<bool> update(MovimentacaoEstoqueModel model) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Validação do modelo
      if (!model.isValid()) {
        _errorMessage =
            'Dados inválidos: verifique se apenas um tipo de item foi selecionado e se a quantidade é positiva.';
        return false;
      }

      // Atualizar movimentação
      await _repo.update(model);

      // Atualizar na lista local
      final index = _lista.indexWhere((m) => m.id == model.id);
      if (index != -1) {
        _lista[index] = model;
      }

      return true;
    } catch (e) {
      _errorMessage = 'Erro ao atualizar movimentação: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // DELETE /api/MovimentacaoEstoques/{id}
  Future<bool> delete(int id) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _repo.delete(id);

      // Remover da lista local
      _lista.removeWhere((m) => m.id == id);

      return true;
    } catch (e) {
      _errorMessage = 'Erro ao excluir movimentação: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // GET /api/MovimentacaoEstoques/{id}
  Future<MovimentacaoEstoqueModel?> getById(int id) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final movimentacao = await _repo.getById(id);
      _currentMovimentacao = movimentacao;
      return movimentacao;
    } catch (e) {
      _errorMessage = 'Erro ao buscar movimentação: $e';
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // GET /api/MovimentacaoEstoques/lavoura/{lavouraId}
  Future<bool> fetchByLavoura(int lavouraId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _lista = await _repo.getByLavoura(lavouraId);
      return true;
    } catch (e) {
      _lista = [];
      _errorMessage = 'Erro ao carregar movimentações da lavoura: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // GET /api/MovimentacaoEstoques/lavoura/{lavouraId}/periodo
  Future<bool> fetchByPeriod(
    int lavouraId,
    DateTime dataInicio,
    DateTime dataFim,
  ) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _lista = await _repo.getByPeriod(lavouraId, dataInicio, dataFim);
      return true;
    } catch (e) {
      _lista = [];
      _errorMessage = 'Erro ao carregar movimentações por período: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // GET /api/MovimentacaoEstoques/lavoura/{lavouraId}/tipo/{itemId}
  Future<bool> fetchByItemType(
    int lavouraId,
    String itemType,
    int itemId,
  ) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _lista = await _repo.getByItemType(lavouraId, itemType, itemId);
      return true;
    } catch (e) {
      _lista = [];
      _errorMessage = 'Erro ao carregar movimentações por tipo de item: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Métodos auxiliares
  List<MovimentacaoEstoqueModel> getEntradas() {
    return _lista.where((m) => m.movimentacao == 1).toList();
  }

  List<MovimentacaoEstoqueModel> getSaidas() {
    return _lista.where((m) => m.movimentacao == 2).toList();
  }

  List<MovimentacaoEstoqueModel> getByItemId(int itemId) {
    return _lista
        .where(
          (m) =>
              m.agrotoxicoID == itemId ||
              m.sementeID == itemId ||
              m.insumoID == itemId,
        )
        .toList();
  }

  double getSaldoAtual(int itemId) {
    double saldo = 0.0;

    for (final mov in _lista) {
      if (mov.agrotoxicoID == itemId ||
          mov.sementeID == itemId ||
          mov.insumoID == itemId) {
        if (mov.movimentacao == 1) {
          saldo += mov.qtde; // Entrada
        } else {
          saldo -= mov.qtde; // Saída
        }
      }
    }

    return saldo;
  }

  // Verificar se há estoque suficiente para saída
  bool hasEstoqueSuficiente(int itemId, double quantidade) {
    final saldo = getSaldoAtual(itemId);
    return saldo >= quantidade;
  }

  // Limpar dados
  void clear() {
    _lista.clear();
    _currentMovimentacao = null;
    _errorMessage = null;
    notifyListeners();
  }
}
