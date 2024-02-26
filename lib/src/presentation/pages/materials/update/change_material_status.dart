import 'package:cotiznow/lib.dart';

import '../../../../domain/domain.dart';
import '../../../widgets/components/components.dart';

class ChangeMaterialStatus extends StatefulWidget {
  final Function onCancelForm;
  final Materials material;
  const ChangeMaterialStatus(
      {super.key, required this.onCancelForm, required this.material});

  @override
  State<ChangeMaterialStatus> createState() => _ChangeMaterialStatusState();
}

class _ChangeMaterialStatusState extends State<ChangeMaterialStatus> {
  String? selectedOption;
  MaterialsController materialController = Get.find();

  void _resetForm() {
    selectedOption = "";
  }

  void _onCancelForm() {
    widget.onCancelForm();
    _resetForm();
  }

  Future<void> changeMaterialStatus() async {
    String status = selectedOption! == "Habilitar" ? "enable" : "disable";

    if (status.isNotEmpty) {
      materialController
          .updateMaterialStatus(widget.material.id, status)
          .then((value) async {
        Get.snackbar(
          'Actualizacion de material exitoso',
          value,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          backgroundColor: Palette.accent,
          icon: const Icon(Icons.check_circle),
        );
        _onCancelForm();
      }).catchError((error) {
        Get.snackbar(
          'Error al actualizar estado material',
          '$error',
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          backgroundColor: Palette.error,
          icon: const Icon(Icons.error),
        );
      });
    } else {
      Get.snackbar(
        'Error al actualizar estado material',
        'Ingrese los campos requeridos para poder registrar',
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
        backgroundColor: Palette.accent,
        icon: const Icon(Icons.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    List<String> options = ['Habilitar', 'Desahabilitar'];
    return BounceInUp(
      duration: const Duration(microseconds: 10),
      child: Container(
        width: screenWidth * 1,
        height: screenHeight * 0.9,
        decoration: const BoxDecoration(
          color: Palette.accent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.04),
                child: Text(
                  "Actualizar material",
                  style: GoogleFonts.varelaRound(
                    color: Colors.white,
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("  Cambiar estado",
                      style: GoogleFonts.varelaRound(
                        color: Colors.white,
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1,
                      )),
                  CustomDropdown(
                    padding: 0,
                    border: 10,
                    options: options,
                    width: 0.79,
                    height: 0.075,
                    widthItems: 0.58,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedOption = newValue;
                      });
                    },
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.095,
                    vertical: screenHeight * 0.028),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomElevatedButton(
                      text: 'Cancelar',
                      onPressed: _onCancelForm,
                      height: screenHeight * 0.065,
                      width: screenWidth * 0.35,
                      textColor: Colors.white,
                      textSize: screenWidth * 0.04,
                      borderColor: Palette.accent,
                      backgroundColor: Palette.accent,
                      hasBorder: true,
                    ),
                    CustomElevatedButton(
                      text: 'Actualizar',
                      onPressed: changeMaterialStatus,
                      height: screenHeight * 0.065,
                      width: screenWidth * 0.35,
                      textColor: Colors.white,
                      textSize: screenWidth * 0.04,
                      backgroundColor: Palette.primary,
                      hasBorder: false,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
