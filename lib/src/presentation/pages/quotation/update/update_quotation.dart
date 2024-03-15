import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/domain.dart';
import 'package:cotiznow/src/presentation/pages/quotation/registration/registration.dart';
import 'package:cotiznow/src/presentation/widgets/widgets.dart';

class UpdateQuotation extends StatefulWidget {
  const UpdateQuotation({super.key});

  @override
  State<UpdateQuotation> createState() => _UpdateQuotationState();
}

class _UpdateQuotationState extends State<UpdateQuotation> {
  final quotation = Get.arguments as Quotation;
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();
  TextEditingController controllerLength = TextEditingController();
  TextEditingController controllerWidth = TextEditingController();
  UserController userController = Get.find();
  QuotationController quotationController = Get.find();
  List<Materials> selectedMaterials = [];

  List<String> selectOptionsService = [];
  String totalQuotation = "";
  int _activeCurrentStep = 0;

  @override
  void initState() {
    super.initState();
    loadControllers();
  }

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

  void loadControllers() {
    if (quotation != null) {
      controllerName.text = quotation.name;
      controllerDescription.text = quotation.description;
      controllerLength.text = quotation.length;
      controllerWidth.text = quotation.width;
      totalQuotation = quotation.total;
    }
  }

  void updateQuotation() {
    String name = controllerName.text;
    String description = controllerDescription.text;
    String length = controllerLength.text;
    String width = controllerWidth.text;
    if (name.isNotEmpty &&
        description.isNotEmpty &&
        length.isNotEmpty &&
        width.isNotEmpty &&
        totalQuotation.isNotEmpty) {
      Quotation newQuotation = Quotation(
          id: quotation.id,
          name: name,
          description: description,
          idService: selectOptionsService,
          length: length,
          materials: selectedMaterials,
          status: quotation.status,
          total: totalQuotation,
          width: width,
          userId: quotation.userId);

      confirmationUpdateQuotation(newQuotation);
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
        title: Text('Datos generales',
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
        title: Text('Servicios',
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
              selectOptionsService = section;
            });
            updateQuotation();
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
                      "Actualizar cotización",
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
                      status: quotation.status,
                      total: totalQuotation,
                      onTap: () {},
                      icon: () {},
                      onDoubleTap: () {}),
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
                      elevation: 0,
                    ),
                  )
                ]),
          ),
        ),
      ),
    );
  }

  Future<void> confirmationUpdateQuotation(Quotation quotation) async {
    DialogUtil.showConfirmationDialog(
      title: 'Actualizar  cotización',
      message: '¿Desea actualizar esta cotización?',
      confirmButtonText: 'Aceptar',
      cancelButtonText: 'Cancelar',
      onConfirm: () async {
        try {
          String message = await quotationController.updateQuotation(quotation);
          Get.snackbar(
            'Éxito',
            message,
            colorText: Colors.white,
            duration: const Duration(seconds: 5),
            backgroundColor: Palette.accent,
            icon: const Icon(Icons.check_circle),
          );
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        } catch (error) {
          print("Error al actualizar la cotización: $error");
          Get.snackbar(
            'Error',
            error.toString(),
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
}
