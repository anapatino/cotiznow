import 'package:cotiznow/src/domain/domain.dart';

class QuotationHistory {
  String id;
  String date;
  Quotation quotation;

  QuotationHistory(
      {required this.id, required this.quotation, required this.date});

  factory QuotationHistory.fromJson(Map<String, dynamic>? json) {
    return QuotationHistory(
      id: json?['id'] ?? '',
      date: json?['date'] ?? '',
      quotation: Quotation.fromJson(json?['quotation']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'quotation': quotation.toJson(),
    };
  }
}
