import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fgl_1/models/AgrotoxicoModel.dart';
import 'package:flutter_fgl_1/viewmodels/AgrotoxicoViewModel.dart';
import 'package:flutter_fgl_1/viewmodels/FornecedoresViewmodel.dart';
import 'package:flutter_fgl_1/viewmodels/TipoAgrotoxicoViewModel.dart';
import 'package:flutter_fgl_1/views/Fornecedores/FornecedoresFormView.dart';
import 'package:flutter_fgl_1/views/TipoAgrotoxico/TipoAgrotoxicoFormView.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AgrotoxicoFormView extends StatefulWidget {
  final AgrotoxicoModel? agrotoxico;

  const AgrotoxicoFormView({super.key, this.agrotoxico});

  @override
  State<AgrotoxicoFormView> createState() => _AgrotoxicoFormViewState();
}

class _AgrotoxicoFormViewState extends State<AgrotoxicoFormView> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _unidadeController = TextEditingController();
  final _dataCadastroController = TextEditingController();
  final _qtdeController = TextEditingController();
  final _precoController = TextEditingController();

  int? _fornecedorID;
  int? _tipoID;
  DateTime? _selectedDate;

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
    if (widget.agrotoxico != null) {
      _nomeController.text = widget.agrotoxico!.nome;
      _unidadeController.text = widget.agrotoxico!.unidade_Medida;
      _qtdeController.text = widget.agrotoxico!.qtde.toString();
      _precoController.text = widget.agrotoxico!.preco.toString();
      _fornecedorID = widget.agrotoxico!.fornecedorID;
      _tipoID = widget.agrotoxico!.tipoID;
      _selectedDate = widget.agrotoxico!.data_Cadastro;
      if (_selectedDate != null) {
        _dataCadastroController.text =
            DateFormat('dd/MM/yyyy').format(_selectedDate!);
      }
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _unidadeController.dispose();
    _dataCadastroController.dispose();
    _qtdeController.dispose();
    _precoController.dispose();
    super.dispose();
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

  bool _nomeJaExiste(String nome) {
    final viewModel = Provider.of<AgrotoxicoViewModel>(context, listen: false);
    final lista = viewModel.lista;

    if (widget.agrotoxico != null) {
      return lista.any((f) =>
          f.nome.toLowerCase() == nome.toLowerCase() &&
          f.id != widget.agrotoxico!.id);
    }

    return lista.any((f) => f.nome.toLowerCase() == nome.toLowerCase());
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final model = AgrotoxicoModel(
      id: widget.agrotoxico?.id,
      nome: _nomeController.text.trim(),
      unidade_Medida: _unidadeController.text.trim(),
      qtde: double.tryParse(_qtdeController.text.replaceAll(',', '.')) ?? 0.0,
      preco: double.tryParse(_precoController.text.replaceAll(',', '.')) ?? 0.0,
      data_Cadastro: _selectedDate!,
      fornecedorID: _fornecedorID!,
      tipoID: _tipoID!,
    );

    final viewModel = Provider.of<AgrotoxicoViewModel>(context, listen: false);

    if (widget.agrotoxico == null) {
      viewModel.add(model);
    } else {
      viewModel.update(model);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Agrotóxico salvo com sucesso!'),
        backgroundColor: Colors.green[600],
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final fornecedorViewModel = Provider.of<FornecedoresViewModel>(context);
    final tipoViewModel = Provider.of<TipoAgrotoxicoViewModel>(context);

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
        title: Text(
          widget.agrotoxico == null ? 'Novo Agrotóxico' : 'Editar Agrotóxico',
        ),
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          inputDecorationTheme: formInputDecorationTheme,
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: primaryColor,
            selectionColor: primaryColor.withOpacity(0.3),
            selectionHandleColor: primaryColor,
          ),
          colorScheme:
              Theme.of(context).colorScheme.copyWith(error: errorColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: fornecedorViewModel.fornecedores.isEmpty ||
                  tipoViewModel.tipo.isEmpty
              ? Center(
                  child: CircularProgressIndicator(color: primaryColor),
                )
              : Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      _buildTextField(
                        controller: _nomeController,
                        label: 'Nome',
                        hint: 'Nome do Agrotóxico',
                        icon: Icons.science_outlined,
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              value: _fornecedorID,
                              items: fornecedorViewModel.fornecedores
                                  .map(
                                    (f) => DropdownMenuItem(
                                      value: f.id,
                                      child: Text(f.nome),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) =>
                                  setState(() => _fornecedorID = value),
                              decoration: const InputDecoration(
                                labelText: 'Fornecedor',
                                prefixIcon: Icon(Icons.business),
                              ),
                              validator: (value) => value == null
                                  ? 'Selecione um fornecedor'
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(Icons.add_circle, color: primaryColor),
                            tooltip: 'Novo Fornecedor',
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const FornecedoresFormView(),
                                ),
                              );
                              fornecedorViewModel.fetch();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              value: _tipoID,
                              items: tipoViewModel.tipo
                                  .map(
                                    (t) => DropdownMenuItem(
                                      value: t.id,
                                      child: Text(t.descricao),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) =>
                                  setState(() => _tipoID = value),
                              decoration: const InputDecoration(
                                labelText: 'Tipo',
                                prefixIcon: Icon(Icons.category_outlined),
                              ),
                              validator: (value) =>
                                  value == null ? 'Selecione um tipo' : null,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(Icons.add_circle, color: primaryColor),
                            tooltip: 'Novo Tipo',
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const TipoAgrotoxicoFormView(),
                                ),
                              );
                              tipoViewModel.fetch();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _qtdeController,
                              decoration: const InputDecoration(
                                labelText: 'Quantidade',
                                prefixIcon: Icon(Icons.scale_outlined),
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+[,.]?\d{0,2}'),
                                ),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'Informe a quantidade';
                                if (double.tryParse(
                                        value.replaceAll(',', '.')) ==
                                    null) return 'Valor inválido';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _unidadeController,
                              decoration: const InputDecoration(
                                labelText: 'Unidade',
                                hintText: 'Ex: L, Kg',
                                prefixIcon: Icon(Icons.straighten),
                              ),
                              validator: (value) => value == null ||
                                      value.isEmpty
                                  ? 'Informe a unidade'
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _precoController,
                        decoration: const InputDecoration(
                          labelText: 'Preço',
                          hintText: 'Informe o preço unitário',
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+[,.]?\d{0,2}')),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Informe o preço';
                          if (double.tryParse(
                                  value.replaceAll(',', '.')) ==
                              null) return 'Valor inválido';
                          return null;
                        },
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
                        validator: (value) =>
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
                          widget.agrotoxico == null ? 'ADICIONAR' : 'ATUALIZAR',
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      validator: validator,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
    );
  }
}
