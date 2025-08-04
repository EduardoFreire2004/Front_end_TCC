import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fgl_1/models/LavouraModel.dart';
import 'package:flutter_fgl_1/viewmodels/LavouraViewModel.dart';
import 'package:provider/provider.dart';

class LavouraFormView extends StatefulWidget {
  final LavouraModel? lavoura;

  const LavouraFormView({super.key, this.lavoura});

  @override
  State<LavouraFormView> createState() => _LavouraFormViewState();
}

class _LavouraFormViewState extends State<LavouraFormView> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _areaController = TextEditingController();

  final Color primaryColor = Colors.green[700]!;
  final Color primaryColorDark = Colors.green[800]!;
  final Color errorColor = Colors.redAccent;
  final Color lightGreyColor = Colors.grey[400]!;
  final Color mediumGreyColor = Colors.grey[600]!;
  final Color whiteColor = Colors.white;
  final Color formBackgroundColor = Colors.grey[50]!;

  @override
  void initState() {
    super.initState();
    if (widget.lavoura != null) {
      _nomeController.text = widget.lavoura!.nome;
      _areaController.text = widget.lavoura!.area.toString();
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  void _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final lavoura = LavouraModel(
      id: widget.lavoura?.id,
      nome: _nomeController.text.trim(),
      area: double.parse(_areaController.text.replaceAll(',', '.')),
    );

    final viewModel = Provider.of<LavouraViewModel>(context, listen: false);

    try {
      if (widget.lavoura == null) {
        await viewModel.add(lavoura);
      } else {
        await viewModel.update(lavoura);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lavoura salva com sucesso!'),
          backgroundColor: primaryColor,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar: $e'),
          backgroundColor: errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    InputDecorationTheme formInputDecorationTheme = InputDecorationTheme(
      labelStyle: TextStyle(color: primaryColorDark),
      hintStyle: TextStyle(color: mediumGreyColor),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: lightGreyColor),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor, width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: errorColor, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: errorColor, width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      errorStyle: TextStyle(color: errorColor),
      prefixIconColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.error)) return errorColor;
        if (states.contains(MaterialState.focused)) return primaryColor;
        return mediumGreyColor;
      }),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 12.0,
      ),
    );

    return Scaffold(
      backgroundColor: formBackgroundColor,
      appBar: AppBar(
        title: Text(widget.lavoura == null ? 'Nova Lavoura' : 'Editar Lavoura'),
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          inputDecorationTheme: formInputDecorationTheme,
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: primaryColor,
            selectionColor: primaryColor.withOpacity(0.3),
            selectionHandleColor: primaryColor,
          ),
          colorScheme: Theme.of(
            context,
          ).colorScheme.copyWith(error: errorColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                _buildTextField(
                  controller: _nomeController,
                  label: 'Nome da Lavoura',
                  hint: 'Informe o nome da lavoura',
                  icon: Icons.agriculture,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nome é obrigatório';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _areaController,
                  label: 'Área (ha)',
                  hint: 'Ex: 10.5',
                  icon: Icons.square_foot_outlined,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+[,.]?\d{0,2}'),
                    ),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Área é obrigatória';
                    }
                    if (double.tryParse(value.replaceAll(',', '.')) == null) {
                      return 'Informe um valor válido';
                    }
                    return null;
                  },
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
                    widget.lavoura == null ? 'ADICIONAR' : 'ATUALIZAR',
                    style: TextStyle(fontSize: 16, color: whiteColor),
                  ),
                ),
              ],
            ),
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
      ),
      validator: validator,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
    );
  }
}
