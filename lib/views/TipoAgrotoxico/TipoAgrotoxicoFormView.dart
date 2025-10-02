import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fgl_1/models/TipoAgrotoxicoModel.dart';
import 'package:flutter_fgl_1/viewmodels/TipoAgrotoxicoViewModel.dart';
import 'package:provider/provider.dart';

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

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final tipo = TipoAgrotoxicoModel(
        id: widget.tipo?.id,
        descricao: _nomeController.text.trim(),
      );

      final viewModel = Provider.of<TipoAgrotoxicoViewModel>(
        context,
        listen: false,
      );

      if (widget.tipo == null) {
        viewModel.add(tipo);
      } else {
        viewModel.update(tipo);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('tipo salvo com sucesso!'),
          backgroundColor: Colors.green[600],
        ),
      );

      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  bool _nomeJaExiste(String nome) {
    final viewModel = Provider.of<TipoAgrotoxicoViewModel>(
      context,
      listen: false,
    );
    final lista = viewModel.tipo;

    if (widget.tipo != null) {
      return lista.any(
        (f) =>
            f.descricao.toLowerCase() == nome.toLowerCase() &&
            f.id != widget.tipo!.id,
      );
    }

    return lista.any((f) => f.descricao.toLowerCase() == nome.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.green[700];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tipo == null ? 'Novo tipo' : 'Editar tipo'),
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
                hint: 'Nome do tipo',
                icon: Icons.grass,
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

