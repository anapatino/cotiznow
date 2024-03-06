import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/data/data.dart';

import '../models/models.dart';

class UnitsController extends GetxController {
  final Rxn<List<Units>> _unitsList = Rxn<List<Units>>();

  List<Units>? get unitsList => _unitsList.value;

  Future<String> registerUnit(String unit) async {
    try {
      return await UnitsRequest.registerUnit(unit);
    } catch (e) {
      throw Future.error('Error al registrar la unidad en la base de datos');
    }
  }

  Future<List<Units>> getAllUnits() async {
    try {
      List<Units> list = await UnitsRequest.getAllUnits();
      _unitsList.value = list;
      return list;
    } catch (e) {
      throw Future.error(
          'Error al obtener todas las unidades desde la base de datos');
    }
  }
}
