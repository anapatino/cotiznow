import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/domain.dart';
import 'package:cotiznow/src/presentation/widgets/class/class.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/components/components.dart';
import '../dashboard/dashboard.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  UserController userController = Get.find();

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      String? name = prefs.getString('name');
      String? lastName = prefs.getString('lastName');
      String? phone = prefs.getString('phone');
      String? address = prefs.getString('address');
      String? email = prefs.getString('email');
      String? role = prefs.getString('role');
      String? account = prefs.getString('account');
      String? id = prefs.getString('id');
      String? authId = prefs.getString('authId');

      if (name!.isNotEmpty &&
          lastName!.isNotEmpty &&
          phone!.isNotEmpty &&
          address!.isNotEmpty &&
          email!.isNotEmpty &&
          role!.isNotEmpty &&
          account!.isNotEmpty &&
          id!.isNotEmpty &&
          authId!.isNotEmpty) {
        Users user = Users(
            name: name,
            lastName: lastName,
            phone: phone,
            address: address,
            email: email,
            role: role,
            account: account,
            id: id,
            authId: authId);
        userController.updateController(user);
      }

      if (userController.role == "cliente" &&
          userController.account == "activa") {
        Get.offAll(() => CustomerDashboard());
      }
      if (userController.role == "administrador" ||
          userController.role == "super administrador" &&
              userController.account == "activa") {
        Get.offAll(() => AdministratorDashboard());
      }
    }
  }

  void registerDataCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('name', userController.name.toString());
    await prefs.setString('lastName', userController.lastName.toString());
    await prefs.setString('phone', userController.phone.toString());
    await prefs.setString('address', userController.address.toString());
    await prefs.setString('email', userController.userEmail.toString());
    await prefs.setString('role', userController.role.toString());
    await prefs.setString('account', userController.account.toString());
    await prefs.setString('id', userController.idUser.toString());
    await prefs.setString('authId', userController.authId.toString());
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    Future<void> authenticateUser() async {
      String email = controllerEmail.text;
      String password = controllerPassword.text;

      if (email.isNotEmpty && password.isNotEmpty) {
        userController.login(email, password).then((value) async {
          if (userController.userEmail.isNotEmpty) {
            registerDataCache();

            if (userController.role == "cliente" &&
                userController.account == "activa") {
              Get.offAll(() => CustomerDashboard());
            }
            if (userController.role == "administrador" ||
                userController.role == "super administrador" &&
                    userController.account == "activa") {
              Get.offAll(() => AdministratorDashboard());
            }
          }
        }).catchError((error) {
          MessageHandler.showMessageError('Validacion de usuario', error);
        });

        controllerEmail.clear();
        controllerPassword.clear();
      } else {
        MessageHandler.showMessageWarning('Mensaje informativo',
            'Ingrese los campos requeridos para poder ingresar');
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
                      top: screenHeight * 0.18,
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
                            type: TextInputType.emailAddress,
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
