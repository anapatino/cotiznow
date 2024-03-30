import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/data/data.dart';
import 'package:cotiznow/src/domain/domain.dart';

class InvoiceController extends GetxController {
  Future<String> uploadPDF(Uint8List pdfBytes) async {
    try {
      return await InvoiceRequest.uploadPDF(pdfBytes);
    } catch (e) {
      throw Future.error('Error al subir el PDF: $e');
    }
  }

  Future<void> deletePDF() async {
    try {
      await InvoiceRequest.deletePDF();
    } catch (e) {
      throw Future.error('Error al eliminar el PDF: $e');
    }
  }

  Future<String> generatePDF(
      Quotation quotation, Users user, Management management) async {
    try {
      await InvoiceRequest.generatePDF(quotation, user, management);
      return Future.value('PDF generated successfully');
    } catch (e) {
      throw Future.error('Error al generar el PDF: $e');
    }
  }
}
