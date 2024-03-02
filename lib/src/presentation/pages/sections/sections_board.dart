import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/presentation/pages/sections/sections.dart';
import 'package:cotiznow/src/presentation/widgets/widgets.dart';
import '../../../domain/domain.dart';
import '../../routes/routes.dart';

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
  bool isRegisterFormVisible = false;
  List<Section> filteredSections = [];
  Section section =
      Section(id: "", icon: "", name: "", description: "", status: "");

  @override
  void initState() {
    super.initState();
  }

  void toggleUpdateFormVisibility(Section selectedSection) {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          isUpdateFormVisible = !isUpdateFormVisible;
          section = selectedSection;
          if (!isUpdateFormVisible) {
            activeIndex = -1;
          }
        }));
  }

  void toggleRegisterFormVisibility() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          isRegisterFormVisible = !isRegisterFormVisible;
        }));
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
                  onChanged: (value) {
                    filterSections(value);
                  },
                  controller: controllerSearch,
                ),
                SizedBox(height: screenHeight * 0.01),
                _buildSectionsList(),
              ],
            ),
          ),
          Visibility(
            visible: isUpdateFormVisible,
            child: Positioned(
              top: screenHeight * 0.22,
              child: UpdateSectionForm(
                onCancelForm: () {
                  toggleUpdateFormVisibility(section);
                },
                section: section,
              ),
            ),
          ),
          Visibility(
            visible: isRegisterFormVisible,
            child: Positioned(
              top: screenHeight * 0.22,
              child: RegisterSectionForm(
                onCancelForm: () {
                  toggleRegisterFormVisibility();
                },
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
    );
  }

  void filterSections(String searchText) {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          if (searchText.isEmpty) {
            filteredSections = widget.sectionsController.sectionsList
                    ?.where((section) => section.status == 'activo')
                    .toList() ??
                [];
          } else {
            filteredSections = widget.sectionsController.sectionsList!
                .where((section) =>
                    section.name
                        .toLowerCase()
                        .contains(searchText.toLowerCase()) &&
                    section.status == 'activo')
                .toList();
          }
        }));
  }

  Widget _buildSectionsList() {
    return FutureBuilder<List<Section>>(
      future: widget.sectionsController.getAllSections(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        final sections = snapshot.data!;
        List<Section> filteredSections =
            sections.where((section) => section.status == 'activo').toList();
        if (controllerSearch.text.isNotEmpty) {
          filteredSections = sections
              .where((section) =>
                  section.name
                      .toLowerCase()
                      .contains(controllerSearch.text.toLowerCase()) &&
                  section.status == 'activo')
              .toList();
        }

        return _buildRoundIconButtons(filteredSections);
      },
    );
  }

  Widget _buildRoundIconButtons(List<Section> sections) {
    return Expanded(
      child: SizedBox(
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
    });
    toggleUpdateFormVisibility(sectionNew);
  }

  void showDisableSectionAlert(Section section) {
    DialogUtil.showConfirmationDialog(
      title: 'Deshabilitar Sección',
      message: '¿Desea deshabilitar esta sección?',
      confirmButtonText: 'Aceptar',
      cancelButtonText: 'Cancelar',
      onConfirm: () async {
        String message = await widget.sectionsController
            .updateSectionStatus(section.id, 'inactivo');
        Get.snackbar(
          'Éxito',
          message,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          backgroundColor: Palette.accent,
          icon: const Icon(Icons.check_circle),
        );
      },
      backgroundConfirmButton: Palette.accentBackground,
      backgroundCancelButton: Palette.accent,
      backgroundColor: Palette.accent,
    );
  }
}
