import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/domain.dart';

import '../../../routes/routes.dart';
import '../../../widgets/components/components.dart';

class VisitDetails extends StatefulWidget {
  const VisitDetails({
    super.key,
  });

  @override
  State<VisitDetails> createState() => _VisitDetailsState();
}

class _VisitDetailsState extends State<VisitDetails> {
  final programmeVisit = Get.arguments as ProgrammeVisits;
  ProgrammeVisitsController programmeVisitsController = Get.find();

  String? selectedOption;
  List<String> options = ['pendiente', 'aceptada', 'rechazada'];

  Future<void> registerStatus() async {
    try {
      await programmeVisitsController.updateVisitStatus(
          programmeVisit.id, selectedOption!);

      Get.snackbar(
        'Visita actualizada correctamente',
        "Se ha actualizado en la base de datos con exito",
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
        backgroundColor: Palette.accent,
        icon: const Icon(Icons.check_circle),
      );
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (error) {
      Get.snackbar(
        'Error al actualizar visita',
        error.toString(),
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
        backgroundColor: Palette.error,
        icon: const Icon(Icons.error_rounded),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    UserController userController = Get.find();

    return Scaffold(
      appBar: AppBar(actions: const []),
      drawer: CustomDrawer(
        name: userController.name,
        email: userController.userEmail,
        itemConfigs: userController.role == "cliente"
            ? CustomerRoutes().itemConfigs
            : AdministratorRoutes().itemConfigs,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.056),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Detalles visita",
                  style: GoogleFonts.varelaRound(
                    color: Colors.black,
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.015),
              Container(
                width: screenWidth * 1,
                decoration: const BoxDecoration(
                  color: Palette.accent,
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.066,
                    vertical: screenHeight * 0.015,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: screenHeight * 0.019,
                          bottom: screenHeight * 0.003,
                        ),
                        child: Text(
                          'Información de la visita',
                          style: GoogleFonts.varelaRound(
                            color: Colors.white,
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ),
                      customText(
                        'Codigo:',
                        programmeVisit.id,
                        screenWidth,
                        0.04,
                        fontWeight: FontWeight.normal,
                      ),
                      customText(
                        'Fecha de registro:',
                        programmeVisit.date,
                        screenWidth,
                        0.04,
                      ),
                      customText(
                        'Motivo:',
                        programmeVisit.motive,
                        screenWidth,
                        0.042,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: screenHeight * 0.019,
                          bottom: screenHeight * 0.003,
                        ),
                        child: Text(
                          'Información del solicitante',
                          style: GoogleFonts.varelaRound(
                            color: Colors.white,
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ),
                      customText(
                        'Nombre:',
                        '${programmeVisit.user.name} ${programmeVisit.user.lastName}',
                        screenWidth,
                        0.042,
                      ),
                      customText(
                        'Correo:',
                        programmeVisit.user.email,
                        screenWidth,
                        0.042,
                      ),
                      customText(
                        'Dirección:',
                        programmeVisit.user.address,
                        screenWidth,
                        0.042,
                      ),
                      customText(
                        'Telefono:',
                        programmeVisit.user.phone,
                        screenWidth,
                        0.042,
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      if (userController.role != "cliente")
                        Padding(
                          padding: EdgeInsets.only(
                              top: screenHeight * 0.04,
                              bottom: screenHeight * 0.015),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Cambiar estado",
                                style: GoogleFonts.varelaRound(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 1,
                                ),
                              ),
                              CustomDropdown(
                                options: options,
                                width: 0.75,
                                widthItems: 0.55,
                                height: 0.073,
                                border: 10,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedOption = newValue;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      if (userController.role != "cliente")
                        Padding(
                          padding: EdgeInsets.only(
                              top: screenHeight * 0.02,
                              bottom: screenHeight * 0.03),
                          child: CustomElevatedButton(
                            text: 'Guardar',
                            onPressed: registerStatus,
                            height: screenHeight * 0.065,
                            width: screenWidth * 0.75,
                            textColor: Colors.white,
                            textSize: screenWidth * 0.04,
                            backgroundColor: Palette.primary,
                            hasBorder: false,
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customText(
    String label,
    String value,
    double screenWidth,
    double fontSize, {
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return Text.rich(
      TextSpan(
        text: '$label ',
        style: GoogleFonts.varelaRound(
          color: Colors.white,
          fontSize: screenWidth * fontSize,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.1,
        ),
        children: [
          TextSpan(
            text: value,
            style: GoogleFonts.varelaRound(
              color: Colors.white,
              fontSize: screenWidth * fontSize,
              fontWeight: fontWeight,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}
