import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/viewmodels/PlantioViewmodel.dart';
import 'package:flutter_fgl_1/views/plantio/PlantioFormView.dart';
import 'package:provider/provider.dart';

class PlantioListView extends StatefulWidget {
  const PlantioListView({super.key});

  @override
  State<PlantioListView> createState() => _PlantioListViewState();
}

class _PlantioListViewState extends State<PlantioListView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<PlantioViewModel>(context, listen: false).fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PlantioViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Plantios')),
      body: RefreshIndicator(
        onRefresh: viewModel.fetch,
        child: viewModel.isLoading
            ? Center(child: CircularProgressIndicator())
            : viewModel.plantio.isEmpty
                ? Center(child: Text('Nenhum plantio cadastrado.'))
                : ListView.builder(
                    itemCount: viewModel.plantio.length,
                    itemBuilder: (context, index) {
                      final plantio = viewModel.plantio[index];
                      return Dismissible(
                        key: Key(plantio.id.toString()),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 16),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => viewModel.delete(plantio.id!),
                        child: ListTile(
                          title: Text(plantio.descricao),
                          subtitle: Text(
                            'Área: ${plantio.areaPlantada} ha - ${plantio.dataHora.day}/${plantio.dataHora.month}/${plantio.dataHora.year}',
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PlantioFormView(plantio: plantio),
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
          MaterialPageRoute(builder: (_) => PlantioFormView()),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
