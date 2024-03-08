import 'package:get/get.dart';

import '../../../data/service/entities/material_request.dart';
import '../../models/entities/material.dart';

class MaterialsController extends GetxController {
  final Rxn<List<Materials>> _materialsList = Rxn<List<Materials>>();
  final Rxn<List<Materials>> _materialsBySectionList = Rxn<List<Materials>>();

  List<Materials>? get materialsList => _materialsList.value;
  List<Materials>? get materialsBySectionList => _materialsBySectionList.value;

  Future<String> registerMaterial(
    Materials material,
  ) async {
    try {
      return await MaterialsRequest.registerMaterial(material);
    } catch (e) {
      throw Future.error('Error al registrar material en la base de datos');
    }
  }

  Future<String> updateMaterialStatus(
    String materialId,
    String newStatus,
  ) async {
    try {
      return await MaterialsRequest.updateMaterialStatus(materialId, newStatus);
    } catch (e) {
      throw Future.error('Error al actualizar el estado del material');
    }
  }

  Future<String> updateDiscount(
    String materialId,
    String discount,
  ) async {
    try {
      return await MaterialsRequest.changeDiscount(materialId, discount);
    } catch (e) {
      throw Future.error('Error al actualizar el descuento del material');
    }
  }

  Future<String> updateMaterial(Materials material, String urlOld) async {
    try {
      return await MaterialsRequest.updateMaterial(material, urlOld);
    } catch (e) {
      throw Future.error('Error al actualizar el material');
    }
  }

  Future<List<Materials>> getAllMaterials() async {
    try {
      List<Materials> list = await MaterialsRequest.getAllMaterials();
      _materialsList.value = list;
      return list;
    } catch (e) {
      throw Future.error(
          'Error al obtener los materiales desde la base de datos');
    }
  }

  Future<List<Materials>> getMaterialsBySectionId(String sectionId) async {
    try {
      List<Materials> list =
          await MaterialsRequest.getMaterialsBySectionId(sectionId);
      _materialsBySectionList.value = list;
      return list;
    } catch (e) {
      throw Future.error('Error al obtener los materiales por sectionId');
    }
  }

  Future<String> deleteMaterial(String materialId, String urlPhoto) async {
    try {
      return await MaterialsRequest.deleteMaterial(materialId, urlPhoto);
    } catch (e) {
      throw Future.error('Error al eliminar los materiales');
    }
  }
}
