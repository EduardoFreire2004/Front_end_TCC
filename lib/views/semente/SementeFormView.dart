import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fgl_1/models/SementeModel.dart';
import 'package:flutter_fgl_1/viewmodels/ForneSementeViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/SementeViewModel.dart';
import 'package:flutter_fgl_1/views/ForneSemente/FornecedorSementeFormView.dart';
import 'package:provider/provider.dart';

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

  final primaryColor = Colors.green[700]!;
  final whiteColor = Colors.white;

  @override
  void initState() {
    super.initState();
    final semente = widget.semente;
    if (semente != null) {
      _nomeController.text = semente.nome;
      _tipoController.text = semente.tipo;
      _marcaController.text = semente.marca;
      _qtdeController.text = semente.qtde.toString();
      _fornecedorID = semente.fornecedorSementeID;
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _tipoController.dispose();
    _marcaController.dispose();
    _qtdeController.dispose();
    super.dispose();
  }

  bool _nomeJaExiste(String nome) {
    final viewModel = Provider.of<SementeViewModel>(context, listen: false);
    final lista = viewModel.semente;

    if (widget.semente != null) {
      return lista.any(
        (s) =>
            s.nome.toLowerCase() == nome.toLowerCase() &&
            s.id != widget.semente!.id,
      );
    }

    return lista.any((s) => s.nome.toLowerCase() == nome.toLowerCase());
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final model = SementeModel(
      id: widget.semente?.id,
      nome: _nomeController.text.trim(),
      tipo: _tipoController.text.trim(),
      marca: _marcaController.text.trim(),
      qtde: double.tryParse(_qtdeController.text.replaceAll(',', '.')) ?? 0.0,
      fornecedorSementeID: _fornecedorID!,
    );

    final viewModel = Provider.of<SementeViewModel>(context, listen: false);

    if (widget.semente == null) {
      viewModel.add(model);
    } else {
      viewModel.update(model);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Semente salva com sucesso!"),
        backgroundColor: primaryColor,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final fornecedorVM = Provider.of<ForneSementeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.semente == null ? "Nova Semente" : "Editar Semente"),
      ),
      body: fornecedorVM.forneSemente.isEmpty
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _nomeController,
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                        prefixIcon: Icon(Icons.grass),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nome é obrigatório';
                        }
                        if (_nomeJaExiste(value.trim())) {
                          return 'Este nome já está cadastrado';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(_tipoController, "Tipo", Icons.category),
                    const SizedBox(height: 16),
                    _buildTextField(_marcaController, "Marca", Icons.branding_watermark),
                    const SizedBox(height: 16),
                    _buildTextField(
                      _qtdeController,
                      "Quantidade",
                      Icons.scale,
                      inputType: TextInputType.numberWithOptions(decimal: true),
                      formatter: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9,\.]')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: _fornecedorID,
                            decoration: const InputDecoration(
                              labelText: "Fornecedor",
                              prefixIcon: Icon(Icons.business),
                            ),
                            items: fornecedorVM.forneSemente
                                .map((f) => DropdownMenuItem(
                                      value: f.id,
                                      child: Text(f.nome),
                                    ))
                                .toList(),
                            onChanged: (value) => setState(() => _fornecedorID = value),
                            validator: (value) => value == null ? "Selecione um fornecedor" : null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.add_circle, color: primaryColor),
                          tooltip: 'Novo Fornecedor',
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const FornecedorSementeFormView(),
                              ),
                            );
                            fornecedorVM.fetch();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _salvar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        widget.semente == null ? "ADICIONAR" : "ATUALIZAR",
                        style: TextStyle(color: whiteColor, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType inputType = TextInputType.text,
    List<TextInputFormatter>? formatter,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      keyboardType: inputType,
      inputFormatters: formatter,
      validator: (value) => value == null || value.isEmpty ? "Campo obrigatório" : null,
    );
  }
}
