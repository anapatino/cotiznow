import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotiznow/src/domain/models/materials.dart';

class MaterialsRequest {
  static final FirebaseFirestore database = FirebaseFirestore.instance;

  static Future<String> registerMaterial(
    Materials material,
  ) async {
    try {
      await database.collection('sections').add({
        'url_photo': material.urlPhoto,
        'name': material.name,
        'unit': material.description,
        'size': material.status,
        'purchase_price': material.description,
        'sale_price': material.status,
        'section_id': material.description,
        'quantity': material.status,
        'description': material.description,
        'status': material.status,
      });
      return "Se ha realizado exitosamente el registro de una materiales";
    } catch (e) {
      throw Future.error('Error al registrar usuario en la base de datos');
    }
  }

  static Future<String> updateMaterialStatus(
    String materialId,
    String newStatus,
  ) async {
    try {
      await database
          .collection('materials')
          .doc(materialId)
          .update({'status': newStatus});

      return "Se ha actualizado exitosamente el estado del material";
    } catch (e) {
      throw Future.error('Error al actualizar el estado del material');
    }
  }

  static Future<String> updateMaterial(Materials material) async {
    try {
      await database.collection('materials').doc(material.id).update({
        'url_photo': material.urlPhoto,
        'name': material.name,
        'unit': material.unit,
        'size': material.size,
        'purchase_price': material.purchasePrice,
        'sale_price': material.salePrice,
        'section_id': material.sectionId,
        'quantity': material.quantity,
        'description': material.description,
        'status': material.status,
      });

      return "Se ha actualizado exitosamente el material";
    } catch (e) {
      throw Future.error('Error al actualizar el material');
    }
  }

  static Future<List<Materials>> getAllMaterials() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await database.collection('materials').get();

      List<Materials> materialsList = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return Materials(
          urlPhoto: data['url_photo'] ?? '',
          name: data['name'] ?? '',
          unit: data['unit'] ?? '',
          size: data['size'] ?? '',
          purchasePrice: data['purchase_price'] ?? '',
          salePrice: data['sale_price'] ?? '',
          sectionId: data['section_id'] ?? '',
          quantity: data['quantity'] ?? '',
          description: data['description'] ?? '',
          status: data['status'] ?? '',
          id: doc.id,
        );
      }).toList();

      return materialsList;
    } catch (e) {
      throw Future.error(
          'Error al obtener las secciones desde la base de datos');
    }
  }

  static Future<List<Materials>> getMaterialsBySectionId(
      String sectionId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await database
          .collection('materials')
          .where('section_id', isEqualTo: sectionId)
          .get();

      List<Materials> materialsList = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return Materials(
          urlPhoto: data['url_photo'] ?? '',
          name: data['name'] ?? '',
          unit: data['unit'] ?? '',
          size: data['size'] ?? '',
          purchasePrice: data['purchase_price'] ?? '',
          salePrice: data['sale_price'] ?? '',
          sectionId: data['section_id'] ?? '',
          quantity: data['quantity'] ?? '',
          description: data['description'] ?? '',
          status: data['status'] ?? '',
          id: doc.id,
        );
      }).toList();

      return materialsList;
    } catch (e) {
      throw Future.error(
          'Error al obtener los materiales desde la base de datos');
    }
  }
}
