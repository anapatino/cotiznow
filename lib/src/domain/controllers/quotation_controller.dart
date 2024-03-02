import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/data/data.dart';
import 'package:cotiznow/src/domain/domain.dart';

class QuotationController extends GetxController {
  final Rxn<List<Quotation>> _quotationsList = Rxn<List<Quotation>>();
  final Rxn<List<Quotation>> _quotationsListByUser = Rxn<List<Quotation>>();

  List<Quotation>? get quotationsList => _quotationsList.value;
  List<Quotation>? get quotationsListByUser => _quotationsListByUser.value;

  Future<String> registerQuotation(Quotation quotation) async {
    try {
      return await QuotationRequest.quoteRegistration(quotation);
    } catch (e) {
      throw Future.error('Error al registrar cotización en la base de datos');
    }
  }

  Future<String> updateQuotationStatus(
      String quotationId, String newStatus) async {
    try {
      return await QuotationRequest.updateQuotationStatus(
          quotationId, newStatus);
    } catch (e) {
      throw Future.error('Error al actualizar el estado de la cotización');
    }
  }

  Future<List<Quotation>> getAllQuotations() async {
    try {
      List<Quotation> list = await QuotationRequest.getAllQuotations();
      _quotationsList.value = list;
      return list;
    } catch (e) {
      throw Future.error(
          'Error al obtener todas las cotizaciones desde la base de datos');
    }
  }

  Future<List<Quotation>> getQuotationsByUserId(String userId) async {
    try {
      List<Quotation> list =
          await QuotationRequest.getQuotationsByUserId(userId);
      _quotationsListByUser.value = list;
      return list;
    } catch (e) {
      throw Future.error(
          'Error al obtener todas las cotizaciones de un usuario desde la base de datos');
    }
  }

  Future<String> deleteQuotation(String quotationId) async {
    try {
      return await QuotationRequest.deleteQuotation(quotationId);
    } catch (e) {
      throw Future.error('Error al eliminar la cotización');
    }
  }
}
