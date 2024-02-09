class Sections {
  String icon, name, description, status, id;

  Sections({
    required this.id,
    required this.icon,
    required this.name,
    required this.description,
    required this.status,
  });

  factory Sections.fromJson(Map<String, dynamic>? json) {
    return Sections(
      id: json?['id'] ?? '',
      icon: json?['icon'] ?? '',
      name: json?['name'] ?? '',
      description: json?['description'] ?? '',
      status: json?['status'] ?? '',
    );
  }
}
