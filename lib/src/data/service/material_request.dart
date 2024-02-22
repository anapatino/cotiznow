import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotiznow/src/domain/models/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MaterialsRequest {
  static final FirebaseFirestore database = FirebaseFirestore.instance;
  static final FirebaseStorage storage = FirebaseStorage.instance;

  static Future<String> _uploadImageToFirebase(String filePath) async {
    try {
      final File file = File(filePath);
      final String fileName = file.path.split('/').last;

      final Reference storageReference =
          storage.ref().child('images').child(fileName);
      final UploadTask uploadTask = storageReference.putFile(file);
      await uploadTask;

      String urlPhoto = await storageReference.getDownloadURL();
      print('URL de la imagen: $urlPhoto');
      return urlPhoto;
    } catch (e) {
      throw Future.error('Error al subir la imagen a Firebase Storage');
    }
  }

  static Future<String> registerMaterial(Materials material) async {
    try {
      final url = await _uploadImageToFirebase(material.urlPhoto);

      await database.collection('materials').add({
        'url_photo': url,
        'name': material.name,
        'code': material.code,
        'unit': material.unit,
        'size': material.size,
        'purchase_price': material.purchasePrice,
        'sale_price': material.salePrice,
        'section_id': material.sectionId,
        'quantity': material.quantity,
        'description': material.description,
        'status': material.status,
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

  static Future<String> updateMaterial(Materials material) async {
    try {
      await database.collection('materials').doc(material.id).update({
        'url_photo': material.urlPhoto,
        'name': material.name,
        'code': material.code,
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
          code: data['code'] ?? '',
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
          code: data['code'] ?? '',
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
