import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/domain.dart';
import 'package:cotiznow/src/presentation/widgets/class/class.dart';
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
  TextEditingController controllerDate = TextEditingController();
  double screenWidth = 0;
  double screenHeight = 0;
  bool isTablet = false;

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
    String visitingDate = controllerDate.text;
    if (motive.isNotEmpty && visitingDate.isNotEmpty) {
      ProgrammeVisits programmeVisit = ProgrammeVisits(
          id: "",
          user: widget.userController.user!,
          motive: motive,
          date: formattedDate,
          status: 'pendiente',
          visitingDate: visitingDate);
      widget.programmeVisitsController
          .registerVisit(programmeVisit)
          .then((value) async {
        MessageHandler.showMessageSuccess('Registro de visita exitosa', value);
      }).catchError((error) {
        MessageHandler.showMessageError('Error al registrar visita', error);
      });
      _onCancelForm();
    } else {
      MessageHandler.showMessageWarning('Validación de campos',
          'Ingrese los campos requeridos para poder registrar');
    }
  }

  String _addLeadingZero(int number) {
    return number.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) {
        _onCancelForm();
      },
      child: BounceInUp(
        duration: const Duration(microseconds: 10),
        child: Container(
          width: screenWidth * 1,
          height: screenHeight * 1,
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
                padding: EdgeInsets.only(
                    top: screenHeight * 0.04, bottom: screenHeight * 0.02),
                child: Text(
                  "Registrar Visita",
                  style: GoogleFonts.varelaRound(
                    color: Colors.white,
                    fontSize:
                        isTablet ? screenWidth * 0.04 : screenWidth * 0.05,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.125,
                    vertical: screenHeight * 0.02),
                child: GestureDetector(
                  onTap: () {
                    showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(DateTime.now().year - 100),
                            lastDate: DateTime(DateTime.now().year + 1))
                        .then((value) {
                      if (value != null) {
                        controllerDate.text =
                            '${value.day.toString()}/${value.month.toString()}/${value.year.toString()}';
                      }
                    });
                  },
                  child: TextField(
                    controller: controllerDate,
                    decoration: InputDecoration(
                        labelText: 'Fecha de visita ',
                        prefixIcon: const Icon(Icons.calendar_today),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(8.0),
                        )),
                    style: const TextStyle(color: Colors.black),
                    enabled: false,
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
                    horizontal:
                        isTablet ? screenWidth * 0.13 : screenWidth * 0.07,
                    vertical: screenHeight * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomElevatedButton(
                      text: 'Cancelar',
                      onPressed: _onCancelForm,
                      height: screenHeight * 0.065,
                      width: isTablet ? screenWidth * 0.3 : screenWidth * 0.35,
                      textColor: Colors.white,
                      textSize:
                          isTablet ? screenWidth * 0.03 : screenWidth * 0.04,
                      borderColor: Palette.accent,
                      backgroundColor: Palette.accent,
                      hasBorder: true,
                    ),
                    CustomElevatedButton(
                      text: 'Registrar',
                      onPressed: registerVisit,
                      height: screenHeight * 0.065,
                      width: isTablet ? screenWidth * 0.3 : screenWidth * 0.35,
                      textColor: Colors.white,
                      textSize:
                          isTablet ? screenWidth * 0.03 : screenWidth * 0.04,
                      backgroundColor: Palette.primary,
                      hasBorder: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
