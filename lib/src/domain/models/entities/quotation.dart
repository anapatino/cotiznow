import 'package:cotiznow/src/domain/domain.dart';

class Quotation {
  String id;
  String name;
  String description;
  List<String> idService;
  String length;
  List<Materials> materials;
  String status;
  String total;
  String width;
  String userId;

  Quotation({
    required this.id,
    required this.name,
    required this.description,
    required this.idService,
    required this.length,
    required this.materials,
    required this.status,
    required this.total,
    required this.width,
    required this.userId,
  });

  factory Quotation.fromJson(Map<String, dynamic>? json) {
    return Quotation(
      id: json?['id'] ?? '',
      name: json?['name'] ?? '',
      description: json?['description'] ?? '',
      idService: json?['id_service'] != null
          ? List<String>.from(json?['id_service'])
          : [],
      length: json?['length'] ?? '',
      materials: (json?['materials'] as List<dynamic>?)
              ?.map((materialJson) => Materials.fromJson(materialJson))
              .toList() ??
          [],
      status: json?['status'] ?? '',
      total: json?['total'] ?? '',
      width: json?['width'] ?? '',
      userId: json?['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'idService': idService,
      'length': length,
      'materials': materials.map((material) => material.toJson()).toList(),
      'status': status,
      'total': total,
      'width': width,
      'id': id,
      'userId': userId,
    };
  }
}
