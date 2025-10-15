import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/MovimentacaoEstoqueModel.dart';
import '../../viewmodels/MovimentacaoEstoqueViewModel.dart';
import '../../viewmodels/AgrotoxicoViewModel.dart';
import '../../viewmodels/SementeViewModel.dart';
import '../../viewmodels/InsumoViewModel.dart';

class MovimentacaoEstoqueFormView extends StatefulWidget {
  final int lavouraId;
  final MovimentacaoEstoqueModel? movimentacao;

  const MovimentacaoEstoqueFormView({
    super.key,
    required this.lavouraId,
    this.movimentacao,
  });

  @override
  State<MovimentacaoEstoqueFormView> createState() =>
      _MovimentacaoEstoqueFormViewState();
}

class _MovimentacaoEstoqueFormViewState
    extends State<MovimentacaoEstoqueFormView> {
  final _formKey = GlobalKey<FormState>();

  int? _movimentacao; 
  int? _selectedAgrotoxico;
  int? _selectedSemente;
  int? _selectedInsumo;
  double? _qtde;
  DateTime _dataHora = DateTime.now();
  String? _descricao;

  @override
  void initState() {
    super.initState();
    Provider.of<AgrotoxicoViewModel>(context, listen: false).fetch();
    Provider.of<SementeViewModel>(context, listen: false).fetch();
    Provider.of<InsumoViewModel>(context, listen: false).fetch();

    if (widget.movimentacao != null) {
      final mov = widget.movimentacao!;
      _movimentacao = mov.movimentacao;
      _selectedAgrotoxico = mov.agrotoxicoID;
      _selectedSemente = mov.sementeID;
      _selectedInsumo = mov.insumoID;
      _qtde = mov.qtde;
      _dataHora = mov.dataHora;
      _descricao = mov.descricao;
    }
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (_movimentacao == null) {
      _showError('Selecione o tipo de movimentação');
      return;
    }

    if (_movimentacao != 1) {
      _showError(
        'Apenas movimentações do tipo Entrada são permitidas nesta tela. Saídas são geradas automaticamente por Aplicação, Plantio e Aplicação de Insumo.',
      );
      return;
    }

    int tiposSelecionados = 0;
    if (_selectedAgrotoxico != null) tiposSelecionados++;
    if (_selectedSemente != null) tiposSelecionados++;
    if (_selectedInsumo != null) tiposSelecionados++;

    if (tiposSelecionados != 1) {
      _showError('Selecione apenas um tipo: Agrotóxico, Semente ou Insumo');
      return;
    }

    if (_qtde == null || _qtde! <= 0) {
      _showError('A quantidade deve ser maior que zero');
      return;
    }


    final movimentacaoModel = MovimentacaoEstoqueModel(
      id: widget.movimentacao?.id,
      lavouraID: widget.lavouraId,
      movimentacao: 1,
      agrotoxicoID: _selectedAgrotoxico,
      sementeID: _selectedSemente,
      insumoID: _selectedInsumo,
      qtde: _qtde!,
      dataHora: _dataHora,
      descricao: _descricao,
    );

    try {
      final movimentacaoVM = Provider.of<MovimentacaoEstoqueViewModel>(
        context,
        listen: false,
      );

      if (widget.movimentacao != null) {
        final success = await movimentacaoVM.update(movimentacaoModel);
        if (success) {
          if (!mounted) return;
          _showSuccess('Movimentação atualizada com sucesso!');
          Navigator.pop(context, true);
        } else {
          if (!mounted) return;
          _showError(
            movimentacaoVM.errorMessage ?? 'Erro ao atualizar movimentação',
          );
        }
      } else {
        final success = await movimentacaoVM.add(movimentacaoModel);
        if (success) {
          if (!mounted) return;
          _showSuccess('Movimentação criada com sucesso!');
          Navigator.pop(context, true);
        } else {
          if (!mounted) return;
          _showError(
            movimentacaoVM.errorMessage ?? 'Erro ao criar movimentação',
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      _showError('Erro ao salvar: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _clearOtherSelections(String selectedType) {
    setState(() {
      switch (selectedType) {
        case 'agrotoxico':
          _selectedSemente = null;
          _selectedInsumo = null;
          break;
        case 'semente':
          _selectedAgrotoxico = null;
          _selectedInsumo = null;
          break;
        case 'insumo':
          _selectedAgrotoxico = null;
          _selectedSemente = null;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final agroVM = Provider.of<AgrotoxicoViewModel>(context);
    final sementeVM = Provider.of<SementeViewModel>(context);
    final insumoVM = Provider.of<InsumoViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.movimentacao != null
              ? 'Editar Movimentação'
              : 'Nova Movimentação de Estoque',
        ),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tipo de Movimentação *',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: 'Selecione o tipo',
                        ),
                        value: _movimentacao,
                        items: [
                          // Somente Entrada (1)
                          DropdownMenuItem<int>(
                            value: 1,
                            child: Row(
                              children: [
                                Icon(Icons.arrow_downward, color: Colors.green),
                                const SizedBox(width: 8),
                                const Text('Entrada'),
                              ],
                            ),
                          ),
                        ],
                        onChanged:
                            (value) => setState(() => _movimentacao = value),
                        validator:
                            (value) =>
                                value == null ? 'Selecione o tipo' : null,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selecione o Item *',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Selecione apenas um tipo de item',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),

                      DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: 'Agrotóxico',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        value: _selectedAgrotoxico,
                        items: [
                          const DropdownMenuItem<int>(
                            value: null,
                            child: Text('Selecione um agrotóxico'),
                          ),
                          ...agroVM.lista.map(
                            (a) => DropdownMenuItem(
                              value: a.id,
                              child: Text(a.nome),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedAgrotoxico = value;
                            if (value != null) {
                              _clearOtherSelections('agrotoxico');
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: 'Semente',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        value: _selectedSemente,
                        items: [
                          const DropdownMenuItem<int>(
                            value: null,
                            child: Text('Selecione uma semente'),
                          ),
                          ...sementeVM.semente.map(
                            (s) => DropdownMenuItem(
                              value: s.id,
                              child: Text(s.nome),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedSemente = value;
                            if (value != null) {
                              _clearOtherSelections('semente');
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: 'Insumo',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        value: _selectedInsumo,
                        items: [
                          const DropdownMenuItem<int>(
                            value: null,
                            child: Text('Selecione um insumo'),
                          ),
                          ...insumoVM.insumo.map(
                            (i) => DropdownMenuItem(
                              value: i.id,
                              child: Text(i.nome),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedInsumo = value;
                            if (value != null) {
                              _clearOtherSelections('insumo');
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Detalhes da Movimentação',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Quantidade *',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixText: 'kg/L',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        initialValue: _qtde?.toString(),
                        onSaved:
                            (value) => _qtde = double.tryParse(value ?? '0'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe a quantidade';
                          }
                          final qtde = double.tryParse(value);
                          if (qtde == null || qtde <= 0) {
                            return 'A quantidade deve ser maior que zero';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Descrição',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: 'Descrição opcional da movimentação',
                        ),
                        initialValue: _descricao,
                        onSaved: (value) => _descricao = value,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Data e Hora da Movimentação',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.calendar_today,
                          color: Colors.green[700],
                        ),
                        title: Text(
                          'Data: ${DateFormat('dd/MM/yyyy').format(_dataHora)}',
                        ),
                        subtitle: Text(
                          'Hora: ${DateFormat('HH:mm').format(_dataHora)}',
                        ),
                        trailing: ElevatedButton(
                          onPressed: () async {
                            final currentContext = context;
                            if (!mounted) return;

                            final date = await showDatePicker(
                              context: currentContext,
                              initialDate: _dataHora,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: Colors.green[600]!,
                                      onPrimary: Colors.white,
                                      onSurface: Colors.black,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );

                            if (date != null && mounted) {
                              final time = await showTimePicker(
                                context: currentContext,
                                initialTime: TimeOfDay.fromDateTime(_dataHora),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: ColorScheme.light(
                                        primary: Colors.green[600]!,
                                        onPrimary: Colors.white,
                                        onSurface: Colors.black,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );

                              if (time != null && mounted) {
                                setState(() {
                                  _dataHora = DateTime(
                                    date.year,
                                    date.month,
                                    date.day,
                                    time.hour,
                                    time.minute,
                                  );
                                });
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[600],
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Alterar'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _saveForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                  child: Text(
                    widget.movimentacao != null ? 'Atualizar' : 'Salvar',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
