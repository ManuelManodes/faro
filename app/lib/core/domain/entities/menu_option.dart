class MenuOption {
  final String id;
  final String title;
  final String description;
  final String icon;
  final String route;
  final bool isActive;

  const MenuOption({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.route,
    this.isActive = true,
  });

  MenuOption copyWith({
    String? id,
    String? title,
    String? description,
    String? icon,
    String? route,
    bool? isActive,
  }) {
    return MenuOption(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      route: route ?? this.route,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MenuOption && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'MenuOption(id: $id, title: $title)';
  }
}

