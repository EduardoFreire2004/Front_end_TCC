import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../models/AgrotoxicoModel.dart';
import '../../../models/ForneAgrotoxicoModel.dart';
import '../../../models/TipoAgrotoxicoModel.dart';
import '../../../repositories/ForneAgrotoxicoRepo.dart';
import '../../../repositories/TipoAgrotoxicoRepo.dart';
import '../../../viewmodels/AgrotoxicoViewmodel.dart';
import '../ForneAgrotoxico/FornecedorAgrotoxicoFormView.dart';
import '../TipoAgrotoxico/TipoAgrotoxicoFormView.dart';

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
  final _data_CadastroController = TextEditingController();
  final _qtdeController = TextEditingController();

  int? _fornecedorID;
  int? _tipoID;

  List<ForneAgrotoxicoModel> _fornecedores = [];
  List<TipoAgrotoxicoModel> _tipos = [];

  @override
  void initState() {
    super.initState();
    _carregarListas();
    if (widget.agrotoxico != null) {
      _nomeController.text = widget.agrotoxico!.nome;
      _unidadeController.text = widget.agrotoxico!.unidade_Medida;
      _qtdeController.text = widget.agrotoxico!.qtde.toString();
      _data_CadastroController.text = widget.agrotoxico!.data_Cadastro.toIso8601String();
      _fornecedorID = widget.agrotoxico!.fornecedorID;
      _tipoID = widget.agrotoxico!.tipoID;
    }
  }

  Future<void> _carregarListas() async {
    _fornecedores = await ForneAgrotoxicoRepo().getAll();
    _tipos = await TipoAgrotoxicoRepo().getAll();
    setState(() {});
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final model = AgrotoxicoModel(
      id: widget.agrotoxico?.id,
      nome: _nomeController.text.trim(),
      unidade_Medida: _unidadeController.text.trim(),
      qtde: double.parse(_qtdeController.text),
      data_Cadastro: DateTime.now(),
      fornecedorID: _fornecedorID!,
      tipoID: _tipoID!,
    );

    final viewModel = Provider.of<AgrotoxicoViewModel>(context, listen: false);

    if (widget.agrotoxico == null) {
      viewModel.add(model);
    } else {
      viewModel.update(model);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.agrotoxico == null ? 'Novo Agrotóxico' : 'Editar Agrotóxico',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF2E7D32),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _fornecedores.isEmpty || _tipos.isEmpty
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
                )
              )
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<int>(
                                value: _fornecedorID,
                                items: _fornecedores
                                    .map(
                                      (f) => DropdownMenuItem(
                                        value: f.id,
                                        child: Text(f.nome, style: TextStyle(color: Color(0xFF2E7D32))),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) => setState(() => _fornecedorID = value),
                                decoration: InputDecoration(
                                  labelText: 'Fornecedor',
                                  labelStyle: TextStyle(color: Color(0xFF1976D2)),
                                  border: InputBorder.none,
                                ),
                                validator: (value) => value == null ? 'Selecione um fornecedor' : null,
                                dropdownColor: Colors.white,
                                icon: Icon(Icons.arrow_drop_down, color: Color(0xFF1976D2)),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.add_circle, color: Color(0xFF2E7D32)),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => FornecedorAgrotoxicoFormView(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<int>(
                                value: _tipoID,
                                items: _tipos
                                    .map(
                                      (t) => DropdownMenuItem(
                                        value: t.id,
                                        child: Text(t.descricao, style: TextStyle(color: Color(0xFF2E7D32))),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) => setState(() => _tipoID = value),
                                decoration: InputDecoration(
                                  labelText: 'Tipo',
                                  labelStyle: TextStyle(color: Color(0xFF1976D2)),
                                  border: InputBorder.none,
                                ),
                                validator: (value) => value == null ? 'Selecione um tipo' : null,
                                dropdownColor: Colors.white,
                                icon: Icon(Icons.arrow_drop_down, color: Color(0xFF1976D2)),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.add_circle, color: Color(0xFF2E7D32)),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TipoAgrotoxicoFormView(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _nomeController,
                      decoration: InputDecoration(
                        labelText: 'Nome',
                        labelStyle: TextStyle(color: Color(0xFF1976D2)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Color(0xFF2E7D32)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Color(0xFF2E7D32)),
                        ),
                      ),
                      style: TextStyle(color: Color(0xFF2E7D32)),
                      validator: (value) => value == null || value.isEmpty ? 'Informe o nome' : null,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _unidadeController,
                      decoration: InputDecoration(
                        labelText: 'Unidade de Medida',
                        labelStyle: TextStyle(color: Color(0xFF1976D2)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Color(0xFF2E7D32)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Color(0xFF2E7D32)),
                        ),
                      ),
                      style: TextStyle(color: Color(0xFF2E7D32)),
                      validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _qtdeController,
                      decoration: InputDecoration(
                        labelText: 'Quantidade',
                        labelStyle: TextStyle(color: Color(0xFF1976D2)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Color(0xFF2E7D32)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Color(0xFF2E7D32)),
                        ),
                      ),
                      style: TextStyle(color: Color(0xFF2E7D32)),
                      keyboardType: TextInputType.number,
                      validator: (value) => value == null || double.tryParse(value) == null ? 'Valor inválido' : null,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _data_CadastroController,
                      decoration: InputDecoration(
                        labelText: 'Data de Cadastro',
                        labelStyle: TextStyle(color: Color(0xFF1976D2)),
                        hintText: 'DD/MM/AAAA',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Color(0xFF2E7D32)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Color(0xFF2E7D32)),
                        ),
                      ),
                      style: TextStyle(color: Color(0xFF2E7D32)),
                      keyboardType: TextInputType.datetime,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(8),
                        _DateInputFormatter(),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Data de cadastro é obrigatória';
                        } else if (value.length != 10) {
                          return 'Data inválida';
                        }
                        try {
                          final parts = value.split('/');
                          final day = int.parse(parts[0]);
                          final month = int.parse(parts[1]);
                          final year = int.parse(parts[2]);
                          final data = DateTime(year, month, day);

                          if (data.isAfter(DateTime.now())) {
                            return 'Data não pode ser no futuro';
                          }
                        } catch (e) {
                          return 'Data inválida';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _salvar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2E7D32),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        widget.agrotoxico == null ? 'ADICIONAR' : 'ATUALIZAR',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final String text = newValue.text.replaceAll(r'[^0-9]', '');

    if (text.length > 8) {
      return oldValue;
    }

    String formatted = '';

    if (text.length >= 2) {
      formatted += '${text.substring(0, 2)}/';
      if (text.length >= 4) {
        formatted += '${text.substring(2, 4)}/';
        if (text.length > 4) {
          formatted += text.substring(4);
        }
      } else {
        formatted += text.substring(2);
      }
    } else {
      formatted = text;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}