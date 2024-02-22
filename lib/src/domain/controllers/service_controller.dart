import 'package:cotiznow/lib.dart';

import '../../data/service/service_request.dart';
import '../models/service.dart';

class ServicesController extends GetxController {
  final Rxn<List<Service>> _servicesList = Rxn<List<Service>>();

  List<Service>? get servicesList => _servicesList.value;

  Future<String> registerService(Service service) async {
    try {
      return await ServicesRequest.registerService(service);
    } catch (e) {
      throw Future.error('Error al registrar servicio en la base de datos');
    }
  }

  Future<String> updateServiceStatus(
    String serviceId,
    String newStatus,
  ) async {
    try {
      return await ServicesRequest.updateServiceStatus(serviceId, newStatus);
    } catch (e) {
      throw Future.error('Error al actualizar el estado del servicio');
    }
  }

  Future<String> updateService(Service service) async {
    try {
      return await ServicesRequest.updateService(service);
    } catch (e) {
      throw Future.error('Error al actualizar el servicio en la base de datos');
    }
  }

  Future<List<Service>> getAllServices() async {
    try {
      List<Service> list = await ServicesRequest.getAllServices();
      _servicesList.value = list;
      return list;
    } catch (e) {
      throw Future.error(
          'Error al obtener los servicios desde la base de datos');
    }
  }
}
