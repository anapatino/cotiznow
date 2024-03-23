import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/domain.dart';
import 'package:cotiznow/src/presentation/widgets/widgets.dart';

class QuotationWidget {
  final double screenHeight;
  final double screenWidth;
  UserController userController = Get.find();
  QuotationController quotationController = Get.find();
  ServicesController servicesController = Get.find();

  QuotationWidget({
    required this.screenHeight,
    required this.screenWidth,
  });

  List<Quotation> _filterListByOption(
      List<Quotation> quotations, String selectedOption) {
    if (selectedOption == "todos" || selectedOption == "") {
      return quotations;
    }
    return quotations = quotations
        .where((quotation) => quotation.status == selectedOption)
        .toList();
  }

  Widget buildQuotationList(
      String selectedOption, bool showOptionUpdate, Function showDeleteAlert) {
    return FutureBuilder<List<Quotation>>(
      future: userController.role == "cliente"
          ? quotationController.getQuotationsByUserId(userController.idUser)
          : quotationController.getAllQuotations(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('Error al cargar la lista de cotizaciones'),
          );
        }
        List<Quotation> quotations = snapshot.data!;
        quotations = _filterListByOption(quotations, selectedOption);
        return _buildCardQuotation(
            quotations, showOptionUpdate, showDeleteAlert);
      },
    );
  }

  Widget _buildCardQuotation(List<Quotation> quotations, bool showOptionUpdate,
      Function showDeleteAlert) {
    return SizedBox(
      height: screenHeight * 0.75,
      child: ListView.builder(
        itemCount: quotations.length,
        itemBuilder: (context, index) {
          Quotation quotation = quotations[index];
          return CardQuotation(
            onLongPress: () {
              showDeleteAlert(quotation);
            },
            backgroundColor: quotation.status == "pendiente"
                ? Palette.accent
                : quotation.status == "rechazada"
                    ? Palette.error
                    : Palette.primary,
            title: quotation.name,
            description: quotation.description,
            status: quotation.status,
            total: quotation.total,
            onTap: () async {
              await servicesController.getAllServices();
              Get.toNamed('/details-quotation', arguments: quotation);
            },
            icon: () {},
            onDoubleTap: () async {
              if (showOptionUpdate) {
                Get.toNamed('/update-quotation', arguments: quotation);
              }
            },
          );
        },
      ),
    );
  }
}
