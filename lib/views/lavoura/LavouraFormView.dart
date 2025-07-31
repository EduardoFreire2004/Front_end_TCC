import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/models/LavouraModel.dart';
import 'package:flutter_fgl_1/viewmodels/LavouraViewModel.dart';
import 'package:provider/provider.dart';

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

  void _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final lavouraViewModel = Provider.of<LavouraViewModel>(context, listen: false);

    final novaLavoura = LavouraModel(
      id: widget.lavoura?.id,
      nome: _nomeController.text.trim(),
      area: double.parse(_areaController.text),
    );

    try {
      if (widget.lavoura == null) {
        await lavouraViewModel.add(novaLavoura);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lavoura criada com sucesso')),
        );
      } else {
        await lavouraViewModel.update(novaLavoura);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lavoura atualizada com sucesso')),
        );
      }

      Navigator.pop(context); // Volta após salvar
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: $e')),
      );
    }
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
          ElevatedButton(
            onPressed: _salvar,
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
