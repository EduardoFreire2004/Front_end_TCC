import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/TipoAgrotoxicoModel.dart';
import '../../../viewmodels/TipoAgrotoxicoViewmodel.dart';

class TipoAgrotoxicoFormView extends StatefulWidget {
  final TipoAgrotoxicoModel? tipo;

  const TipoAgrotoxicoFormView({Key? key, this.tipo}) : super(key: key);

  @override
  State<TipoAgrotoxicoFormView> createState() => _TipoAgrotoxicoFormViewState();
}

class _TipoAgrotoxicoFormViewState extends State<TipoAgrotoxicoFormView> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.tipo != null) {
      _nomeController.text = widget.tipo!.descricao;
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final novoTipo = TipoAgrotoxicoModel(
        id: widget.tipo?.id,
        descricao: _nomeController.text.trim(),
      );

      final viewModel = Provider.of<TipoAgrotoxicoViewModel>(context, listen: false);

      if (widget.tipo == null) {
        viewModel.addTipo(novoTipo);
      } else {
        viewModel.updateTipo(novoTipo);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tipo == null ? 'Novo Tipo' : 'Editar Tipo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome do Tipo'),
                validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
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
