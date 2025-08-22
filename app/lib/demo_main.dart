import 'package:flutter/material.dart';

import 'widgets/common/common.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Faro - Widgets Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      home: const AppShortcuts(child: WidgetDemoPage()),
    );
  }
}

class WidgetDemoPage extends StatefulWidget {
  const WidgetDemoPage({super.key});

  @override
  State<WidgetDemoPage> createState() => _WidgetDemoPageState();
}

class _WidgetDemoPageState extends State<WidgetDemoPage> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Faro - Widgets Demo'),
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
      ),
      body: FigmaGridContainer(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título principal
                FigmaRow(
                  children: [
                    FigmaColumn(
                      columns: 12,
                      mobileColumns: 12,
                      tabletColumns: 12,
                      child: Text(
                        '🎉 Sistema de Grillas de 12 Columnas',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ],
                ),
                AppSpacing.lgV,

                // Sección de Botones
                FigmaRow(
                  children: [
                    FigmaColumn(
                      columns: 12,
                      mobileColumns: 12,
                      tabletColumns: 12,
                      child: Text(
                        'Botones:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
                AppSpacing.mdV,
                FigmaRow(
                  children: [
                    FigmaColumn(
                      columns: 12,
                      mobileColumns: 12,
                      tabletColumns: 12,
                      child: Wrap(
                        spacing: AppSpacing.sm,
                        children: [
                          AppButton.primary(text: 'Primario', icon: Icons.star),
                          AppButton.secondary(text: 'Secundario'),
                          AppButton.outlined(text: 'Con Borde'),
                          AppButton.white(
                            text: 'Fondo Blanco',
                            icon: Icons.search,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                AppSpacing.lgV,

                // Sección de Cards
                FigmaRow(
                  children: [
                    FigmaColumn(
                      columns: 12,
                      mobileColumns: 12,
                      tabletColumns: 12,
                      child: Text(
                        'Tarjetas:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
                AppSpacing.mdV,
                FigmaRow(
                  children: [
                    FigmaColumn(
                      columns: 6,
                      mobileColumns: 12,
                      tabletColumns: 6,
                      child: AppCard.elevated(
                        padding: EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          children: [
                            const Icon(Icons.dashboard, size: 40),
                            AppSpacing.smV,
                            const Text('Tarjeta Elevada'),
                          ],
                        ),
                      ),
                    ),
                    FigmaColumn(
                      columns: 6,
                      mobileColumns: 12,
                      tabletColumns: 6,
                      child: AppCard.outlined(
                        padding: EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          children: [
                            const Icon(Icons.settings, size: 40),
                            AppSpacing.smV,
                            const Text('Tarjeta con Borde'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                AppSpacing.lgV,

                // Sección de Badges
                FigmaRow(
                  children: [
                    FigmaColumn(
                      columns: 12,
                      mobileColumns: 12,
                      tabletColumns: 12,
                      child: Text(
                        'Badges:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
                AppSpacing.mdV,
                FigmaRow(
                  children: [
                    FigmaColumn(
                      columns: 12,
                      mobileColumns: 12,
                      tabletColumns: 12,
                      child: Wrap(
                        spacing: AppSpacing.sm,
                        children: [
                          AppBadge.primary(text: 'Hobby'),
                          AppBadge.secondary(text: 'Pro'),
                        ],
                      ),
                    ),
                  ],
                ),
                AppSpacing.lgV,

                // Sección de Lista
                FigmaRow(
                  children: [
                    FigmaColumn(
                      columns: 12,
                      mobileColumns: 12,
                      tabletColumns: 12,
                      child: Text(
                        'Lista de Items:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
                AppSpacing.mdV,
                FigmaRow(
                  children: [
                    FigmaColumn(
                      columns: 8,
                      mobileColumns: 12,
                      tabletColumns: 10,
                      child: AppCard.outlined(
                        child: Column(
                          children: [
                            AppListItem(
                              title: 'Overview',
                              subtitle: 'Dashboard principal',
                              leadingIcon: Icons.dashboard,
                              isSelected: true,
                              onTap: () {},
                            ),
                            const Divider(height: 1),
                            AppListItem(
                              title: 'Settings',
                              subtitle: 'Configuración',
                              leadingIcon: Icons.settings,
                              onTap: () {},
                            ),
                            const Divider(height: 1),
                            AppListItem(
                              title: 'Profile',
                              subtitle: 'Tu perfil',
                              leadingIcon: Icons.person,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                AppSpacing.lgV,

                // Sección de Search
                FigmaRow(
                  children: [
                    FigmaColumn(
                      columns: 12,
                      mobileColumns: 12,
                      tabletColumns: 12,
                      child: Text(
                        'Campo de Búsqueda:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
                AppSpacing.mdV,
                FigmaRow(
                  children: [
                    FigmaColumn(
                      columns: 6,
                      mobileColumns: 12,
                      tabletColumns: 8,
                      child: AppSearchField(
                        controller: _searchController,
                        hintText: 'Buscar...',
                        onChanged: (value) {
                          debugPrint('Buscando: $value');
                        },
                      ),
                    ),
                  ],
                ),
                AppSpacing.lgV,

                // Nota sobre responsive
                FigmaRow(
                  children: [
                    FigmaColumn(
                      columns: 12,
                      mobileColumns: 12,
                      tabletColumns: 12,
                      child: Container(
                        padding: EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: AppBorderRadius.md,
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '📱 Sistema de Grillas Responsive',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(color: Colors.blue.shade700),
                            ),
                            AppSpacing.smV,
                            Text(
                              'Este demo usa un sistema de grillas de 12 columnas basado en Figma. '
                              'Redimensiona la ventana para ver cómo se adaptan los elementos.',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.blue.shade600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
