import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/models/user.dart';

class UserRequest {
  static final FirebaseFirestore database = FirebaseFirestore.instance;
  static final FirebaseAuth authentication = FirebaseAuth.instance;

  static Future<UserCredential> login(String email, String password) async {
    try {
      return await authentication.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return Future.error('El usuario no existe');
        case 'wrong-password':
          return Future.error('Contraseña incorrecta');
        case 'invalid-email':
          return Future.error('Correo electrónico inválido');
        case 'user-disabled':
          return Future.error('Usuario deshabilitado');
        case 'too-many-requests':
          return Future.error('Demasiados intentos. Intenta más tarde.');
        case 'operation-not-allowed':
          return Future.error('Operación no permitida.');
        default:
          return Future.error(
              'Error al iniciar sesión, compruebe verificando de nuevo sus datos.');
      }
    } catch (e) {
      return Future.error('Error inesperado: $e');
    }
  }

  static Future<UserCredential> register(
      String name,
      String lastName,
      String email,
      String password,
      String phone,
      String address,
      String role,
      String account) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await saveUserData(userCredential.user!.uid, name, lastName, email, phone,
          address, role, account);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return Future.error('La contraseña es demasiado debil');
      } else if (e.code == 'email-already-in-use') {
        return Future.error('Ya existe una cuenta con este email');
      }
    }
    return Future.error('Error al autenticar el usuario');
  }

  static Future<void> saveUserData(
      String userId,
      String name,
      String lastName,
      String email,
      String phone,
      String address,
      String role,
      String account) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'name': name,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'address': address,
        'account': account,
        'role': role,
      });
    } catch (e) {
      throw Future.error('Error al registrar usuario en la base de datos');
    }
  }

  static Future<String> updateUserData(Users user) async {
    try {
      await database.collection('users').doc(user.id).update({
        'name': user.name,
        'lastName': user.lastName,
        'email': user.email,
        'phone': user.phone,
        'address': user.address,
        'account': user.account,
        'role': user.role,
      });

      return "Se ha actualizado exitosamente el usuario";
    } catch (e) {
      throw Future.error('Error al actualizar el usuario');
    }
  }

  static Future<Users> findUser(String email) async {
    Users? user;
    await database.collection('users').get().then((value) {
      for (var doc in value.docs) {
        if (doc.data()['email'] == email) {
          user = Users.fromJson(doc.data());
          user!.id = doc.id;
        }
      }
    });
    return user!;
  }

  static Future<List<Users>> getUsersList() async {
    List<Users> userList = [];
    try {
      await database.collection('users').get().then((value) => {
            for (var doc in value.docs)
              {userList.add(Users.fromJson(doc.data()))}
          });
      return userList;
    } catch (e) {
      throw Future.error('Error al obtener la lista de usuarios: $e');
    }
  }
}
