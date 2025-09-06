import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/services/RelatorioService.dart';
import 'package:flutter_fgl_1/services/auth_service.dart';
import 'package:flutter_fgl_1/models/RelatorioDto.dart';
import 'package:flutter_fgl_1/config/app_colors.dart';

class RelatorioColheitasScreen extends StatefulWidget {
  const RelatorioColheitasScreen({Key? key}) : super(key: key);

  @override
  State<RelatorioColheitasScreen> createState() =>
      _RelatorioColheitasScreenState();
}

class _RelatorioColheitasScreenState extends State<RelatorioColheitasScreen> {
  DateTime? _dataInicio;
  DateTime? _dataFim;
  bool _isGenerating = false;
  String? _errorMessage;
  RelatorioColheitasDto? _relatorio;
  late RelatorioService _relatorioService;

  @override
  void initState() {
    super.initState();
    _relatorioService = RelatorioService();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryGreen,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _dataInicio = picked;
        } else {
          _dataFim = picked;
        }
      });
    }
  }

  Future<void> _generateReport() async {
    if (_dataInicio == null || _dataFim == null) {
      setState(() {
        _errorMessage = 'Selecione as datas de início e fim';
      });
      return;
    }

    if (_dataFim!.isBefore(_dataInicio!)) {
      setState(() {
        _errorMessage = 'A data de fim deve ser posterior à data de início';
      });
      return;
    }

    setState(() {
      _isGenerating = true;
      _errorMessage = null;
      _relatorio = null;
    });

    try {
      // Obter o ID do usuário logado
      final usuario = AuthService.usuario;
      if (usuario?.id == null) {
        setState(() {
          _errorMessage = 'Usuário não autenticado. Faça login novamente.';
        });
        return;
      }

      final usuarioId = usuario!.id!;

      _relatorio = await _relatorioService.gerarRelatorioColheitas(
        usuarioId: usuarioId,
        dataInicio: _dataInicio!,
        dataFim: _dataFim!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Relatório de Colheitas gerado com sucesso!'),
            backgroundColor: AppColors.primaryGreen,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao gerar relatório: $e';
      });
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  Future<void> _generatePDF() async {
    if (_relatorio == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gere o relatório primeiro'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // TODO: Implementar PDF específico para colheitas
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('PDF de Colheitas será implementado em breve'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColheitaCard(ColheitaDto colheita) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        title: Text(
          colheita.cultura,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Data: ${colheita.dataColheita}'),
            Text('Área: ${colheita.areaColhida.toStringAsFixed(2)} ha'),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${colheita.quantidadeColhida.toStringAsFixed(2)} kg',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGradientEnd.withOpacity(0.1),
      appBar: AppBar(
        title: const Text(
          'Relatório de Colheitas',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_relatorio != null)
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              onPressed: _generatePDF,
              tooltip: 'Gerar PDF',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seleção de datas
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: AppColors.primaryGreen,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Período do Relatório',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Data Início',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: () => _selectDate(context, true),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey[300]!,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey[50],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _dataInicio != null
                                            ? '${_dataInicio!.day}/${_dataInicio!.month}/${_dataInicio!.year}'
                                            : 'Selecionar data',
                                        style: TextStyle(
                                          color:
                                              _dataInicio != null
                                                  ? Colors.black
                                                  : Colors.grey[600],
                                          fontSize: 16,
                                        ),
                                      ),
                                      Icon(
                                        Icons.calendar_today,
                                        color:
                                            _dataInicio != null
                                                ? AppColors.primaryGreen
                                                : Colors.grey[400],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Data Fim',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: () => _selectDate(context, false),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey[300]!,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey[50],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _dataFim != null
                                            ? '${_dataFim!.day}/${_dataFim!.month}/${_dataFim!.year}'
                                            : 'Selecionar data',
                                        style: TextStyle(
                                          color:
                                              _dataFim != null
                                                  ? Colors.black
                                                  : Colors.grey[600],
                                          fontSize: 16,
                                        ),
                                      ),
                                      Icon(
                                        Icons.calendar_today,
                                        color:
                                            _dataFim != null
                                                ? AppColors.primaryGreen
                                                : Colors.grey[400],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Botão de gerar relatório
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: _isGenerating ? null : _generateReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 6,
                ),
                icon:
                    _isGenerating
                        ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                        : const Icon(Icons.assessment, size: 28),
                label: Text(
                  _isGenerating ? 'Gerando...' : 'Gerar Relatório',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Mensagem de erro
            if (_errorMessage != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red[600], size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red[700], fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Exibição do relatório
            if (_relatorio != null) ...[
              const SizedBox(height: 24),
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.grass,
                            color: AppColors.primaryGreen,
                            size: 32,
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'Relatório de Colheitas',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildInfoCard('Lavoura', _relatorio!.lavoura.nome),
                      _buildInfoCard(
                        'Total de Colheitas',
                        _relatorio!.estatisticas.totalColheitas.toString(),
                      ),
                      _buildInfoCard(
                        'Quantidade Total Colhida',
                        '${_relatorio!.estatisticas.quantidadeTotal.toStringAsFixed(2)} kg',
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Colheitas:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ..._relatorio!.colheitas.map(
                        (colheita) => _buildColheitaCard(colheita),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
