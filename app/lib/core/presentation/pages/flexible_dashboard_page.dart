import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/menu_option.dart';
import '../controllers/menu_controller.dart' as menu;
import '../widgets/app_layout.dart';
import '../widgets/common/common.dart';
import '../widgets/simplified_view_header_widget.dart';
import 'assistant_page.dart';

class FlexibleDashboardPage extends StatefulWidget {
  const FlexibleDashboardPage({super.key});

  @override
  State<FlexibleDashboardPage> createState() => _FlexibleDashboardPageState();
}

class _FlexibleDashboardPageState extends State<FlexibleDashboardPage> {
  String? _selectedViewType;
  String? _selectedViewTitle;

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
        return AppLayout(
          child: _selectedViewType != null
              ? _buildSelectedView()
              : _buildMenuGrid(),
        );
      },
    );
  }

  Widget _buildSelectedView() {
    // Mostrar la página específica según el tipo de vista seleccionada
    switch (_selectedViewType) {
      case 'assistant':
        return const AssistantPage();
      default:
        return SimplifiedViewHeaderWidget(title: _selectedViewTitle!);
    }
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

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sistema de Gestión',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(
                  context.read<ThemeProvider>().isDarkMode,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Selecciona una opción para comenzar',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary(
                  context.read<ThemeProvider>().isDarkMode,
                ),
              ),
            ),
            const SizedBox(height: 32),
            GridView.builder(
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
            ),
          ],
        );
      },
    );
  }

  Widget _buildMenuCard(MenuOption option) {
    return AppCard.elevated(
      child: InkWell(
        onTap: () => _selectView(option),
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

  void _selectView(MenuOption option) {
    setState(() {
      _selectedViewType = _getViewType(option.id);
      _selectedViewTitle = option.title;
    });
  }

  String _getViewType(String optionId) {
    switch (optionId) {
      case 'attendance':
        return 'attendance';
      case 'assistant':
        return 'assistant';
      default:
        return 'flexible';
    }
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
      case 'widgets':
        return Icons.widgets;
      case 'report_problem':
        return Icons.report_problem;
      default:
        return Icons.apps;
    }
  }
}
