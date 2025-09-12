import 'package:flutter/material.dart';
import '../controllers/holland_test_controller.dart';
import '../../domain/entities/holland_test.dart';
import 'common/common.dart';

/// Widget para manejar encabezados fijos con animación de rebote
class HollandStickyHeadersList extends StatefulWidget {
  final List<Map<String, dynamic>> blocks;
  final HollandTestController controller;
  final bool isDarkMode;

  const HollandStickyHeadersList({
    super.key,
    required this.blocks,
    required this.controller,
    required this.isDarkMode,
  });

  @override
  State<HollandStickyHeadersList> createState() =>
      _HollandStickyHeadersListState();
}

class _HollandStickyHeadersListState extends State<HollandStickyHeadersList>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _bounceAnimations;
  int _currentStickyIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationControllers = List.generate(
      widget.blocks.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      ),
    );
    _bounceAnimations = _animationControllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.elasticOut));
    }).toList();

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    final scrollOffset = _scrollController.offset;
    final blockHeight = 400.0; // Altura aproximada de cada bloque

    // Calcular el índice del bloque actual
    final newStickyIndex = (scrollOffset / blockHeight).floor().clamp(
      0,
      widget.blocks.length - 1,
    );

    if (newStickyIndex != _currentStickyIndex) {
      setState(() {
        _currentStickyIndex = newStickyIndex;
      });

      // Animar el rebote cuando se acerca al siguiente bloque
      if (newStickyIndex < widget.blocks.length - 1) {
        _animationControllers[newStickyIndex].forward().then((_) {
          _animationControllers[newStickyIndex].reverse();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Lista principal con todos los bloques
        ListView.builder(
          controller: _scrollController,
          itemCount: widget.blocks.length,
          itemBuilder: (context, index) {
            return _buildQuestionBlock(
              widget.blocks[index],
              widget.controller,
              widget.isDarkMode,
              index,
            );
          },
        ),

        // Encabezado fijo
        if (_currentStickyIndex < widget.blocks.length)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _bounceAnimations[_currentStickyIndex],
              builder: (context, child) {
                return Transform.scale(
                  scale:
                      1.0 +
                      (_bounceAnimations[_currentStickyIndex].value * 0.05),
                  child: _buildStickyHeader(
                    widget.blocks[_currentStickyIndex],
                    widget.isDarkMode,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildStickyHeader(Map<String, dynamic> block, bool isDarkMode) {
    final type = block['type'] as HollandType;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundPrimary(isDarkMode),
        border: Border(
          bottom: BorderSide(
            color: AppColors.dividerTheme(isDarkMode),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.textPrimary(isDarkMode).withAlpha(20),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
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
    );
  }

  Widget _buildQuestionBlock(
    Map<String, dynamic> block,
    HollandTestController controller,
    bool isDarkMode,
    int blockIndex,
  ) {
    final questions = block['questions'] as List<String>;
    final type = block['type'] as HollandType;

    return AppContainer.outlined(
      isDarkMode: isDarkMode,
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Espaciador para el encabezado fijo
          if (blockIndex == 0) const SizedBox(height: 60),

          // Encabezado del bloque (solo visible cuando no está fijo)
          if (blockIndex != _currentStickyIndex)
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
}
