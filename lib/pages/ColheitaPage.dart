import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/ColheitaModel.dart';
import '../viewmodels/ColheitaViewmodel.dart';
import 'package:intl/intl.dart';

class ColheitaPage extends StatefulWidget {
  const ColheitaPage({Key? key}) : super(key: key);

  @override
  State<ColheitaPage> createState() => _ColheitaPageState();
}

class _ColheitaPageState extends State<ColheitaPage> {
  List<ColheitaModel> filteredColheitas = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<ColheitaViewmodel>(context, listen: false);
    viewModel.loadColheita().then((_) {
      setState(() {
        filteredColheitas = viewModel.colheita;
      });
    });
  }

  void filterColheitas(String query, List<ColheitaModel> allColheitas) {
    setState(() {
      if (query.isEmpty) {
        filteredColheitas = allColheitas;
      } else {
        filteredColheitas =
            allColheitas
                .where(
                  (colheita) => DateFormat(
                    'yyyy-MM-dd',
                  ).format(colheita.dataHora).contains(query),
                )
                .toList();
      }
    });
  }

  void _showFormDialog(BuildContext context) {
    final tipoController = TextEditingController();
    final descricaoController = TextEditingController();
    DateTime? dataHoraSelecionada;
    final viewModel = Provider.of<ColheitaViewmodel>(context, listen: false);

    showDialog(
      context: context,
      builder:
          (_) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Nova Colheita'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: tipoController,
                      decoration: const InputDecoration(labelText: 'Tipo'),
                    ),
                    TextField(
                      controller: descricaoController,
                      decoration: const InputDecoration(labelText: 'Descrição'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );

                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );

                          if (time != null) {
                            final selected = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              time.hour,
                              time.minute,
                            );

                            setState(() {
                              dataHoraSelecionada = selected;
                            });
                          }
                        }
                      },
                      child: Text(
                        dataHoraSelecionada == null
                            ? 'Selecionar Data e Hora'
                            : 'Selecionado: ${dataHoraSelecionada.toString()}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      final tipo = tipoController.text;
                      final descricao = descricaoController.text;

                      if (tipo.isNotEmpty && dataHoraSelecionada != null) {
                        final novaColheita = ColheitaModel(
                          tipo: tipo,
                          descricao: descricao,
                          dataHora: dataHoraSelecionada!,
                        );

                        viewModel.addColheita(novaColheita).then((_) {
                          setState(() {
                            filteredColheitas = viewModel.colheita;
                          });
                          Navigator.pop(context);
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Preencha todos os campos corretamente.',
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text('Salvar'),
                  ),
                ],
              );
            },
          ),
    );
  }

  void _showEditFormDialog(BuildContext context, ColheitaModel colheita) {
    final tipoController = TextEditingController(text: colheita.tipo);
    final descricaoController = TextEditingController(text: colheita.descricao);
    DateTime dataHoraSelecionada = colheita.dataHora;
    final viewModel = Provider.of<ColheitaViewmodel>(context, listen: false);

    showDialog(
      context: context,
      builder:
          (_) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Editar Colheita'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: tipoController,
                      decoration: const InputDecoration(labelText: 'Tipo'),
                    ),
                    TextField(
                      controller: descricaoController,
                      decoration: const InputDecoration(labelText: 'Descrição'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: dataHoraSelecionada,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );

                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                              dataHoraSelecionada,
                            ),
                          );

                          if (time != null) {
                            setState(() {
                              dataHoraSelecionada = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                time.hour,
                                time.minute,
                              );
                            });
                          }
                        }
                      },
                      child: Text(
                        'Selecionado: ${DateFormat('yyyy-MM-dd – kk:mm').format(dataHoraSelecionada)}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      final tipo = tipoController.text;
                      final descricao = descricaoController.text;

                      if (tipo.isNotEmpty) {
                        final atualizado = ColheitaModel(
                          id: colheita.id,
                          tipo: tipo,
                          descricao: descricao,
                          dataHora: dataHoraSelecionada,
                        );

                        viewModel.updateColheita(atualizado).then((_) {
                          setState(() {
                            filteredColheitas = viewModel.colheita;
                          });
                          Navigator.pop(context);
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Preencha todos os campos corretamente.',
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text('Salvar'),
                  ),
                ],
              );
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ColheitaViewmodel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Colheitas'),
        backgroundColor: Colors.green[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Pesquisar por data (ex: 2024-01-20)',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) => filterColheitas(value, viewModel.colheita),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredColheitas.length,
                itemBuilder: (context, index) {
                  final colheita = filteredColheitas[index];
                  return Card(
                    color: Colors.green[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Data: ${DateFormat('yyyy-MM-dd – kk:mm').format(colheita.dataHora)}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Tipo: ${colheita.tipo}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Descrição: ${colheita.descricao ?? 'Sem descrição'}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    _showEditFormDialog(context, colheita);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    viewModel.deleteColheita(colheita.id!).then(
                                      (_) {
                                        setState(() {
                                          filteredColheitas =
                                              viewModel.colheita;
                                        });
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormDialog(context),
        backgroundColor: Colors.green[800],
        child: const Icon(Icons.add),
      ),
    );
  }
}
