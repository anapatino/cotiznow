import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/domain.dart';
import '../../../widgets/components/components.dart';

// ignore: must_be_immutable
class RegisterProgrammeVisits extends StatefulWidget {
  final Function onCancelForm;

  UserController userController = Get.find();
  ProgrammeVisitsController programmeVisitsController = Get.find();
  RegisterProgrammeVisits({super.key, required this.onCancelForm});

  @override
  State<RegisterProgrammeVisits> createState() =>
      _RegisterProgrammeVisitsState();
}

class _RegisterProgrammeVisitsState extends State<RegisterProgrammeVisits> {
  TextEditingController controllerMotive = TextEditingController();
  double screenWidth = 0;
  double screenHeight = 0;

  void _resetForm() {
    controllerMotive.clear();
  }

  void _onCancelForm() {
    widget.onCancelForm();
    _resetForm();
  }

  Future<void> registerVisit() async {
    DateTime now = DateTime.now();
    String formattedDate =
        "${now.year}-${_addLeadingZero(now.month)}-${_addLeadingZero(now.day)} ${_addLeadingZero(now.hour)}:${_addLeadingZero(now.minute)}:${_addLeadingZero(now.second)}";
    String motive = controllerMotive.text;
    if (motive.isNotEmpty) {
      ProgrammeVisits programmeVisit = ProgrammeVisits(
          id: "",
          user: widget.userController.user!,
          motive: motive,
          date: formattedDate,
          status: 'pendiente');
      widget.programmeVisitsController
          .registerVisit(programmeVisit)
          .then((value) async {
        Get.snackbar(
          'Registro de visita exitosa',
          value,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          backgroundColor: Palette.accent,
          icon: const Icon(Icons.check_circle),
        );
      }).catchError((error) {
        Get.snackbar(
          'Error al registrar visita',
          '$error',
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          backgroundColor: Palette.error,
          icon: const Icon(Icons.error),
        );
      });
      _onCancelForm();
    } else {
      Get.snackbar(
        'Error al registrar visita',
        'Ingrese los campos requeridos para poder registrar',
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
        backgroundColor: Palette.accent,
        icon: const Icon(Icons.error),
      );
    }
  }

  String _addLeadingZero(int number) {
    return number.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return BounceInUp(
      duration: const Duration(microseconds: 10),
      child: Container(
        width: screenWidth * 1,
        height: screenHeight * 0.5,
        decoration: const BoxDecoration(
          color: Palette.accent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.04),
              child: Text(
                "Registrar Visita",
                style: GoogleFonts.varelaRound(
                  color: Colors.white,
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ),
            CustomTextField(
              icon: Icons.dehaze_rounded,
              hintText: 'Motivo de la visita',
              isPassword: false,
              width: screenWidth * 0.75,
              height: screenHeight * 0.2,
              maxLine: 8,
              inputColor: Colors.white,
              textColor: Colors.black,
              onChanged: (value) {},
              controller: controllerMotive,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.07,
                  vertical: screenHeight * 0.01),
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
                    text: 'Registrar',
                    onPressed: registerVisit,
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
          ],
        ),
      ),
    );
  }
}
