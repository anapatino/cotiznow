import 'package:cotiznow/src/domain/domain.dart';

class Quotation {
  String id;
  String name;
  String description;
  String idSection;
  String idService;
  String length;
  Map<String, Materials> materials;
  String status;
  String total;
  String width;

  Quotation({
    required this.id,
    required this.name,
    required this.description,
    required this.idSection,
    required this.idService,
    required this.length,
    required this.materials,
    required this.status,
    required this.total,
    required this.width,
  });

  factory Quotation.fromJson(Map<String, dynamic>? json) {
    return Quotation(
      id: json?['id'] ?? '',
      name: json?['name'] ?? '',
      description: json?['description'] ?? '',
      idSection: json?['id_section'] ?? '',
      idService: json?['id_service'] ?? '',
      length: json?['length'] ?? '',
      materials: (json?['materials'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(
              key,
              Materials.fromJson(value as Map<String, dynamic>?),
            ),
          ) ??
          {},
      status: json?['status'] ?? '',
      total: json?['total'] ?? '',
      width: json?['width'] ?? '',
    );
  }
}
