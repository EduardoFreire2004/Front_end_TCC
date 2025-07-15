import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/models/ColheitaModel.dart';
import 'package:flutter_fgl_1/viewmodels/ColheitaViewModel.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
  DateTime? _dataHora;

  @override
  void initState() {
    super.initState();
    final colheita = widget.colheita;
    if (colheita != null) {
      _tipoController.text = colheita.tipo;
      _descricaoController.text = colheita.descricao ?? '';
      _dataHora = colheita.dataHora;
    }
  }

  @override
  void dispose() {
    _tipoController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final novaColheita = ColheitaModel(
      id: widget.colheita?.id,
      tipo: _tipoController.text.trim(),
      descricao: _descricaoController.text.trim(),
      dataHora: _dataHora!,
    );

    final viewModel = Provider.of<ColheitaViewModel>(context, listen: false);

    if (widget.colheita == null) {
      viewModel.add(novaColheita);
    } else {
      viewModel.update(novaColheita);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Colheita salva com sucesso!')),
    );
    Navigator.pop(context);
  }

  Future<void> _selecionarData() async {
    final DateTime? dataEscolhida = await showDatePicker(
      context: context,
      initialDate: _dataHora ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('pt', 'BR'),
    );
    if (dataEscolhida != null) {
      setState(() {
        _dataHora = dataEscolhida;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.green[700]!;

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
                decoration: const InputDecoration(labelText: 'Tipo'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(_dataHora == null
                    ? 'Selecione uma data'
                    : 'Data: ${DateFormat('dd/MM/yyyy').format(_dataHora!)}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: _selecionarData,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _salvar,
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                child: Text(widget.colheita == null ? 'ADICIONAR' : 'ATUALIZAR'),
              )
            ],
          ),
        ),
      ),
    );
  }
}