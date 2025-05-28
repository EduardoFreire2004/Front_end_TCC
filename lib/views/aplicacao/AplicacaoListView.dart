import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/AplicacacaoViewmodel.dart';
import 'AplicacaoFormView.dart';

class AplicacaoListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AplicacaoViewModel>(context);

    void _showDetails(context, aplicacao) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text(
              aplicacao.descicao,
              style: TextStyle(
                color: Color(0xFF2E7D32), // Verde escuro
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailItem(Icons.calendar_today, 
                    'Data: ${formatarDataHora(aplicacao.data_Hora)}'),
                _buildDetailItem(Icons.agriculture, 
                    'Agrotóxico ID: ${aplicacao.agrotoxicoID}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Fechar',
                  style: TextStyle(color: Color(0xFF1976D2)), // Azul
                ),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFE8F5E9), // Verde água claro
      appBar: AppBar(
        title: Text('Aplicações', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF2E7D32), // Verde escuro
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: RefreshIndicator(
        color: Color(0xFF2E7D32), // Verde
        backgroundColor: Colors.white,
        onRefresh: viewModel.fetch,
        child: viewModel.isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
                )
            )
            : ListView.builder(
                itemCount: viewModel.aplicacoes.length,
                itemBuilder: (context, index) {
                  final aplicacao = viewModel.aplicacoes[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Dismissible(
                      key: Key(aplicacao.id.toString()),
                      background: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFE53935), // Vermelho para delete
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(Icons.delete_forever, color: Colors.white),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) => viewModel.delete(aplicacao.id!),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () => _showDetails(context, aplicacao),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: [
                              // Ícone com círculo azul
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Color(0xFF1976D2).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.agriculture,
                                  color: Color(0xFF1976D2),
                                  size: 24,
                                ),
                              ),
                              SizedBox(width: 16),
                              // Conteúdo
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      aplicacao.descicao,
                                      style: TextStyle(
                                        color: Color(0xFF2E7D32),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      formatarDataHora(aplicacao.data_Hora),
                                      style: TextStyle(
                                        color: Color(0xFF1976D2),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Botão de edição
                              IconButton(
                                icon: Icon(Icons.edit, color: Color(0xFF2E7D32)),
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AplicacaoFormView(aplicacao: aplicacao),
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
          MaterialPageRoute(builder: (_) => AplicacaoFormView()),
        ),
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0xFF2E7D32), // Verde
        elevation: 2,
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Color(0xFF1976D2)), // Azul
          SizedBox(width: 8),
          Text(text, style: TextStyle(color: Color(0xFF2E7D32))), // Verde
        ],
      ),
    );
  }

  String formatarDataHora(DateTime dataHora) {
    return '${dataHora.day.toString().padLeft(2, '0')}/${dataHora.month.toString().padLeft(2, '0')}/${dataHora.year} '
        '${dataHora.hour.toString().padLeft(2, '0')}:${dataHora.minute.toString().padLeft(2, '0')}';
  }
}