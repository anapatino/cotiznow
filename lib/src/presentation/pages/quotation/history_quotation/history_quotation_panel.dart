import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/presentation/routes/routes.dart';
import 'package:cotiznow/src/presentation/widgets/widgets.dart';
import '../../../../domain/domain.dart';
import 'package:intl/intl.dart';

import '../../../widgets/components/card/card_statistics.dart';

// ignore: must_be_immutable
class HistoryQuotationPanel extends StatefulWidget {
  UserController userController = Get.find();
  QuotationController quotationController = Get.find();

  HistoryQuotationPanel({super.key});

  @override
  State<HistoryQuotationPanel> createState() => _HistoryQuotationPanelState();
}

class _HistoryQuotationPanelState extends State<HistoryQuotationPanel> {
  double screenWidth = 0;
  double screenHeight = 0;
  bool isTablet = false;
  bool isContainerVisible = false;
  String selectedFilterType = 'mes';
  List<Quotation> listQuotation = [];
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchQuotations();
  }

  Future<void> _fetchQuotations() async {
    List<Quotation> quotations =
        await widget.quotationController.getAllQuotations();
    setState(() {
      listQuotation = quotations;
    });
  }

  int calculateDateStatus(String status, DateTime date,
      {String filterType = 'mes'}) {
    if (listQuotation.isNotEmpty) {
      return listQuotation.where((quotation) {
        if (quotation.status != status) {
          return false;
        }

        DateTime quotationDate =
            DateFormat("yyyy-MM-dd HH:mm:ss").parse(quotation.date);
        switch (filterType) {
          case 'año':
            return quotationDate.year == date.year;
          case 'mes':
            return quotationDate.year == date.year &&
                quotationDate.month == date.month;
          case 'semana':
            int selectedWeek = _getWeekOfYear(date);
            int quotationWeek = _getWeekOfYear(quotationDate);
            return quotationDate.year == date.year &&
                selectedWeek == quotationWeek;
          default:
            return false;
        }
      }).length;
    }
    return 0;
  }

  int _getWeekOfYear(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return PopScope(
      canPop: false,
      child: SlideInLeft(
        duration: const Duration(milliseconds: 15),
        child: Scaffold(
          appBar: AppBar(
            actions: const [],
          ),
          drawer: CustomDrawer(
            name: widget.userController.name,
            email: widget.userController.userEmail,
            itemConfigs: widget.userController.role == "usuario"
                ? CustomerRoutes().itemConfigs
                : AdministratorRoutes().itemConfigs,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.055),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Reporte de cotizaciones",
                    style: GoogleFonts.varelaRound(
                      color: Colors.black,
                      fontSize:
                          isTablet ? screenWidth * 0.04 : screenWidth * 0.06,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    "Elija la fecha para aplicar el filtro:",
                    style: GoogleFonts.varelaRound(
                      color: Colors.black,
                      fontSize:
                          isTablet ? screenWidth * 0.02 : screenWidth * 0.035,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.007),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () => _selectDate(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Palette.accent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          "Seleccionar Fecha",
                          style: GoogleFonts.varelaRound(
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.1),
                      DropdownButton<String>(
                        value: selectedFilterType,
                        underline: Container(
                          height: 0,
                        ),
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Palette.textColor),
                        elevation: 1,
                        borderRadius: BorderRadius.circular(15),
                        items: <String>['año', 'mes', 'semana']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: GoogleFonts.varelaRound(
                                fontSize: screenWidth * 0.035,
                                fontWeight: FontWeight.w400,
                                color: Palette.textlabel,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedFilterType = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    "Fecha seleccionada: ${DateFormat('dd-MM-yyyy').format(selectedDate)}",
                    style: GoogleFonts.varelaRound(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize:
                          isTablet ? screenWidth * 0.025 : screenWidth * 0.038,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CardStatistics(
                            backgroundColor: Colors.green,
                            number: calculateDateStatus(
                                'aprobado', selectedDate,
                                filterType: selectedFilterType),
                            title: 'Aprobado',
                            orientation: 'column',
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          CardStatistics(
                            backgroundColor: Colors.red,
                            number: calculateDateStatus(
                                'rechazada', selectedDate,
                                filterType: selectedFilterType),
                            title: 'Rechazado',
                            orientation: 'column',
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      CardStatistics(
                        backgroundColor: Palette.accent,
                        number: calculateDateStatus('pendiente', selectedDate,
                            filterType: selectedFilterType),
                        title: 'Pendiente',
                        orientation: 'row',
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      CardStatistics(
                        backgroundColor: Palette.primary,
                        number: calculateDateStatus('terminado', selectedDate,
                            filterType: selectedFilterType),
                        title: 'Terminado',
                        orientation: 'row',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
