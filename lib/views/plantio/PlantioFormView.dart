import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fgl_1/models/PlantioModel.dart';
import 'package:flutter_fgl_1/viewmodels/PlantioViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/SementeViewModel.dart';
import 'package:flutter_fgl_1/views/Semente/SementeFormView.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PlantioFormView extends StatefulWidget {
  final PlantioModel? plantio;
  final int lavouraId;

  const PlantioFormView({super.key, this.plantio, required this.lavouraId});

  @override
  State<PlantioFormView> createState() => _PlantioFormViewState();
}

class _PlantioFormViewState extends State<PlantioFormView> {
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  final _areaController = TextEditingController();
  final _dataHoraController = TextEditingController();
  final _qtdeController = TextEditingController();

  int? _sementeID;
  DateTime? _dataHora;
  double? _qtde;

  final Color primaryColor = Colors.green[700]!;
  final Color primaryColorDark = Colors.green[800]!;
  final Color errorColor = Colors.redAccent;
  final Color whiteColor = Colors.white;
  final Color formBackgroundColor = Colors.grey[50]!;

  @override
  void initState() {
    super.initState();
    if (widget.plantio != null) {
      _descricaoController.text = widget.plantio!.descricao;
      _areaController.text = widget.plantio!.areaPlantada.toString().replaceAll(
        '.',
        ',',
      );
      _sementeID = widget.plantio!.sementeID;
      _dataHora = widget.plantio!.dataHora;
      _qtde = widget.plantio!.qtde;
      _dataHoraController.text = DateFormat(
        'dd/MM/yyyy HH:mm',
      ).format(_dataHora!);
    }
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    _areaController.dispose();
    _dataHoraController.dispose();
    _qtdeController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _dataHora ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder:
          (context, child) => Theme(
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
        builder:
            (context, child) => Theme(
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
          _dataHoraController.text = DateFormat(
            'dd/MM/yyyy HH:mm',
          ).format(_dataHora!);
        });
      }
    }
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final model = PlantioModel(
      id: widget.plantio?.id,
      descricao: _descricaoController.text.trim(),
      sementeID: _sementeID!,
      qtde: _qtde ?? double.parse(_qtdeController.text),
      dataHora: _dataHora!,
      areaPlantada:
          double.tryParse(_areaController.text.replaceAll(',', '.')) ?? 0.0,
      lavouraID: widget.lavouraId,
    );

    final viewModel = Provider.of<PlantioViewModel>(context, listen: false);

    if (widget.plantio == null) {
      viewModel.add(model);
    } else {
      viewModel.update(model);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Plantio salvo com sucesso!'),
        backgroundColor: primaryColor,
      ),
    );

    Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    final sementeViewModel = Provider.of<SementeViewModel>(context);

    return Scaffold(
      backgroundColor: formBackgroundColor,
      appBar: AppBar(
        title: Text(widget.plantio == null ? 'Novo Plantio' : 'Editar Plantio'),
      ),
      body:
          sementeViewModel.semente.isEmpty
              ? Center(child: CircularProgressIndicator(color: primaryColor))
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      _buildTextField(
                        controller: _descricaoController,
                        label: 'Descrição',
                        hint: 'Ex: Plantio de Soja Safra 2025',
                        icon: Icons.description,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Descrição é obrigatória';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _areaController,
                        label: 'Área Plantada (ha)',
                        hint: 'Ex: 150.5',
                        icon: Icons.map_outlined,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[\d,.]')),
                        ],
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Área é obrigatória';
                          }
                          if (double.tryParse(value.replaceAll(',', '.')) ==
                              null) {
                            return 'Valor numérico inválido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              value: _sementeID,
                              items:
                                  sementeViewModel.semente.map((s) {
                                    return DropdownMenuItem(
                                      value: s.id,
                                      child: Text(s.nome),
                                    );
                                  }).toList(),
                              onChanged:
                                  (value) => setState(() => _sementeID = value),
                              decoration: InputDecoration(
                                labelText: 'Semente',
                                prefixIcon: const Icon(Icons.grass),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              validator:
                                  (value) =>
                                      value == null
                                          ? 'Selecione uma semente'
                                          : null,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(
                              Icons.add_circle,
                              color: primaryColor,
                              size: 30,
                            ),
                            tooltip: 'Nova Semente',
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SementeFormView(),
                                ),
                              );
                              sementeViewModel.fetch();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _qtdeController,
                        decoration: const InputDecoration(
                          labelText: 'Quantidade',
                          prefixIcon: Icon(Icons.scale),
                          hintText: 'Ex: 2.5',
                        ),
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*'),
                          ),
                        ],
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Quantidade é obrigatória';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Digite uma quantidade válida';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Quantidade deve ser maior que zero';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _dataHoraController,
                        readOnly: true,
                        onTap: () => _selectDateTime(context),
                        decoration: InputDecoration(
                          labelText: 'Data e Hora do Plantio',
                          prefixIcon: const Icon(Icons.calendar_today),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Selecione data e hora'
                                    : null,
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
                          widget.plantio == null ? 'ADICIONAR' : 'ATUALIZAR',
                          style: TextStyle(fontSize: 16, color: whiteColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
