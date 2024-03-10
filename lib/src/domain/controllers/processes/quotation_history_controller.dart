import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/data/data.dart';
import 'package:cotiznow/src/domain/domain.dart';

class QuotationHistoryController extends GetxController {
  final Rxn<List<QuotationHistory>> _quotationsList =
      Rxn<List<QuotationHistory>>();

  List<QuotationHistory>? get quotationsList => _quotationsList.value;

  Future<void> addToQuotationsHistory(QuotationHistory quotationHistory) async {
    try {
      await QuotationHistoryRequest.addToQuotationsHistory(quotationHistory);
    } catch (e) {
      throw Future.error('Error al añadir cotización al historial: $e');
    }
  }

  Future<List<QuotationHistory>> getAllQuotationsHistory() async {
    try {
      List<QuotationHistory> list =
          await QuotationHistoryRequest.getAllQuotationsHistory();
      _quotationsList.value = list;
      return list;
    } catch (e) {
      throw Future.error('Error al cargar el historial de cotizaciones: $e');
    }
  }

  Future<void> deleteQuotationHistory(String quotationHistoryId) async {
    try {
      await QuotationHistoryRequest.deleteQuotationHistory(quotationHistoryId);
    } catch (e) {
      throw Future.error('Error al eliminar cotización del historial: $e');
    }
  }
}
