import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/views/semente/SementeFormView.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/SementeViewmodel.dart';

class SementeListView extends StatefulWidget {
  const SementeListView({super.key});

  @override
  State<SementeListView> createState() => _SementeListViewState();
}

class _SementeListViewState extends State<SementeListView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<SementeViewModel>(context, listen: false).fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SementeViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Sementes')),
      body: RefreshIndicator(
        onRefresh: viewModel.fetch,
        child: viewModel.isLoading
            ? Center(child: CircularProgressIndicator())
            : viewModel.semente.isEmpty
                ? Center(child: Text('Nenhuma semente cadastrada.'))
                : ListView.builder(
                    itemCount: viewModel.semente.length,
                    itemBuilder: (context, index) {
                      final semente = viewModel.semente[index];
                      return Dismissible(
                        key: Key(semente.id.toString()),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 16),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => viewModel.delete(semente.id!),
                        child: ListTile(
                          title: Text(semente.nome),
                          subtitle: Text('${semente.qtde} unidades • ${semente.marca}'),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SementeFormView(semente: semente),
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
          MaterialPageRoute(builder: (_) => SementeFormView()),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
