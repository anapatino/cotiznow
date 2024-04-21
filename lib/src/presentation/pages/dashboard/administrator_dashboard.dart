import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/presentation/widgets/widgets.dart';

import '../../../domain/domain.dart';
import '../../routes/routes.dart';

class AdministratorDashboard extends StatefulWidget {
  final MaterialsController materialController = Get.find();
  final SectionsController sectionsController = Get.find();
  final UserController userController = Get.find();
  AdministratorDashboard({super.key});

  @override
  State<AdministratorDashboard> createState() => _AdministratorDashboardState();
}

class _AdministratorDashboardState extends State<AdministratorDashboard> {
  TextEditingController controllerSearch = TextEditingController();

  UserController userController = Get.find();
  double screenWidth = 0;
  double screenHeight = 0;
  List<Section> listSections = [];
  List<Materials> filteredMaterials = [];
  String sectionId = "";
  int activeIndex = -1;

  @override
  void initState() {
    super.initState();
    loadSectionsAndHandleIconClick();
  }

  Future<void> loadSectionsAndHandleIconClick() async {
    try {
      listSections = await widget.sectionsController.getAllSections();
      setState(() {
        List<Section> filteredSections = listSections
            .where((section) => section.status == 'activo')
            .toList();
        if (filteredSections.isNotEmpty) {
          handleIconClick(0, filteredSections[0]);
        }
      });
    } catch (error) {
      MessageHandler.showMessageWarning("Error al carga las secciones", error);
    }
  }

  void filterMaterials(String searchText) {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          if (searchText.isEmpty) {
            filteredMaterials = (widget.materialController.materialsList ?? [])
                .where((material) =>
                    material.status == 'activo' &&
                    material.sectionId == sectionId)
                .toList();
          } else {
            filteredMaterials = (widget.materialController.materialsList ?? [])
                .where((material) =>
                    material.name
                        .toLowerCase()
                        .contains(searchText.toLowerCase()) &&
                    material.sectionId == sectionId &&
                    material.status == 'activo')
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
          return Center(
            child: Text(snapshot.error.toString(),
                style: GoogleFonts.varelaRound(
                  color: Colors.black,
                  fontSize: screenWidth * 0.04,
                )),
          );
        }
        final sections = snapshot.data!;
        List<Section> filteredSections =
            sections.where((section) => section.status == 'activo').toList();
        return _buildRoundIconButtons(filteredSections);
      },
    );
  }

  Widget _buildRoundIconButtons(List<Section> sections) {
    return SizedBox(
      width: screenWidth * 0.86,
      height: screenHeight * 0.17,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: sections.length,
        itemBuilder: (context, index) {
          Section section = sections[index];

          return RoundIconButton(
            icon: section.icon,
            title: section.name,
            onClick: () {
              setState(() {
                handleIconClick(index, section);
              });
            },
            onLongPress: () {},
            isActive: activeIndex == index,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    final MaterialWidgets materialWidgets = MaterialWidgets(
      screenHeight: screenHeight,
      screenWidth: screenWidth,
    );

    return PopScope(
      canPop: false,
      child: SlideInRight(
        duration: const Duration(milliseconds: 15),
        child: Scaffold(
          appBar: AppBar(
            actions: const [],
          ),
          drawer: CustomDrawer(
            name: userController.name,
            email: userController.userEmail,
            itemConfigs: AdministratorRoutes().itemConfigs,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.055),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomTextField(
                        icon: Icons.search_rounded,
                        hintText: 'Buscar',
                        isPassword: false,
                        width: screenWidth * 0.85,
                        height: screenHeight * 0.06,
                        inputColor: Palette.grey,
                        textColor: Colors.black,
                        border: 30,
                        onChanged: (value) {
                          filterMaterials(value);
                        },
                        controller: controllerSearch,
                      ),
                    ],
                  ),
                  _buildSectionsList(),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  materialWidgets.buildMaterialsBySectionIdSearch(
                      sectionId,
                      controllerSearch.text.isNotEmpty
                          ? controllerSearch.text
                          : ""),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: screenHeight * 0.025),
                    child: Text(
                      'Descuentos',
                      style: GoogleFonts.varelaRound(
                        color: Colors.black,
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                  materialWidgets.buildMaterialsWithDiscount(false),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void handleIconClick(int index, Section section) {
    setState(() {
      if (activeIndex == index) {
        activeIndex = -1;
      } else {
        activeIndex = index;
      }
      sectionId = section.id;
    });
  }
}
