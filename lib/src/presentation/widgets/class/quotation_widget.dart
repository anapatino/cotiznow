import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/domain.dart';
import 'package:cotiznow/src/presentation/widgets/widgets.dart';

class QuotationWidget {
  final double screenHeight;
  final double screenWidth;
  UserController userController = Get.find();
  QuotationController quotationController = Get.find();
  ServicesController servicesController = Get.find();
  QuotationHistoryController historyQuotationController = Get.find();

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

  List<QuotationHistory> _filterListByOptionHistory(
      List<QuotationHistory> list, String selectedOption) {
    if (selectedOption == "todos" || selectedOption == "") {
      return list;
    }
    List<QuotationHistory> filteredList = [];
    for (var history in list) {
      if (history.quotation.status == selectedOption) {
        filteredList.add(history);
      }
    }

    return filteredList;
  }

  Widget buildQuotationList(
      String selectedOption, bool showOptionUpdate, Function showDeleteAlert) {
    return FutureBuilder<List<Quotation>>(
      future: userController.role == "usuario"
          ? quotationController.getQuotationsByUserId(userController.idUser)
          : quotationController.getAllQuotations(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error al cargar la lista de cotizaciones',
                style: GoogleFonts.varelaRound(
                  color: Colors.black,
                  fontSize: screenWidth * 0.04,
                )),
          );
        }
        List<Quotation> quotations = snapshot.data!;
        quotations = _filterListByOption(quotations, selectedOption);
        return _buildCardQuotation(
            quotations, showOptionUpdate, showDeleteAlert);
      },
    );
  }

  Widget buildHistoryQuotationList(
      String selectedOption, Function showDeleteAlert) {
    return FutureBuilder<List<QuotationHistory>>(
      future: historyQuotationController.getAllQuotationsHistory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error al cargar el historial de cotizaciones',
                style: GoogleFonts.varelaRound(
                  color: Colors.black,
                  fontSize: screenWidth * 0.04,
                )),
          );
        }
        List<QuotationHistory> list = snapshot.data!;
        list = _filterListByOptionHistory(list, selectedOption);
        return _buildCardQuotationHistory(list, showDeleteAlert);
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
            name: quotation.name,
            address: quotation.address,
            phone: quotation.phone,
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

  Widget _buildCardQuotationHistory(
      List<QuotationHistory> history, Function showDeleteAlert) {
    return SizedBox(
      height: screenHeight * 0.75,
      child: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          Quotation quotation = history[index].quotation;
          QuotationHistory _history = history[index];

          return CardQuotation(
            isHistory: true,
            date: history[index].date,
            onLongPress: () {
              showDeleteAlert(_history);
            },
            backgroundColor: quotation.status == "pendiente"
                ? Palette.accent
                : quotation.status == "rechazada"
                    ? Palette.error
                    : Palette.primary,
            name: quotation.name,
            address: quotation.address,
            phone: quotation.phone,
            status: quotation.status,
            total: quotation.total,
            onTap: () async {
              await servicesController.getAllServices();
              Get.toNamed('/details-quotation', arguments: quotation);
            },
            icon: () {},
            onDoubleTap: () {},
          );
        },
      ),
    );
  }
}
