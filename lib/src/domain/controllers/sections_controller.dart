import 'package:get/get.dart';

import '../../data/service/sections_request.dart';
import '../models/sections.dart';

class SectionsService extends GetxController {
  final Rxn<List<Sections>> _sectionsList = Rxn<List<Sections>>();

  List<Sections>? get sectionsList => _sectionsList.value;

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

  Future<String> updateSection(Sections section) async {
    try {
      return await SectionsRequest.updateSection(section);
    } catch (e) {
      throw Future.error('Error al registrar sección en la base de datos');
    }
  }

  Future<void> getAllSections() async {
    try {
      List<Sections> list = await SectionsRequest.getAllSections();
      _sectionsList.value = list;
    } catch (e) {
      throw Future.error(
          'Error al obtener las secciones desde la base de datos');
    }
  }
}
