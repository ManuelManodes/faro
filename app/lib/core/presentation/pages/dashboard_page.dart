import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/menu_option.dart';
import '../controllers/menu_controller.dart' as menu;
import '../widgets/app_layout.dart';
import '../widgets/common/common.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // Cargar opciones del menú al inicializar la página
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<menu.MainMenuController>().loadMenuOptions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;

        return AppLayout(
          child: FigmaRow(
            children: [
              FigmaColumn(
                columns: 12,
                mobileColumns: 12,
                tabletColumns: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sistema de Gestión',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(isDarkMode),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Selecciona una opción para comenzar',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary(isDarkMode),
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildMenuGrid(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuGrid() {
    return Consumer<menu.MainMenuController>(
      builder: (context, menuController, child) {
        if (menuController.isLoading) {
          return const Center(
            child: Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Cargando opciones...'),
              ],
            ),
          );
        }

        if (menuController.error != null) {
          return AppCard.outlined(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 8),
                  Text('Error', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    menuController.error!,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        if (menuController.menuOptions.isEmpty) {
          return AppCard.outlined(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.menu_open, size: 48),
                  const SizedBox(height: 8),
                  Text(
                    'No hay opciones disponibles',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemCount: menuController.menuOptions.length,
          itemBuilder: (context, index) {
            final option = menuController.menuOptions[index];
            return _buildMenuCard(option);
          },
        );
      },
    );
  }

  Widget _buildMenuCard(MenuOption option) {
    return AppCard.elevated(
      child: InkWell(
        onTap: () {
          context.read<menu.MainMenuController>().selectOption(option);
          _showOptionDetails(option);
        },
        borderRadius: AppBorderRadius.md,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getIconData(option.icon),
                size: 48,
                color: AppColors.primary,
              ),
              const SizedBox(height: 12),
              Text(
                option.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                option.description,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'dashboard':
        return Icons.dashboard;
      case 'people':
        return Icons.people;
      case 'event':
        return Icons.event;
      case 'assessment':
        return Icons.assessment;
      case 'report':
        return Icons.report;
      case 'smart_toy':
        return Icons.smart_toy;
      case 'account_tree':
        return Icons.account_tree;
      default:
        return Icons.apps;
    }
  }

  void _showOptionDetails(MenuOption option) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(_getIconData(option.icon), color: AppColors.primary),
            const SizedBox(width: 8),
            Expanded(child: Text(option.title)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              option.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Ruta: ${option.route}',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          AppButton.outlined(
            text: 'Cerrar',
            onPressed: () => Navigator.of(context).pop(),
          ),
          AppButton.primary(
            text: 'Abrir',
            onPressed: () {
              Navigator.of(context).pop();
              // Aquí se implementaría la navegación real
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Abriendo: ${option.title}'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
