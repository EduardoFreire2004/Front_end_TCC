import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fgl_1/models/AplicacaoModel.dart';
import 'package:flutter_fgl_1/viewmodels/AgrotoxicoViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/AplicacacaoViewmodel.dart';
import 'package:flutter_fgl_1/views/Agrotoxico/AgrotoxicoFormView.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AplicacaoFormView extends StatefulWidget {
  final AplicacaoModel? aplicacao;
  final int lavouraId;

  const AplicacaoFormView({super.key, this.aplicacao, required this.lavouraId});

  @override
  State<AplicacaoFormView> createState() => _AplicacaoFormViewState();
}

class _AplicacaoFormViewState extends State<AplicacaoFormView> {
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  final _dataHoraController = TextEditingController();
  final _qtdeController = TextEditingController();

  int? _agrotoxicoID;
  DateTime? _dataHora;
  double? _qtde;

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
    if (widget.aplicacao != null) {
      _descricaoController.text = widget.aplicacao!.descricao;
      _agrotoxicoID = widget.aplicacao!.agrotoxicoID;
      _dataHora = widget.aplicacao!.dataHora;
      _qtde = widget.aplicacao!.qtde;
      _dataHoraController.text = DateFormat(
        'dd/MM/yyyy HH:mm',
      ).format(_dataHora!);
      _qtdeController.text = _qtde.toString();
    }
  }

  @override
  void dispose() {
    _descricaoController.dispose();
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

    final model = AplicacaoModel(
      id: widget.aplicacao?.id,
      descricao: _descricaoController.text.trim(),
      dataHora: _dataHora!,
      agrotoxicoID: _agrotoxicoID!,
      lavouraID: widget.lavouraId,
      qtde: _qtde ?? double.parse(_qtdeController.text),
    );

    final viewModel = Provider.of<AplicacaoViewModel>(context, listen: false);

    if (widget.aplicacao == null) {
      viewModel.add(model);
    } else {
      viewModel.update(model);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Aplicação salva com sucesso!'),
        backgroundColor: primaryColor,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final agrotoxicoViewModel = Provider.of<AgrotoxicoViewModel>(context);

    return Scaffold(
      backgroundColor: formBackgroundColor,
      appBar: AppBar(
        title: Text(
          widget.aplicacao == null ? 'Nova Aplicação' : 'Editar Aplicação',
        ),
      ),
      body:
          agrotoxicoViewModel.lista.isEmpty
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
                        hint: 'Ex: Aplicação na lavoura A',
                        icon: Icons.description,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Descrição é obrigatória';
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
                              value: _agrotoxicoID,
                              items:
                                  agrotoxicoViewModel.lista.map((a) {
                                    return DropdownMenuItem(
                                      value: a.id,
                                      child: Text(a.nome),
                                    );
                                  }).toList(),
                              onChanged:
                                  (value) =>
                                      setState(() => _agrotoxicoID = value),
                              decoration: const InputDecoration(
                                labelText: 'Agrotóxico',
                                prefixIcon: Icon(Icons.science),
                              ),
                              validator:
                                  (value) =>
                                      value == null
                                          ? 'Selecione um agrotóxico'
                                          : null,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(Icons.add_circle, color: primaryColor),
                            tooltip: 'Novo Agrotóxico',
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AgrotoxicoFormView(),
                                ),
                              );
                              agrotoxicoViewModel.fetch();
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
                        decoration: const InputDecoration(
                          labelText: 'Data e Hora da Aplicação',
                          prefixIcon: Icon(Icons.calendar_today),
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
                          widget.aplicacao == null ? 'ADICIONAR' : 'ATUALIZAR',
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
