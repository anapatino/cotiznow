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
  TextEditingController controllerAddress = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();

  List<CustomizedService> customizedServices = [];
  UserController userController = Get.find();
  QuotationController quotationController = Get.find();
  ShoppingCartController shoppingCartController = Get.find();
  String totalQuotation = "";
  int _activeCurrentStep = 0;

  @override
  void initState() {
    super.initState();
    controllerAddress.text = userController.address;
    controllerPhone.text = userController.phone;
    controllerName.text = userController.name;
  }

  void clearControllers() {
    controllerName.clear();
    controllerAddress.clear();
    controllerPhone.clear();
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
        DateTime now = DateTime.now();
    String formattedDate =
        "${now.year}-${_addLeadingZero(now.month)}-${_addLeadingZero(now.day)} ${_addLeadingZero(now.hour)}:${_addLeadingZero(now.minute)}:${_addLeadingZero(now.second)}";
    String name = controllerName.text;
    String address = controllerAddress.text;
    String phone = controllerPhone.text;

    if (name.isNotEmpty &&
        address.isNotEmpty &&
        phone.isNotEmpty &&
        totalQuotation.isNotEmpty && formattedDate.isNotEmpty) {
      Quotation quotation = Quotation(
          id: '',
          name: name,
          address: address,
          phone: phone,
          materials: shoppingCartController.cartItems,
          status: 'pendiente',
          total: totalQuotation,
          userId: userController.idUser,
          customizedServices: shoppingCartController.selectCustomizedService, date: formattedDate);
      if (int.parse(totalQuotation) <= 0) {
        MessageHandler.showMessageWarning('Validación de campos',
            "No se puede registrar una cotización sin haber elegido un servicio/material");
      } else {
        confirmationRegistrationQuotation(quotation);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    List<Step> steps = [
      Step(
        state: StepState.indexed,
        isActive: _activeCurrentStep >= 0,
        title: Text('Datos generales',
            style: GoogleFonts.varelaRound(
              color: Colors.black,
              fontSize: isTablet ? screenWidth * 0.028 : screenWidth * 0.036,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.2,
            )),
        content: GeneralInformation(
          controllerName: controllerName,
          controllerAddress: controllerAddress,
          controllerPhone: controllerPhone,
          onNext: handleContinue,
        ),
      ),
      Step(
        state: StepState.indexed,
        isActive: _activeCurrentStep >= 1,
        title: Text('Servicios',
            style: GoogleFonts.varelaRound(
              color: Colors.black,
              fontSize: isTablet ? screenWidth * 0.028 : screenWidth * 0.036,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.2,
            )),
        content: InformationServices(
          onBack: handleBack,
          onSelected: (total) {
            setState(() {
              totalQuotation = total;
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
                    padding: EdgeInsets.only(
                      bottom: screenHeight * 0.02,
                    ),
                    child: Text(
                      "Registrar cotización",
                      style: GoogleFonts.varelaRound(
                        color: Colors.black,
                        fontSize:
                            isTablet ? screenWidth * 0.04 : screenWidth * 0.064,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                  CardQuotation(
                    showMoreInfo: true,
                    onLongPress: () {},
                    backgroundColor: Palette.accent,
                    name: controllerName.text,
                    address: controllerAddress.text,
                    phone: controllerPhone.text,
                    status: "pendiente",
                    total: totalQuotation,
                    onTap: () {},
                    icon: () {},
                    onDoubleTap: () {},
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
                      elevation: 0,
                    ),
                  )
                ]),
          ),
        ),
      ),
    );
  }

  String _addLeadingZero(int number) {
    return number.toString().padLeft(2, '0');
  }

  Future<void> confirmationRegistrationQuotation(Quotation quotation) async {
    DateTime now = DateTime.now();
    String formattedDate =
        "${now.year}-${_addLeadingZero(now.month)}-${_addLeadingZero(now.day)} ${_addLeadingZero(now.hour)}:${_addLeadingZero(now.minute)}:${_addLeadingZero(now.second)}";
    DialogUtil.showConfirmationDialog(
      title: 'Registro de cotización',
      message: '¿Desea registrar esta cotización?',
      confirmButtonText: 'Aceptar',
      cancelButtonText: 'Cancelar',
      onConfirm: () async {
        try {
          String message = await quotationController.registerQuotation(
              quotation, formattedDate);
          MessageHandler.showMessageSuccess(
              'Registro realizado con exito', message);

          // ignore: use_build_context_synchronously
          Get.offAllNamed("/quotations");
        } catch (error) {
          MessageHandler.showMessageError(
              'Error al registrar cotización', error);
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
