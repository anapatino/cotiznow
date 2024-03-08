import 'package:cotiznow/src/domain/domain.dart';

class ProgrammeVisits {
  String id;
  Users user;
  String motive;

  ProgrammeVisits({
    required this.id,
    required this.user,
    required this.motive,
  });

  factory ProgrammeVisits.fromJson(Map<String, dynamic>? json) {
    return ProgrammeVisits(
      id: json?['id'] ?? '',
      user: Users.fromJson(json?['user']),
      motive: json?['motive'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'motive': motive,
    };
  }
}
