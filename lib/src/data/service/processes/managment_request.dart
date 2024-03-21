import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotiznow/src/domain/models/models.dart';

class ManagementRequest {
  static final FirebaseFirestore database = FirebaseFirestore.instance;

  static Future<Management> getManagement() async {
    try {
      final contactData = await _getDocumentData('contact');
      final methodOfPaymentData = await _getDocumentData('methodOfPayment');

      Contact contact = Contact.fromFirestore(contactData);
      MethodOfPayment methodOfPayment =
          MethodOfPayment.fromFirestore(methodOfPaymentData);

      return Management(contact: contact, methodOfPayment: methodOfPayment);
    } catch (e) {
      throw Future.error('Error al obtener la gestión desde la base de datos');
    }
  }

  static Future<Map<String, dynamic>> _getDocumentData(
      String documentName) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await database.collection('management').doc(documentName).get();
      return documentSnapshot.data() ?? {};
    } catch (e) {
      throw Future.error(
          'Error al obtener el documento $documentName desde la base de datos');
    }
  }
}
