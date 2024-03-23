class Management {
  final Contact contact;
  final MethodOfPayment methodOfPayment;

  const Management({
    required this.contact,
    required this.methodOfPayment,
  });
}

class Contact {
  final String phone;
  final String messageWhatsApp;
  final String email;

  Contact({
    required this.phone,
    required this.messageWhatsApp,
    required this.email,
  });

  factory Contact.fromFirestore(Map<String, dynamic>? data) {
    return Contact(
      phone: data?['phone'] ?? '',
      messageWhatsApp: data?['messageWhatsApp'] ?? '',
      email: data?['email'] ?? '',
    );
  }
}

class MethodOfPayment {
  final Bancolombia bancolombia;
  final String nequi;
  final String daviplata;

  MethodOfPayment({
    required this.bancolombia,
    required this.nequi,
    required this.daviplata,
  });

  factory MethodOfPayment.fromFirestore(Map<String, dynamic>? data) {
    return MethodOfPayment(
      bancolombia: Bancolombia.fromMap(data?['bancolombia']),
      nequi: data?['nequi'] ?? '',
      daviplata: data?['daviplata'] ?? '',
    );
  }
}

class Bancolombia {
  final String name;
  final String cc;
  final String account;
  final String number;

  Bancolombia({
    required this.name,
    required this.cc,
    required this.account,
    required this.number,
  });

  factory Bancolombia.fromMap(Map<String, dynamic>? data) {
    return Bancolombia(
      name: data?['name'] ?? '',
      cc: data?['cc'] ?? '',
      account: data?['account'] ?? '',
      number: data?['number'] ?? '',
    );
  }
}
