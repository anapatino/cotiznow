import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/data/data.dart';
import 'package:cotiznow/src/domain/domain.dart';

class ProgrammeVisitsController extends GetxController {
  RxList<ProgrammeVisits> visitsList = <ProgrammeVisits>[].obs;
  final Rxn<List<ProgrammeVisits>> _visitsList = Rxn<List<ProgrammeVisits>>();

  List<ProgrammeVisits>? get listOfPlannedVisits => _visitsList.value;

  Future<String> registerVisit(ProgrammeVisits visit) async {
    try {
      return await ProgrammeVisitsRequest.registerVisit(visit);
    } catch (e) {
      return 'Error al registrar la visita: $e';
    }
  }

  Future<void> getAllVisits() async {
    try {
      List<ProgrammeVisits> visits =
          await ProgrammeVisitsRequest.getAllVisits();
      _visitsList.value = visits;
    } catch (e) {
      throw Future.error('Error al obtener todas las visitas: $e');
    }
  }
}
