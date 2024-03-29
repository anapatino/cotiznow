import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class InvoiceRequest {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<String> uploadPDF(Uint8List pdfBytes) async {
    Reference ref = _storage.ref().child('invoice.pdf');
    await ref.putData(pdfBytes);
    return ref.getDownloadURL();
  }

  static Future<void> deletePDF() async {
    Reference ref = _storage.ref().child('invoice.pdf');
    try {
      await ref.delete();
    } catch (e) {
      throw Future.error('Error al eliminar el PDF: $e');
    }
  }
}
