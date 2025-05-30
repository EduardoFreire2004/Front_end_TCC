import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/viewmodels/ColheitaViewmodel.dart';
import 'package:provider/provider.dart';
import '../../../models/ColheitaModel.dart';

class ColheitaFormView extends StatefulWidget {
  final ColheitaModel? colheita;

  const ColheitaFormView({super.key, this.colheita});

  @override
  State<ColheitaFormView> createState() => _ColheitaFormViewState();
}

class _ColheitaFormViewState extends State<ColheitaFormView> {
  final _formKey = GlobalKey<FormState>();
  final _tipoController = TextEditingController();
  final _descricaoController = TextEditingController();

  DateTime _dataSelecionada = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.colheita != null) {
      _tipoController.text = widget.colheita!.tipo;
      _descricaoController.text = widget.colheita!.descricao ?? '';
      _dataSelecionada = widget.colheita!.dataHora;
    }
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final model = ColheitaModel(
      id: widget.colheita?.id,
      tipo: _tipoController.text.trim(),
      descricao: _descricaoController.text.trim().isEmpty
          ? null
          : _descricaoController.text.trim(),
      dataHora: _dataSelecionada,
    );

    final viewModel = Provider.of<ColheitaViewmodel>(context, listen: false);
    widget.colheita == null ? viewModel.add(model) : viewModel.update(model);

    Navigator.pop(context);
  }

  Future<void> _selecionarData() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dataSelecionada = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.colheita == null ? 'Nova Colheita' : 'Editar Colheita'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tipoController,
                decoration: InputDecoration(labelText: 'Tipo'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o tipo' : null,
              ),
              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(labelText: 'Descrição (opcional)'),
              ),
              ListTile(
                title: Text(
                    'Data: ${_dataSelecionada.day}/${_dataSelecionada.month}/${_dataSelecionada.year}'),
                trailing: Icon(Icons.calendar_today),
                onTap: _selecionarData,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvar,
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
