import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fgl_1/models/SementeModel.dart';
import 'package:flutter_fgl_1/viewmodels/FornecedoresViewmodel.dart';
import 'package:flutter_fgl_1/viewmodels/SementeViewModel.dart';
import 'package:flutter_fgl_1/views/Fornecedores/FornecedoresFormView.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class SementeFormView extends StatefulWidget {
  final SementeModel? semente;
  const SementeFormView({super.key, this.semente});

  @override
  State<SementeFormView> createState() => _SementeFormViewState();
}

class _SementeFormViewState extends State<SementeFormView> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _dataCadastroController = TextEditingController();
  final _tipoController = TextEditingController();
  final _marcaController = TextEditingController();
  final _precoController = TextEditingController();

  int? _fornecedorID;
  DateTime? _selectedDate;

  final primaryColor = Colors.green[700]!;
  final whiteColor = Colors.white;
  final Color primaryColorDark = Colors.green[800]!;

  @override
  void initState() {
    super.initState();
    final semente = widget.semente;
    if (semente != null) {
      _nomeController.text = semente.nome;
      _tipoController.text = semente.tipo;
      _marcaController.text = semente.marca;
      _fornecedorID = semente.fornecedorSementeID;
      _selectedDate = semente.data_Cadastro;
      if (_selectedDate != null) {
        _dataCadastroController.text = DateFormat(
          'dd/MM/yyyy',
        ).format(_selectedDate!);
      }

      if (semente.preco != null) {
        _precoController.text = toCurrencyString(
          semente.preco.toStringAsFixed(2),
          leadingSymbol: 'R\$ ',
          useSymbolPadding: true,
        );
      }
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _tipoController.dispose();
    _marcaController.dispose();
    _precoController.dispose();
    _dataCadastroController.dispose();
    super.dispose();
  }

  bool _nomeJaExiste(String nome) {
    final viewModel = Provider.of<SementeViewModel>(context, listen: false);
    final lista = viewModel.semente;

    if (widget.semente != null) {
      return lista.any(
        (s) =>
            s.nome.toLowerCase() == nome.toLowerCase() &&
            s.id != widget.semente!.id,
      );
    }

    return lista.any((s) => s.nome.toLowerCase() == nome.toLowerCase());
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: whiteColor,
              onSurface: primaryColorDark,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: primaryColor),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dataCadastroController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final precoText = _precoController.text
        .replaceAll(RegExp(r'[^0-9,]'), '')
        .replaceAll(',', '.');
    final preco = double.tryParse(precoText) ?? 0.0;

    final model = SementeModel(
      id: widget.semente?.id,
      nome: _nomeController.text.trim(),
      tipo: _tipoController.text.trim(),
      marca: _marcaController.text.trim(),
      qtde: widget.semente?.qtde ?? 0.0,
      preco: preco,
      fornecedorSementeID: _fornecedorID!,
      data_Cadastro: _selectedDate!,
    );

    final viewModel = Provider.of<SementeViewModel>(context, listen: false);

    if (widget.semente == null) {
      viewModel.add(model);
    } else {
      viewModel.update(model);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Semente salva com sucesso!"),
        backgroundColor: primaryColor,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final fornecedorVM = Provider.of<FornecedoresViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.semente == null ? "Nova Semente" : "Editar Semente"),
      ),
      body:
          fornecedorVM.fornecedores.isEmpty
              ? Center(child: CircularProgressIndicator(color: primaryColor))
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      _buildTextField(
                        _nomeController,
                        "Nome",
                        Icons.grass,
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
                      const SizedBox(height: 16),
                      _buildTextField(_tipoController, "Tipo", Icons.category),
                      const SizedBox(height: 16),
                      _buildTextField(
                        _marcaController,
                        "Marca",
                        Icons.branding_watermark,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        _precoController,
                        "Preço (R\$)",
                        Icons.attach_money,
                        inputType: TextInputType.number,
                        formatter: [
                          MoneyInputFormatter(
                            leadingSymbol: 'R\$',
                            useSymbolPadding: true,
                            thousandSeparator: ThousandSeparator.Period,
                            mantissaLength: 2,
                          ),
                        ],
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Preço é obrigatório';
                          }
                          final cleaned = value.replaceAll(
                            RegExp(r'[^0-9,]'),
                            '',
                          );
                          if (cleaned.isEmpty) {
                            return 'Preço inválido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              value: _fornecedorID,
                              decoration: const InputDecoration(
                                labelText: "Fornecedor",
                                prefixIcon: Icon(Icons.business),
                              ),
                              items:
                                  fornecedorVM.fornecedores
                                      .map(
                                        (f) => DropdownMenuItem(
                                          value: f.id,
                                          child: Text(f.nome),
                                        ),
                                      )
                                      .toList(),
                              onChanged:
                                  (value) =>
                                      setState(() => _fornecedorID = value),
                              validator:
                                  (value) =>
                                      value == null
                                          ? "Selecione um fornecedor"
                                          : null,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add_circle, color: primaryColor),
                            tooltip: 'Novo Fornecedor',
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const FornecedoresFormView(),
                                ),
                              );
                              fornecedorVM.fetch();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _dataCadastroController,
                        decoration: const InputDecoration(
                          labelText: 'Data de Cadastro',
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        readOnly: true,
                        onTap: () => _selectDate(context),
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Selecione a data'
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
                          widget.semente == null ? "ADICIONAR" : "ATUALIZAR",
                          style: TextStyle(color: whiteColor, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType inputType = TextInputType.text,
    List<TextInputFormatter>? formatter,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      keyboardType: inputType,
      inputFormatters: formatter,
      validator:
          validator ??
          (value) =>
              value == null || value.isEmpty ? "Campo obrigatório" : null,
    );
  }
}

