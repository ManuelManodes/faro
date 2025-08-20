import 'package:flutter/material.dart';
import 'widgets/app_layout.dart';
import 'widgets/common/common.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Faro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      ),
      home: const AppShortcuts(child: HomePage()),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      child: FigmaRow(
        children: [
          FigmaColumn(
            columns: 8,
            mobileColumns: 12,
            tabletColumns: 10,
            child: const Center(
              child: Text(
                'Contenido principal usando grilla de 12 columnas',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
