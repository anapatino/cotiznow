import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/domain.dart';
import 'package:cotiznow/src/presentation/widgets/class/class.dart';

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
      MessageHandler.showMessageSuccess('Visita actualizada correctamente',
          "Se ha actualizado en la base de datos con exito");

      // ignore: use_build_context_synchronously
      Get.toNamed('/request-visit');
    } catch (error) {
      MessageHandler.showMessageError('Error al actualizar visita', error);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    UserController userController = Get.find();

    return Scaffold(
      appBar: AppBar(actions: const []),
      drawer: CustomDrawer(
        name: userController.name,
        email: userController.userEmail,
        itemConfigs: userController.role == "usuario"
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
                    fontSize:
                        isTablet ? screenWidth * 0.045 : screenWidth * 0.06,
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
                            fontSize: isTablet
                                ? screenWidth * 0.04
                                : screenWidth * 0.05,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ),
                      customText(
                        'Codigo:',
                        programmeVisit.id,
                        screenWidth,
                        isTablet ? 0.035 : 0.04,
                        fontWeight: FontWeight.normal,
                      ),
                      customText(
                        'Fecha de registro:',
                        programmeVisit.date,
                        screenWidth,
                        isTablet ? 0.035 : 0.04,
                      ),
                      customText(
                        'Fecha de la visita:',
                        programmeVisit.visitingDate,
                        screenWidth,
                        isTablet ? 0.035 : 0.04,
                      ),
                      customText(
                        'Motivo:',
                        programmeVisit.motive,
                        screenWidth,
                        isTablet ? 0.037 : 0.042,
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
                            fontSize: isTablet
                                ? screenWidth * 0.04
                                : screenWidth * 0.05,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ),
                      customText(
                        'Nombre:',
                        '${programmeVisit.user.name} ${programmeVisit.user.lastName}',
                        screenWidth,
                        isTablet ? 0.035 : 0.042,
                      ),
                      customText(
                        'Correo:',
                        programmeVisit.user.email,
                        screenWidth,
                        isTablet ? 0.035 : 0.042,
                      ),
                      customText(
                        'Dirección:',
                        programmeVisit.user.address,
                        screenWidth,
                        isTablet ? 0.035 : 0.042,
                      ),
                      customText(
                        'Telefono:',
                        programmeVisit.user.phone,
                        screenWidth,
                        isTablet ? 0.035 : 0.042,
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      if (userController.role != "usuario")
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
                                  fontSize: isTablet
                                      ? screenWidth * 0.032
                                      : screenWidth * 0.04,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 1,
                                ),
                              ),
                              CustomDropdown(
                                options: options,
                                width: 0.75,
                                widthItems: isTablet ? 0.6 : 0.55,
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
                      if (userController.role != "usuario")
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
                            textSize: isTablet
                                ? screenWidth * 0.035
                                : screenWidth * 0.04,
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
