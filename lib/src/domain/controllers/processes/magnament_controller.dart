import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/data/data.dart';
import 'package:cotiznow/src/domain/models/models.dart';

class ManagementController extends GetxController {
  final Rx<Management?> _management = Rx<Management?>(null);
  final Rx<String> _phone = "".obs;
  final Rx<String> _messageWhatsApp = "".obs;

  String get phone => _phone.value;
  String get messageWhatsApp => _messageWhatsApp.value;
  Management? get management => _management.value;

  static Future<Management> fetchManagement() async {
    try {
      return await ManagementRequest.getManagement();
    } catch (e) {
      throw Future.error(
          'Error al obtener la información desde la base de datos');
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchManagement().then((value) {
      _management.value = value;
      _phone.value = value.contact.phone;
      _messageWhatsApp.value = value.contact.messageWhatsApp;
    }).catchError((error) {
      print(error);
    });
  }
}
