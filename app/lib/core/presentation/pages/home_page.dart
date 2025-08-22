import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/user.dart';
import '../controllers/user_controller.dart';
import '../widgets/app_layout.dart';
import '../widgets/common/common.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Cargar usuarios al inicializar la página
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserController>().loadUsers();
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
                columns: 8,
                mobileColumns: 12,
                tabletColumns: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bienvenido a Faro',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Aplicación con Arquitectura Hexagonal',
                      style: TextStyle(
                        fontSize: 16,
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildUsersSection(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUsersSection() {
    return Consumer<UserController>(
      builder: (context, userController, child) {
        if (userController.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (userController.error != null) {
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
                    userController.error!,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        if (userController.users.isEmpty) {
          return AppCard.outlined(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.people_outline, size: 48),
                  const SizedBox(height: 8),
                  Text(
                    'No hay usuarios',
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
              'Usuarios (${userController.users.length})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ...userController.users.map((user) => _buildUserCard(user)),
          ],
        );
      },
    );
  }

  Widget _buildUserCard(User user) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard.elevated(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.primary,
            child: Text(
              user.name[0].toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(user.name),
          subtitle: Text(user.email),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            context.read<UserController>().selectUser(user);
            _showUserDetails(user);
          },
        ),
      ),
    );
  }

  void _showUserDetails(User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detalles de ${user.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${user.id}'),
            Text('Email: ${user.email}'),
            Text('Creado: ${user.createdAt.toString().split('.')[0]}'),
            Text('Actualizado: ${user.updatedAt.toString().split('.')[0]}'),
          ],
        ),
        actions: [
          AppButton.outlined(
            text: 'Cerrar',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
