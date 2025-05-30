import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/viewmodels/ColheitaViewmodel.dart';
import 'package:flutter_fgl_1/views/colheita/ColheitaFormView.dart';
import 'package:provider/provider.dart';

class ColheitaListView extends StatefulWidget {
  const ColheitaListView({super.key});

  @override
  State<ColheitaListView> createState() => _ColheitaListViewState();
}

class _ColheitaListViewState extends State<ColheitaListView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ColheitaViewmodel>(context, listen: false).fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ColheitaViewmodel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Colheitas')),
      body: RefreshIndicator(
        onRefresh: viewModel.fetch,
        child: viewModel.isLoading
            ? Center(child: CircularProgressIndicator())
            : viewModel.colheita.isEmpty
                ? Center(child: Text('Nenhuma colheita cadastrada.'))
                : ListView.builder(
                    itemCount: viewModel.colheita.length,
                    itemBuilder: (context, index) {
                      final colheita = viewModel.colheita[index];
                      return Dismissible(
                        key: Key(colheita.id.toString()),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 16),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => viewModel.delete(colheita.id!),
                        child: ListTile(
                          title: Text(colheita.tipo),
                          subtitle: Text(
                            '${colheita.dataHora.day}/${colheita.dataHora.month}/${colheita.dataHora.year}'
                            '${colheita.descricao != null ? ' - ${colheita.descricao}' : ''}',
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ColheitaFormView(colheita: colheita),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ColheitaFormView()),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
