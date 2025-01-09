import 'package:flutter/foundation.dart';
import 'bank_type.dart';
import 'transaction_type.dart';

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

  String get title {
    final desc = description.toLowerCase();
    if (desc.contains('uber')) return 'Uber';
    if (desc.contains('nescafe')) return 'Nescafe';
    if (desc.contains('chicken')) return 'Tasty Fried Chicken';
    return 'Transaction';
  }

  String get subtitle {
    if (description.toLowerCase().contains('transfer')) {
      return 'Transfer';
    }
    return 'Debit Card';
  }

  String get formattedAmount {
    final prefix = type == TransactionType.withdrawal ? '-' : '+';
    return '$prefix\$${amount.toStringAsFixed(2)}';
  }

  String get formattedDate {
    return '${date.day.toString().padLeft(2, '0')} ${_getMonthName(date.month)}, ${date.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}

