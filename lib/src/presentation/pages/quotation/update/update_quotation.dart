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
  final parameters = Get.arguments as Quotation;
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();
  TextEditingController controllerLength = TextEditingController();
  TextEditingController controllerWidth = TextEditingController();
  UserController userController = Get.find();
  QuotationController quotationController = Get.find();
  ShoppingCartController shoppingCartController = Get.find();

  List<String> selectOptionsService = [];
  List<Materials> list = [];
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
    if (parameters != null) {
      list = List<Materials>.from(parameters.materials);
      controllerName.text = parameters.name;
      controllerDescription.text = parameters.description;
      controllerLength.text = parameters.length;
      controllerWidth.text = parameters.width;
      totalQuotation = parameters.total;
      shoppingCartController.cartItems =
          RxList<Materials>(parameters.materials);

      shoppingCartController.updateSelectedServices(parameters.idService);
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
          id: parameters.id,
          name: name,
          description: description,
          idService: shoppingCartController.extractSelectedServiceIds(),
          length: length,
          materials: shoppingCartController.cartItems,
          status: parameters.status,
          total: totalQuotation,
          width: width,
          userId: parameters.userId);
      if ((userController.role == "cliente" &&
              parameters.status != "aprobado") ||
          (userController.role != "cliente")) {
        confirmationUpdateQuotation(newQuotation);
      } else {
        Get.snackbar(
          'Mensaje informativo',
          "No puedes actualizar la cotización en estado aprobada",
          colorText: Colors.white,
          backgroundColor: Palette.warning,
          icon: const Icon(Icons.error),
        );
      }
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
          onSelected: (total) {
            setState(() {
              totalQuotation = total;
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
                      status: parameters.status,
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

  @override
  void dispose() {
    shoppingCartController.clearCart();
    super.dispose();
  }
}
