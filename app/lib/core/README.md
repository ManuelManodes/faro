# Arquitectura Hexagonal - Faro

Este proyecto utiliza una arquitectura hexagonal (también conocida como arquitectura de puertos y adaptadores) para mantener una separación clara entre las diferentes capas de la aplicación.

## Estructura del Proyecto

```
lib/
├── core/
│   ├── domain/                    # Capa de dominio (núcleo de negocio)
│   │   ├── entities/             # Entidades del dominio
│   │   ├── repositories/         # Interfaces de repositorios
│   │   └── usecases/            # Casos de uso
│   ├── application/              # Capa de aplicación
│   │   ├── services/            # Servicios de aplicación
│   │   └── ports/               # Puertos (interfaces)
│   ├── infrastructure/           # Capa de infraestructura
│   │   ├── adapters/            # Adaptadores
│   │   ├── repositories/        # Implementaciones de repositorios
│   │   ├── services/            # Servicios de infraestructura
│   │   └── di/                  # Inyección de dependencias
│   └── presentation/             # Capa de presentación
│       ├── pages/               # Páginas de la aplicación
│       ├── widgets/             # Widgets de UI
│       ├── controllers/         # Controladores
│       └── providers/           # Proveedores de estado
└── main.dart                    # Punto de entrada de la aplicación
```

## Capas de la Arquitectura

### 1. Domain (Dominio)
- **Entidades**: Objetos del dominio de negocio (ej: `User`)
- **Repositorios**: Interfaces que definen contratos para acceso a datos
- **Casos de Uso**: Lógica de negocio específica

### 2. Application (Aplicación)
- **Servicios**: Orquestan casos de uso y coordinan operaciones
- **Puertos**: Interfaces que conectan el dominio con el exterior

### 3. Infrastructure (Infraestructura)
- **Adaptadores**: Implementaciones concretas de puertos
- **Repositorios**: Implementaciones de acceso a datos
- **Servicios**: Servicios externos (API, base de datos, etc.)
- **DI**: Configuración de inyección de dependencias

### 4. Presentation (Presentación)
- **Páginas**: Pantallas de la aplicación
- **Widgets**: Componentes reutilizables de UI
- **Controladores**: Manejan el estado de la UI
- **Proveedores**: Gestión de estado global

## Flujo de Datos

1. **UI** → **Controller** → **Service** → **UseCase** → **Repository** → **DataSource**
2. **DataSource** → **Repository** → **UseCase** → **Service** → **Controller** → **UI**

## Beneficios

- **Separación de responsabilidades**: Cada capa tiene una responsabilidad específica
- **Testabilidad**: Fácil de testear cada capa de forma independiente
- **Mantenibilidad**: Cambios en una capa no afectan otras
- **Escalabilidad**: Fácil agregar nuevas funcionalidades
- **Independencia de frameworks**: El dominio no depende de Flutter

## Ejemplo de Uso

```dart
// En una página
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(
      builder: (context, controller, child) {
        return ListView.builder(
          itemCount: controller.users.length,
          itemBuilder: (context, index) {
            final user = controller.users[index];
            return ListTile(title: Text(user.name));
          },
        );
      },
    );
  }
}
```

## Agregar Nuevas Funcionalidades

1. **Crear entidad** en `domain/entities/`
2. **Definir repositorio** en `domain/repositories/`
3. **Implementar casos de uso** en `domain/usecases/`
4. **Crear servicio** en `application/services/`
5. **Implementar repositorio** en `infrastructure/repositories/`
6. **Crear controlador** en `presentation/controllers/`
7. **Configurar DI** en `infrastructure/di/dependency_injection.dart`
8. **Crear páginas/widgets** en `presentation/`
