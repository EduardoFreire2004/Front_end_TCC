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
  const PlantioFormView({super.key, this.plantio});

  @override
  State<PlantioFormView> createState() => _PlantioFormViewState();
}

class _PlantioFormViewState extends State<PlantioFormView> {
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  final _areaController = TextEditingController();
  final _dataHoraController = TextEditingController();
  int? _sementeID;
  DateTime? _selectedDate;

  final primaryColor = Colors.green[700]!;
  final whiteColor = Colors.white;

  @override
  void initState() {
    super.initState();
    final plantio = widget.plantio;
    if (plantio != null) {
      _descricaoController.text = plantio.descricao;
      _areaController.text = plantio.areaPlantada.toString();
      _sementeID = plantio.sementeID;
      _selectedDate = plantio.dataHora;
      _dataHoraController.text = DateFormat('dd/MM/yyyy HH:mm').format(plantio.dataHora);
    }
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    _areaController.dispose();
    _dataHoraController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate ?? DateTime.now()),
      );

      if (pickedTime != null) {
        final finalDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          _selectedDate = finalDateTime;
          _dataHoraController.text = DateFormat('dd/MM/yyyy HH:mm').format(finalDateTime);
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
      dataHora: _selectedDate!,
      areaPlantada: double.tryParse(_areaController.text.replaceAll(',', '.')) ?? 0.0,
    );

    final viewModel = Provider.of<PlantioViewModel>(context, listen: false);

    if (widget.plantio == null) {
      viewModel.add(model);
    } else {
      viewModel.update(model);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Plantio salvo com sucesso!'), backgroundColor: primaryColor),
    );

    Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    final sementeVM = Provider.of<SementeViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.plantio == null ? 'Novo Plantio' : 'Editar Plantio')),
      body: sementeVM.semente.isEmpty
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _buildTextField(_descricaoController, 'Descrição', Icons.description),
                    const SizedBox(height: 16),
                    _buildTextField(
                      _areaController,
                      'Área Plantada',
                      Icons.terrain,
                      inputType: TextInputType.numberWithOptions(decimal: true),
                      formatter: [FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]'))],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _dataHoraController,
                      readOnly: true,
                      onTap: () => _selectDateTime(context),
                      decoration: const InputDecoration(
                        labelText: 'Data e Hora do Plantio',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Selecione data e hora' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: _sementeID,
                            decoration: const InputDecoration(
                              labelText: "Semente",
                              prefixIcon: Icon(Icons.grass),
                            ),
                            items: sementeVM.semente
                                .map(
                                  (s) => DropdownMenuItem(
                                    value: s.id,
                                    child: Text(s.nome),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) => setState(() => _sementeID = value),
                            validator: (value) => value == null ? "Selecione uma semente" : null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.add_circle, color: primaryColor),
                          tooltip: 'Nova Semente',
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const SementeFormView()),
                            );
                            sementeVM.fetch();
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      ),
                      child: Text(
                        widget.plantio == null ? "ADICIONAR" : "ATUALIZAR",
                        style: TextStyle(color: whiteColor, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
