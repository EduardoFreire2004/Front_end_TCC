import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fgl_1/models/ColheitaModel.dart';
import 'package:flutter_fgl_1/viewmodels/ColheitaViewModel.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ColheitaFormView extends StatefulWidget {
  final ColheitaModel? colheita;
  final int lavouraId;

  const ColheitaFormView({
    super.key,
    this.colheita,
    required this.lavouraId,
  });

  @override
  State<ColheitaFormView> createState() => _ColheitaFormViewState();
}

class _ColheitaFormViewState extends State<ColheitaFormView> {
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  final _dataHoraController = TextEditingController();
  final _tipoController = TextEditingController();

  DateTime? _dataHora;

  final Color primaryColor = Colors.green[700]!;
  final Color primaryColorDark = Colors.green[800]!;
  final Color whiteColor = Colors.white;
  final Color formBackgroundColor = Colors.grey[50]!;

  @override
  void initState() {
    super.initState();
    if (widget.colheita != null) {
      _descricaoController.text = widget.colheita!.descricao ?? '';
      _tipoController.text = widget.colheita!.tipo;
      _dataHora = widget.colheita!.dataHora;
      _dataHoraController.text = DateFormat('dd/MM/yyyy HH:mm').format(_dataHora!);
    }
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    _dataHoraController.dispose();
    _tipoController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _dataHora ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: primaryColor,
            onPrimary: whiteColor,
            onSurface: primaryColorDark,
          ),
        ),
        child: child!,
      ),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_dataHora ?? DateTime.now()),
        builder: (context, child) => Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: whiteColor,
              onSurface: primaryColorDark,
            ),
          ),
          child: child!,
        ),
      );

      if (pickedTime != null) {
        setState(() {
          _dataHora = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _dataHoraController.text = DateFormat('dd/MM/yyyy HH:mm').format(_dataHora!);
        });
      }
    }
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final model = ColheitaModel(
      id: widget.colheita?.id,
      lavouraID: widget.lavouraId,
      tipo: _tipoController.text.trim(),
      dataHora: _dataHora!,
      descricao: _descricaoController.text.trim().isEmpty ? null : _descricaoController.text.trim(),
    );

    final viewModel = Provider.of<ColheitaViewModel>(context, listen: false);
    if (widget.colheita == null) {
      viewModel.add(model);
    } else {
      viewModel.update(model);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Colheita salva com sucesso!'),
        backgroundColor: primaryColor,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: formBackgroundColor,
      appBar: AppBar(
        title: Text(widget.colheita == null ? 'Nova Colheita' : 'Editar Colheita'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                controller: _tipoController,
                label: 'Tipo de Colheita',
                hint: 'Ex: Manual, Mecanizada',
                icon: Icons.category,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Tipo é obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _descricaoController,
                label: 'Descrição (opcional)',
                hint: 'Detalhes adicionais da colheita',
                icon: Icons.description,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dataHoraController,
                readOnly: true,
                onTap: () => _selectDateTime(context),
                decoration: const InputDecoration(
                  labelText: 'Data e Hora da Colheita',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Selecione data e hora' : null,
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
                  widget.colheita == null ? 'ADICIONAR' : 'ATUALIZAR',
                  style: TextStyle(fontSize: 16, color: whiteColor),
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
