import 'package:cotiznow/src/domain/domain.dart';

class ProgrammeVisits {
  String id;
  Users user;
  String date;
  String motive;
  String status;

  ProgrammeVisits({
    required this.id,
    required this.user,
    required this.motive,
    required this.date,
    required this.status,
  });

  factory ProgrammeVisits.fromJson(Map<String, dynamic>? json) {
    return ProgrammeVisits(
      id: json?['id'] ?? '',
      user: Users.fromJson(json?['user']),
      motive: json?['motive'] ?? '',
      date: json?['date'] ?? '',
      status: json?['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'motive': motive,
      'date': date,
      'status': status,
    };
  }
}
