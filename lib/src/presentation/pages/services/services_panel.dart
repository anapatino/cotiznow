import 'package:cotiznow/lib.dart';

import '../../../domain/controllers/controllers.dart';
import '../../routes/administrator.dart';
import '../../widgets/components/components.dart';

class ServicesPanel extends StatefulWidget {
  final UserController userController = Get.find();

  ServicesPanel({super.key});

  @override
  State<ServicesPanel> createState() => _ServicesPanelState();
}

class _ServicesPanelState extends State<ServicesPanel> {
  late final TextEditingController? controllerSearch;

  double screenWidth = 0;
  double screenHeight = 0;

  @override
  void initState() {
    super.initState();
    controllerSearch = TextEditingController();
  }

  @override
  void dispose() {
    controllerSearch?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return SlideInLeft(
      duration: const Duration(milliseconds: 15),
      child: Scaffold(
        appBar: AppBar(
          actions: const [],
        ),
        drawer: CustomDrawer(
          name: widget.userController.name,
          email: widget.userController.userEmail,
          itemConfigs: AdministratorRoutes().itemConfigs,
          context: context,
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.055),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Servicios",
                    style: GoogleFonts.varelaRound(
                      color: Colors.black,
                      fontSize: screenWidth * 0.06,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  CustomTextField(
                    icon: Icons.search_rounded,
                    hintText: 'Buscar',
                    isPassword: false,
                    width: screenWidth * 0.9,
                    height: screenHeight * 0.06,
                    inputColor: Palette.grey,
                    textColor: Colors.black,
                    border: 30,
                    onChanged: (value) {
                      // filterSections(value);
                    },
                    controller: controllerSearch!,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
