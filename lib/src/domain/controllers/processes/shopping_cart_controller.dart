import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/domain.dart';

class ShoppingCartController extends GetxController {
  RxList<Materials> cartItems = <Materials>[].obs;
  RxList<Service> selectService = <Service>[].obs;
  RxList<CustomizedService> selectCustomizedService = <CustomizedService>[].obs;
  ServicesController serviceController = Get.find();
  Service serviceNotFound = Service(
      id: "-1",
      icon: "",
      name: "",
      description: "",
      status: "",
      price: "",
      measures: '');
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

  void createCustomizedService(
      Map<String, TextEditingController> heightControllers,
      Map<String, TextEditingController> widthControllers) {
    selectCustomizedService.clear();
    for (Service service in selectService) {
      int height = int.tryParse(heightControllers[service.id]?.text ?? '') ?? 0;
      int width = int.tryParse(widthControllers[service.id]?.text ?? '') ?? 0;
      int servicePrice = int.tryParse(service.price) ?? 0;
      int total = (height == 0 && width == 0)
          ? servicePrice
          : (height * width) * servicePrice;
      selectCustomizedService.add(CustomizedService(
        id: service.id,
        name: service.name,
        price: total.toString(),
        measures: Measures(height: height.toString(), width: width.toString()),
      ));
    }
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

  int calculateServicesTotal() {
    return selectCustomizedService.fold(0, (sum, service) {
      return sum + int.parse(service.price);
    });
  }

  Future<void> updateSelectedServices(
      List<CustomizedService> customService) async {
    selectService.clear();
    selectCustomizedService.clear();
    List<Service> services = await serviceController.getAllServices();
    for (CustomizedService custom in customService) {
      Service service = services.firstWhere((s) => s.id == custom.id,
          orElse: () => serviceNotFound);
      if (service.id != "-1") {
        selectService.add(service);
        selectCustomizedService.add(custom);
      }
    }
  }
}
