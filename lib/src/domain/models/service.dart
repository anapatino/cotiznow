class Service {
  String icon, name, description, status, id, price;

  Service({
    required this.id,
    required this.icon,
    required this.name,
    required this.description,
    required this.status,
    required this.price,
  });

  factory Service.fromJson(Map<String, dynamic>? json) {
    return Service(
      id: json?['id'] ?? '',
      icon: json?['icon'] ?? '',
      name: json?['name'] ?? '',
      description: json?['description'] ?? '',
      status: json?['status'] ?? '',
      price: json?['price'] ?? '',
    );
  }
}
