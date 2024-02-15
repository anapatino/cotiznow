import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/controllers/section_controller.dart';
import 'package:cotiznow/src/domain/controllers/user_controller.dart';
import 'package:cotiznow/src/presentation/pages/sections/register_section_form.dart';
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
  TextEditingController? controllerSearch;
  int activeIndex = -1;
  double screenWidth = 0;
  double screenHeight = 0;
  bool isUpdateFormVisible = false;
  bool isRegisterFormVisible = false;
  List<Section> filteredSections = [];
  Section section =
      Section(id: "", icon: "", name: "", description: "", status: "");

  @override
  void initState() {
    super.initState();
    controllerSearch = TextEditingController();
    _fetchSectionsList();
  }

  @override
  void dispose() {
    controllerSearch?.dispose();
    super.dispose();
  }

  void toggleUpdateFormVisibility(Section selectedSection) {
    setState(() {
      isUpdateFormVisible = !isUpdateFormVisible;
      section = selectedSection;
    });
  }

  void toggleRegisterFormVisibility() {
    setState(() {
      isRegisterFormVisible = !isRegisterFormVisible;
    });
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
              child: SingleChildScrollView(
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
                      onChanged: (value) {
                        filterSections(value);
                      },
                      controller: controllerSearch!,
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    _buildSectionsList(),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: isUpdateFormVisible,
              child: Positioned(
                top: screenHeight * 0.35,
                child: Opacity(
                  opacity: isUpdateFormVisible ? 1 : 0.0,
                  child: UpdateSectionForm(
                    onCancelForm: () {
                      toggleUpdateFormVisibility(section);
                    },
                    section: section,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isRegisterFormVisible,
              child: Positioned(
                top: screenHeight * 0.35,
                child: Opacity(
                  opacity: isRegisterFormVisible ? 1 : 0.0,
                  child: RegisterSectionForm(
                    onCancelForm: () {
                      toggleRegisterFormVisibility();
                    },
                  ),
                ),
              ),
            ),
          ]),
          floatingActionButton: isRegisterFormVisible || isUpdateFormVisible
              ? const SizedBox()
              : FloatingActionButton(
                  onPressed: toggleRegisterFormVisibility,
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

  void filterSections(String searchText) {
    setState(() {
      if (searchText.isEmpty) {
        filteredSections = widget.sectionsController.sectionsList
                ?.where((section) => section.status == 'enable')
                .toList() ??
            [];
      } else {
        filteredSections = widget.sectionsController.sectionsList!
            .where((section) =>
                section.name.toLowerCase().contains(searchText.toLowerCase()) &&
                section.status == 'enable')
            .toList();
      }
    });
  }

  void _fetchSectionsList() async {
    await widget.sectionsController.getAllSections();
    setState(() {
      filteredSections = widget.sectionsController.sectionsList
              ?.where((section) => section.status == "enable")
              .toList() ??
          [];
    });
  }

  Widget _buildSectionsList() {
    return _buildRoundIconButtons(filteredSections);
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
                handleIconClick(index, section);
              },
              onLongPress: () {
                showDisableSectionAlert(section);
              },
              isActive: activeIndex == index,
            );
          }).toList(),
        ),
      ),
    );
  }

  void handleIconClick(int index, Section sectionNew) {
    setState(() {
      if (activeIndex == index) {
        activeIndex = -1;
      } else {
        activeIndex = index;
      }
      toggleUpdateFormVisibility(sectionNew);
    });
  }

  void showDisableSectionAlert(Section section) {
    Get.defaultDialog(
      title: 'Deshabilitar Sección',
      content: Column(
        children: [
          Text(
            '¿Desea deshabilitar esta sección?',
            style: GoogleFonts.varelaRound(
              color: Colors.black,
              fontSize: screenWidth * 0.035,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  Get.back();
                  widget.sectionsController
                      .updateSectionStatus(section.id, 'disable');
                  Get.snackbar(
                    'Éxito',
                    'Sección deshabilitada correctamente',
                    colorText: Colors.white,
                    duration: const Duration(seconds: 5),
                    backgroundColor: Palette.accent,
                    icon: const Icon(Icons.error_outline_rounded),
                  );
                },
                child: Text(
                  'Aceptar',
                  style: GoogleFonts.varelaRound(
                    color: Colors.black,
                    fontSize: screenWidth * 0.03,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  'Cancelar',
                  style: GoogleFonts.varelaRound(
                    color: Colors.black,
                    fontSize: screenWidth * 0.03,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
