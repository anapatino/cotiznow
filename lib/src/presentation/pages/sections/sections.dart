import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/controllers/section_controller.dart';
import 'package:cotiznow/src/domain/controllers/user_controller.dart';
import 'package:cotiznow/src/presentation/pages/sections/update_section_form.dart';
import '../../../domain/models/section.dart';
import '../../routes/administrator.dart';
import '../../widgets/components/button/icon_button.dart';
import '../../widgets/components/drawer.dart';
import '../../widgets/components/input.dart';

// ignore: must_be_immutable
class Sections extends StatefulWidget {
  final SectionsController sectionsController = Get.find();
  final UserController userController = Get.find();

  Sections({Key? key}) : super(key: key);

  @override
  State<Sections> createState() => _SectionsState();
}

class _SectionsState extends State<Sections> {
  TextEditingController controllerSearch = TextEditingController();
  int activeIndex = -1;
  double screenWidth = 0;
  double screenHeight = 0;
  bool isUpdateFormVisible = false;

  void toggleUpdateFormVisibility() {
    setState(() {
      isUpdateFormVisible = !isUpdateFormVisible;
    });
  }

  @override
  void dispose() {
    controllerSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

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
          body: Stack(children: [
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
                  _buildSectionsList(),
                ],
              ),
            ),
            Positioned(
              top: screenHeight * 0.2,
              child: Opacity(
                opacity: isUpdateFormVisible ? 1 : 0.0,
                child: SingleChildScrollView(
                    child: UpdateSectionForm(
                  icon: '',
                  onCancelUpdate: () {
                    toggleUpdateFormVisibility();
                  },
                  name: '',
                  description: '',
                )),
              ),
            ),
          ]),
          floatingActionButton: FloatingActionButton(
            onPressed: toggleUpdateFormVisibility,
            backgroundColor: Palette.primary,
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            shape: const CircleBorder(),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionsList() {
    return FutureBuilder<List<Section>>(
      future: widget.sectionsController.getAllSections(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.snackbar(
              'Error al cargar las secciones',
              'Ha ocurrido un error',
              colorText: Colors.white,
              duration: const Duration(seconds: 5),
              backgroundColor: Palette.accent,
              icon: const Icon(Icons.error_outline_rounded),
            );
          });
          return const SizedBox();
        } else if (snapshot.hasData) {
          List<Section> sections = snapshot.data!;
          return _buildRoundIconButtons(sections);
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.snackbar(
              'No se pudieron cargar las secciones',
              'Vuelva a intentarlo nuevamente',
              colorText: Colors.white,
              duration: const Duration(seconds: 5),
              backgroundColor: Palette.accent,
              icon: const Icon(Icons.error_outline_rounded),
            );
          });
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildRoundIconButtons(List<Section> sections) {
    return SizedBox(
      width: screenWidth * 0.9,
      height: screenHeight * 0.7,
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 0.01,
          runSpacing: 10.0,
          children: sections.map((section) {
            int index = sections.indexOf(section);
            return RoundIconButton(
              icon: section.icon,
              title: section.name,
              onClick: () {
                handleIconClick(index);
              },
              isActive: activeIndex == index,
            );
          }).toList(),
        ),
      ),
    );
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
