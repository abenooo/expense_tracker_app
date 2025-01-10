import 'package:flutter/material.dart';

enum TransactionType { deposit, withdrawal }
enum BankType { cbe, awash }

class Transaction {
  final double amount;
  final TransactionType type;
  final DateTime date;
  final String description;
  final BankType bankType;
  final String accountNumber;

  Transaction({
    required this.amount,
    required this.type,
    required this.date,
    required this.description,
    required this.bankType,
    required this.accountNumber,
  });
}

class Message {
  final String body;
  final DateTime? date;

  Message({required this.body, this.date});
}


Transaction parseTransaction(String messageBody, DateTime? messageDate) {
  final regex = RegExp(r'(\d+)\s+(credited|debited)\s+Birr\s+([\d,]+)');
  final match = regex.firstMatch(messageBody);

  if (match == null) {
    throw Exception('Invalid transaction format');
  }

  return Transaction(
    amount: double.parse(match.group(3)!.replaceAll(',', '')),
    type: match.group(2) == 'credited' ? TransactionType.deposit : TransactionType.withdrawal,
    date: messageDate ?? DateTime.now(),
    description: messageBody,
    bankType: BankType.cbe,
    accountNumber: match.group(1)!,
  );
}


void main() {
  final message1 = Message(body: '12345 credited Birr 1000,00', date: DateTime(2024, 3, 10));
  final message2 = Message(body: '67890 debited Birr 500', date: DateTime(2024, 3, 15));
  final message3 = Message(body: '13579 credited Birr 2500.50');


  try{
    final transaction1 = parseTransaction(message1.body, message1.date);
    final transaction2 = parseTransaction(message2.body, message2.date);
    final transaction3 = parseTransaction(message3.body, message3.date);

    print(transaction1.toJson());
    print(transaction2.toJson());
    print(transaction3.toJson());
  } catch (e){
    print("Error parsing transaction: $e");
  }

}


extension TransactionToJson on Transaction {
  Map<String, dynamic> toJson() => {
        'amount': amount,
        'type': type.toString().split('.').last,
        'date': date.toIso8601String(),
        'description': description,
        'bankType': bankType.toString().split('.').last,
        'accountNumber': accountNumber,
      };
}

