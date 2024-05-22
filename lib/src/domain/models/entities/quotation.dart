import 'package:cotiznow/src/domain/domain.dart';

class Quotation {
  String id;
  String name;
  String address;
  String phone;
  List<Materials> materials;
  List<CustomizedService> customizedServices;
  String status;
  String total;
  String userId;

  Quotation({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
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
      address: json?['address'] ?? '',
      phone: json?['phone'] ?? '',
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
      "address": address,
      "phone": phone,
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
