import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/models/AgrotoxicoModel.dart';
import 'package:flutter_fgl_1/viewmodels/ForneInsumoViewmodel.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/AgrotoxicoViewmodel.dart';
import '../../../views/agrotoxico/AgrotoxicoFormView.dart';

class AgrotoxicoListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AgrotoxicoViewModel>(context);


  Widget _buildDetailItem(IconData icon, String text) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Color(0xFF1976D2)), // Azul
            SizedBox(width: 8),
            Text(text, style: TextStyle(color: Color(0xFF2E7D32))), // Verde
          ],
        ),
      );
    }

    void _details(AgrotoxicoModel agrotoxico) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(agrotoxico.nome, style: TextStyle(
              color: Color(0xFF2E7D32), // Verde escuro
              fontWeight: FontWeight.bold
            )),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailItem(Icons.calendar_today, 'Data do Cadastro: ${agrotoxico.data_Cadastro}'),
                _buildDetailItem(Icons.scale, 'Quantidade: ${agrotoxico.qtde} ${agrotoxico.unidade_Medida}'),
                _buildDetailItem(Icons.category, 'Tipo: ${agrotoxico.tipoID}'),
                _buildDetailItem(Icons.business, 'Fornecedor: ${agrotoxico.fornecedorID}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Fechar', style: TextStyle(color: Color(0xFF1976D2))), // Azul
              ),
            ],
          );
        },
      );
    }


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Agrotóxicos', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF2E7D32), // Verde escuro
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: RefreshIndicator(
        color: Color(0xFF2E7D32), // Verde
        backgroundColor: Colors.white,
        onRefresh: () => viewModel.fetch(),
        child: viewModel.isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)), // Verde
                ),
              )
            : ListView.builder(
                itemCount: viewModel.lista.length,
                itemBuilder: (context, index) {
                  final item = viewModel.lista[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Color(0xFFE0E0E0), // Cinza claro
                        width: 1,
                      ),
                    ),
                    child: Dismissible(
                      key: Key(item.id.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFE53935), // Vermelho para delete
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(Icons.delete_forever, color: Colors.white),
                      ),
                      onDismissed: (_) => viewModel.delete(item.id!),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => _details(item),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: [
                              // Ícone com círculo azul
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Color(0xFF1976D2).withOpacity(0.1), // Azul claro
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.water_drop,
                                  color: Color(0xFF1976D2), // Azul
                                  size: 24,
                                ),
                              ),
                              SizedBox(width: 16),
                              // Conteúdo central
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.nome,
                                      style: TextStyle(
                                        color: Color(0xFF2E7D32), // Verde escuro
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '${item.qtde} ${item.unidade_Medida}',
                                      style: TextStyle(
                                        color: Color(0xFF1976D2), // Azul
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Botão de edição
                              IconButton(
                                icon: Icon(Icons.edit, color: Color(0xFF2E7D32)), // Verde
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AgrotoxicoFormView(agrotoxico: item),
                                  ),
                                ),
                              ),
                            ],
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
          MaterialPageRoute(builder: (_) => AgrotoxicoFormView()),
        ),
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0xFF2E7D32), // Verde
        elevation: 2,
      ),
    );
  }
}