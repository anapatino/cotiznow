import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/presentation/pages/dashboard/administrator.dart';

import '../../../domain/controllers/user_controller.dart';
import '../../widgets/components/button/button.dart';
import '../../widgets/components/input.dart';
import '../dashboard/customer.dart';

class Login extends StatelessWidget {
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();

  Login({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    UserController userController = Get.find();

    Future<void> authenticateUser() async {
      String email = controllerEmail.text;
      String password = controllerPassword.text;

      if (email.isNotEmpty && password.isNotEmpty) {
        userController.login(email, password).then((value) async {
          if (userController.userEmail.isNotEmpty) {
            //await publicityController.viewPublicity();
            if (userController.role == "customer" &&
                userController.account == "enable") {
              Get.offAll(() => Customer());
            }
            if (userController.role == "administrator" &&
                userController.account == "enable") {
              Get.offAll(() => Administrator());
            }
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

        controllerEmail.clear();
        controllerPassword.clear();
      } else {
        Get.snackbar(
          'Error al ingresar',
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
                      top: screenHeight * 0.1,
                      left: screenWidth * 0.14,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Ingresar",
                              style: GoogleFonts.varelaRound(
                                color: Colors.white,
                                fontSize: screenWidth * 0.1,
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
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.normal,
                                  letterSpacing: 1,
                                )),
                          ),
                          SizedBox(
                            height: screenHeight * 0.02,
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
                          SizedBox(
                            height: screenHeight * 0.015,
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
                            height: screenHeight * 0.07,
                          ),
                          CustomElevatedButton(
                            text: 'Ingresar',
                            onPressed: authenticateUser,
                            height: screenHeight * 0.065,
                            width: screenWidth * 0.75,
                            textColor: Palette.secondary,
                            textSize: screenWidth * 0.045,
                            backgroundColor: Palette.primary,
                            hasBorder: false,
                          ),
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          CustomElevatedButton(
                            text: '¿No tienes cuenta? Registrate.',
                            onPressed: () {
                              Get.offAllNamed('/register');
                            },
                            height: screenHeight * 0.065,
                            width: screenWidth * 0.75,
                            textColor: Palette.primary,
                            textSize: screenWidth * 0.035,
                            backgroundColor:
                                Palette.secondary.withOpacity(0.55),
                            hasBorder: false,
                          )
                        ],
                      ))
                ],
              )),
        ),
      ),
    );
  }
}
