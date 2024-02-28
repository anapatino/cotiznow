import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/domain.dart';

class QuotationRequest {
  static final FirebaseFirestore database = FirebaseFirestore.instance;

  static Future<String> quoteRegistration(Quotation quotation) async {
    try {
      await database.collection('quotations').add({
        'name': quotation.name,
        'description': quotation.description,
        'id_section': quotation.idSection,
        'id_service': quotation.idService,
        'length': quotation.length,
        'materials': quotation.materials.values
            .map((material) => material.toJson())
            .toList(),
        'status': quotation.status,
        'total': quotation.total,
        'width': quotation.width,
      });

      return "Se ha realizado exitosamente el registro de una cotización";
    } catch (e) {
      throw Future.error(
          'Error al registrar la cotización en la base de datos');
    }
  }

  static Future<String> updateQuotationStatus(
      String quotationId, String newStatus) async {
    try {
      await database.collection('quotations').doc(quotationId).update({
        'status': newStatus,
      });
      return "Se ha actualizado el estado de la cotización";
    } catch (e) {
      throw Future.error(
          'Error al actualizar el estado de la cotización en la base de datos');
    }
  }

  static Future<List<Quotation>> getAllQuotations() async {
    try {
      QuerySnapshot querySnapshot =
          await database.collection('quotations').get();

      List<Quotation> quotations = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Quotation.fromJson(data);
      }).toList();

      return quotations;
    } catch (e) {
      throw Future.error(
          'Error al obtener todas las cotizaciones de la base de datos');
    }
  }

  static Future<String> deleteQuotation(String quotationId) async {
    try {
      await database.collection('quotations').doc(quotationId).delete();
      return "Se ha eliminado la cotización satisfactoriamente";
    } catch (e) {
      throw Future.error('Error al eliminar la cotización de la base de datos');
    }
  }
}
