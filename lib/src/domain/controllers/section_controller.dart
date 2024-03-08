import 'package:cotiznow/lib.dart';
import 'package:get/get.dart';

import '../../data/service/section_request.dart';
import '../models/entities/section.dart';

class SectionsController extends GetxController {
  final Rxn<List<Section>> _sectionsList = Rxn<List<Section>>();

  List<Section>? get sectionsList => _sectionsList.value;

  Future<String> registerSection(
    String icon,
    String name,
    String description,
    String status,
  ) async {
    try {
      return await SectionsRequest.registerSection(
          icon, name, description, status);
    } catch (e) {
      throw Future.error('Error al registrar sección en la base de datos');
    }
  }

  Future<String> updateSectionStatus(
    String sectionId,
    String newStatus,
  ) async {
    try {
      return await SectionsRequest.updateSectionStatus(sectionId, newStatus);
    } catch (e) {
      throw Future.error('Error al actualizar el estado de la sección');
    }
  }

  Future<String> updateSection(Section section) async {
    try {
      return await SectionsRequest.updateSection(section);
    } catch (e) {
      throw Future.error('Error al actualizar la sección en la base de datos');
    }
  }

  Future<List<Section>> getAllSections() async {
    try {
      List<Section> list = await SectionsRequest.getAllSections();
      _sectionsList.value = list;
      return list;
    } catch (e) {
      throw Future.error(
          'Error al obtener las secciones desde la base de datos');
    }
  }

  Future<String> deleteSection(String sectionId) async {
    try {
      return await SectionsRequest.deleteSection(sectionId);
    } catch (e) {
      throw Future.error('Error al eliminar la sección');
    }
  }
}
