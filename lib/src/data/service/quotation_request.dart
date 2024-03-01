import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/domain.dart';

class QuotationRequest {
  static final FirebaseFirestore database = FirebaseFirestore.instance;

  static Future<String> quoteRegistration(
      Quotation quotation, String userId) async {
    try {
      DocumentReference quotationRef =
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

      String quotationId = quotationRef.id;

      await updateQuotationIdInUser(userId, quotationId);

      return "Se ha realizado exitosamente el registro de una cotización";
    } catch (e) {
      throw Future.error(
          'Error al registrar la cotización en la base de datos: $e');
    }
  }

  static Future<void> updateQuotationIdInUser(
      String userId, String quotationId) async {
    try {
      DocumentSnapshot userSnapshot =
          await database.collection('users').doc(userId).get();

      if (userSnapshot.exists && userSnapshot.data() != null) {
        List<String> quotationIds =
            (userSnapshot.data() as Map<String, dynamic>)['quotationIds'] ?? [];

        quotationIds.add(quotationId);

        await database.collection('users').doc(userId).update({
          'quotationIds': quotationIds,
        });
      } else {
        throw Future.error('Usuario no encontrado o sin quotationIds');
      }
    } catch (e) {
      throw Future.error(
          'Error al actualizar el ID de cotización en la colección de usuarios: $e');
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

  static Future<List<Quotation>> getQuotationsByUser(String userId) async {
    try {
      DocumentSnapshot userSnapshot =
          await database.collection('users').doc(userId).get();

      if (userSnapshot.exists && userSnapshot.data() != null) {
        List<dynamic> quotationIds =
            (userSnapshot.data() as Map<String, dynamic>)['quotationIds'] ?? [];

        List<Quotation> quotations = [];
        for (String quotationId in quotationIds) {
          DocumentSnapshot quotationSnapshot =
              await database.collection('quotations').doc(quotationId).get();

          if (quotationSnapshot.exists) {
            Map<String, dynamic> data =
                quotationSnapshot.data() as Map<String, dynamic>;
            data['id'] = quotationSnapshot.id;
            quotations.add(Quotation.fromJson(data));
          }
        }

        return quotations;
      } else {
        throw Future.error('Usuario no encontrado o sin quotationIds');
      }
    } catch (e) {
      throw Future.error('Error al obtener cotizaciones por usuario: $e');
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
