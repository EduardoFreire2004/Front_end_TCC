import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/ForneAgrotoxicoModel.dart';
import '../../viewmodels/ForneAgrotoxicoViewModel.dart';

class FornecedorAgrotoxicoFormView extends StatefulWidget {
  final ForneAgrotoxicoModel? fornecedor;

  const FornecedorAgrotoxicoFormView({Key? key, this.fornecedor}) : super(key: key);

  @override
  State<FornecedorAgrotoxicoFormView> createState() => _FornecedorAgrotoxicoFormViewState();
}

class _FornecedorAgrotoxicoFormViewState extends State<FornecedorAgrotoxicoFormView> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _telefoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.fornecedor != null) {
      _nomeController.text = widget.fornecedor!.nome;
      _cnpjController.text = widget.fornecedor!.cnpj;
      _telefoneController.text = widget.fornecedor!.telefone;
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final novo = ForneAgrotoxicoModel(
        id: widget.fornecedor?.id,
        nome: _nomeController.text.trim(),
        cnpj: _cnpjController.text.trim(),
        telefone: _telefoneController.text.trim(),
      );

      final viewModel = Provider.of<ForneAgrotoxicoViewModel>(context, listen: false);

      if (widget.fornecedor == null) {
        viewModel.add(novo);
      } else {
        viewModel.update(novo);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.fornecedor == null ? 'Novo Fornecedor' : 'Editar Fornecedor')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _cnpjController,
                decoration: InputDecoration(labelText: 'CNPJ'),
                validator: (value) => value == null || value.isEmpty ? 'Informe um CNPJ válido' : null,
              ),
              TextFormField(
                controller: _telefoneController,
                decoration: InputDecoration(labelText: 'Telefone'),
                validator: (value) => value == null || value.isEmpty ? 'Informe um telefone' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _save,
                child: Text('Salvar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
