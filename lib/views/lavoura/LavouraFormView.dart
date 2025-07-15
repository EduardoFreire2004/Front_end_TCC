import 'package:flutter/material.dart';
import '../../../models/LavouraModel.dart';

class LavouraFormView extends StatelessWidget {
  final LavouraModel? lavoura;

  const LavouraFormView({super.key, this.lavoura});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lavoura == null ? 'Nova Lavoura' : 'Editar Lavoura'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormLavouraCadastro(lavoura: lavoura),
      ),
    );
  }
}

class FormLavouraCadastro extends StatefulWidget {
  final LavouraModel? lavoura;

  const FormLavouraCadastro({super.key, this.lavoura});

  @override
  State<FormLavouraCadastro> createState() => _FormLavouraCadastroState();
}

class _FormLavouraCadastroState extends State<FormLavouraCadastro> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _areaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.lavoura != null) {
      _nomeController.text = widget.lavoura!.nome;
      _areaController.text = widget.lavoura!.area.toString();
    }
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final novaLavoura = LavouraModel(
      id: widget.lavoura?.id,
      nome: _nomeController.text.trim(),
      area: double.parse(_areaController.text),
    );

    Navigator.pop(context, novaLavoura);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          TextFormField(
            controller: _nomeController,
            decoration: const InputDecoration(labelText: 'Nome da Lavoura'),
            validator: (value) =>
                value == null || value.isEmpty ? 'Informe o nome' : null,
          ),
          TextFormField(
            controller: _areaController,
            decoration: const InputDecoration(labelText: 'Área (hectares)'),
            keyboardType: TextInputType.number,
            validator: (value) =>
                value == null || double.tryParse(value) == null
                    ? 'Área inválida'
                    : null,
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _salvar, child: const Text('Salvar')),
        ],
      ),
    );
  }
}
