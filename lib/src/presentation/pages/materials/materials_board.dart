import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/presentation/pages/materials/materials.dart';
import 'package:cotiznow/src/presentation/widgets/components/card/card_material.dart';
import '../../../domain/domain.dart';
import '../../routes/routes.dart';
import '../../widgets/components/components.dart';

class MaterialsBoard extends StatefulWidget {
  final MaterialsController materialController = Get.find();
  final SectionsController sectionsController = Get.find();

  final UserController userController = Get.find();
  MaterialsBoard({super.key});

  @override
  State<MaterialsBoard> createState() => _MaterialsBoardState();
}

class _MaterialsBoardState extends State<MaterialsBoard> {
  late final TextEditingController controllerSearch = TextEditingController();
  int activeIndex = -1;
  String sectionId = "";
  double screenWidth = 0;
  double screenHeight = 0;
  bool isUpdateFormVisible = false;
  bool isUpdateStatusVisible = false;
  bool isRegisterFormVisible = false;
  List<Section> listSections = [];
  Materials material = Materials(
      urlPhoto: '',
      name: '',
      unit: '',
      size: '',
      purchasePrice: '',
      salePrice: '',
      sectionId: '',
      quantity: '',
      description: '',
      status: '',
      id: '',
      code: '');

  @override
  void initState() {
    super.initState();
    //controllerSearch?.addListener(() {
    // filterSections(controllerSearch!.text);
    //});
  }

  @override
  void dispose() {
    controllerSearch.clear();
    controllerSearch.dispose();
    super.dispose();
  }

  void toggleUpdateFormVisibility(Materials selectMaterial) {
    setState(() {
      isUpdateFormVisible = !isUpdateFormVisible;
      material = selectMaterial;
      if (!isUpdateFormVisible) {
        activeIndex = -1;
      }
    });
  }

  void toggleUpdateStatusVisibility(Materials selectMaterial) {
    setState(() {
      isUpdateStatusVisible = !isUpdateStatusVisible;
      material = selectMaterial;
      if (!isUpdateStatusVisible) {
        activeIndex = -1;
      }
    });
  }

  void toggleRegisterFormVisibility() {
    setState(() {
      isRegisterFormVisible = !isRegisterFormVisible;
    });
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
            sections.where((section) => section.status == 'enable').toList();
        return _buildRoundIconButtons(filteredSections);
      },
    );
  }

  Widget _buildRoundIconButtons(List<Section> sections) {
    return SizedBox(
      width: screenWidth * 0.86,
      height: screenHeight * 0.15,
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

  Widget _buildMaterialsBySectionId(String sectionId) {
    return FutureBuilder<List<Materials>>(
      future: widget.materialController.getMaterialsBySectionId(sectionId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        final materials = snapshot.data!;
        List<Materials> filteredMaterials =
            materials.where((material) => material.status == 'enable').toList();
        return _buildCardMaterial(filteredMaterials);
      },
    );
  }

  Widget _buildCardMaterial(List<Materials> materials) {
    return Expanded(
      child: SizedBox(
        width: screenWidth * 0.86,
        height: screenHeight * 0.8,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: materials.length,
          itemBuilder: (context, index) {
            Materials material = materials[index];

            return CardMaterialSimple(
                material: material,
                onClick: () {},
                onLongPress: () {
                  toggleUpdateStatusVisibility(material);
                },
                onDoubleTap: () {
                  toggleUpdateFormVisibility(material);
                });
          },
        ),
      ),
    );
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
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.055),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Materiales",
                      style: GoogleFonts.varelaRound(
                        color: Colors.black,
                        fontSize: screenWidth * 0.06,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
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
                            //filterSections(value);
                          },
                          controller: controllerSearch,
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    _buildSectionsList(),
                    _buildMaterialsBySectionId(sectionId),
                  ],
                ),
              ),
              Visibility(
                visible: isRegisterFormVisible,
                child: Positioned(
                  top: screenHeight * 0.05,
                  child: Opacity(
                    opacity: isRegisterFormVisible ? 1 : 0.0,
                    child: RegisterMaterialForm(
                      onCancelForm: () {
                        toggleRegisterFormVisibility();
                      },
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: isUpdateFormVisible,
                child: Positioned(
                  top: screenHeight * 0.05,
                  child: Opacity(
                    opacity: isUpdateFormVisible ? 1 : 0.0,
                    child: UpdateFormMaterial(
                      onCancelForm: () {
                        toggleUpdateFormVisibility(material);
                      },
                      material: material,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: isUpdateStatusVisible,
                child: Positioned(
                  top: screenHeight * 0.05,
                  child: Opacity(
                    opacity: isUpdateStatusVisible ? 1 : 0.0,
                    child: ChangeMaterialStatus(
                      onCancelForm: () {
                        toggleUpdateStatusVisibility(material);
                      },
                      material: material,
                    ),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: isRegisterFormVisible ||
                  isUpdateFormVisible ||
                  isUpdateStatusVisible
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
