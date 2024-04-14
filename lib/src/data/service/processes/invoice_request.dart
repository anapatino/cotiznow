import 'dart:async';
import 'dart:convert';
import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/domain.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class InvoiceRequest {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final ServicesController servicesController = Get.find();

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

  static Future<List<Map<String, dynamic>>> loadService(
      List<String> idServices) async {
    servicesController.getAllServices();
    List<Map<String, dynamic>> serviceDetailsList = [];
    for (String id in idServices) {
      Service? service = servicesController.servicesList
          ?.firstWhere((service) => service.id == id);
      if (service != null) {
        serviceDetailsList.add({
          'name': service.name,
          'price': service.price,
        });
      }
    }
    return serviceDetailsList;
  }

//modificar como se va a enviar la informacion de service
  static Future<String> generatePDF(
      Quotation quotation, Users user, Management management) async {
    List<Map<String, dynamic>> serviceDetailsList = await loadService(
        quotation.customizedServices.map((service) => service.id).toList());
    var quotationJson = quotation.toJson();
    quotationJson['idService'] = serviceDetailsList;

    var url = Uri.parse('https://pdf-invoicing-app.onrender.com/invoice');
    var methodJson = management.methodOfPayment.toJson();

    try {
      var responseRequest = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'name': '${user.name} ${user.lastName}',
          'address': user.address,
          'phone': user.phone,
          'quotation': quotationJson,
          'methodOfPayment': methodJson
        }),
      );

      if (responseRequest.statusCode == 200) {
        String downloadURL = await uploadPDF(responseRequest.bodyBytes);

        return await downloadAndDeletePDF(downloadURL, quotation.id);
      } else {
        print('Error en la solicitud: ${responseRequest.statusCode}');
        throw Exception('Error en la solicitud: ${responseRequest.statusCode}');
      }
    } catch (e) {
      print('Error en la solicitud: $e');
      throw Exception('Error en la solicitud: $e');
    }
  }

  static Future<String> downloadAndDeletePDF(
      String downloadURL, String id) async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    Completer<String> completer = Completer<String>();

    FileDownloader.downloadFile(
        url: downloadURL,
        name: "factura-$id",
        onProgress: (fileName, progress) {
          print('FILE $fileName HAS PROGRESS $progress');
        },
        onDownloadCompleted: (String path) {
          print('FILE DOWNLOADED TO PATH: $path');
          deletePDF().then((_) {
            completer.complete(path);
          }).catchError((error) {
            completer.completeError(error);
          });
        },
        onDownloadError: (String error) {
          Future.error('DOWNLOAD ERROR: $error');
          completer.completeError(error);
        });

    return completer.future;
  }
}
