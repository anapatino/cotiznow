import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/data/data.dart';

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
}
