class Materials {
  String url_photo;
  String name;
  String code;
  String unit;
  String size;
  String purchasePrice;
  String salePrice;
  String sectionId;
  String quantity;
  String description;
  String status;
  String id;
  String discount;

  Materials({
    required this.url_photo,
    required this.name,
    required this.code,
    required this.unit,
    required this.size,
    required this.purchasePrice,
    required this.salePrice,
    required this.sectionId,
    required this.quantity,
    required this.description,
    required this.status,
    required this.id,
    required this.discount,
  });

  factory Materials.fromJson(Map<String, dynamic>? json) {
    return Materials(
      url_photo: json?['url_photo'] ?? '',
      name: json?['name'] ?? '',
      code: json?['code'] ?? '',
      unit: json?['unit'] ?? '',
      size: json?['size'] ?? '',
      purchasePrice: json?['purchase_price'] ?? '',
      salePrice: json?['sale_price'] ?? '',
      sectionId: json?['section_id'] ?? '',
      quantity: json?['quantity'] ?? '',
      description: json?['description'] ?? '',
      status: json?['status'] ?? '',
      id: json?['id'] ?? '',
      discount: json?['discount'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url_photo': url_photo,
      'name': name,
      'code': code,
      'unit': unit,
      'size': size,
      'purchase_price': purchasePrice,
      'sale_price': salePrice,
      'section_id': sectionId,
      'quantity': quantity,
      'description': description,
      'status': status,
      'id': id,
      'discount': discount,
    };
  }
}
