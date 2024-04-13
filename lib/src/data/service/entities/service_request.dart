import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/models/entities/service.dart';

class ServicesRequest {
  static final FirebaseFirestore database = FirebaseFirestore.instance;

  static Future<String> registerService(Service service) async {
    try {
      await database.collection('services').add({
        'icon': service.icon,
        'name': service.name,
        'description': service.description,
        'status': service.status,
        'price': service.price,
        'measures': service.measures,
      });
      return "Registro del servicio exitoso";
    } catch (e) {
      throw Future.error('Error al registrar el servicio en la base de datos');
    }
  }

  static Future<String> updateServiceStatus(
    String serviceId,
    String newStatus,
  ) async {
    try {
      await database
          .collection('services')
          .doc(serviceId)
          .update({'status': newStatus});

      return "Estado del servicio actualizado exitosamente";
    } catch (e) {
      throw Future.error('Error al actualizar el estado del servicio');
    }
  }

  static Future<String> updateService(Service service) async {
    try {
      await database.collection('services').doc(service.id).update({
        'icon': service.icon,
        'name': service.name,
        'description': service.description,
        'status': service.status,
        'price': service.price,
        'measures': service.measures,
      });

      return "Servicio actualizado exitosamente";
    } catch (e) {
      throw Future.error('Error al actualizar el servicio');
    }
  }

  static Future<List<Service>> getAllServices() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await database.collection('services').get();

      List<Service> servicesList = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return Service(
          id: doc.id,
          icon: data['icon'] ?? '',
          name: data['name'] ?? '',
          description: data['description'] ?? '',
          status: data['status'] ?? '',
          price: data['price'] ?? '',
          measures: data['measures'] ?? '',
        );
      }).toList();

      return servicesList;
    } catch (e) {
      throw Future.error(
          'Error al obtener los servicios desde la base de datos');
    }
  }

  static Future<String> deleteService(String sectionId) async {
    try {
      await database.collection('services').doc(sectionId).delete();
      return "Se ha eliminado con exito el servicio";
    } catch (e) {
      throw Future.error('Error al eliminar el servicio: $e');
    }
  }
}
