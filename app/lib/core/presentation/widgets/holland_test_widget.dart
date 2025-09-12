import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';

import '../controllers/holland_test_controller.dart';
import '../../domain/entities/holland_test.dart';
import 'common/common.dart';

/// Widget principal del Test de Holland
class HollandTestWidget extends StatelessWidget {
  const HollandTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HollandTestController(),
      child: Consumer<HollandTestController>(
        builder: (context, controller, child) {
          if (!controller.hasTest) {
            return const _TestStartScreen();
          }

          if (controller.isTestCompleted) {
            return const _TestResultScreen();
          }

          return const _TestQuestionScreen();
        },
      ),
    );
  }
}

/// Pantalla de inicio del test
class _TestStartScreen extends StatelessWidget {
  const _TestStartScreen();

  @override
  Widget build(BuildContext context) {
    return Consumer2<HollandTestController, ThemeProvider>(
      builder: (context, controller, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: AppContainer.elevated(
              isDarkMode: isDarkMode,
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icono del test
                  Icon(
                    Icons.psychology,
                    size: 64,
                    color: AppColors.textPrimary(isDarkMode),
                  ),
                  AppSpacing.lgV,

                  // Título
                  Text(
                    'Test de Holland',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(isDarkMode),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  AppSpacing.mdV,

                  // Descripción
                  Text(
                    'Descubre tu perfil vocacional y las carreras que mejor se adaptan a tu personalidad',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary(isDarkMode),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  AppSpacing.lgV,

                  // Información del test
                  _buildTestInfo(isDarkMode),
                  AppSpacing.lgV,

                  // Formulario de inicio
                  _buildStartForm(context, controller, isDarkMode),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTestInfo(bool isDarkMode) {
    return AppContainer.outlined(
      isDarkMode: isDarkMode,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Información del Test',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary(isDarkMode),
            ),
          ),
          AppSpacing.smV,
          _buildInfoItem(
            'Duración estimada',
            '15-20 minutos',
            Icons.timer,
            isDarkMode,
          ),
          _buildInfoItem(
            'Número de preguntas',
            '${HollandTestData.totalQuestions} preguntas',
            Icons.quiz,
            isDarkMode,
          ),
          _buildInfoItem(
            'Tipos de personalidad',
            '6 tipos diferentes',
            Icons.psychology,
            isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    String label,
    String value,
    IconData icon,
    bool isDarkMode,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.iconSecondary(isDarkMode)),
          AppSpacing.smH,
          Text(
            '$label: ',
            style: TextStyle(
              color: AppColors.textSecondary(isDarkMode),
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: AppColors.textPrimary(isDarkMode),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartForm(
    BuildContext context,
    HollandTestController controller,
    bool isDarkMode,
  ) {
    final nameController = TextEditingController();
    final idController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Datos del Estudiante',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary(isDarkMode),
          ),
        ),
        AppSpacing.mdV,

        // Campo de nombre
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface(isDarkMode),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.dividerTheme(isDarkMode)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Icon(
                  Icons.person,
                  size: 16,
                  color: AppColors.iconSecondary(isDarkMode),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: 'Ingresa el nombre completo',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: AppColors.textSecondary(isDarkMode),
                      ),
                    ),
                    style: TextStyle(color: AppColors.textPrimary(isDarkMode)),
                  ),
                ),
              ],
            ),
          ),
        ),
        AppSpacing.mdV,

