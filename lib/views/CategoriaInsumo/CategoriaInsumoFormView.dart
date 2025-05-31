import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/viewmodels/CategoriaInsumoViewModel.dart';
import 'package:provider/provider.dart';
import '../../../models/CategoriaInsumoModel.dart';

class CategoriaInsumoFormView extends StatefulWidget {
  final CategoriaInsumoModel? categoria;

  const CategoriaInsumoFormView({super.key, this.categoria});

  @override
  State<CategoriaInsumoFormView> createState() => _CategoriaInsumoFormViewState();
}

class _CategoriaInsumoFormViewState extends State<CategoriaInsumoFormView> {
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.categoria != null) {
      _descricaoController.text = widget.categoria!.descricao;
    }
  }

  void _salvar() {
    if (_formKey.currentState!.validate()) {
      final model = CategoriaInsumoModel(
        id: widget.categoria?.id,
        descricao: _descricaoController.text.trim(),
      );

      final viewModel = Provider.of<CategoriaInsumoViewModel>(context, listen: false);

      widget.categoria == null ? viewModel.add(model) : viewModel.update(model);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoria == null ? 'Nova Categoria' : 'Editar Categoria'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(labelText: 'Descrição'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe a descrição' : null,
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
