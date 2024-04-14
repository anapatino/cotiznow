import 'package:cotiznow/src/domain/domain.dart';

class Quotation {
  String id;
  String name;
  String description;
  List<Materials> materials;
  List<CustomizedService> customizedServices;
  String status;
  String total;
  String userId;

  Quotation({
    required this.id,
    required this.name,
    required this.description,
    required this.materials,
    required this.status,
    required this.total,
    required this.userId,
    required this.customizedServices,
  });

  factory Quotation.fromJson(Map<String, dynamic>? json) {
    return Quotation(
      id: json?['id'] ?? '',
      name: json?['name'] ?? '',
      description: json?['description'] ?? '',
      materials: (json?['materials'] as List<dynamic>?)
              ?.map((materialJson) => Materials.fromJson(materialJson))
              .toList() ??
          [],
      status: json?['status'] ?? '',
      total: json?['total'] ?? '',
      userId: json?['userId'] ?? '',
      customizedServices: (json?['customizedServices'] as List<dynamic>?)
              ?.map((customizedServices) =>
                  CustomizedService.fromJson(customizedServices))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "description": description,
      "materials": materials.map((material) => material.toJson()).toList(),
      "status": status,
      "total": total,
      "id": id,
      "userId": userId,
      "customizedServices":
          customizedServices.map((service) => service.toJson()).toList(),
    };
  }
}
