import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/domain.dart';

class QuotationHistoryRequest {
  static final FirebaseFirestore database = FirebaseFirestore.instance;

  static Future<String> addToQuotationsHistory(
      QuotationHistory quotationHistory) async {
    try {
      DocumentReference docRef = await database
          .collection('quotations_history')
          .add({
        'quotation': quotationHistory.quotation.toJson(),
        'date': quotationHistory.date
      });

      await docRef.update({'id': docRef.id});

      return "Se ha añadido la cotización al historial";
    } catch (e) {
      throw Future.error(
          'Error al añadir la cotización al historial en la base de datos: $e');
    }
  }

  static Future<List<QuotationHistory>> getAllQuotationsHistory() async {
    try {
      QuerySnapshot querySnapshot =
          await database.collection('quotations_history').get();

      List<QuotationHistory> quotationsHistory = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return QuotationHistory.fromJson(data);
      }).toList();

      return quotationsHistory;
    } catch (e) {
      throw Future.error(
          'Error al obtener todas las cotizaciones del historial de la base de datos');
    }
  }

  static Future<String> deleteQuotationHistory(
      String quotationHistoryId) async {
    try {
      await database
          .collection('quotations_history')
          .doc(quotationHistoryId)
          .delete();
      return "Se ha eliminado la cotización del historial satisfactoriamente";
    } catch (e) {
      throw Future.error(
          'Error al eliminar la cotización del historial de la base de datos: $e');
    }
  }
}
