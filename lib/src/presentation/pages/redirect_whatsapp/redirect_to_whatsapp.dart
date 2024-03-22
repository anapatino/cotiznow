import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/controllers/controllers.dart';
import 'package:cotiznow/src/presentation/routes/routes.dart';
import 'package:cotiznow/src/presentation/widgets/widgets.dart';

class RedirectToWhatsapp extends StatefulWidget {
  const RedirectToWhatsapp({super.key});

  @override
  State<RedirectToWhatsapp> createState() => _RedirectToWhatsappState();
}

class _RedirectToWhatsappState extends State<RedirectToWhatsapp> {
  ManagementController managementController = Get.find();
  UserController userController = Get.find();

  @override
  void initState() {
    super.initState();
    _launchUrl();
  }

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse(
        'https://wa.me/${managementController.phone}?text=${managementController.messageWhatsApp}');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SlideInRight(
      duration: const Duration(milliseconds: 15),
      child: Scaffold(
        appBar: AppBar(
          actions: const [],
        ),
        drawer: CustomDrawer(
          name: userController.name,
          email: userController.userEmail,
          itemConfigs: CustomerRoutes().itemConfigs,
        ),
        body: Center(
            child: InkWell(
          borderRadius: BorderRadius.circular(screenWidth * 0.54),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: _launchUrl,
          child: Container(
            height: screenHeight * 0.12,
            width: screenWidth * 0.65,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/logo_whatsapp.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        )),
      ),
    );
  }
}
