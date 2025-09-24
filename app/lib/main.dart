import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/infrastructure/di/dependency_injection.dart';
import 'core/presentation/pages/flexible_dashboard_page.dart';
import 'core/presentation/widgets/common/common.dart';

void main() {
  // La API key se maneja directamente en el servicio OpenAIService
  runApp(
    MultiProvider(
      providers: [
        ...DependencyInjection.getSimpleProviders(),
        ...DependencyInjection.getProviders(),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Faro',
          debugShowCheckedModeBanner: false,
          theme: themeProvider.getTheme(),

          // Configuración de localización en español
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('es', 'ES'), // Español de España
            Locale('es', 'MX'), // Español de México
            Locale('es', 'AR'), // Español de Argentina
            Locale('es', 'CL'), // Español de Chile
            Locale('es', 'CO'), // Español de Colombia
            Locale('es', 'PE'), // Español de Perú
            Locale('en', 'US'), // Inglés como fallback
          ],
          locale: const Locale(
            'es',
            'ES',
          ), // Forzar español como idioma principal

          home: const PlatformBrightnessListener(
            child: AppShortcuts(child: FlexibleDashboardPage()),
          ),
        );
      },
    );
  }
}
