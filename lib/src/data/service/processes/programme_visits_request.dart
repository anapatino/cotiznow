import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotiznow/src/domain/domain.dart';

class ProgrammeVisitsRequest {
  static final FirebaseFirestore database = FirebaseFirestore.instance;

  static Future<String> registerVisit(ProgrammeVisits visit) async {
    try {
      DocumentReference documentReference =
          await database.collection('programme_visits').add({
        'user': visit.user.toJson(),
        'motive': visit.motive,
      });

      String visitId = documentReference.id;
      await documentReference.update({'id': visitId});
      return "Se ha registrado exitosamente la visita";
    } catch (e) {
      throw Future.error(
          'Error al registrar la visita en la base de datos: $e');
    }
  }

  static Future<List<ProgrammeVisits>> getAllVisits() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await database.collection('programme_visits').get();

      List<ProgrammeVisits> visitsList = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return ProgrammeVisits.fromJson(data);
      }).toList();

      return visitsList;
    } catch (e) {
      throw Future.error(
          'Error al obtener todas las visitas de la base de datos');
    }
  }
}
