import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fgl_1/models/InsumoModel.dart';
import 'package:flutter_fgl_1/viewmodels/CategoriaInsumoViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/ForneInsumoViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/InsumoViewModel.dart';
import 'package:flutter_fgl_1/views/CategoriaInsumo/CategoriaInsumoFormView.dart';
import 'package:flutter_fgl_1/views/ForneInsumo/ForneInsumoFormView.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
  DateTime _dataCadastro = DateTime.now();
  int? _categoriaID;
  int? _fornecedorID;

  final primaryColor = Colors.green[700]!;
  final whiteColor = Colors.white;

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
    }
  }

  bool _nomeJaExiste(String nome) {
    final viewModel = Provider.of<InsumoViewModel>(context, listen: false);
    final lista = viewModel.insumo;

    if (widget.insumo != null) {
      return lista.any(
        (f) => f.nome.toLowerCase() == nome.toLowerCase() && f.id != widget.insumo!.id,
      );
    }

    return lista.any((f) => f.nome.toLowerCase() == nome.toLowerCase());
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final model = InsumoModel(
      id: widget.insumo?.id,
      nome: _nomeController.text.trim(),
      unidade_Medida: _unidadeController.text.trim(),
      qtde: double.tryParse(_qtdeController.text.replaceAll(',', '.')) ?? 0.0,
      data_Cadastro: _dataCadastro,
      categoriaID: _categoriaID!,
      fornecedorID: _fornecedorID!,
    );

    final viewModel = Provider.of<InsumoViewModel>(context, listen: false);

    if (widget.insumo == null) {
      viewModel.add(model);
    } else {
      viewModel.update(model);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Insumo salvo com sucesso!'), backgroundColor: primaryColor),
    );

    Navigator.pop(context);
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dataCadastro,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('pt', 'BR'),
    );

    if (picked != null) {
      setState(() => _dataCadastro = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriaVM = Provider.of<CategoriaInsumoViewModel>(context);
    final fornecedorVM = Provider.of<ForneInsumoViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.insumo == null ? "Novo Insumo" : "Editar Insumo"),
      ),
      body: categoriaVM.categoriaInsumo.isEmpty || fornecedorVM.forneInsumo.isEmpty
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _nomeController,
                      decoration: const InputDecoration(
                        labelText: "Nome",
                        prefixIcon: Icon(Icons.inventory),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nome é obrigatório';
                        }
                        if (_nomeJaExiste(value.trim())) {
                          return 'Este nome já está cadastrado';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _unidadeController,
                      decoration: const InputDecoration(
                        labelText: "Unidade de Medida",
                        prefixIcon: Icon(Icons.straighten),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? "Campo obrigatório" : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _qtdeController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9,\.]')),
                      ],
                      decoration: const InputDecoration(
                        labelText: "Quantidade",
                        prefixIcon: Icon(Icons.scale),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? "Campo obrigatório" : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      readOnly: true,
                      onTap: _selectDate,
                      controller: TextEditingController(
                        text: DateFormat('dd/MM/yyyy').format(_dataCadastro),
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Data de Cadastro',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Data obrigatória'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: _categoriaID,
                            items: categoriaVM.categoriaInsumo
                                .map((c) => DropdownMenuItem(
                                      value: c.id,
                                      child: Text(c.descricao),
                                    ))
                                .toList(),
                            onChanged: (value) => setState(() => _categoriaID = value),
                            decoration: const InputDecoration(
                              labelText: "Categoria",
                              prefixIcon: Icon(Icons.category),
                            ),
                            validator: (value) =>
                                value == null ? "Selecione uma categoria" : null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.add_circle, color: primaryColor),
                          tooltip: 'Nova Categoria',
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CategoriaInsumoFormView(),
                              ),
                            );
                            categoriaVM.fetch();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: _fornecedorID,
                            items: fornecedorVM.forneInsumo
                                .map((f) => DropdownMenuItem(
                                      value: f.id,
                                      child: Text(f.nome),
                                    ))
                                .toList(),
                            onChanged: (value) => setState(() => _fornecedorID = value),
                            decoration: const InputDecoration(
                              labelText: "Fornecedor",
                              prefixIcon: Icon(Icons.business),
                            ),
                            validator: (value) =>
                                value == null ? "Selecione um fornecedor" : null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.add_circle, color: primaryColor),
                          tooltip: 'Novo Fornecedor',
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FornecedorInsumoFormView(),
                              ),
                            );
                            fornecedorVM.fetch();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _salvar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        widget.insumo == null ? "ADICIONAR" : "ATUALIZAR",
                        style: TextStyle(color: whiteColor, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
