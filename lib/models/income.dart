import 'package:cloud_firestore/cloud_firestore.dart';

class Income {
  final String? id;
  final String category;
  final int amount;
  final DateTime date;
  final String? note;

  Income(
      {this.id,
      required this.category,
      required this.amount,
      required this.date,
      this.note});

  factory Income.fromJson(QueryDocumentSnapshot json) {
    Map<String, dynamic> jsonData = json.data() as Map<String, dynamic>;
    return Income(
      id: json.id,
      category: jsonData['category'],
      amount: jsonData['amount'],
      date: DateTime.parse(jsonData['date'].toDate().toString()),
      note: jsonData['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'category': category,
      'amount': amount,
      'date': date,
      'note': note,
    };
  }
}
