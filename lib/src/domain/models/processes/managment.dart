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
  final String bancolombia;
  final String nequi;
  final String daviplata;

  MethodOfPayment({
    required this.bancolombia,
    required this.nequi,
    required this.daviplata,
  });

  factory MethodOfPayment.fromFirestore(Map<String, dynamic>? data) {
    return MethodOfPayment(
      bancolombia: data?['bancolombia'] ?? '',
      nequi: data?['nequi'] ?? '',
      daviplata: data?['daviplata'] ?? '',
    );
  }
}
