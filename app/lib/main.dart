import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/app_layout.dart';
import 'widgets/common/common.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
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
          home: const PlatformBrightnessListener(
            child: AppShortcuts(child: HomePage()),
          ),
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;

        return AppLayout(
          child: FigmaRow(
            children: [
              FigmaColumn(
                columns: 8,
                mobileColumns: 12,
                tabletColumns: 10,
                child: Center(
                  child: Text(
                    'Contenido principal usando grilla de 12 columnas',
                    style: TextStyle(
                      fontSize: 18,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
