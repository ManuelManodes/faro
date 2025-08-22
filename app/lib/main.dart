import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/infrastructure/di/dependency_injection.dart';
import 'core/presentation/pages/home_page.dart';
import 'core/presentation/widgets/common/common.dart';

void main() {
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
          home: const PlatformBrightnessListener(
            child: AppShortcuts(child: HomePage()),
          ),
        );
      },
    );
  }
}
