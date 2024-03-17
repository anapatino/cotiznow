import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/models/entities/entities.dart';

class ShoppingCartController extends GetxController {
  RxList<Materials> cartItems = <Materials>[].obs;
  Materials materialNotFound = Materials(
      url_photo: "",
      name: "",
      code: "",
      unit: "",
      size: "",
      purchasePrice: "",
      salePrice: "",
      sectionId: "",
      quantity: "",
      description: "",
      status: "",
      id: "-1",
      discount: "");

  void addToCart(Materials material) {
    cartItems.add(material);
  }

  void removeFromCart(Materials material) {
    cartItems.remove(material);
  }

  void updateCartItem(Materials oldMaterial, Materials newMaterial) {
    final index = cartItems.indexOf(oldMaterial);
    if (index != -1) {
      cartItems[index] = newMaterial;
    }
  }

  bool isInCart(Materials material) {
    return cartItems.contains(material);
  }

  void increaseQuantity(Materials material) {
    Materials existingMaterial = cartItems.firstWhere(
      (element) => element.id == material.id,
      orElse: () => materialNotFound,
    );

    if (existingMaterial.id == "-1") {
      material.quantity = "1";
      addToCart(material);
    } else {
      existingMaterial.quantity =
          (int.parse(existingMaterial.quantity) + 1).toString();
    }
  }

  void decreaseQuantity(Materials material) {
    Materials existingMaterial = cartItems.firstWhere(
      (element) => element.id == material.id,
      orElse: () => materialNotFound,
    );

    if (existingMaterial.id != "-1") {
      int quantity = int.parse(existingMaterial.quantity);
      if (quantity > 1) {
        existingMaterial.quantity = (quantity - 1).toString();
      } else {
        removeFromCart(existingMaterial);
      }
    }
  }

  void clearCart() {
    cartItems.clear();
  }
}
