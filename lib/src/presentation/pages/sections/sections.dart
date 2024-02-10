import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/controllers/section_controller.dart';
import 'package:cotiznow/src/domain/controllers/user_controller.dart';
import '../../../domain/models/section.dart';
import '../../routes/administrator.dart';
import '../../widgets/components/button/icon_button.dart';
import '../../widgets/components/drawer.dart';
import '../../widgets/components/input.dart';

// ignore: must_be_immutable
class Sections extends StatefulWidget {
  SectionsController sectionsController = Get.find();
  UserController userController = Get.find();

  Sections({super.key});

  @override
  State<Sections> createState() => _SectionsState();
}

class _SectionsState extends State<Sections> {
  TextEditingController controllerSearch = TextEditingController();
  int activeIndex = -1;

  @override
  void initState() {
    super.initState();
    widget.sectionsController.getAllSections();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    List<Section>? sections = widget.sectionsController.sectionsList;

    return SlideInLeft(
      duration: const Duration(milliseconds: 15),
      child: SafeArea(
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
                    "Secciones",
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
                    onChanged: (value) {},
                    controller: controllerSearch,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  sections != null
                      ? SizedBox(
                          width: screenWidth * 0.9,
                          height: screenHeight * 0.7,
                          child: SingleChildScrollView(
                            child: Wrap(
                              spacing: 0.01,
                              runSpacing: 10.0,
                              children: _buildRoundIconButtons(sections),
                            ),
                          ),
                        )
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                ],
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Palette.primary,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          shape: const CircleBorder(),
        ),
      )),
    );
  }

  List<Widget> _buildRoundIconButtons(List<Section> sections) {
    return sections.map((section) {
      int index = sections.indexOf(section);
      return RoundIconButton(
        icon: section.icon,
        title: section.name,
        onClick: () {
          print('${section.name} clicado');
          handleIconClick(index);
        },
        isActive: activeIndex == index,
      );
    }).toList();
  }

  void handleIconClick(int index) {
    setState(() {
      if (activeIndex == index) {
        activeIndex = -1;
      } else {
        activeIndex = index;
      }
    });
  }
}
