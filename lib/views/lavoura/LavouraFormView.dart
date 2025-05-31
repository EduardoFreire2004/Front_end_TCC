import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/views/Aplicacao/AplicacaoListView.dart';
import 'package:flutter_fgl_1/views/Colheita/ColheitaListView.dart';
import 'package:flutter_fgl_1/views/Insumo/insumoListView.dart';
import 'package:flutter_fgl_1/views/plantio/PlantioListView.dart';
import 'package:flutter_fgl_1/views/semente/SementeListView.dart';
import '../../../models/LavouraModel.dart';

class LavouraFormView extends StatelessWidget {
  final LavouraModel? lavoura;

  const LavouraFormView({super.key, this.lavoura});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          lavoura == null ? 'Nova Lavoura' : 'Lavoura: ${lavoura!.nome}',
        ),
      ),
      body:
          lavoura == null
              ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: FormLavouraCadastro(),
              )
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildCard(
                      context,
                      'Aplicações',
                      Icons.opacity,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AplicacaoListView()),
                      ),
                    ),
                    _buildCard(
                      context,
                      'Colheitas',
                      Icons.agriculture,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ColheitaListView()),
                      ),
                    ),
                    _buildCard(
                      context,
                      'Plantios',
                      Icons.grass,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => PlantioListView()),
                      ),
                    ),
                    _buildCard(
                      context,
                      'Insumos',
                      Icons.inventory,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => InsumoListView()),
                      ),
                    ),
                    _buildCard(
                      context,
                      'Sementes',
                      Icons.eco,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SementeListView()),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        color: Colors.lightGreen.shade100,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: Colors.green[700]),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FormLavouraCadastro extends StatefulWidget {
  @override
  State<FormLavouraCadastro> createState() => _FormLavouraCadastroState();
}

class _FormLavouraCadastroState extends State<FormLavouraCadastro> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _areaController = TextEditingController();

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final novaLavoura = LavouraModel(
      nome: _nomeController.text.trim(),
      area: double.parse(_areaController.text),
    );

    // Aqui você chamaria o viewModel para salvar
    Navigator.pop(context, novaLavoura);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          TextFormField(
            controller: _nomeController,
            decoration: InputDecoration(labelText: 'Nome da Lavoura'),
            validator:
                (value) =>
                    value == null || value.isEmpty ? 'Informe o nome' : null,
          ),
          TextFormField(
            controller: _areaController,
            decoration: InputDecoration(labelText: 'Área (hectares)'),
            keyboardType: TextInputType.number,
            validator:
                (value) =>
                    value == null || double.tryParse(value) == null
                        ? 'Área inválida'
                        : null,
          ),
          SizedBox(height: 20),
          ElevatedButton(onPressed: _salvar, child: Text('Salvar')),
        ],
      ),
    );
  }
}
