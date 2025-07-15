import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fgl_1/models/CategoriaInsumoModel.dart';
import 'package:flutter_fgl_1/viewmodels/CategoriaInsumoViewModel.dart';
import 'package:provider/provider.dart';

class CategoriaInsumoFormView extends StatefulWidget {
  final CategoriaInsumoModel? categoria;

  const CategoriaInsumoFormView({Key? key, this.categoria}) : super(key: key);

  @override
  State<CategoriaInsumoFormView> createState() => _TipoAgrotoxicoFormViewState();
}

class _TipoAgrotoxicoFormViewState extends State<CategoriaInsumoFormView> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.categoria != null) {
      _nomeController.text = widget.categoria!.descricao;
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final categoria = CategoriaInsumoModel(
        id: widget.categoria?.id,
        descricao: _nomeController.text.trim(),
      );

      final viewModel = Provider.of<CategoriaInsumoViewModel>(
        context,
        listen: false,
      );

      if (widget.categoria == null) {
        viewModel.add(categoria);
      } else {
        viewModel.update(categoria);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('categoria salvo com sucesso!'),
          backgroundColor: Colors.green[600],
        ),
      );

      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  bool _nomeJaExiste(String nome) {
    final viewModel = Provider.of<CategoriaInsumoViewModel>(
      context,
      listen: false,
    );
    final lista = viewModel.categoriaInsumo;

    if (widget.categoria != null) {
      return lista.any(
        (f) =>
            f.descricao.toLowerCase() == nome.toLowerCase() &&
            f.id != widget.categoria!.id,
      );
    }

    return lista.any((f) => f.descricao.toLowerCase() == nome.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.green[700];
    final errorColor = Colors.redAccent;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoria == null ? 'Nova categoria' : 'Editar categoria'),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                controller: _nomeController,
                label: 'Nome',
                hint: 'Nome da categoria',
                icon: Icons.spa,
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
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _save,
                icon: Icon(Icons.check),
                label: Text('Salvar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      validator: validator,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
    );
  }
}
