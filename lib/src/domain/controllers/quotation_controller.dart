import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/data/data.dart';
import 'package:cotiznow/src/domain/domain.dart';

class QuotesController extends GetxController {
  final Rxn<List<Quotation>> _quotationsList = Rxn<List<Quotation>>();

  List<Quotation>? get quotationsList => _quotationsList.value;

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

  Future<void> getAllQuotations() async {
    try {
      List<Quotation> list = await QuotationRequest.getAllQuotations();
      _quotationsList.value = list;
    } catch (e) {
      throw Future.error(
          'Error al obtener todas las cotizaciones desde la base de datos');
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
