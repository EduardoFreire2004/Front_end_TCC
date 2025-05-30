import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/models/LavouraModel.dart';
import 'package:flutter_fgl_1/viewmodels/LavouraViewModel.dart';
import 'package:flutter_fgl_1/views/lavoura/LavouraFormView.dart';
import 'package:provider/provider.dart';

class LavouraListView extends StatefulWidget {
  const LavouraListView({super.key});

  @override
  State<LavouraListView> createState() => _LavouraListViewState();
}

class _LavouraListViewState extends State<LavouraListView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<LavouraViewModel>(context, listen: false).fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LavouraViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Lavouras')),
      body: RefreshIndicator(
        onRefresh: viewModel.fetch,
        child: viewModel.isLoading
            ? Center(child: CircularProgressIndicator())
            : viewModel.lavoura.isEmpty
                ? Center(child: Text('Nenhuma lavoura cadastrada.'))
                : ListView.builder(
                    itemCount: viewModel.lavoura.length,
                    itemBuilder: (context, index) {
                      final lavoura = viewModel.lavoura[index];
                      return ListTile(
                        title: Text(lavoura.nome),
                        subtitle: Text('Área: ${lavoura.area} ha'),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LavouraFormView(lavoura: lavoura),
                            ),
                          );
                        },
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final novaLavoura = await Navigator.push<LavouraModel?>(
            context,
            MaterialPageRoute(
              builder: (_) => LavouraFormView(),
            ),
          );

          if (novaLavoura != null) {
            Provider.of<LavouraViewModel>(context, listen: false).add(novaLavoura);
          }
        },
      ),
    );
  }
}
