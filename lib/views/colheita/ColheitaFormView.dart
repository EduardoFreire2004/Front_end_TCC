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
  final _quantidadeSacasController = TextEditingController();
  final _areaHectaresController = TextEditingController();
  final _cooperativaController = TextEditingController();
  final _precoPorSacaController = TextEditingController();

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

      _quantidadeSacasController.text = widget.colheita!.quantidadeSacas.toStringAsFixed(2);
      _areaHectaresController.text = widget.colheita!.areaHectares.toStringAsFixed(2);
      _cooperativaController.text = widget.colheita!.cooperativaDestino;
      _precoPorSacaController.text = widget.colheita!.precoPorSaca.toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    _dataHoraController.dispose();
    _tipoController.dispose();
    _quantidadeSacasController.dispose();
    _areaHectaresController.dispose();
    _cooperativaController.dispose();
    _precoPorSacaController.dispose();
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
      descricao: _descricaoController.text.trim().isEmpty
          ? null
          : _descricaoController.text.trim(),
      quantidadeSacas:
          double.parse(_quantidadeSacasController.text.replaceAll(',', '.')),
      areaHectares:
          double.parse(_areaHectaresController.text.replaceAll(',', '.')),
      cooperativaDestino: _cooperativaController.text.trim(),
      precoPorSaca: double.parse(
        _precoPorSacaController.text.replaceAll(RegExp(r'[^\d.]'), ''),
      ),
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
              const SizedBox(height: 16),
              _buildTextField(
                controller: _quantidadeSacasController,
                label: 'Quantidade de Sacas (60kg)',
                hint: 'Ex: 1200',
                icon: Icons.shopping_bag,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty)
                    return 'Informe a quantidade de sacas';
                  if (double.tryParse(value.replaceAll(',', '.')) == null)
                    return 'Valor inválido';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _areaHectaresController,
                label: 'Área Colhida (hectares)',
                hint: 'Ex: 20',
                icon: Icons.landscape,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty)
                    return 'Informe a área colhida';
                  if (double.tryParse(value.replaceAll(',', '.')) == null)
                    return 'Valor inválido';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _cooperativaController,
                label: 'Cooperativa de Destino',
                hint: 'Nome da cooperativa',
                icon: Icons.store,
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Informe a cooperativa' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _precoPorSacaController,
                label: 'Preço por Saca (R\$)',
                hint: 'Ex: 130.50',
                icon: Icons.monetization_on,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty)
                    return 'Informe o preço por saca';
                  if (double.tryParse(value.replaceAll(RegExp(r'[^\d.]'), '')) == null)
                    return 'Valor inválido';
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
