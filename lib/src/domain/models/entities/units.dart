class Units {
  String code, name;

  Units({
    required this.code,
    required this.name,
  });

  factory Units.fromJson(Map<String, dynamic>? json) {
    return Units(
      code: json?['code'] ?? '',
      name: json?['name'] ?? '',
    );
  }
}
