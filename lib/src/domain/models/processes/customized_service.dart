class CustomizedService {
  String id;
  String name;
  String price;
  Measures measures;

  CustomizedService({
    required this.id,
    required this.name,
    required this.price,
    required this.measures,
  });

  factory CustomizedService.fromJson(Map<String, dynamic>? json) {
    return CustomizedService(
      id: json?['id'] ?? '',
      name: json?['name'] ?? '',
      price: json?['price'] ?? '',
      measures: Measures.fromJson(json?['measures']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'measures': measures.toJson(),
    };
  }
}

class Measures {
  String height;
  String width;

  Measures({
    required this.height,
    required this.width,
  });

  factory Measures.fromJson(Map<String, dynamic>? json) {
    return Measures(
      height: json?['height'] ?? '',
      width: json?['width'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'height': height,
      'width': width,
    };
  }
}
