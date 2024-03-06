import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/domain.dart';

class UnitsRequest {
  static final FirebaseFirestore database = FirebaseFirestore.instance;

  static Future<String> registerUnit(String unit) async {
    try {
      DocumentReference docRef = await database.collection('units').add({
        'name': unit,
      });

      await docRef.update({'code': docRef.id});

      return "Se ha registrado exitosamente la unidad";
    } catch (e) {
      throw Future.error('Error al registrar la unidad en la base de datos');
    }
  }

  static Future<List<Units>> getAllUnits() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await database.collection('units').get();

      List<Units> unitsList = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return Units(
          code: data['code'] ?? '',
          name: data['name'] ?? '',
        );
      }).toList();

      return unitsList;
    } catch (e) {
      throw Future.error(
          'Error al obtener todas las unidades desde la base de datos');
    }
  }
}
