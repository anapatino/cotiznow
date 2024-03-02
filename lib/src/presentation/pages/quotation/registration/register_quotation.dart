import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/domain.dart';
import 'package:cotiznow/src/presentation/pages/quotation/registration/registration.dart';
import 'package:cotiznow/src/presentation/widgets/widgets.dart';

class RegisterQuotation extends StatefulWidget {
  const RegisterQuotation({super.key});

  @override
  State<RegisterQuotation> createState() => _RegisterQuotationState();
}

class _RegisterQuotationState extends State<RegisterQuotation> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();
  TextEditingController controllerLength = TextEditingController();
  TextEditingController controllerWidth = TextEditingController();
  UserController userController = Get.find();
  QuotationController quotationController = Get.find();
  List<Materials> selectedMaterials = [];

  String? selectOptionService;
  String totalQuotation = "";
  int _activeCurrentStep = 0;

  void clearControllers() {
    controllerName.clear();
    controllerDescription.clear();
    controllerLength.clear();
    controllerWidth.clear();
  }

  void handleContinue() {
    setState(() {
      _activeCurrentStep += 1;
    });
  }

  void handleBack() {
    setState(() {
      _activeCurrentStep -= 1;
    });
  }

  void sendQuotation() {
    String name = controllerName.text;
    String description = controllerDescription.text;
    String length = controllerLength.text;
    String width = controllerWidth.text;
    if (name.isNotEmpty &&
        description.isNotEmpty &&
        length.isNotEmpty &&
        width.isNotEmpty &&
        totalQuotation.isNotEmpty &&
        selectOptionService != "") {
      Quotation quotation = Quotation(
          id: '',
          name: name,
          description: description,
          idService: selectOptionService!,
          length: length,
          materials: selectedMaterials,
          status: 'pendiente',
          total: totalQuotation,
          width: width,
          userId: userController.idUser);
      confirmationRegistrationQuotation(quotation);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    List<Step> steps = [
      Step(
        state: StepState.indexed,
        isActive: _activeCurrentStep >= 0,
        title: Text('',
            style: GoogleFonts.varelaRound(
              color: Colors.black,
              fontSize: screenWidth * 0.036,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.2,
            )),
        content: GeneralInformation(
          controllerName: controllerName,
          controllerDescription: controllerDescription,
          onNext: handleContinue,
        ),
      ),
      Step(
        state: StepState.indexed,
        isActive: _activeCurrentStep >= 1,
        title: Text('',
            style: GoogleFonts.varelaRound(
              color: Colors.black,
              fontSize: screenWidth * 0.036,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.2,
            )),
        content: InformationServices(
          onBack: handleBack,
          controllerLength: controllerLength,
          controllerWidth: controllerWidth,
          onSelected: (section, total, materials) {
            setState(() {
              selectedMaterials = materials;
              totalQuotation = total;
              selectOptionService = section;

              sendQuotation();
            });
          },
        ),
      ),
    ];

    return SlideInRight(
      duration: const Duration(milliseconds: 15),
      child: Scaffold(
        appBar: AppBar(
          actions: const [],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.055),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                    child: Text(
                      "Registrar cotización",
                      style: GoogleFonts.varelaRound(
                        color: Colors.black,
                        fontSize: screenWidth * 0.064,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                  CardQuotation(
                    showDescription: true,
                    onLongPress: () {},
                    backgroundColor: Palette.accent,
                    title: controllerName.text,
                    description: controllerDescription.text,
                    status: "pendiente",
                    total: totalQuotation,
                    onTap: () {
                      /*Get.toNamed('/details-quotation', arguments: {
                        'name': quotation.name,
                        'description': quotation.description,
                        'id_section': quotation.idSection,
                        'id_service': quotation.idService,
                        'length': quotation.length,
                        'materials': quotation.materials
                            .map((material) => material.toJson())
                            .toList(),
                        'status': quotation.status,
                        'total': quotation.total,
                        'width': quotation.width,
                      });*/
                    },
                  ),
                  SizedBox(
                    width: screenWidth * 1,
                    height: screenHeight * 0.65,
                    child: Stepper(
                      controlsBuilder: (context, controller) {
                        return const SizedBox.shrink();
                      },
                      physics: const ScrollPhysics(),
                      type: StepperType.horizontal,
                      currentStep: _activeCurrentStep,
                      steps: steps,
                      onStepTapped: (int index) {
                        setState(() => _activeCurrentStep = index);
                      },
                    ),
                  )
                ]),
          ),
        ),
      ),
    );
  }

  Future<void> confirmationRegistrationQuotation(Quotation quotation) async {
    DialogUtil.showConfirmationDialog(
      title: 'Registro de cotización',
      message: '¿Desea registrar esta cotización?',
      confirmButtonText: 'Aceptar',
      cancelButtonText: 'Cancelar',
      onConfirm: () async {
        try {
          String message =
              await quotationController.registerQuotation(quotation);
          Get.snackbar(
            'Éxito',
            message,
            colorText: Colors.white,
            duration: const Duration(seconds: 5),
            backgroundColor: Palette.accent,
            icon: const Icon(Icons.check_circle),
          );
          Navigator.pop(context);
        } catch (error) {
          print("Error al registrar la cotización: $error");
          Get.snackbar(
            'Error',
            'Hubo un problema al registrar la cotización.',
            colorText: Colors.white,
            backgroundColor: Colors.red,
            icon: const Icon(Icons.error),
          );
        }
      },
      backgroundConfirmButton: Palette.accentBackground,
      backgroundCancelButton: Palette.accent,
      backgroundColor: Palette.accent,
    );
  }

  @override
  void dispose() {
    clearControllers();
    if (mounted) {
      controllerName.dispose();
      controllerDescription.dispose();
      controllerLength.dispose();
      controllerWidth.dispose();
    }

    super.dispose();
  }
}
