import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotiznow/src/data/service/service.dart';

import '../../../domain/domain.dart';

class QuotationRequest {
  static final FirebaseFirestore database = FirebaseFirestore.instance;

  static Future<String> quoteRegistration(Quotation quotation) async {
    DateTime now = DateTime.now();
    try {
      DocumentReference newQuotation =
          await database.collection('quotations').add({
        'name': quotation.name,
        'description': quotation.description,
        'id_service': quotation.idService,
        'length': quotation.length,
        'materials':
            quotation.materials.map((material) => material.toJson()).toList(),
        'status': quotation.status,
        'total': quotation.total,
        'width': quotation.width,
        'userId': quotation.userId,
      });
      await newQuotation.update({'id': newQuotation.id});
      quotation.id = newQuotation.id;
      QuotationHistory quotationHistory = QuotationHistory(
        id: "",
        quotation: quotation,
        date: now.toString(),
      );

      await QuotationHistoryRequest.addToQuotationsHistory(quotationHistory);

      MaterialsRequest.subtractMaterialsQuantity(quotation.materials, false);

      return "Se ha realizado exitosamente el registro de una cotización";
    } catch (e) {
      throw Future.error(
          'Error al registrar la cotización en la base de datos: $e');
    }
  }

  static Future<String> updateQuotation(
      Quotation updatedQuotation, List<Materials> oldMaterials) async {
    DateTime now = DateTime.now();

    try {
      await database
          .collection('quotations')
          .doc(updatedQuotation.id)
          .update(updatedQuotation.toJson());

      QuotationHistory quotationHistory = QuotationHistory(
        id: "",
        quotation: updatedQuotation,
        date: now.toString(),
      );

      await QuotationHistoryRequest.addToQuotationsHistory(quotationHistory);
      await MaterialsRequest.calculateNewMaterialValue(
          updatedQuotation.materials, oldMaterials);

      return "Se ha actualizado la cotización y registrado en el historial";
    } catch (e) {
      throw Future.error(
          'Error al actualizar la cotización en la base de datos: $e');
    }
  }

  static Future<String> updateQuotationStatus(
      Quotation quotation, String newStatus) async {
    DateTime now = DateTime.now();

    try {
      await database.collection('quotations').doc(quotation.id).update({
        'status': newStatus,
      });
      quotation.status = newStatus;
      QuotationHistory quotationHistory = QuotationHistory(
        id: "",
        quotation: quotation,
        date: now.toString(),
      );

      await QuotationHistoryRequest.addToQuotationsHistory(quotationHistory);
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

      List<Quotation> quotations = querySnapshot.docs
          .map((doc) => Quotation.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return quotations;
    } catch (e) {
      throw Future.error(
          'Error al obtener todas las cotizaciones de la base de datos');
    }
  }

  static Future<List<Quotation>> getQuotationsByUserId(String userId) async {
    try {
      QuerySnapshot querySnapshot = await database
          .collection('quotations')
          .where('userId', isEqualTo: userId)
          .get();

      List<Quotation> quotations = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Quotation.fromJson(data);
      }).toList();

      return quotations;
    } catch (e) {
      throw Future.error('Error al obtener las cotizaciones por userId: $e');
    }
  }

  static Future<String> deleteQuotation(Quotation quotation) async {
    try {
      await database.collection('quotations').doc(quotation.id).delete();
      MaterialsRequest.subtractMaterialsQuantity(quotation.materials, true);
      return "Se ha eliminado la cotización satisfactoriamente";
    } catch (e) {
      throw Future.error('Error al eliminar la cotización de la base de datos');
    }
  }
}
