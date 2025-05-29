import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fgl_1/repositories/CategoriaInsumoRepo.dart';
import 'package:flutter_fgl_1/repositories/ForneInsumoRepo.dart';
import 'package:flutter_fgl_1/viewmodels/InsumoViewmodel.dart';
import 'package:provider/provider.dart';
import '../../../models/InsumoModel.dart';
import '../../../models/CategoriaInsumoModel.dart';
import '../../../models/ForneInsumoModel.dart';

class InsumoFormView extends StatefulWidget {
  final InsumoModel? insumo;

  const InsumoFormView({super.key, this.insumo});

  @override
  State<InsumoFormView> createState() => _InsumoFormViewState();
}

class _InsumoFormViewState extends State<InsumoFormView> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _unidadeController = TextEditingController();
  final _qtdeController = TextEditingController();
  final _data_CadastroController = TextEditingController();


  int? _fornecedorID;
  int? _categoriaID;


  List<ForneInsumoModel> _fornecedores = [];
  List<CategoriaInsumoModel> _categorias = [];

  @override
  void initState() {
    super.initState();
    _carregarDropdowns();
    if (widget.insumo != null) {
      _nomeController.text = widget.insumo!.nome;
      _unidadeController.text = widget.insumo!.unidade_Medida;
      _qtdeController.text = widget.insumo!.qtde.toString();
      _fornecedorID = widget.insumo!.fornecedorID;
      _categoriaID = widget.insumo!.categoriaID;
      _data_CadastroController.text = widget.insumo!.data_Cadastro.toIso8601String();

    }
  }

  Future<void> _carregarDropdowns() async {
    _fornecedores = await ForneInsumoRepo().getAll();
    _categorias = await CategoriaInsumoRepo().getAll();
    setState(() {});
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final model = InsumoModel(
      id: widget.insumo?.id,
      nome: _nomeController.text.trim(),
      unidade_Medida: _unidadeController.text.trim(),
      qtde: double.parse(_qtdeController.text),
      data_Cadastro: DateTime.now(),
      fornecedorID: _fornecedorID!,
      categoriaID: _categoriaID!,
    );

    final viewModel = Provider.of<InsumoViewModel>(context, listen: false);

    widget.insumo == null ? viewModel.add(model) : viewModel.update(model);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.insumo == null ? 'Novo Insumo' : 'Editar Insumo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _fornecedores.isEmpty || _categorias.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: _fornecedorID,
                            items: _fornecedores
                                .map((f) => DropdownMenuItem(
                                      value: f.id,
                                      child: Text(f.nome),
                                    ))
                                .toList(),
                            onChanged: (value) => setState(() => _fornecedorID = value),
                            decoration: InputDecoration(labelText: 'Fornecedor'),
                            validator: (value) => value == null ? 'Selecione o fornecedor' : null,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: _categoriaID,
                            items: _categorias
                                .map((c) => DropdownMenuItem(
                                      value: c.id,
                                      child: Text(c.descricao),
                                    ))
                                .toList(),
                            onChanged: (value) => setState(() => _categoriaID = value),
                            decoration: InputDecoration(labelText: 'Categoria'),
                            validator: (value) => value == null ? 'Selecione a categoria' : null,
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: _nomeController,
                      decoration: InputDecoration(labelText: 'Nome'),
                      validator: (value) => value == null || value.isEmpty ? 'Informe o nome' : null,
                    ),
                    TextFormField(
                      controller: _unidadeController,
                      decoration: InputDecoration(labelText: 'Unidade de Medida'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Campo obrigatório' : null,
                    ),
                    TextFormField(
                      controller: _qtdeController,
                      decoration: InputDecoration(labelText: 'Quantidade'),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value == null || double.tryParse(value) == null ? 'Valor inválido' : null,
                    ),
                     SizedBox(height: 16),
                    TextFormField(
                      controller: _data_CadastroController,
                      decoration: InputDecoration(
                        labelText: 'Data de Cadastro',
                        labelStyle: TextStyle(color: Color(0xFF1976D2)),
                        hintText: 'DD/MM/AAAA',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Color(0xFF2E7D32)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Color(0xFF2E7D32)),
                        ),
                      ),
                      style: TextStyle(color: Color(0xFF2E7D32)),
                      keyboardType: TextInputType.datetime,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(8),
                        _DateInputFormatter(),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Data de cadastro é obrigatória';
                        } else if (value.length != 10) {
                          return 'Data inválida';
                        }
                        try {
                          final parts = value.split('/');
                          final day = int.parse(parts[0]);
                          final month = int.parse(parts[1]);
                          final year = int.parse(parts[2]);
                          final data = DateTime(year, month, day);

                          if (data.isAfter(DateTime.now())) {
                            return 'Data não pode ser no futuro';
                          }
                        } catch (e) {
                          return 'Data inválida';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(onPressed: _salvar, child: Text('Salvar')),
                  ],
                ),
              ),
      ),
    );
  }
}

class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final String text = newValue.text.replaceAll(r'[^0-9]', '');

    if (text.length > 8) {
      return oldValue;
    }

    String formatted = '';

    if (text.length >= 2) {
      formatted += '${text.substring(0, 2)}/';
      if (text.length >= 4) {
        formatted += '${text.substring(2, 4)}/';
        if (text.length > 4) {
          formatted += text.substring(4);
        }
      } else {
        formatted += text.substring(2);
      }
    } else {
      formatted = text;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
