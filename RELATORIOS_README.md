# Sistema de Relatórios em PDF - FGL

## Visão Geral

Este projeto implementa um sistema completo de geração de relatórios em PDF para as entidades principais do sistema FGL (Freire Gerenciamento de Lavouras):

- **Agrotóxicos**: Relatório com informações de produtos químicos
- **Sementes**: Relatório com dados de sementes e fornecedores
- **Insumos**: Relatório com materiais e categorias
- **Aplicações de Insumos**: Relatório de aplicações de materiais nas lavouras
- **Aplicações de Agrotóxicos**: Relatório de aplicações de produtos químicos
- **Plantios**: Relatório de plantios realizados nas lavouras

## Funcionalidades

### 1. Geração de Relatórios
- Relatórios em formato PDF profissional
- Cores personalizadas do projeto FGL (verde, laranja)
- Cabeçalho com logo FGL e data de geração
- Tabelas organizadas com dados completos
- Rodapé com informações do sistema

### 2. Interface do Usuário
- Botões de relatório em cada view principal
- **FloatingActionButton**: Botões PDF azuis acima dos botões de adicionar para todas as entidades
- **Posicionamento**: Botões de relatório sempre no topo da coluna de FloatingActionButton
- Feedback visual com SnackBars
- Tratamento de erros robusto

### 3. Cores do Projeto
- **Verde Escuro**: `#2E7D32` - Cabeçalho principal
- **Verde Claro**: `#4CAF50` - Cabeçalhos de tabela
- **Cinza Escuro**: `#212121` - Texto principal
- **Cinza Claro**: `#F5F5F5` - Fundo de rodapé

### 4. Estilo Simplificado
- Design limpo e profissional
- Cabeçalho com nome completo "FGL Freire Gerenciamento de Lavouras"
- Tabelas organizadas e legíveis
- Rodapé informativo centralizado

## Como Usar

### Gerar Relatório de Agrotóxicos
1. Acesse a view de Agrotóxicos
2. Clique no botão PDF (ícone azul) acima do botão de adicionar
3. O relatório será gerado e exibido automaticamente

### Gerar Relatório de Sementes
1. Acesse a view de Sementes
2. Clique no botão PDF (ícone azul) acima do botão de adicionar
3. O relatório será gerado e exibido automaticamente

### Gerar Relatório de Insumos
1. Acesse a view de Insumos
2. Clique no botão PDF (ícone azul) acima do botão de adicionar
3. O relatório será gerado e exibido automaticamente

### Gerar Relatório de Aplicações de Insumos
1. Acesse a view de Aplicações de Insumos
2. Clique no botão PDF (ícone azul) acima do botão de adicionar
3. O relatório será gerado e exibido automaticamente

### Gerar Relatório de Aplicações de Agrotóxicos
1. Acesse a view de Aplicações de Agrotóxicos
2. Clique no botão PDF (ícone azul) acima do botão de adicionar
3. O relatório será gerado e exibido automaticamente

### Gerar Relatório de Plantios
1. Acesse a view de Plantios
2. Clique no botão PDF (ícone azul) acima do botão de adicionar
3. O relatório será gerado e exibido automaticamente

## Estrutura Técnica

### Arquivos Principais
- `lib/services/RelatorioService.dart` - Serviço principal de relatórios
- `lib/widgets/RelatorioButton.dart` - Widget reutilizável do botão
- Views atualizadas com botões de relatório

### Dependências
- `pdf: ^3.10.4` - Geração de PDFs
- `printing: ^5.12.0` - Visualização e impressão

### Métodos Disponíveis
```dart
// Relatório de Agrotóxicos
await RelatorioService.gerarRelatorioAgrotoxicos(List<AgrotoxicoModel>);

// Relatório de Sementes
await RelatorioService.gerarRelatorioSementes(List<SementeModel>);

// Relatório de Insumos
await RelatorioService.gerarRelatorioInsumos(List<InsumoModel>);

// Relatório de Aplicações de Insumos
await RelatorioService.gerarRelatorioAplicacoesInsumos(List<AplicacaoInsumoModel>);

// Relatório de Aplicações de Agrotóxicos
await RelatorioService.gerarRelatorioAplicacoes(List<AplicacaoModel>);

// Relatório de Plantios
await RelatorioService.gerarRelatorioPlantios(List<PlantioModel>);
```

## Personalização

### Cores
As cores podem ser alteradas no `RelatorioService.dart`:
```dart
static const PdfColor corPrimaria = PdfColor.fromInt(0xFF2E7D32);
static const PdfColor corSecundaria = PdfColor.fromInt(0xFF4CAF50);
static const PdfColor corDestaque = PdfColor.fromInt(0xFFFF9800);
```

### Layout
- Tabelas com colunas configuráveis
- Cabeçalhos personalizáveis
- Rodapé com informações do sistema

## Tratamento de Erros

O sistema inclui tratamento robusto de erros:
- Try-catch em todas as operações de PDF
- SnackBars informativos para o usuário
- Verificação de contexto montado

## Compatibilidade

- Flutter SDK: ^3.7.2
- Android e iOS
- Web (com limitações de impressão)

## Próximas Melhorias

- Relatórios com gráficos
- Exportação para outros formatos
- Templates personalizáveis
- Relatórios agendados
- Filtros avançados nos relatórios
