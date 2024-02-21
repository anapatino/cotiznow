import 'package:cotiznow/lib.dart';

import '../../../domain/controllers/user_controller.dart';
import '../../widgets/components/button/custom_button.dart';
import '../../widgets/components/dropdown.dart';
import '../../widgets/components/input.dart';

// ignore: must_be_immutable
class AdministratorRegistration extends StatefulWidget {
  final Function onCancelRegistration;
  const AdministratorRegistration({
    super.key,
    required this.onCancelRegistration,
  });

  @override
  State<AdministratorRegistration> createState() =>
      _AdministratorRegistrationState();
}

class _AdministratorRegistrationState extends State<AdministratorRegistration> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerLastName = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerAddress = TextEditingController();
  UserController userController = Get.find();

  String? selectedOption;

  @override
  void initState() {
    super.initState();
  }

  Future<void> registerUser() async {
    String name = controllerName.text;
    String lastName = controllerLastName.text;
    String phone = controllerPhone.text;
    String email = controllerEmail.text;
    String password = controllerPassword.text;
    String address = controllerAddress.text;
    String role = selectedOption == "Cliente"
        ? "customer"
        : selectedOption == "Administrador"
            ? "administrator"
            : "super_administrator";
    String account = "enable";
    if (name.isNotEmpty &&
        lastName.isNotEmpty &&
        phone.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        address.isNotEmpty) {
      userController
          .register(
              name, lastName, email, password, phone, address, role, account)
          .then((value) async {
        if (userController.userEmail.isNotEmpty) {
          Get.snackbar(
            'Registro de cliente exitoso',
            'Se ha registrado correctamente en el sistema',
            colorText: Colors.white,
            duration: const Duration(seconds: 5),
            backgroundColor: Palette.accent,
            icon: const Icon(Icons.supervised_user_circle_sharp),
          );
        }
      }).catchError((error) {
        Get.snackbar(
          'Validacion de usuario',
          '$error',
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          backgroundColor: Palette.error,
          icon: const Icon(Icons.error_outline_rounded),
        );
      });
      _onCancelRegistration();
    } else {
      Get.snackbar(
        'Error al registrar',
        'Ingrese los campos requeridos para poder registrar',
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
        backgroundColor: Palette.accent,
        icon: const Icon(Icons.error_outline_rounded),
      );
    }
  }

  void _resetForm() {
    controllerName.clear();
    controllerLastName.clear();
    controllerPhone.clear();
    controllerEmail.clear();
    controllerPassword.clear();
    controllerAddress.clear();
  }

  void _onCancelRegistration() {
    widget.onCancelRegistration();
    _resetForm();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    List<String> options = userController.role == "administrator"
        ? ['Cliente', 'Administrador']
        : ['Cliente', 'Administrador', 'Super Administrador'];

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: screenHeight * 0.04,
              ),
              Text(
                "Registrar cliente",
                style: GoogleFonts.varelaRound(
                  color: Colors.white,
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.04,
              ),
              CustomTextField(
                icon: Icons.person,
                hintText: 'Nombre',
                isPassword: false,
                width: screenWidth * 0.75,
                height: screenHeight * 0.075,
                inputColor: Colors.white,
                textColor: Colors.black,
                onChanged: (value) {},
                controller: controllerName,
              ),
              CustomTextField(
                icon: Icons.person,
                hintText: 'Apellido',
                isPassword: false,
                width: screenWidth * 0.75,
                height: screenHeight * 0.075,
                inputColor: Colors.white,
                textColor: Colors.black,
                onChanged: (value) {},
                controller: controllerLastName,
              ),
              CustomTextField(
                icon: Icons.phone,
                hintText: 'Telefono',
                isPassword: false,
                width: screenWidth * 0.75,
                height: screenHeight * 0.075,
                inputColor: Colors.white,
                textColor: Colors.black,
                onChanged: (value) {},
                controller: controllerPhone,
              ),
              CustomTextField(
                icon: Icons.location_on_rounded,
                hintText: 'Dirección',
                isPassword: false,
                width: screenWidth * 0.75,
                height: screenHeight * 0.075,
                inputColor: Colors.white,
                textColor: Colors.black,
                onChanged: (value) {},
                controller: controllerAddress,
              ),
              CustomTextField(
                icon: Icons.mail_rounded,
                hintText: 'Correo electronico',
                isPassword: false,
                width: screenWidth * 0.75,
                height: screenHeight * 0.075,
                inputColor: Colors.white,
                textColor: Colors.black,
                onChanged: (value) {},
                controller: controllerEmail,
              ),
              CustomTextField(
                icon: Icons.key_outlined,
                hintText: 'Contraseña',
                isPassword: true,
                width: screenWidth * 0.75,
                height: screenHeight * 0.075,
                inputColor: Colors.white,
                textColor: Colors.black,
                onChanged: (value) {},
                controller: controllerPassword,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Eliga un rol",
                    style: GoogleFonts.varelaRound(
                      color: Colors.white,
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  CustomDropdown(
                    options: options,
                    width: 0.75,
                    height: 0.075,
                    widthItems: 0.55,
                    border: 10,
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
                    horizontal: screenWidth * 0.1,
                    vertical: screenHeight * 0.04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomElevatedButton(
                      text: 'Cancelar',
                      onPressed: _onCancelRegistration,
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
                      onPressed: registerUser,
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
      ),
    );
  }
}
