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

  const MovimentacaoEstoqueFormView({super.key, required this.lavouraId});

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
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final movimentacaoModel = MovimentacaoEstoqueModel(
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione apenas um tipo: Agrotóxico, Semente ou Insumo'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await Provider.of<MovimentacaoEstoqueViewModel>(context, listen: false)
        .add(movimentacaoModel);

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final agroVM = Provider.of<AgrotoxicoViewModel>(context);
    final sementeVM = Provider.of<SementeViewModel>(context);
    final insumoVM = Provider.of<InsumoViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Movimentação de Estoque'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Tipo de Movimentação'),
                value: _movimentacao,
                items: const [
                  DropdownMenuItem(value: 1, child: Text('Entrada')),
                  DropdownMenuItem(value: 2, child: Text('Saída')),
                ],
                onChanged: (value) => setState(() => _movimentacao = value),
                validator: (value) =>
                    value == null ? 'Selecione o tipo' : null,
              ),
              const SizedBox(height: 16),

              // Agrotóxico
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Agrotóxico'),
                value: _selectedAgrotoxico,
                items: agroVM.lista
                    .map((a) => DropdownMenuItem(value: a.id, child: Text(a.nome)))
                    .toList(),
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
                items: sementeVM.semente
                    .map((s) => DropdownMenuItem(value: s.id, child: Text(s.nome)))
                    .toList(),
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
                items: insumoVM.insumo
                    .map((i) => DropdownMenuItem(value: i.id, child: Text(i.nome)))
                    .toList(),
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
                onSaved: (value) => _qtde = double.tryParse(value ?? '0'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe a quantidade' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Descrição'),
                onSaved: (value) => _descricao = value,
              ),
              const SizedBox(height: 16),

              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Data: ${DateFormat('dd/MM/yyyy HH:mm').format(_dataHora)}'),
                trailing: Icon(Icons.calendar_today, color: Colors.green[700]),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _dataHora,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(_dataHora),
                    );
                    if (time != null) {
                      setState(() {
                        _dataHora = DateTime(date.year, date.month, date.day, time.hour, time.minute);
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
                child: const Text(
                  'Salvar',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
