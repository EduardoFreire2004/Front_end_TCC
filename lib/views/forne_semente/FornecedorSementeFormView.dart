import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/models/ForneSementeModel.dart';
import 'package:flutter_fgl_1/viewmodels/ForneSementeViewmodel.dart';
import 'package:provider/provider.dart';

class FornecedorSementeFormView extends StatefulWidget {
  final ForneSementeModel? fornecedor;

  const FornecedorSementeFormView({super.key, this.fornecedor});

  @override
  State<FornecedorSementeFormView> createState() => _FornecedorSementeFormViewState();
}

class _FornecedorSementeFormViewState extends State<FornecedorSementeFormView> {
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

  void _salvar() {
    if (_formKey.currentState!.validate()) {
      final model = ForneSementeModel(
        id: widget.fornecedor?.id,
        nome: _nomeController.text.trim(),
        cnpj: _cnpjController.text.trim(),
        telefone: _telefoneController.text.trim(),
      );

      final viewModel = Provider.of<FornecedorSementeViewModel>(context, listen: false);

      widget.fornecedor == null ? viewModel.add(model) : viewModel.update(model);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fornecedor == null ? 'Novo Fornecedor' : 'Editar Fornecedor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) => value == null || value.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: _cnpjController,
                decoration: InputDecoration(labelText: 'CNPJ'),
                validator: (value) => value == null || value.isEmpty ? 'Informe o CNPJ' : null,
              ),
              TextFormField(
                controller: _telefoneController,
                decoration: InputDecoration(labelText: 'Telefone'),
                validator: (value) => value == null || value.isEmpty ? 'Informe o telefone' : null,
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
