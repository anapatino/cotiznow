class Material {
  String urlPhoto;
  String name;
  String unit;
  String size;
  String purchasePrice;
  String salePrice;
  String sectionId;
  String quantity;
  String description;
  String status;
  String id;

  Material({
    required this.urlPhoto,
    required this.name,
    required this.unit,
    required this.size,
    required this.purchasePrice,
    required this.salePrice,
    required this.sectionId,
    required this.quantity,
    required this.description,
    required this.status,
    required this.id,
  });

  factory Material.fromJson(Map<String, dynamic>? json) {
    return Material(
      urlPhoto: json?['url_photo'] ?? '',
      name: json?['name'] ?? '',
      unit: json?['unit'] ?? '',
      size: json?['size'] ?? '',
      purchasePrice: json?['purchase_price'] ?? '',
      salePrice: json?['sale_price'] ?? '',
      sectionId: json?['section_id'] ?? '',
      quantity: json?['quantity'] ?? '',
      description: json?['description'] ?? '',
      status: json?['status'] ?? '',
      id: json?['id'] ?? '',
    );
  }
}
