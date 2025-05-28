import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/views/forne_insumo/ForneInsumoFormView.dart';
import 'package:provider/provider.dart';
import 'package:flutter_fgl_1/viewmodels/ForneInsumoViewmodel.dart';

class FornecedorInsumoListView extends StatelessWidget {
  const FornecedorInsumoListView({super.key});

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

  void _showDetails(BuildContext context, fornecedor) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            fornecedor.nome,
            style: TextStyle(
              color: Color(0xFF2E7D32), // Verde escuro
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailItem(Icons.business_outlined, 'NOME: ${fornecedor.nome}'),
              _buildDetailItem(Icons.business, 'CNPJ: ${fornecedor.cnpj}'),
              _buildDetailItem(Icons.phone, 'Telefone: ${fornecedor.telefone ?? 'Não informado'}'),
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

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<FornecedorInsumoViewModel>(context);

    return Scaffold(
      backgroundColor: Color(0xFFE8F5E9), // Verde água claro
      appBar: AppBar(
        title: Text('Fornecedores de Insumo', style: TextStyle(color: Colors.white)),
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
                itemCount: viewModel.fornecedores.length,
                itemBuilder: (context, index) {
                  final fornecedor = viewModel.fornecedores[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Dismissible(
                      key: Key(fornecedor.id.toString()),
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
                      onDismissed: (_) => viewModel.delete(fornecedor.id!),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () => _showDetails(context, fornecedor),
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
                                  Icons.business,
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
                                      fornecedor.nome,
                                      style: TextStyle(
                                        color: Color(0xFF2E7D32),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'CNPJ: ${fornecedor.cnpj}',
                                      style: TextStyle(
                                        color: Color(0xFF1976D2)),
                                    ),
                                  ],
                                ),
                              ),
                              // Botão de edição
                              IconButton(
                                icon: Icon(Icons.edit, color: Color(0xFF2E7D2)),
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => FornecedorInsumoFormView(fornecedor: fornecedor),
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
          MaterialPageRoute(builder: (_) => FornecedorInsumoFormView()),
        ),
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0xFF2E7D2), // Verde
        elevation: 2
      )
    );
  }
}