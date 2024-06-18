import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotiznow/src/data/service/service.dart';

import '../../../domain/domain.dart';

class QuotationRequest {
  static final FirebaseFirestore database = FirebaseFirestore.instance;

  static Future<String> quoteRegistration(
      Quotation quotation, String date) async {
    try {
      DocumentReference newQuotation =
          await database.collection('quotations').add({
        'name': quotation.name,
        'address': quotation.address,
        'phone': quotation.phone,
        'materials':
            quotation.materials.map((material) => material.toJson()).toList(),
        'status': quotation.status,
        'total': quotation.total,
        'userId': quotation.userId,
        'customizedServices': quotation.customizedServices
            .map((service) => service.toJson())
            .toList(),
        'date': quotation.date,
      });
      await newQuotation.update({'id': newQuotation.id});
      quotation.id = newQuotation.id;
      QuotationHistory quotationHistory = QuotationHistory(
        id: "",
        quotation: quotation,
        date: date,
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
      Quotation updatedQuotation, String date) async {
    try {
      DocumentSnapshot quotationSnapshot = await database
          .collection('quotations')
          .doc(updatedQuotation.id)
          .get();
      Map<String, dynamic> quotationData =
          quotationSnapshot.data() as Map<String, dynamic>;
      Quotation oldQuotation = Quotation.fromJson(quotationData);
      if (oldQuotation.materials.isNotEmpty) {
        await MaterialsRequest.calculateNewMaterialValue(
            updatedQuotation.materials, oldQuotation.materials);
      } else {
        MaterialsRequest.subtractMaterialsQuantity(
            updatedQuotation.materials, false);
      }
      await deleteQuotationService(updatedQuotation);

      await database
          .collection('quotations')
          .doc(updatedQuotation.id)
          .update(updatedQuotation.toJson());

      QuotationHistory quotationHistory = QuotationHistory(
        id: "",
        quotation: updatedQuotation,
        date: date,
      );

      await QuotationHistoryRequest.addToQuotationsHistory(quotationHistory);

      return "Se ha actualizado la cotización y registrado en el historial";
    } catch (e) {
      throw Future.error(
          'Error al actualizar la cotización en la base de datos: $e');
    }
  }

  static Future<void> deleteQuotationService(Quotation quotation) async {
    try {
      await database.collection('quotations').doc(quotation.id).update({
        'customizedServices': FieldValue.delete(),
      });
    } catch (e) {
      throw Future.error('Error al eliminar el campo customizedServices: $e');
    }
  }

  static String _addLeadingZero(int number) {
    return number.toString().padLeft(2, '0');
  }

  static Future<String> updateQuotationStatus(
      Quotation quotation, String newStatus) async {
    DateTime now = DateTime.now();
    String formattedDate =
        "${now.year}-${_addLeadingZero(now.month)}-${_addLeadingZero(now.day)} ${_addLeadingZero(now.hour)}:${_addLeadingZero(now.minute)}:${_addLeadingZero(now.second)}";
    try {
      await database.collection('quotations').doc(quotation.id).update({
        'status': newStatus,
      });
      quotation.status = newStatus;
      QuotationHistory quotationHistory = QuotationHistory(
        id: "",
        quotation: quotation,
        date: formattedDate,
      );

      if (newStatus == "rechazada") {
        MaterialsRequest.subtractMaterialsQuantity(quotation.materials, true);
      }

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
      if (quotation.status != "rechazada") {
        MaterialsRequest.subtractMaterialsQuantity(quotation.materials, true);
      }
      return "Se ha eliminado la cotización satisfactoriamente";
    } catch (e) {
      throw Future.error('Error al eliminar la cotización de la base de datos');
    }
  }
}
