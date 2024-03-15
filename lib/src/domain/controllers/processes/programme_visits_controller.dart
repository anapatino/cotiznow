import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/data/data.dart';
import 'package:cotiznow/src/domain/domain.dart';

class ProgrammeVisitsController extends GetxController {
  RxList<ProgrammeVisits> visitsList = <ProgrammeVisits>[].obs;
  final Rxn<List<ProgrammeVisits>> _visitsList = Rxn<List<ProgrammeVisits>>();
  final Rxn<List<ProgrammeVisits>> _visitsByUserList =
      Rxn<List<ProgrammeVisits>>();

  List<ProgrammeVisits>? get listOfPlannedVisits => _visitsList.value;
  List<ProgrammeVisits>? get listOfPlannedVisitsByUser =>
      _visitsByUserList.value;

  Future<String> registerVisit(ProgrammeVisits visit) async {
    try {
      return await ProgrammeVisitsRequest.registerVisit(visit);
    } catch (e) {
      return 'Error al registrar la visita: $e';
    }
  }

  Future<List<ProgrammeVisits>> getAllVisits() async {
    try {
      List<ProgrammeVisits> visits =
          await ProgrammeVisitsRequest.getAllVisits();
      _visitsList.value = visits;
      return visits;
    } catch (e) {
      throw Future.error('Error al obtener todas las visitas: $e');
    }
  }

  Future<List<ProgrammeVisits>> getAllVisitsByUser(String authId) async {
    try {
      List<ProgrammeVisits> visits =
          await ProgrammeVisitsRequest.getAllVisitsByUser(authId);
      _visitsByUserList.value = visits;
      return visits;
    } catch (e) {
      throw Future.error('Error al obtener todas las visitas: $e');
    }
  }

  Future<void> updateVisitStatus(String visitId, String newStatus) async {
    try {
      await ProgrammeVisitsRequest.updateVisitStatus(visitId, newStatus);
    } catch (e) {
      throw Future.error('Error al actualizar el estado de la visita: $e');
    }
  }

  Future<void> deleteVisit(String visitId) async {
    try {
      await ProgrammeVisitsRequest.deleteVisit(visitId);
      visitsList.removeWhere((visit) => visit.id == visitId);
    } catch (e) {
      throw Future.error('Error al eliminar la visita: $e');
    }
  }
}
