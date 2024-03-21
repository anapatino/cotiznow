class Materials {
  String urlPhoto;
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
    required this.urlPhoto,
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
      urlPhoto: json?['urlPhoto'] ?? '',
      name: json?['name'] ?? '',
      code: json?['code'] ?? '',
      unit: json?['unit'] ?? '',
      size: json?['size'] ?? '',
      purchasePrice: json?['purchasePrice'] ?? '',
      salePrice: json?['salePrice'] ?? '',
      sectionId: json?['sectionId'] ?? '',
      quantity: json?['quantity'] ?? '',
      description: json?['description'] ?? '',
      status: json?['status'] ?? '',
      id: json?['id'] ?? '',
      discount: json?['discount'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'urlPhoto': urlPhoto,
      'name': name,
      'code': code,
      'unit': unit,
      'size': size,
      'purchasePrice': purchasePrice,
      'salePrice': salePrice,
      'sectionId': sectionId,
      'quantity': quantity,
      'description': description,
      'status': status,
      'id': id,
      'discount': discount,
    };
  }

  static Materials createMaterialFromParameters(
      Map<String, dynamic>? parameters) {
    String? getValue(String key) => parameters?[key]?.toString();

    return Materials(
      urlPhoto: getValue('urlPhoto') ?? '',
      name: getValue('name') ?? '',
      code: getValue('code') ?? '',
      unit: getValue('unit') ?? '',
      size: getValue('size') ?? '',
      purchasePrice: getValue('purchasePrice') ?? '',
      salePrice: getValue('salePrice') ?? '',
      sectionId: getValue('sectionId') ?? '',
      quantity: getValue('quantity') ?? '',
      description: getValue('description') ?? '',
      id: getValue('id') ?? '',
      status: getValue('status') ?? '',
      discount: getValue('discount') ?? '',
    );
  }
}
