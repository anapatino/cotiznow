import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/models/entities/entities.dart';
import 'package:cotiznow/src/presentation/widgets/widgets.dart';

import '../../../domain/controllers/controllers.dart';

class MaterialWidgets {
  final double screenHeight;
  final double screenWidth;
  ShoppingCartController shoppingCartController = Get.find();
  MaterialsController materialController = Get.find();

  MaterialWidgets({
    required this.screenHeight,
    required this.screenWidth,
  });

  Widget buildMaterialsBySectionId(String sectionId) {
    return FutureBuilder<List<Materials>>(
      future: materialController.getMaterialsBySectionId(sectionId),
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
        final filteredMaterials =
            materials.where((material) => material.status == 'activo').toList();
        return buildCardMaterial(filteredMaterials);
      },
    );
  }

  Widget buildMaterialsBySectionIdSearch(
      String sectionId, String controllerSearch) {
    return FutureBuilder<List<Materials>>(
      future: materialController.getMaterialsBySectionId(sectionId),
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
        List<Materials> filteredMaterials =
            materials.where((material) => material.status == 'activo').toList();
        if (controllerSearch.isNotEmpty) {
          filteredMaterials = filteredMaterials
              .where((material) =>
                  material.name
                      .toLowerCase()
                      .contains(controllerSearch.toLowerCase()) &&
                  material.sectionId == sectionId &&
                  material.status == 'activo')
              .toList();
        }
        return _buildCardMaterialCustom(filteredMaterials);
      },
    );
  }

  Widget _buildCardMaterialCustom(List<Materials> materials) {
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

  Widget buildCardMaterial(List<Materials> materials) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
      child: SizedBox(
        width: screenWidth * 1,
        height: screenHeight * 0.35,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: materials.length,
          itemBuilder: (context, index) {
            Materials material = materials[index];
            material.quantity = "0";
            Materials existingMaterial =
                shoppingCartController.cartItems.firstWhere(
              (element) => element.id == material.id,
              orElse: () => shoppingCartController.materialNotFound,
            );
            if (existingMaterial.id != "-1") {
              material.quantity = existingMaterial.quantity;
            }

            return CardShop(
              material: material,
              showQuantity: false,
              increaseQuantity: shoppingCartController.increaseQuantity,
              decreaseQuantity: shoppingCartController.decreaseQuantity,
            );
          },
        ),
      ),
    );
  }

  Widget buildCardMaterialCart(List<Materials> materials) {
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
        child: SizedBox(
          width: screenWidth * 1,
          height: screenHeight * 0.35,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: materials.length,
            itemBuilder: (context, index) {
              Materials material = materials[index];

              return CardShop(
                material: material,
                showQuantity: true,
                increaseQuantity: shoppingCartController.increaseQuantity,
                decreaseQuantity: shoppingCartController.decreaseQuantity,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildMaterialsWithDiscount(bool showTotal) {
    return FutureBuilder<List<Materials>>(
      future: materialController.getAllMaterials(),
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

        return _buildCardMaterialClassic(filteredMaterials, showTotal);
      },
    );
  }

  Widget _buildCardMaterialClassic(List<Materials> materials, bool showTotal) {
    return SizedBox(
      width: screenWidth * 0.86,
      height: screenHeight * 0.2,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: materials.length,
        itemBuilder: (context, index) {
          Materials material = materials[index];

          return Padding(
            padding: EdgeInsets.only(
                left: screenWidth * 0.01, right: screenWidth * 0.025),
            child: CardMaterialSimple(
                material: material,
                onClick: () {
                  Get.toNamed(
                    '/details-material',
                    arguments: material,
                  );
                },
                showTotal: showTotal,
                onLongPress: () {},
                onDoubleTap: () {}),
          );
        },
      ),
    );
  }
}
