import 'package:flutter/material.dart';
import 'bank_type.dart';
import 'transaction_type.dart';

class Transaction {
  final double amount;
  final TransactionType type;
  final DateTime date;
  final String description;
  final BankType bankType;
  final String accountNumber;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;

  Transaction({
    required this.amount,
    required this.type,
    required this.date,
    required this.description,
    required this.bankType,
    required this.accountNumber,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
  });

  factory Transaction.sample() {
    return Transaction(
      amount: 120,
      type: TransactionType.withdrawal,
      date: DateTime.now(),
      description: 'Shopping',
      bankType: BankType.cbe,
      accountNumber: '1234',
      subtitle: 'Buy some grocery',
      icon: Icons.shopping_bag,
      iconColor: Colors.orange,
      iconBackground: Colors.orange.shade50,
    );
  }

  String get title {
    final desc = description.toLowerCase();
    if (desc.contains('uber')) return 'Uber';
    if (desc.contains('nescafe')) return 'Nescafe';
    if (desc.contains('chicken')) return 'Tasty Fried Chicken';
    return 'Transaction';
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

