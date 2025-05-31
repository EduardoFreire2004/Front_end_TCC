import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/models/ForneSementeModel.dart';
import 'package:flutter_fgl_1/repositories/ForneSementeRepo.dart';
import 'package:flutter_fgl_1/viewmodels/SementeViewmodel.dart';
import 'package:flutter_fgl_1/views/ForneSemente/FornecedorSementeFormView.dart';
import 'package:provider/provider.dart';
import '../../../models/SementeModel.dart';

class SementeFormView extends StatefulWidget {
  final SementeModel? semente;

  const SementeFormView({super.key, this.semente});

  @override
  State<SementeFormView> createState() => _SementeFormViewState();
}

class _SementeFormViewState extends State<SementeFormView> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _tipoController = TextEditingController();
  final _marcaController = TextEditingController();
  final _qtdeController = TextEditingController();

  int? _fornecedorID;
  List<ForneSementeModel> _fornecedores = [];

  @override
  void initState() {
    super.initState();
    _carregarFornecedores();
    if (widget.semente != null) {
      _nomeController.text = widget.semente!.nome;
      _tipoController.text = widget.semente!.tipo;
      _marcaController.text = widget.semente!.marca;
      _qtdeController.text = widget.semente!.qtde.toString();
      _fornecedorID = widget.semente!.fornecedorSementeID;
    }
  }

  Future<void> _carregarFornecedores() async {
    _fornecedores = await ForneSementeRepo().getAll();
    setState(() {});
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final model = SementeModel(
      id: widget.semente?.id,
      nome: _nomeController.text.trim(),
      tipo: _tipoController.text.trim(),
      marca: _marcaController.text.trim(),
      qtde: double.parse(_qtdeController.text),
      fornecedorSementeID: _fornecedorID!,
    );

    final viewModel = Provider.of<SementeViewModel>(context, listen: false);
    widget.semente == null ? viewModel.add(model) : viewModel.update(model);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.semente == null ? 'Nova Semente' : 'Editar Semente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _fornecedores.isEmpty
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
                            validator: (value) =>
                                value == null ? 'Selecione o fornecedor' : null,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FornecedorSementeFormView(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: _nomeController,
                      decoration: InputDecoration(labelText: 'Nome'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Informe o nome' : null,
                    ),
                    TextFormField(
                      controller: _tipoController,
                      decoration: InputDecoration(labelText: 'Tipo'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Informe o tipo' : null,
                    ),
                    TextFormField(
                      controller: _marcaController,
                      decoration: InputDecoration(labelText: 'Marca'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Informe a marca' : null,
                    ),
                    TextFormField(
                      controller: _qtdeController,
                      decoration: InputDecoration(labelText: 'Quantidade'),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value == null || double.tryParse(value) == null
                              ? 'Quantidade inválida'
                              : null,
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
