import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/viewmodels/CustosViewModel.dart';
import 'package:provider/provider.dart';

class CustoListView extends StatefulWidget {
  final int lavouraId;
  const CustoListView({super.key, required this.lavouraId});

  @override
  State<CustoListView> createState() => _CustoListViewState();
}

class _CustoListViewState extends State<CustoListView> {
  @override
  void initState() {
    super.initState();
    Provider.of<CustoViewModel>(
      context,
      listen: false,
    ).fetchByLavoura(widget.lavouraId);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CustoViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Custos"),
        backgroundColor: Colors.green[700],
      ),
      body:
          viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : viewModel.errorMessage != null
              ? Center(child: Text(viewModel.errorMessage!))
              : ListView.builder(
                itemCount: viewModel.custos.length,
                itemBuilder: (context, index) {
                  final custo = viewModel.custos[index];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(
                        "Custo: R\$ ${custo.custoTotal.toStringAsFixed(2)}",
                      ),
                      subtitle: Text(
                        "Ganho: R\$ ${custo.ganhoTotal.toStringAsFixed(2)}",
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await viewModel.delete(custo.id!, widget.lavouraId);
                        },
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
