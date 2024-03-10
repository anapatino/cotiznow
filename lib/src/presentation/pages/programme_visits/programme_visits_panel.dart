import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/controllers/controllers.dart';
import 'package:cotiznow/src/domain/models/models.dart';
import 'package:cotiznow/src/presentation/routes/routes.dart';
import 'package:cotiznow/src/presentation/widgets/components/components.dart';

// ignore: must_be_immutable
class ProgrammeVisitsPanel extends StatefulWidget {
  UserController userController = Get.find();
  ProgrammeVisitsController programmeVisitsController = Get.find();

  ProgrammeVisitsPanel({super.key});

  @override
  State<ProgrammeVisitsPanel> createState() => _ProgrammeVisitsPanelState();
}

class _ProgrammeVisitsPanelState extends State<ProgrammeVisitsPanel> {
  double screenWidth = 0;
  double screenHeight = 0;
  bool isContainerVisible = false;

  Widget _buildQuotationList() {
    return FutureBuilder<List<ProgrammeVisits>>(
      future: widget.programmeVisitsController.getAllVisits(),
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
        List<ProgrammeVisits> visits = snapshot.data!;
        // return _buildCardQuotation(visits);
        return Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return SlideInLeft(
      duration: const Duration(milliseconds: 15),
      child: Scaffold(
        appBar: AppBar(
          actions: const [],
        ),
        drawer: CustomDrawer(
          name: widget.userController.name,
          email: widget.userController.userEmail,
          itemConfigs: widget.userController.role == "cliente"
              ? CustomerRoutes().itemConfigs
              : AdministratorRoutes().itemConfigs,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.055),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Visitas programadas",
                style: GoogleFonts.varelaRound(
                  color: Colors.black,
                  fontSize: screenWidth * 0.06,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              _buildQuotationList(),
            ],
          ),
        ),
      ),
    );
  }
}
