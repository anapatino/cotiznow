import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/domain.dart';

import '../../../domain/controllers/controllers.dart';
import '../../widgets/components/components.dart';

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
    String? role = selectedOption;
    String account = "activa";
    if (name.isNotEmpty &&
        lastName.isNotEmpty &&
        phone.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        address.isNotEmpty) {
      Users user = Users(
        name: name,
        lastName: lastName,
        phone: phone,
        address: address,
        email: email,
        role: role!,
        account: account,
        id: '',
        authId: '',
      );
      userController.register(user, password, false).then((value) async {
        if (userController.userEmail.isNotEmpty) {
          Get.snackbar(
            'Registro de usuario exitoso',
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
          icon: const Icon(Icons.error_rounded),
        );
      });
      _onCancelRegistration();
    } else {
      Get.snackbar(
        'Error al registrar usuario',
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
    List<String> options = userController.role == "administrador"
        ? ['cliente', 'administrador']
        : ['cliente', 'administrador', 'super administrador'];

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
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.04),
              child: Text(
                "Registrar cliente",
                style: GoogleFonts.varelaRound(
                  color: Colors.white,
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.75,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                      type: TextInputType.phone,
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
                      type: TextInputType.streetAddress,
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
                      type: TextInputType.emailAddress,
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
          ],
        ),
      ),
    );
  }
}
