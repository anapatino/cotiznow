import 'package:cotiznow/lib.dart';

import '../../../domain/domain.dart';
import '../../routes/routes.dart';
import '../../widgets/components/components.dart';

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
          return Center(child: Text(snapshot.error.toString()));
        }
        final sections = snapshot.data!;
        List<Section> filteredSections =
            sections.where((section) => section.status == 'activo').toList();
        return _buildRoundIconButtons(filteredSections);
      },
    );
  }

  Widget _buildMaterialsBySectionId(String sectionId) {
    return FutureBuilder<List<Materials>>(
      future: widget.materialController.getMaterialsBySectionId(sectionId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
              width: screenWidth * 0.86,
              height: screenHeight * 0.15,
              child: SizedBox(
                  width: screenWidth * 0.86,
                  height: screenHeight * 0.3,
                  child: const Center(child: CircularProgressIndicator())));
        }
        if (snapshot.hasError) {
          return SizedBox(
              width: screenWidth * 0.86,
              height: screenHeight * 0.15,
              child: Center(child: Text(snapshot.error.toString())));
        }
        final materials = snapshot.data!;
        filteredMaterials =
            materials.where((material) => material.status == 'activo').toList();
        if (controllerSearch.text.isNotEmpty) {
          filteredMaterials = filteredMaterials
              .where((material) =>
                  material.name
                      .toLowerCase()
                      .contains(controllerSearch.text.toLowerCase()) &&
                  material.sectionId == sectionId &&
                  material.status == 'activo')
              .toList();
        }
        return _buildCardMaterial(filteredMaterials);
      },
    );
  }

  Widget _buildCardMaterial(List<Materials> materials) {
    return SizedBox(
      width: screenWidth * 0.86,
      height: screenHeight * 0.32,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: materials.length,
        itemBuilder: (context, index) {
          Materials material = materials[index];

          return CardMaterialCustom(
              material: material,
              onClick: () {
                Get.toNamed(
                  '/details-material',
                  arguments: material,
                );
              },
              onLongPress: () {},
              onDoubleTap: () {});
        },
      ),
    );
  }

  Widget _buildMaterialsWithDiscount() {
    return FutureBuilder<List<Materials>>(
      future: widget.materialController.getAllMaterials(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
              width: screenWidth * 0.86,
              height: screenHeight * 0.2,
              child: const Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return SizedBox(
              width: screenWidth * 0.86,
              height: screenHeight * 0.2,
              child: Center(child: Text(snapshot.error.toString())));
        }
        final materials = snapshot.data!;
        List<Materials> filteredMaterials = materials
            .where((material) =>
                material.status == 'activo' && material.discount != "")
            .toList();

        return _buildCardMaterialClassic(filteredMaterials);
      },
    );
  }

  Widget _buildCardMaterialClassic(List<Materials> materials) {
    return SizedBox(
      width: screenWidth * 0.86,
      height: screenHeight * 0.2,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: materials.length,
        itemBuilder: (context, index) {
          Materials material = materials[index];

          return CardMaterialSimple(
              material: material,
              onClick: () {
                Get.toNamed(
                  '/details-material',
                  arguments: material,
                );
              },
              onLongPress: () {},
              onDoubleTap: () {});
        },
      ),
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

    return SlideInRight(
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
        body: Padding(
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
              _buildMaterialsBySectionId(sectionId),
              Padding(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.025),
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
              _buildMaterialsWithDiscount(),
            ],
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