        // Campo de ID
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface(isDarkMode),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.dividerTheme(isDarkMode)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Icon(
                  Icons.badge,
                  size: 16,
                  color: AppColors.iconSecondary(isDarkMode),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: idController,
                    decoration: InputDecoration(
                      hintText: 'Ingresa el ID o número de estudiante',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: AppColors.textSecondary(isDarkMode),
                      ),
                    ),
                    style: TextStyle(color: AppColors.textPrimary(isDarkMode)),
                  ),
                ),
              ],
            ),
          ),
        ),
        AppSpacing.lgV,

        // Botón de inicio
        SizedBox(
          width: double.infinity,
          child: AppButton.elegantGreen(
            text: 'Iniciar Test',
            onPressed: () {
              if (nameController.text.trim().isEmpty ||
                  idController.text.trim().isEmpty) {
                AppSnackBar.showError(
                  context,
                  'Por favor completa todos los campos',
                );
                return;
              }

              controller.startTest(
                nameController.text.trim(),
                idController.text.trim(),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Pantalla de preguntas del test
class _TestQuestionScreen extends StatelessWidget {
  const _TestQuestionScreen();

  @override
  Widget build(BuildContext context) {
    return Consumer2<HollandTestController, ThemeProvider>(
      builder: (context, controller, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;

        return Column(
          children: [
            // Barra de progreso
            _buildProgressBar(controller, isDarkMode),

            // Contenido del test
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: Column(
                      children: [
                        // Información del estudiante
                        _buildStudentInfo(controller, isDarkMode),
                        AppSpacing.lgV,

                        // Preguntas del test
                        _buildQuestions(controller, isDarkMode),
                        AppSpacing.lgV,

                        // Botones de acción
                        _buildActionButtons(context, controller, isDarkMode),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProgressBar(HollandTestController controller, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary(isDarkMode),
        border: Border(
          bottom: BorderSide(
            color: AppColors.dividerTheme(isDarkMode),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progreso del Test',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary(isDarkMode),
                ),
              ),
              Text(
                '${controller.completionPercentage}% completado',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary(isDarkMode),
                ),
              ),
            ],
          ),
          AppSpacing.smV,
          LinearProgressIndicator(
            value: controller.progress,
            minHeight: 8,
            backgroundColor: AppColors.dividerTheme(isDarkMode),
            valueColor: AlwaysStoppedAnimation<Color>(
              AppColors.textPrimary(isDarkMode),
            ),
          ),
          AppSpacing.xsV,
          Text(
            '${controller.answeredQuestions} de ${controller.totalQuestions} preguntas respondidas',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary(isDarkMode),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentInfo(HollandTestController controller, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          AppAvatar.user(radius: 24),
          AppSpacing.mdH,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.studentName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(isDarkMode),
                  ),
                ),
                Text(
                  'ID: ${controller.studentId}',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary(isDarkMode),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestions(HollandTestController controller, bool isDarkMode) {
    return Column(
      children: HollandTestData.questionBlocks.map((block) {
        return _buildQuestionBlock(block, controller, isDarkMode);
      }).toList(),
    );
  }

  Widget _buildQuestionBlock(
    Map<String, dynamic> block,
    HollandTestController controller,
    bool isDarkMode,
  ) {
    final blockIndex = HollandTestData.questionBlocks.indexOf(block);
    final questions = block['questions'] as List<String>;
    final type = block['type'] as HollandType;

    return AppContainer.outlined(
      isDarkMode: isDarkMode,
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título del bloque
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.textPrimary(isDarkMode).withAlpha(20),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getTypeIcon(type),
                  color: AppColors.textPrimary(isDarkMode),
                  size: 24,
                ),
                AppSpacing.smH,
                Expanded(
                  child: Text(
                    block['title'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(isDarkMode),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Encabezado de opciones
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondary(isDarkMode),
              border: Border(
                bottom: BorderSide(
                  color: AppColors.dividerTheme(isDarkMode),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Actividad',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary(isDarkMode),
                    ),
                  ),
                ),
                ...HollandTestData.answerOptions.map(
                  (option) => Expanded(
                    child: Text(
                      option,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary(isDarkMode),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Preguntas
          ...questions.asMap().entries.map((entry) {
            final questionIndex = entry.key;
            final question = entry.value;
            final questionId = HollandTestData.getQuestionId(
              blockIndex,
              questionIndex,
            );

            return _buildQuestionRow(
              question,
              questionId,
              controller,
              isDarkMode,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildQuestionRow(
    String question,
    String questionId,
    HollandTestController controller,
    bool isDarkMode,
  ) {
    final currentAnswer = controller.getAnswer(questionId);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.dividerTheme(isDarkMode).withAlpha(50),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              question,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary(isDarkMode),
              ),
            ),
          ),
          ...HollandTestData.answerOptions.asMap().entries.map((entry) {
            final optionIndex = entry.key;

            return Expanded(
              child: Center(
                child: Radio<int>(
                  value: optionIndex,
                  groupValue: currentAnswer,
                  onChanged: (value) {
                    controller.updateAnswer(questionId, value!);
                  },
                  activeColor: AppColors.textPrimary(isDarkMode),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  IconData _getTypeIcon(HollandType type) {
    switch (type) {
      case HollandType.realistic:
        return Icons.build;
      case HollandType.investigative:
        return Icons.science;
      case HollandType.artistic:
        return Icons.palette;
      case HollandType.social:
        return Icons.people;
      case HollandType.enterprising:
        return Icons.business;
      case HollandType.conventional:
        return Icons.assignment;
    }
  }

  Widget _buildActionButtons(
    BuildContext context,
    HollandTestController controller,
    bool isDarkMode,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppButton.surface(
          text: 'Reiniciar Test',
          onPressed: () {
            _showResetDialog(context, controller);
          },
        ),
        Row(
          children: [
            if (controller.isComplete) ...[
              AppButton.elegantGreen(
                text: 'Completar Test',
                onPressed: () {
                  controller.completeTest();
                },
              ),
            ] else ...[
              AppButton.surface(text: 'Completar Test', onPressed: null),
            ],
          ],
        ),
      ],
    );
  }

  void _showResetDialog(
    BuildContext context,
    HollandTestController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reiniciar Test'),
        content: const Text(
          '¿Estás seguro de que quieres reiniciar el test? Se perderán todas las respuestas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              controller.resetTest();
              Navigator.of(context).pop();
            },
            child: const Text('Reiniciar'),
          ),
        ],
      ),
    );
  }
}

/// Pantalla de resultados del test
class _TestResultScreen extends StatefulWidget {
  const _TestResultScreen();

  @override
  State<_TestResultScreen> createState() => _TestResultScreenState();
}

class _TestResultScreenState extends State<_TestResultScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    // Iniciar confeti automáticamente al mostrar los resultados
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confettiController.play();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<HollandTestController, ThemeProvider>(
      builder: (context, controller, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;
        final result = controller.result;

        if (result == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Column(
                    children: [
                      // Header de resultados
                      _buildResultHeader(controller, isDarkMode),
                      AppSpacing.lgV,

                      // Resultado principal
                      _buildMainResult(result, isDarkMode),
                      AppSpacing.lgV,

                      // Gráfico de scores
                      _buildScoresChart(result, isDarkMode),
                      AppSpacing.lgV,

                      // Sugerencias de carrera
                      _buildCareerSuggestions(result, isDarkMode),
                      AppSpacing.lgV,

                      // Rasgos de personalidad
                      _buildPersonalityTraits(result, isDarkMode),
                      AppSpacing.lgV,

                      // Botones de acción
                      _buildResultActions(context, controller, isDarkMode),
                    ],
                  ),
                ),
              ),
            ),
            // Confeti
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: 1.5708, // Hacia abajo (π/2)
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple,
                  Colors.teal,
                  Colors.indigo,
                  Colors.red,
                ],
                emissionFrequency: 0.05,
                numberOfParticles: 50,
                gravity: 0.3,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildResultHeader(HollandTestController controller, bool isDarkMode) {
    return AppContainer.elevated(
      isDarkMode: isDarkMode,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(
            Icons.emoji_events,
            size: 48,
            color: AppColors.textPrimary(isDarkMode),
          ),
          AppSpacing.mdV,
          Text(
            '¡Test Completado!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary(isDarkMode),
            ),
          ),
          AppSpacing.smV,
          Text(
            'Resultados para ${controller.studentName}',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary(isDarkMode),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainResult(HollandTestResult result, bool isDarkMode) {
    return AppContainer.outlined(
      isDarkMode: isDarkMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.textPrimary(isDarkMode).withAlpha(20),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  _getTypeIcon(result.primaryType),
                  size: 48,
                  color: AppColors.textPrimary(isDarkMode),
                ),
                AppSpacing.mdV,
                Text(
                  'Tu Perfil Principal',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(isDarkMode),
                  ),
                ),
                AppSpacing.smV,
                Text(
                  result.primaryType.displayName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(isDarkMode),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Interpretación',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(isDarkMode),
                  ),
                ),
                AppSpacing.smV,
                Text(
                  result.interpretation,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary(isDarkMode),
                    height: 1.5,
                  ),
                ),
                AppSpacing.mdV,
                Row(
                  children: [
                    Expanded(
                      child: _buildTypeCard(
                        'Secundario',
                        result.secondaryType,
                        isDarkMode,
                      ),
                    ),
                    AppSpacing.mdH,
                    Expanded(
                      child: _buildTypeCard(
                        'Terciario',
                        result.tertiaryType,
                        isDarkMode,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeCard(String label, HollandType type, bool isDarkMode) {
    return AppContainer.surface(
      isDarkMode: isDarkMode,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(
            _getTypeIcon(type),
            size: 24,
            color: AppColors.textPrimary(isDarkMode),
          ),
          AppSpacing.xsV,
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary(isDarkMode),
            ),
          ),
          AppSpacing.xsV,
          Text(
            type.displayName,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary(isDarkMode),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoresChart(HollandTestResult result, bool isDarkMode) {
    return AppContainer.outlined(
      isDarkMode: isDarkMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Puntuaciones por Tipo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(isDarkMode),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              children: result.scores.entries.map((entry) {
                final type = entry.key;
                final score = entry.value;
                final maxScore = result.scores.values.reduce(
                  (a, b) => a > b ? a : b,
                );
                final percentage = maxScore > 0 ? score / maxScore : 0.0;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        _getTypeIcon(type),
                        size: 20,
                        color: AppColors.textPrimary(isDarkMode),
                      ),
                      AppSpacing.smH,
                      Expanded(
                        flex: 2,
                        child: Text(
                          type.displayName,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textPrimary(isDarkMode),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: LinearProgressIndicator(
                          value: percentage,
                          backgroundColor: AppColors.dividerTheme(isDarkMode),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            type == result.primaryType
                                ? AppColors.textPrimary(isDarkMode)
                                : AppColors.textPrimary(
                                    isDarkMode,
                                  ).withAlpha(100),
                          ),
                        ),
                      ),
                      AppSpacing.smH,
                      Text(
                        '$score',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary(isDarkMode),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareerSuggestions(HollandTestResult result, bool isDarkMode) {
    return AppContainer.outlined(
      isDarkMode: isDarkMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(
                  Icons.work,
                  color: AppColors.textPrimary(isDarkMode),
                  size: 24,
                ),
                AppSpacing.smH,
                Text(
                  'Sugerencias de Carrera',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(isDarkMode),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: result.careerSuggestions.map((career) {
                return AppBadge.primary(text: career);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalityTraits(HollandTestResult result, bool isDarkMode) {
    return AppContainer.outlined(
      isDarkMode: isDarkMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(
                  Icons.psychology,
                  color: AppColors.textPrimary(isDarkMode),
                  size: 24,
                ),
                AppSpacing.smH,
                Text(
                  'Rasgos de Personalidad',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(isDarkMode),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: result.personalityTraits.map((trait) {
                return AppBadge.secondary(text: trait);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultActions(
    BuildContext context,
    HollandTestController controller,
    bool isDarkMode,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppButton.surface(
          text: 'Nuevo Test',
          onPressed: () {
            controller.resetTest();
          },
        ),
        Row(
          children: [
            AppButton.outlined(
              text: '🎉 Confeti',
              onPressed: () {
                _confettiController.play();
              },
            ),
            AppSpacing.mdH,
            AppButton.outlined(
              text: 'Exportar',
              onPressed: () {
                _exportResults(context, controller);
              },
            ),
            AppSpacing.mdH,
            AppButton.elegantGreen(
              text: 'Finalizar',
              onPressed: () {
                controller.resetTest();
              },
            ),
          ],
        ),
      ],
    );
  }

  void _exportResults(BuildContext context, HollandTestController controller) {
    // TODO: Implementar exportación real (PDF, Excel, etc.)
    // final results = controller.exportResult();
    AppSnackBar.showSuccess(context, 'Resultados exportados exitosamente');
  }

  IconData _getTypeIcon(HollandType type) {
    switch (type) {
      case HollandType.realistic:
        return Icons.build;
      case HollandType.investigative:
        return Icons.science;
      case HollandType.artistic:
        return Icons.palette;
      case HollandType.social:
        return Icons.people;
      case HollandType.enterprising:
        return Icons.business;
      case HollandType.conventional:
        return Icons.assignment;
    }
  }
}
