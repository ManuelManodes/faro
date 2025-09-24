import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'common/common.dart';

/// Widget para mostrar información sobre la configuración de IA
/// Muestra el estado de la API de Cursor configurada
class AIConfigWidget extends StatefulWidget {
  final VoidCallback? onConfigSaved;

  const AIConfigWidget({super.key, this.onConfigSaved});

  @override
  State<AIConfigWidget> createState() => _AIConfigWidgetState();
}

class _AIConfigWidgetState extends State<AIConfigWidget> {
  bool _isLoading = false;
  bool _isServiceAvailable = false;
  Map<String, dynamic>? _modelInfo;

  @override
  void initState() {
    super.initState();
    _checkServiceStatus();
  }

  /// Verifica el estado del servicio de IA
  Future<void> _checkServiceStatus() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simular verificación del servicio
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _isServiceAvailable = true;
        _modelInfo = {
          'model': 'claude-3-sonnet-simulated',
          'provider': 'Cursor',
          'status': 'Disponible',
          'type': 'Inteligencia Artificial Simulada',
        };
      });
    } catch (e) {
      setState(() {
        _isServiceAvailable = false;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.backgroundPrimary(isDarkMode),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.dividerTheme(isDarkMode)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.smart_toy,
                      color: AppColors.success,
                      size: 20,
                    ),
                  ),
                  AppSpacing.smH,
                  Text(
                    'Estado del Asistente IA',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary(isDarkMode),
                    ),
                  ),
                ],
              ),

              AppSpacing.mdV,

              // Estado del servicio
              if (_isLoading)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.info,
                          ),
                        ),
                      ),
                      AppSpacing.smH,
                      Text(
                        'Verificando servicio de IA...',
                        style: TextStyle(fontSize: 14, color: AppColors.info),
                      ),
                    ],
                  ),
                )
              else if (_isServiceAvailable)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.success.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppColors.success,
                            size: 20,
                          ),
                          AppSpacing.smH,
                          Text(
                            'Servicio de IA Disponible',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                      AppSpacing.smV,
                      if (_modelInfo != null) ...[
                        Text(
                          'Modelo: ${_modelInfo!['model']}',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary(isDarkMode),
                          ),
                        ),
                        Text(
                          'Proveedor: ${_modelInfo!['provider']}',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary(isDarkMode),
                          ),
                        ),
                        if (_modelInfo!['type'] != null)
                          Text(
                            'Tipo: ${_modelInfo!['type']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.info,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                      ],
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.error.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error, color: AppColors.error, size: 20),
                      AppSpacing.smH,
                      Text(
                        'Servicio de IA no disponible',
                        style: TextStyle(fontSize: 14, color: AppColors.error),
                      ),
                    ],
                  ),
                ),

              AppSpacing.mdV,

              // Información sobre Cursor
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.info.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.info,
                          size: 16,
                        ),
                        AppSpacing.smH,
                        Text(
                          'Configuración Automática',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.info,
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.smV,
                    Text(
                      'El asistente virtual utiliza inteligencia artificial simulada con respuestas contextuales inteligentes. '
                      'No requiere configuración adicional y está optimizado para consultas educativas.',
                      style: TextStyle(fontSize: 12, color: AppColors.info),
                    ),
                  ],
                ),
              ),

              AppSpacing.lgV,

              // Botón de cerrar
              Row(
                children: [
                  Expanded(
                    child: AppButton.elegantGreen(
                      text: 'Cerrar',
                      onPressed: () {
                        Navigator.of(context).pop();
                        widget.onConfigSaved?.call();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
