import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/repositories/SementeRepo.dart';
import 'package:flutter_fgl_1/viewmodels/PlantioViewmodel.dart';
import 'package:provider/provider.dart';
import '../../../models/PlantioModel.dart';
import '../../../models/SementeModel.dart';

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

  int? _sementeID;
  DateTime _dataSelecionada = DateTime.now();

  List<SementeModel> _sementes = [];

  @override
  void initState() {
    super.initState();
    _carregarSementes();
    if (widget.plantio != null) {
      _descricaoController.text = widget.plantio!.descricao;
      _areaController.text = widget.plantio!.areaPlantada.toString();
      _sementeID = widget.plantio!.sementeID;
      _dataSelecionada = widget.plantio!.dataHora;
    }
  }

  Future<void> _carregarSementes() async {
    _sementes = await SementeRepo().getAll();
    setState(() {});
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final model = PlantioModel(
      id: widget.plantio?.id,
      descricao: _descricaoController.text.trim(),
      areaPlantada: double.parse(_areaController.text),
      dataHora: _dataSelecionada,
      sementeID: _sementeID!,
    );

    final viewModel = Provider.of<PlantioViewModel>(context, listen: false);
    widget.plantio == null ? viewModel.add(model) : viewModel.update(model);

    Navigator.pop(context);
  }

  Future<void> _selecionarData() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dataSelecionada = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.plantio == null ? 'Novo Plantio' : 'Editar Plantio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _sementes.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    DropdownButtonFormField<int>(
                      value: _sementeID,
                      items: _sementes
                          .map((s) => DropdownMenuItem(
                                value: s.id,
                                child: Text(s.nome),
                              ))
                          .toList(),
                      onChanged: (value) => setState(() => _sementeID = value),
                      decoration: InputDecoration(labelText: 'Semente'),
                      validator: (value) =>
                          value == null ? 'Selecione a semente' : null,
                    ),
                    TextFormField(
                      controller: _descricaoController,
                      decoration: InputDecoration(labelText: 'Descrição'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Campo obrigatório' : null,
                    ),
                    TextFormField(
                      controller: _areaController,
                      decoration: InputDecoration(labelText: 'Área Plantada (ha)'),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value == null || double.tryParse(value) == null
                              ? 'Informe uma área válida'
                              : null,
                    ),
                    ListTile(
                      title: Text(
                          'Data do Plantio: ${_dataSelecionada.day}/${_dataSelecionada.month}/${_dataSelecionada.year}'),
                      trailing: Icon(Icons.calendar_today),
                      onTap: _selecionarData,
                    ),
                    SizedBox(height: 20),
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
