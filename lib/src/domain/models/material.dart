class Materials {
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

  Materials({
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

  factory Materials.fromJson(Map<String, dynamic>? json) {
    return Materials(
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
