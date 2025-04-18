import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/agrotoxicoViewmodel.dart';
import '../models/AgrotoxicoModel.dart';
import '../models/ForneAgrotoxicoModel.dart';
import '../models/TipoAgrotoxicoModel.dart';

class AgrotoxicoView extends StatefulWidget {
  @override
  _AgrotoxicoViewState createState() => _AgrotoxicoViewState();
}

class _AgrotoxicoViewState extends State<AgrotoxicoView> {
  final TextEditingController fornecedorController = TextEditingController();
  final TextEditingController tipoController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController unidadeController = TextEditingController();
  final TextEditingController qtdeController = TextEditingController();

  ForneAgrotoxicoModel? fornecedorSelecionado;
  TipoAgrotoxicoModel? tipoSelecionado;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AgrotoxicoViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Cadastrar Agrotóxico')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Campo de Fornecedor
              TextField(
                controller: fornecedorController,
                decoration: InputDecoration(labelText: 'Fornecedor'),
                onChanged: (value) {
                  viewModel.buscarFornecedores(value);
                },
              ),
              if (viewModel.fornecedores.isNotEmpty)
                DropdownButton<ForneAgrotoxicoModel>(
                  hint: Text('Selecione o Fornecedor'),
                  value: fornecedorSelecionado,
                  onChanged: (novo) {
                    setState(() {
                      fornecedorSelecionado = novo;
                      fornecedorController.text = novo!.nome;
                    });
                  },
                  items: viewModel.fornecedores.map((forn) {
                    return DropdownMenuItem(
                      value: forn,
                      child: Text('${forn.nome}'),
                    );
                  }).toList(),
                ),
              if (viewModel.fornecedores.isEmpty && fornecedorController.text.isNotEmpty)
                ElevatedButton(
                  child: Text('Cadastrar novo Fornecedor'),
                  onPressed: () async {
                    String cnpj = '';
                    String telefone = '';

                    await showDialog(
                      context: context,
                      builder: (context) {
                        final cnpjController = TextEditingController();
                        final telefoneController = TextEditingController();

                        return AlertDialog(
                          title: Text('Novo Fornecedor'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Nome: ${fornecedorController.text}'),
                              TextField(
                                controller: cnpjController,
                                decoration: InputDecoration(labelText: 'CNPJ'),
                              ),
                              TextField(
                                controller: telefoneController,
                                decoration: InputDecoration(labelText: 'Telefone'),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              child: Text('Cancelar'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            ElevatedButton(
                              child: Text('Salvar'),
                              onPressed: () {
                                cnpj = cnpjController.text;
                                telefone = telefoneController.text;
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );

                    if (cnpj.isNotEmpty && telefone.isNotEmpty) {
                      final novoFornecedor = ForneAgrotoxicoModel(
                        nome: fornecedorController.text,
                        cnpj: cnpj,
                        telefone: telefone,
                      );

                      await viewModel.cadastrarFornecedor(novoFornecedor);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Fornecedor cadastrado!')),
                      );

                      await viewModel.buscarFornecedores(fornecedorController.text);
                    }
                  },
                ),

              SizedBox(height: 10),

              // Campo de Tipo
              TextField(
                controller: tipoController,
                decoration: InputDecoration(labelText: 'Tipo de Agrotóxico'),
                onChanged: (value) {
                  viewModel.buscarTipos(value);
                },
              ),
              if (viewModel.tipos.isNotEmpty)
                DropdownButton<TipoAgrotoxicoModel>(
                  hint: Text('Selecione o Tipo'),
                  value: tipoSelecionado,
                  onChanged: (novo) {
                    setState(() {
                      tipoSelecionado = novo;
                      tipoController.text = novo!.descricao;
                    });
                  },
                  items: viewModel.tipos.map((tipo) {
                    return DropdownMenuItem(
                      value: tipo,
                      child: Text(tipo.descricao),
                    );
                  }).toList(),
                ),
              if (viewModel.tipos.isEmpty && tipoController.text.isNotEmpty)
                ElevatedButton(
                  child: Text('Cadastrar novo Tipo'),
                  onPressed: () async {
                    final novoTipo = TipoAgrotoxicoModel(
                      descricao: tipoController.text,
                    );

                    await viewModel.cadastrarTipo(novoTipo);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Tipo cadastrado!')),
                    );
                    await viewModel.buscarTipos(tipoController.text);
                  },
                ),

              SizedBox(height: 10),

              // Restante dos campos
              TextField(
                controller: nomeController,
                decoration: InputDecoration(labelText: 'Nome do Agrotóxico'),
              ),
              TextField(
                controller: unidadeController,
                decoration: InputDecoration(labelText: 'Unidade de Medida'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: qtdeController,
                decoration: InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
              ),

              SizedBox(height: 20),

              ElevatedButton(
                child: Text('Salvar Agrotóxico'),
                onPressed: () async {
                  if (fornecedorSelecionado == null || tipoSelecionado == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Selecione ou cadastre Fornecedor e Tipo!')),
                    );
                    return;
                  }

                  final agrotoxico = AgrotoxicoModel(
                    fornecedorID: fornecedorSelecionado!.id!,
                    tipoID: tipoSelecionado!.id!,
                    nome: nomeController.text,
                    unidade_Medida: double.parse(unidadeController.text),
                    qtde: double.parse(qtdeController.text),
                    data_Cadastro: DateTime.now(),
                  );

                  await viewModel.salvarAgrotoxico(agrotoxico);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Agrotóxico salvo com sucesso!')),
                  );

                  fornecedorController.clear();
                  tipoController.clear();
                  nomeController.clear();
                  unidadeController.clear();
                  qtdeController.clear();

                  setState(() {
                    fornecedorSelecionado = null;
                    tipoSelecionado = null;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
