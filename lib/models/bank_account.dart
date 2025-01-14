import 'package:flutter/material.dart';

class BankAccount {
  final String bankName;
  final String accountNumber;
  final double balance;
  final DateTime lastUpdated;
  final String shortCode;
  final IconData? bankIcon;

  BankAccount({
    required this.bankName,
    required this.accountNumber,
    required this.balance,
    required this.lastUpdated,
    required this.shortCode,
    this.bankIcon,
  });

  @override
  String toString() {
    return 'BankAccount{bankName: $bankName, accountNumber: $accountNumber, balance: $balance, lastUpdated: $lastUpdated}';
  }
}