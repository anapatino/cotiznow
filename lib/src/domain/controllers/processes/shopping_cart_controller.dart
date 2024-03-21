import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/controllers/controllers.dart';
import 'package:cotiznow/src/domain/models/entities/entities.dart';

class ShoppingCartController extends GetxController {
  RxList<Materials> cartItems = <Materials>[].obs;
  RxList<Service> selectService = <Service>[].obs;
  ServicesController serviceController = Get.find();
  Service serviceNotFound = Service(
      id: "-1", icon: "", name: "", description: "", status: "", price: "");
  Materials materialNotFound = Materials(
      urlPhoto: "",
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
    selectService.clear();
  }

  double calculateMaterialsTotal() {
    return cartItems.fold(0, (sum, material) {
      int quantity = int.parse(material.quantity);
      int salePrice = int.parse(material.salePrice);
      double discount =
          material.discount.isEmpty ? 0 : double.parse(material.discount);
      discount *= salePrice;
      return sum +
          (material.discount.isEmpty
              ? (salePrice * quantity)
              : ((salePrice - discount) * quantity));
    });
  }

  void toggleSelectedService(Service service) {
    if (selectService.contains(service)) {
      selectService.remove(service);
    } else {
      selectService.add(service);
    }
  }

  List<String> extractSelectedServiceIds() {
    return selectService.map((service) => service.id).toList();
  }

  int calculateServicesTotal() {
    return selectService.fold(0, (sum, service) {
      return sum + int.parse(service.price);
    });
  }

  void updateSelectedServices(List<String> serviceIds) async {
    selectService.clear();
    List<Service> services = await serviceController.getAllServices();
    for (String id in serviceIds) {
      Service service =
          services.firstWhere((s) => s.id == id, orElse: () => serviceNotFound);
      if (service.id != "-1") {
        selectService.add(service);
      }
    }
  }
}
