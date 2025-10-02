import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../models/FornecedoresModel.dart';
import '../../viewmodels/FornecedoresViewmodel.dart';

class FornecedoresFormView extends StatefulWidget {
  final FornecedoresModel? fornecedor;

  const FornecedoresFormView({Key? key, this.fornecedor}) : super(key: key);

  @override
  State<FornecedoresFormView> createState() =>
      _FornecedorAgrotoxicoFormViewState();
}

class _FornecedorAgrotoxicoFormViewState extends State<FornecedoresFormView> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _telefoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.fornecedor != null) {
      _nomeController.text = widget.fornecedor!.nome;
      _cnpjController.text = widget.fornecedor!.cnpj;
      _telefoneController.text = widget.fornecedor!.telefone;
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _cnpjController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final fornecedor = FornecedoresModel(
        id: widget.fornecedor?.id,
        nome: _nomeController.text.trim(),
        cnpj: _cnpjController.text.trim(),
        telefone: _telefoneController.text.trim(),
      );

      final viewModel = Provider.of<FornecedoresViewModel>(
        context,
        listen: false,
      );

      if (widget.fornecedor == null) {
        viewModel.add(fornecedor);
      } else {
        viewModel.update(fornecedor);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fornecedor salvo com sucesso!'),
          backgroundColor: Colors.green[600],
        ),
      );

      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  bool _nomeJaExiste(String nome) {
    final viewModel = Provider.of<FornecedoresViewModel>(
      context,
      listen: false,
    );
    final lista = viewModel.fornecedores;

    if (widget.fornecedor != null) {
      return lista.any(
        (f) =>
            f.nome.toLowerCase() == nome.toLowerCase() &&
            f.id != widget.fornecedor!.id,
      );
    }

    return lista.any((f) => f.nome.toLowerCase() == nome.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.green[700];
    final errorColor = Colors.redAccent;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.fornecedor == null ? 'Novo Fornecedor' : 'Editar Fornecedor',
        ),
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
                hint: 'Nome da empresa',
                icon: Icons.business,
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
              SizedBox(height: 16),
              _buildTextField(
                controller: _cnpjController,
                label: 'CNPJ',
                hint: '00.000.000/0000-00',
                icon: Icons.article,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  _CnpjInputFormatter(),
                  LengthLimitingTextInputFormatter(18),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'CNPJ é obrigatório';
                  }
                  final cnpj = value.replaceAll(RegExp(r'\D'), '');
                  if (cnpj.length != 14) {
                    return 'CNPJ inválido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _telefoneController,
                label: 'Telefone',
                hint: '(99) 99999-9999',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  _TelefoneInputFormatter(),
                  LengthLimitingTextInputFormatter(15),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Telefone é obrigatório';
                  }
                  final tel = value.replaceAll(RegExp(r'\D'), '');

                  if (tel.length < 10 || tel.length > 11) {
                    return 'Telefone deve ter 10 ou 11 dígitos';
                  }

                  if (tel.length == 11 && tel[0] != '0') {
                    return 'DDD deve começar com 0';
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

class _CnpjInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    String newText = '';
    if (digits.length >= 3) {
      newText = '${digits.substring(0, 2)}.${digits.substring(2)}';
    }
    if (digits.length >= 6) {
      newText =
          '${digits.substring(0, 2)}.${digits.substring(2, 5)}.${digits.substring(5)}';
    }
    if (digits.length >= 9) {
      newText =
          '${digits.substring(0, 2)}.${digits.substring(2, 5)}.${digits.substring(5, 8)}/${digits.substring(8)}';
    }
    if (digits.length >= 13) {
      newText =
          '${digits.substring(0, 2)}.${digits.substring(2, 5)}.${digits.substring(5, 8)}/${digits.substring(8, 12)}-${digits.substring(12)}';
    }

    return TextEditingValue(
      text: newText.isEmpty ? digits : newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class _TelefoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    String newText = '';

    if (digits.length >= 1) newText = '(${digits.substring(0, 2)}';
    if (digits.length >= 3)
      newText += ') ${digits.substring(2, digits.length.clamp(2, 7))}';
    if (digits.length >= 8)
      newText += '-${digits.substring(7, digits.length.clamp(7, 11))}';

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

