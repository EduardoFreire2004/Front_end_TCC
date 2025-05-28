import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/AplicacaoModel.dart';
import '../../../models/AgrotoxicoModel.dart';
import '../../../repositories/AgrotoxicoRepo.dart';
import '../../viewmodels/AplicacacaoViewmodel.dart';
import '../agrotoxico/AgrotoxicoFormView.dart';

class AplicacaoFormView extends StatefulWidget {
  final AplicacaoModel? aplicacao;

  const AplicacaoFormView({super.key, this.aplicacao});

  @override
  State<AplicacaoFormView> createState() => _AplicacaoFormViewState();
}

class _AplicacaoFormViewState extends State<AplicacaoFormView> {
  final _formKey = GlobalKey<FormState>();
  final _descController = TextEditingController();
  DateTime _dataHora = DateTime.now();
  int? _agrotoxicoID;

  List<AgrotoxicoModel> _agrotoxicos = [];

  @override
  void initState() {
    super.initState();
    _carregarAgrotoxicos();
    if (widget.aplicacao != null) {
      _descController.text = widget.aplicacao!.descicao;
      _dataHora = widget.aplicacao!.data_Hora;
      _agrotoxicoID = widget.aplicacao!.agrotoxicoID;
    }
  }

  Future<void> _carregarAgrotoxicos() async {
    _agrotoxicos = await AgrotoxicoRepo().getAll();
    setState(() {});
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final model = AplicacaoModel(
      id: widget.aplicacao?.id,
      descicao: _descController.text.trim(),
      data_Hora: _dataHora,
      agrotoxicoID: _agrotoxicoID!,
    );

    final viewModel = Provider.of<AplicacaoViewModel>(context, listen: false);

    widget.aplicacao == null ? viewModel.add(model) : viewModel.update(model);

    Navigator.pop(context);
  }

  void _selecionarDataHora() async {
    final data = await showDatePicker(
      context: context,
      initialDate: _dataHora,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (data != null) {
      final hora = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_dataHora),
      );

      if (hora != null) {
        setState(() {
          _dataHora = DateTime(data.year, data.month, data.day, hora.hour, hora.minute);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.aplicacao == null ? 'Nova Aplicação' : 'Editar Aplicação')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _agrotoxicos.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: _agrotoxicoID,
                            items: _agrotoxicos
                                .map((a) => DropdownMenuItem(value: a.id, child: Text(a.nome)))
                                .toList(),
                            onChanged: (value) => setState(() => _agrotoxicoID = value),
                            decoration: InputDecoration(labelText: 'Agrotóxico'),
                            validator: (value) => value == null ? 'Selecione o agrotóxico' : null,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => AgrotoxicoFormView()),
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: _descController,
                      decoration: InputDecoration(labelText: 'Descrição'),
                      validator: (value) => value == null || value.isEmpty ? 'Informe a descrição' : null,
                    ),
                    ListTile(
                      title: Text('Data e Hora: ${_dataHora.day}/${_dataHora.month}/${_dataHora.year} ${_dataHora.hour}:${_dataHora.minute.toString().padLeft(2, '0')}'),
                      trailing: Icon(Icons.calendar_month),
                      onTap: _selecionarDataHora,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(onPressed: _salvar, child: Text('Salvar')),
                  ],
                ),
              ),
      ),
    );
  }
}
