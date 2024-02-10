class Section {
  String icon, name, description, status, id;

  Section({
    required this.id,
    required this.icon,
    required this.name,
    required this.description,
    required this.status,
  });

  factory Section.fromJson(Map<String, dynamic>? json) {
    return Section(
      id: json?['id'] ?? '',
      icon: json?['icon'] ?? '',
      name: json?['name'] ?? '',
      description: json?['description'] ?? '',
      status: json?['status'] ?? '',
    );
  }
}
