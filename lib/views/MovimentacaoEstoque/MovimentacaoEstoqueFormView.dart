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

  int? _movimentacao; // 1 - Entrada, 2 - Saída
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

    // Se estiver editando, preencher os campos
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

    final movimentacaoModel = MovimentacaoEstoqueModel(
      id: widget.movimentacao?.id,
      lavouraID: widget.lavouraId,
      movimentacao: _movimentacao!,
      agrotoxicoID: _selectedAgrotoxico ?? 0,
      sementeID: _selectedSemente ?? 0,
      insumoID: _selectedInsumo ?? 0,
      qtde: _qtde!,
      dataHora: _dataHora,
      descricao: _descricao ?? '',
    );

    // Garante que apenas um tipo foi selecionado
    int tiposSelecionados = 0;
    if (_selectedAgrotoxico != null) tiposSelecionados++;
    if (_selectedSemente != null) tiposSelecionados++;
    if (_selectedInsumo != null) tiposSelecionados++;
    if (tiposSelecionados != 1) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Selecione apenas um tipo: Agrotóxico, Semente ou Insumo',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      if (widget.movimentacao != null) {
        // Atualizando
        await Provider.of<MovimentacaoEstoqueViewModel>(
          context,
          listen: false,
        ).update(movimentacaoModel);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Movimentação atualizada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Criando nova
        await Provider.of<MovimentacaoEstoqueViewModel>(
          context,
          listen: false,
        ).add(movimentacaoModel);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Movimentação criada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: 'Tipo de Movimentação',
                ),
                value: _movimentacao,
                items: const [
                  DropdownMenuItem(value: 1, child: Text('Entrada')),
                  DropdownMenuItem(value: 2, child: Text('Saída')),
                ],
                onChanged: (value) => setState(() => _movimentacao = value),
                validator: (value) => value == null ? 'Selecione o tipo' : null,
              ),
              const SizedBox(height: 16),

              // Agrotóxico
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Agrotóxico'),
                value: _selectedAgrotoxico,
                items: [
                  const DropdownMenuItem<int>(
                    value: null,
                    child: Text('Selecione um agrotóxico'),
                  ),
                  ...agroVM.lista.map(
                    (a) => DropdownMenuItem(value: a.id, child: Text(a.nome)),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedAgrotoxico = value;
                    if (value != null) {
                      _selectedSemente = null;
                      _selectedInsumo = null;
                    }
                  });
                },
              ),

              // Semente
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Semente'),
                value: _selectedSemente,
                items: [
                  const DropdownMenuItem<int>(
                    value: null,
                    child: Text('Selecione uma semente'),
                  ),
                  ...sementeVM.semente.map(
                    (s) => DropdownMenuItem(value: s.id, child: Text(s.nome)),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedSemente = value;
                    if (value != null) {
                      _selectedAgrotoxico = null;
                      _selectedInsumo = null;
                    }
                  });
                },
              ),

              // Insumo
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Insumo'),
                value: _selectedInsumo,
                items: [
                  const DropdownMenuItem<int>(
                    value: null,
                    child: Text('Selecione um insumo'),
                  ),
                  ...insumoVM.insumo.map(
                    (i) => DropdownMenuItem(value: i.id, child: Text(i.nome)),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedInsumo = value;
                    if (value != null) {
                      _selectedAgrotoxico = null;
                      _selectedSemente = null;
                    }
                  });
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
                initialValue: _qtde?.toString(),
                onSaved: (value) => _qtde = double.tryParse(value ?? '0'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Informe a quantidade'
                            : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Descrição'),
                initialValue: _descricao,
                onSaved: (value) => _descricao = value,
              ),
              const SizedBox(height: 16),

              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Data: ${DateFormat('dd/MM/yyyy HH:mm').format(_dataHora)}',
                ),
                trailing: Icon(Icons.calendar_today, color: Colors.green[700]),
                onTap: () async {
                  final currentContext = context;
                  if (!mounted) return;
                  final date = await showDatePicker(
                    context: currentContext,
                    initialDate: _dataHora,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null && mounted) {
                    final time = await showTimePicker(
                      context: currentContext,
                      initialTime: TimeOfDay.fromDateTime(_dataHora),
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
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _saveForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  widget.movimentacao != null ? 'Atualizar' : 'Salvar',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
