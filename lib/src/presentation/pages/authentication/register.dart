import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/presentation/pages/dashboard/customer.dart';

import '../../../domain/controllers/user_controller.dart';
import '../../widgets/components/button.dart';
import '../../widgets/components/input.dart';

class Register extends StatelessWidget {
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerLastName = TextEditingController();
  final TextEditingController controllerPhone = TextEditingController();
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  final TextEditingController controllerAddress = TextEditingController();
  UserController userController = Get.find();

  Register({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    Future<void> registerUser() async {
      String name = controllerName.text;
      String lastName = controllerLastName.text;
      String phone = controllerPhone.text;
      String email = controllerEmail.text;
      String password = controllerPassword.text;
      String address = controllerAddress.text;

      if (name.isNotEmpty &&
          lastName.isNotEmpty &&
          phone.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          address.isNotEmpty) {
        userController
            .register(name, lastName, email, password, phone, address)
            .then((value) async {
          if (userController.userEmail.isNotEmpty) {
            //await publicityController.viewPublicity();
            Get.offAll(() => Customer());
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
        controllerName.clear();
        controllerLastName.clear();
        controllerPhone.clear();
        controllerEmail.clear();
        controllerPassword.clear();
        controllerAddress.clear();
      } else {
        Get.snackbar(
          'Error al registrar',
          'Ingrese los campos requeridos para poder ingresar',
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          backgroundColor: Palette.accent,
          icon: const Icon(Icons.error_outline_rounded),
        );
      }
    }

    return SlideInRight(
      duration: const Duration(milliseconds: 10),
      child: Scaffold(
        backgroundColor: Palette.secondary,
        body: SingleChildScrollView(
          child: SizedBox(
              height: screenHeight * 1,
              width: screenWidth * 1,
              child: Stack(
                children: [
                  Positioned(
                    top: -180,
                    left: -80,
                    child: Container(
                      height: screenHeight * 0.4,
                      width: screenWidth * 0.9,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/full_triangle.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -140,
                    left: -80,
                    child: Container(
                      height: screenHeight * 0.4,
                      width: screenWidth * 0.9,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/triangle_lines.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.2,
                    right: -120,
                    child: Container(
                      height: screenHeight * 0.4,
                      width: screenWidth * 0.9,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/triangle_lines.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -70,
                    left: -120,
                    child: Container(
                      height: screenHeight * 0.4,
                      width: screenWidth * 0.9,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/triangle_lines.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -160,
                    left: -140,
                    child: Container(
                      height: screenHeight * 0.4,
                      width: screenWidth * 0.9,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/full_triangle.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      top: screenHeight * 0.065,
                      left: screenWidth * 0.14,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Registrar",
                              style: GoogleFonts.varelaRound(
                                color: Colors.white,
                                fontSize: screenWidth * 0.085,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                              )),
                          SizedBox(
                            height: screenHeight * 0.004,
                          ),
                          SizedBox(
                            width: screenWidth * 0.75,
                            child: Text(
                                "Por favor, ingresa los campos para continuar.",
                                style: GoogleFonts.varelaRound(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.037,
                                  fontWeight: FontWeight.normal,
                                  letterSpacing: 1,
                                )),
                          ),
                          SizedBox(
                            height: screenHeight * 0.02,
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
                            icon: Icons.add_location_sharp,
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
                          SizedBox(
                            height: screenHeight * 0.012,
                          ),
                          CustomElevatedButton(
                            text: 'Registrar',
                            onPressed: registerUser,
                            height: screenHeight * 0.065,
                            width: screenWidth * 0.75,
                            textColor: Palette.secondary,
                            textSize: screenWidth * 0.045,
                            backgroundColor: Palette.primary,
                            hasBorder: false,
                          ),
                        ],
                      ))
                ],
              )),
        ),
      ),
    );
  }
}
