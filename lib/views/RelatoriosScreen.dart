import 'package:flutter/material.dart';
import 'package:flutter_fgl_1/config/app_colors.dart';
import 'package:flutter_fgl_1/services/RelatorioService.dart';
import 'package:flutter_fgl_1/services/auth_service.dart';

class RelatoriosScreen extends StatefulWidget {
  const RelatoriosScreen({Key? key}) : super(key: key);

  @override
  State<RelatoriosScreen> createState() => _RelatoriosScreenState();
}

class _RelatoriosScreenState extends State<RelatoriosScreen> {
  late RelatorioService _relatorioService;
  String? _tipoRelatorioSelecionado;
  DateTime? _dataInicio;
  DateTime? _dataFim;
  bool _isLoading = false;
  String _lavouraNome = 'Fazenda São João'; // Nome da lavoura atual

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  void _initializeService() {
    _relatorioService = RelatorioService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGradientEnd.withOpacity(0.1),
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Relatórios em PDF',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card principal de informações
            _buildInfoCard(),
            const SizedBox(height: 24),

            // Seção de tipo de relatório
            _buildTipoRelatorioSection(),
            const SizedBox(height: 24),

            // Seção de período
            _buildPeriodoSection(),
            const SizedBox(height: 24),

            // Botão de gerar relatório
            _buildGerarRelatorioButton(),
            const SizedBox(height: 24),

            // Seção de instruções
            _buildInstrucoesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.mainGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.assessment,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Relatórios em PDF',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Lavoura: $_lavouraNome',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Gere relatórios detalhados em formato PDF',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildTipoRelatorioSection() {
    final tiposRelatorio = [
      {
        'nome': 'Relatório Geral',
        'descricao': 'Visão geral da lavoura',
        'tipo': 'geral',
      },
      {
        'nome': 'Plantios',
        'descricao': 'Relatório de plantios',
        'tipo': 'plantios',
      },
      {
        'nome': 'Agrotóxicos',
        'descricao': 'Aplicações de agrotóxicos',
        'tipo': 'agrotoxicos',
      },
      {
        'nome': 'Insumos',
        'descricao': 'Aplicações de insumos',
        'tipo': 'insumos',
      },
      {
        'nome': 'Colheitas',
        'descricao': 'Relatório de colheitas',
        'tipo': 'colheitas',
      },
      {'nome': 'Custos', 'descricao': 'Análise de custos', 'tipo': 'custos'},
      {
        'nome': 'Estoque',
        'descricao': 'Movimentação de estoque',
        'tipo': 'estoque',
      },
      {
        'nome': 'Sementes',
        'descricao': 'Estoque de sementes',
        'tipo': 'sementes',
      },
      {
        'nome': 'Agrotóxicos Estoque',
        'descricao': 'Estoque de agrotóxicos',
        'tipo': 'agrotoxicos-estoque',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tipo de Relatório',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.2,
          children:
              tiposRelatorio.map((tipo) {
                return _buildTipoRelatorioCard(tipo);
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildTipoRelatorioCard(Map<String, String> tipo) {
    final isSelected = _tipoRelatorioSelecionado == tipo['tipo'];

    return GestureDetector(
      onTap: () {
        setState(() {
          _tipoRelatorioSelecionado = tipo['tipo'];
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getIconColor(tipo['tipo']!).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getIcon(tipo['tipo']!),
                color: _getIconColor(tipo['tipo']!),
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              tipo['nome']!,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color:
                    isSelected ? AppColors.primaryGreen : AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              tipo['descricao']!,
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String tipo) {
    switch (tipo) {
      case 'geral':
        return Icons.assessment;
      case 'plantios':
        return Icons.agriculture;
      case 'agrotoxicos':
        return Icons.warning;
      case 'insumos':
        return Icons.inventory;
      case 'colheitas':
        return Icons.grass;
      case 'custos':
        return Icons.attach_money;
      case 'estoque':
        return Icons.warehouse;
      case 'sementes':
        return Icons.eco;
      case 'agrotoxicos-estoque':
        return Icons.warning;
      default:
        return Icons.assessment;
    }
  }

  Color _getIconColor(String tipo) {
    switch (tipo) {
      case 'geral':
        return Colors.blue;
      case 'plantios':
        return Colors.green;
      case 'agrotoxicos':
        return Colors.red;
      case 'insumos':
        return Colors.orange;
      case 'colheitas':
        return Colors.amber;
      case 'custos':
        return Colors.purple;
      case 'estoque':
        return Colors.indigo;
      case 'sementes':
        return Colors.green;
      case 'agrotoxicos-estoque':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  Widget _buildPeriodoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Período do Relatório',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildDateField(
                label: 'Data Início',
                value: _dataInicio,
                onTap: () => _selectDate(true),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDateField(
                label: 'Data Fim',
                value: _dataFim,
                onTap: () => _selectDate(false),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    value != null
                        ? '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}'
                        : 'Selecionar data',
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          value != null
                              ? AppColors.textPrimary
                              : Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGerarRelatorioButton() {
    final canGenerate =
        _tipoRelatorioSelecionado != null &&
        _dataInicio != null &&
        _dataFim != null;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: canGenerate && !_isLoading ? _gerarRelatorio : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          disabledBackgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        child:
            _isLoading
                ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.picture_as_pdf,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Gerar Relatório PDF',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  Widget _buildInstrucoesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGreen.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.info, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 8),
              const Text(
                'Como funciona',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '1. Selecione o tipo de relatório desejado',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          const Text(
            '2. Escolha o período (data início e fim)',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          const Text(
            '3. Clique em "Gerar Relatório PDF"',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          const Text(
            '4. O PDF será baixado e aberto automaticamente',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(bool isInicio) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          isInicio
              ? (_dataInicio ??
                  DateTime.now().subtract(const Duration(days: 30)))
              : (_dataFim ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryGreen,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isInicio) {
          _dataInicio = picked;
          // Se a data de fim for anterior à data de início, limpar a data de fim
          if (_dataFim != null && _dataFim!.isBefore(picked)) {
            _dataFim = null;
          }
        } else {
          _dataFim = picked;
        }
      });
    }
  }

  Future<void> _gerarRelatorio() async {
    if (_tipoRelatorioSelecionado == null ||
        _dataInicio == null ||
        _dataFim == null) {
      _showErrorSnackBar(
        'Por favor, selecione o tipo de relatório e o período',
      );
      return;
    }

    if (_dataFim!.isBefore(_dataInicio!)) {
      _showErrorSnackBar('A data de fim deve ser posterior à data de início');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Obter o ID do usuário logado
      final usuario = AuthService.usuario;
      if (usuario?.id == null) {
        _showErrorSnackBar('Usuário não autenticado. Faça login novamente.');
        return;
      }

      final usuarioId = usuario!.id!;

      // Chamar o método apropriado baseado no tipo de relatório selecionado
      switch (_tipoRelatorioSelecionado) {
        case 'geral':
          await _relatorioService.gerarRelatorioGeral(
            usuarioId: usuarioId,
            dataInicio: _dataInicio!,
            dataFim: _dataFim!,
          );
          break;
        case 'plantios':
          await _relatorioService.gerarRelatorioPlantios(
            usuarioId: usuarioId,
            dataInicio: _dataInicio!,
            dataFim: _dataFim!,
          );
          break;
        case 'agrotoxicos':
          await _relatorioService.gerarRelatorioAgrotoxicos(
            usuarioId: usuarioId,
            dataInicio: _dataInicio!,
            dataFim: _dataFim!,
          );
          break;
        case 'insumos':
          await _relatorioService.gerarRelatorioInsumosEstoque(
            usuarioId: usuarioId,
            dataInicio: _dataInicio!,
            dataFim: _dataFim!,
          );
          break;
        case 'colheitas':
          await _relatorioService.gerarRelatorioColheitas(
            usuarioId: usuarioId,
            dataInicio: _dataInicio!,
            dataFim: _dataFim!,
          );
          break;
        case 'custos':
          await _relatorioService.gerarRelatorioCustos(
            usuarioId: usuarioId,
            dataInicio: _dataInicio!,
            dataFim: _dataFim!,
          );
          break;
        case 'estoque':
          await _relatorioService.gerarRelatorioEstoque(
            usuarioId: usuarioId,
            dataInicio: _dataInicio!,
            dataFim: _dataFim!,
          );
          break;
        case 'sementes':
          await _relatorioService.gerarRelatorioSementes(
            usuarioId: usuarioId,
            dataInicio: _dataInicio!,
            dataFim: _dataFim!,
          );
          break;
        case 'agrotoxicos-estoque':
          await _relatorioService.gerarRelatorioAgrotoxicosEstoque(
            usuarioId: usuarioId,
            dataInicio: _dataInicio!,
            dataFim: _dataFim!,
          );
          break;
        default:
          throw Exception('Tipo de relatório não suportado');
      }

      _showSuccessSnackBar('Relatório gerado com sucesso!');
    } catch (e) {
      print('Erro ao gerar relatório: $e');
      _showErrorSnackBar('Erro ao gerar relatório: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
