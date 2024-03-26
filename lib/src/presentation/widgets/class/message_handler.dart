import 'package:cotiznow/lib.dart';

class MessageHandler {
  static void showSnackbar(String title, dynamic message, String type) {
    Get.snackbar(
      title,
      message.toString(),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      backgroundColor: type == "error"
          ? Palette.error
          : type == "success"
              ? Palette.accent
              : Palette.warning,
      icon: type == "error"
          ? const Icon(Icons.error)
          : const Icon(Icons.check_circle),
    );
  }

  static void showSectionLoadingError(dynamic error) {
    showSnackbar('Error al cargar las secciones', error, "warning");
  }

  static void showUnitsLoadingError(dynamic error) {
    showSnackbar('Error al cargar las unidades', error, "warning");
  }

  static void showMessageError(String title, dynamic error) {
    showSnackbar(title, error, "error");
  }

  static void showMessageSuccess(String title, dynamic message) {
    showSnackbar(title, message, "success");
  }

  static void showMessageWarning(String title, dynamic message) {
    showSnackbar(title, message, "warning");
  }
}
