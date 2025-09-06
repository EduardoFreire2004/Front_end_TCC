import '../viewmodels/base_viewmodel.dart';

class ViewModelManager {
  static final ViewModelManager _instance = ViewModelManager._internal();
  factory ViewModelManager() => _instance;
  ViewModelManager._internal();

  final List<BaseViewModel> _viewModels = [];

  void registerViewModel(BaseViewModel viewModel) {
    if (!_viewModels.contains(viewModel)) {
      _viewModels.add(viewModel);
    }
  }

  void unregisterViewModel(BaseViewModel viewModel) {
    _viewModels.remove(viewModel);
  }

  void clearAllData() {
    for (final viewModel in _viewModels) {
      viewModel.clearData();
    }
  }

  void clearDataExcept(BaseViewModel exceptViewModel) {
    for (final viewModel in _viewModels) {
      if (viewModel != exceptViewModel) {
        viewModel.clearData();
      }
    }
  }

  // Método para recarregar dados de todos os ViewModels após login
  Future<void> refreshAllDataAfterLogin() async {
    for (final viewModel in _viewModels) {
      if (viewModel is RefreshableViewModel) {
        await viewModel.refreshAfterLogin();
      }
    }
  }
}

// Interface para ViewModels que podem ser recarregados
abstract class RefreshableViewModel extends BaseViewModel {
  Future<void> refreshAfterLogin();
}
