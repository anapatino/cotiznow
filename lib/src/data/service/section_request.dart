import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/section.dart';

class SectionsRequest {
  static final FirebaseFirestore database = FirebaseFirestore.instance;

  static Future<String> registerSection(
    String icon,
    String name,
    String description,
    String status,
  ) async {
    try {
      await database.collection('sections').add({
        'icon': icon,
        'name': name,
        'description': description,
        'status': status,
      });
      return "Se ha realizado exitosamente el registro de una sección";
    } catch (e) {
      throw Future.error('Error al registrar usuario en la base de datos');
    }
  }

  static Future<String> updateSectionStatus(
    String sectionId,
    String newStatus,
  ) async {
    try {
      await database
          .collection('sections')
          .doc(sectionId)
          .update({'status': newStatus});

      return "Se ha actualizado exitosamente el estado de la sección";
    } catch (e) {
      throw Future.error('Error al actualizar el estado de la sección');
    }
  }

  static Future<String> updateSection(Section section) async {
    try {
      await database.collection('sections').doc(section.id).update({
        'icon': section.icon,
        'name': section.name,
        'description': section.description,
        'status': section.status,
      });

      return "Se ha actualizado exitosamente la sección";
    } catch (e) {
      throw Future.error('Error al actualizar la sección');
    }
  }

  static Future<List<Section>> getAllSections() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await database.collection('sections').get();

      List<Section> sectionsList = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return Section(
          id: doc.id,
          icon: data['icon'] ?? '',
          name: data['name'] ?? '',
          description: data['description'] ?? '',
          status: data['status'] ?? '',
        );
      }).toList();

      return sectionsList;
    } catch (e) {
      throw Future.error(
          'Error al obtener las secciones desde la base de datos');
    }
  }
}
