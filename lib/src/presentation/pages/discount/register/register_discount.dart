import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/presentation/widgets/class/class.dart';

import '../../../../domain/domain.dart';
import '../../../widgets/components/components.dart';

class RegisterDiscount extends StatefulWidget {
  final MaterialsController materialController = Get.find();
  final SectionsController sectionsController = Get.find();
  final UserController userController = Get.find();
  RegisterDiscount({super.key});

  @override
  State<RegisterDiscount> createState() => _RegisterDiscountState();
}

class _RegisterDiscountState extends State<RegisterDiscount> {
  int activeIndex = -1;
  String sectionId = "";
  double screenWidth = 0;
  double screenHeight = 0;
  List<Section> listSections = [];
  List<Materials> filteredMaterials = [];

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
      code: '',
      discount: '');

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

  Widget _buildSectionsList() {
    return FutureBuilder<List<Section>>(
      future: widget.sectionsController.getAllSections(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
              width: screenWidth * 0.86,
              height: screenHeight * 0.15,
              child: const Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return SizedBox(
              width: screenWidth * 0.86,
              height: screenHeight * 0.15,
              child: Center(
                child: Text(snapshot.error.toString(),
                    style: GoogleFonts.varelaRound(
                      color: Colors.black,
                      fontSize: screenWidth * 0.04,
                    )),
              ));
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
          return SizedBox(
              width: screenWidth * 0.86,
              height: screenHeight * 0.15,
              child: const Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return SizedBox(
              width: screenWidth * 0.86,
              height: screenHeight * 0.15,
              child: Center(
                child: Text(snapshot.error.toString(),
                    style: GoogleFonts.varelaRound(
                      color: Colors.black,
                      fontSize: screenWidth * 0.04,
                    )),
              ));
        }
        final materials = snapshot.data!;
        filteredMaterials =
            materials.where((material) => material.status == 'activo').toList();
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
                onClick: () {
                  Get.toNamed('/update-discounts', arguments: material);
                },
                onLongPress: () {},
                onDoubleTap: () {});
          },
        ),
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
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.055),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Registrar Descuento",
                style: GoogleFonts.varelaRound(
                  color: Colors.black,
                  fontSize: screenWidth * 0.06,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              _buildSectionsList(),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              _buildMaterialsBySectionId(sectionId),
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
