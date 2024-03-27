import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotiznow/src/domain/models/entities/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MaterialsRequest {
  static final FirebaseFirestore database = FirebaseFirestore.instance;
  static final FirebaseStorage storage = FirebaseStorage.instance;
  static Materials material = Materials(
      id: '',
      urlPhoto: '',
      name: '',
      code: '',
      unit: '',
      size: '',
      purchasePrice: '',
      salePrice: '',
      sectionId: '',
      quantity: '',
      description: '',
      status: '',
      discount: '');

  static Future<String> _uploadImageToFirebase(String filePath) async {
    try {
      final File file = File(filePath);
      final String fileName = file.path.split('/').last;

      final Reference storageReference =
          storage.ref().child('images').child(fileName);
      final UploadTask uploadTask = storageReference.putFile(file);
      await uploadTask;

      String urlPhoto = await storageReference.getDownloadURL();
      return urlPhoto;
    } catch (e) {
      throw Future.error('Error al subir la imagen a Firebase Storage');
    }
  }

  static Future<void> deleteMaterialPhoto(String url) async {
    try {
      Reference storageReference = storage.refFromURL(url);
      await storageReference.delete();
    } catch (e) {
      throw Future.error('Error al eliminar la imagen del Firebase Storage');
    }
  }

  static Future<String> registerMaterial(Materials material) async {
    try {
      final url = await _uploadImageToFirebase(material.urlPhoto);

      await database.collection('materials').add({
        'urlPhoto': url,
        'name': material.name,
        'code': material.code,
        'unit': material.unit,
        'size': material.size,
        'purchasePrice': material.purchasePrice,
        'salePrice': material.salePrice,
        'sectionId': material.sectionId,
        'quantity': material.quantity,
        'description': material.description,
        'status': material.status,
        'discount': material.discount,
      });

      return "Se ha realizado exitosamente el registro del material";
    } catch (e) {
      throw Future.error('Error al registrar material en la base de datos');
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

  static Future<String> changeDiscount(
    String materialId,
    String discount,
  ) async {
    try {
      await database
          .collection('materials')
          .doc(materialId)
          .update({'discount': discount});

      return "Se ha actualizado correctamente el descuento al material";
    } catch (e) {
      throw Future.error('Error al modificar descuento en el material');
    }
  }

  static Future<List<Materials>> getAllMaterials() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await database.collection('materials').get();

      List<Materials> materialsList = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return Materials(
          urlPhoto: data['urlPhoto'] ?? '',
          name: data['name'] ?? '',
          code: data['code'] ?? '',
          unit: data['unit'] ?? '',
          size: data['size'] ?? '',
          purchasePrice: data['purchasePrice'] ?? '',
          salePrice: data['salePrice'] ?? '',
          sectionId: data['sectionId'] ?? '',
          quantity: data['quantity'] ?? '',
          description: data['description'] ?? '',
          status: data['status'] ?? '',
          discount: data['discount'] ?? '',
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
          .where('sectionId', isEqualTo: sectionId)
          .get();

      List<Materials> materialsList = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return Materials(
          urlPhoto: data['urlPhoto'] ?? '',
          name: data['name'] ?? '',
          code: data['code'] ?? '',
          unit: data['unit'] ?? '',
          size: data['size'] ?? '',
          purchasePrice: data['purchasePrice'] ?? '',
          salePrice: data['salePrice'] ?? '',
          sectionId: data['sectionId'] ?? '',
          quantity: data['quantity'] ?? '',
          description: data['description'] ?? '',
          status: data['status'] ?? '',
          discount: data['discount'] ?? '',
          id: doc.id,
        );
      }).toList();

      return materialsList;
    } catch (e) {
      throw Future.error(
          'Error al obtener los materiales desde la base de datos');
    }
  }

  static Future<String> updateMaterial(
      Materials material, String urlOld) async {
    String urlNew;
    try {
      if (urlOld == material.urlPhoto) {
        urlNew = material.urlPhoto;
      } else {
        await deleteMaterialPhoto(urlOld);
        urlNew = await _uploadImageToFirebase(material.urlPhoto);
      }

      await database.collection('materials').doc(material.id).update({
        'urlPhoto': urlNew,
        'name': material.name,
        'code': material.code,
        'unit': material.unit,
        'size': material.size,
        'purchasePrice': material.purchasePrice,
        'salePrice': material.salePrice,
        'sectionId': material.sectionId,
        'quantity': material.quantity,
        'description': material.description,
        'status': material.status,
        'discount': material.discount,
      });

      return "Se ha actualizado exitosamente el material";
    } catch (e) {
      throw Future.error('Error al actualizar el material');
    }
  }

  static Future<void> subtractMaterialsQuantity(
      List<Materials> quotationMaterials, bool add) async {
    try {
      List<Materials> allMaterials = await getAllMaterials();
      List<Materials> updatedMaterials = [];
      for (var quotationMaterial in quotationMaterials) {
        Materials matchingMaterial = allMaterials.firstWhere(
          (newMaterial) => newMaterial.id == quotationMaterial.id,
          orElse: () => material,
        );

        if (matchingMaterial.id != '') {
          int quantityInQuotation = int.parse(quotationMaterial.quantity);
          int quantityInMaterial = int.parse(matchingMaterial.quantity);

          if (add) {
            matchingMaterial.quantity =
                (quantityInMaterial + quantityInQuotation).toString();
          } else {
            matchingMaterial.quantity =
                (quantityInMaterial - quantityInQuotation).toString();
          }

          updatedMaterials.add(matchingMaterial);
        }

        for (var updatedMaterial in updatedMaterials) {
          await updateMaterialQuantityInDatabase(updatedMaterial);
        }
      }
    } catch (e) {
      throw Future.error(
          'Error al intentar hacer los cambios en la cantidad de materiales');
    }
  }

  static Future<void> subtractMaterialQuantity(
      Materials material, bool isAdd) async {
    try {
      List<Materials> allMaterials = await getAllMaterials();

      Materials materialToUpdate = allMaterials.firstWhere(
          (m) => m.id == material.id,
          orElse: () => throw Future.error(
              'El material con ID ${material.id} no existe en la colección materials.'));

      int currentQuantity = int.parse(materialToUpdate.quantity);
      int quantityChange = int.parse(material.quantity);

      if (isAdd) {
        currentQuantity += quantityChange;
      } else {
        currentQuantity -= quantityChange;
      }

      materialToUpdate.quantity = currentQuantity.toString();
      await updateMaterialQuantityInDatabase(materialToUpdate);
    } catch (e) {
      throw Future.error('Error al actualizar la cantidad del material: $e');
    }
  }

  static Future<void> calculateNewMaterialValue(
      List<Materials> newMaterials, List<Materials> oldMaterials) async {
    try {
      for (int i = 0; i < newMaterials.length; i++) {
        Materials newMaterial = newMaterials[i];
        Materials oldMaterial = _findOldMaterial(oldMaterials, newMaterial.id);
        if (oldMaterial.id == "") {
          subtractMaterialQuantity(newMaterial, false);
        } else {
          int quantityInNewMaterial = int.parse(newMaterial.quantity);
          int quantityInOldMaterial = int.parse(oldMaterial.quantity);

          Materials databaseMaterial = await _findMaterialById(newMaterial.id);
          databaseMaterial.id = newMaterial.id;
          int databaseQuantity = int.parse(databaseMaterial.quantity);

          if (quantityInNewMaterial > quantityInOldMaterial) {
            databaseQuantity -= quantityInNewMaterial - quantityInOldMaterial;
          }

          if (quantityInNewMaterial < quantityInOldMaterial) {
            databaseQuantity += quantityInOldMaterial - quantityInNewMaterial;
          }
          if (quantityInNewMaterial == 0) {
            databaseQuantity += quantityInOldMaterial;
          }
          databaseMaterial.quantity = databaseQuantity.toString();
          await updateMaterialQuantityInDatabase(databaseMaterial);
        }
      }
    } catch (e) {
      throw Future.error(
          'Error: Al intentar hacer los cambios en la cantidad de materiales');
    }
  }

  static Materials _findOldMaterial(List<Materials> oldMaterials, String id) {
    return oldMaterials.firstWhere(
      (oldMaterial) => oldMaterial.id == id,
      orElse: () => material,
    );
  }

  static Future<Materials> _findMaterialById(String id) async {
    DocumentSnapshot quotationSnapshot =
        await database.collection('materials').doc(id).get();
    Map<String, dynamic> materialData =
        quotationSnapshot.data() as Map<String, dynamic>;

    return Materials.fromJson(materialData);
  }

  static Future<void> updateMaterialQuantityInDatabase(
      Materials material) async {
    try {
      await database.collection('materials').doc(material.id).update({
        'quantity': material.quantity,
      });
    } catch (e) {
      throw Future.error(
          'Error al actualizar la cantidad del material en la base de datos: $e');
    }
  }

  static Future<String> deleteMaterial(
      String materialId, String urlMaterial) async {
    try {
      await deleteMaterialPhoto(urlMaterial);
      await database.collection('materials').doc(materialId).delete();
      return "Se ha eliminado con exito el material";
    } catch (e) {
      throw Future.error('Error al eliminar el material: $e');
    }
  }
}
