import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fgl_1/models/InsumoModel.dart';
import 'package:flutter_fgl_1/viewmodels/CategoriaInsumoViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/FornecedoresViewmodel.dart';
import 'package:flutter_fgl_1/viewmodels/InsumoViewModel.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class InsumoFormView extends StatefulWidget {
  final InsumoModel? insumo;

  const InsumoFormView({super.key, this.insumo});

  @override
  State<InsumoFormView> createState() => _InsumoFormPageState();
}

class _InsumoFormPageState extends State<InsumoFormView> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _unidadeController = TextEditingController();
  final _qtdeController = TextEditingController();
  final _precoController = TextEditingController();

  DateTime _dataCadastro = DateTime.now();
  int? _categoriaID;
  int? _fornecedorID;

  @override
  void initState() {
    super.initState();
    final insumo = widget.insumo;
    if (insumo != null) {
      _nomeController.text = insumo.nome;
      _unidadeController.text = insumo.unidade_Medida;
      _qtdeController.text = insumo.qtde.toString();
      _dataCadastro = insumo.data_Cadastro;
      _categoriaID = insumo.categoriaID;
      _fornecedorID = insumo.fornecedorID;
      _precoController.text = insumo.preco != null
          ? toCurrencyString(insumo.preco!.toStringAsFixed(2),
              leadingSymbol: 'R\$ ', useSymbolPadding: true)
          : '';
    }
  }

  Future<void> _salvar() async {
    if (_formKey.currentState!.validate()) {
      final precoText =
          _precoController.text.replaceAll(RegExp(r'[^0-9,]'), '').replaceAll(',', '.');
      final preco = double.tryParse(precoText) ?? 0.0;

      final model = InsumoModel(
        id: widget.insumo?.id,
        nome: _nomeController.text.trim(),
        unidade_Medida: _unidadeController.text.trim(),
        qtde: double.tryParse(_qtdeController.text.replaceAll(',', '.')) ?? 0.0,
        data_Cadastro: _dataCadastro,
        categoriaID: _categoriaID!,
        fornecedorID: _fornecedorID!,
        preco: preco,
      );

      final viewModel = context.read<InsumoViewModel>();
      try {
        if (widget.insumo == null) {
          await viewModel.add(model);
        } else {
          await viewModel.update(model);
        }
        if (mounted) Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _unidadeController.dispose();
    _qtdeController.dispose();
    _precoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriaVM = context.watch<CategoriaInsumoViewModel>();
    final fornecedorVM = context.watch<FornecedoresViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.insumo == null ? 'Novo Insumo' : 'Editar Insumo'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _unidadeController,
                decoration: const InputDecoration(labelText: 'Unidade de Medida'),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _qtdeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantidade'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Campo obrigatório';
                  final numValue = double.tryParse(value.replaceAll(',', '.'));
                  if (numValue == null || numValue <= 0) return 'Valor inválido';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _precoController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  MoneyInputFormatter(
                    leadingSymbol: 'R\$',
                    useSymbolPadding: true,
                    thousandSeparator: ThousandSeparator.Period,
                    mantissaLength: 2,
                  ),
                ],
                decoration: const InputDecoration(
                  labelText: "Preço (R\$)",
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Preço é obrigatório';
                  }
                  final cleaned = value.replaceAll(RegExp(r'[^0-9,]'), '');
                  if (cleaned.isEmpty) {
                    return 'Preço inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Data de Cadastro: ${DateFormat('dd/MM/yyyy').format(_dataCadastro)}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final data = await showDatePicker(
                    context: context,
                    initialDate: _dataCadastro,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (data != null) {
                    setState(() => _dataCadastro = data);
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _categoriaID,
                decoration: const InputDecoration(labelText: 'Categoria'),
                items: categoriaVM.categoriaInsumo
                    .map((e) => DropdownMenuItem(value: e.id, child: Text(e.descricao)))
                    .toList(),
                onChanged: (value) => setState(() => _categoriaID = value),
                validator: (value) => value == null ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _fornecedorID,
                decoration: const InputDecoration(labelText: 'Fornecedor'),
                items: fornecedorVM.fornecedores
                    .map((e) => DropdownMenuItem(value: e.id, child: Text(e.nome)))
                    .toList(),
                onChanged: (value) => setState(() => _fornecedorID = value),
                validator: (value) => value == null ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _salvar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                ),
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
