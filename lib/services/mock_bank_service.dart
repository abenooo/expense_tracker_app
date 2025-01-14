import '../models/bank_account.dart';
import 'package:flutter/material.dart';

class MockBankService {
  Future<List<BankAccount>> getMockAccounts() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    return [
      BankAccount(
        bankName: 'Commercial Bank',
        accountNumber: '1000200030004000',
        balance: 25000.00,
        lastUpdated: DateTime.now(),
        shortCode: 'CBE',
        bankIcon: Icons.account_balance,
      ),
      BankAccount(
        bankName: 'Bank of Abyssinia',
        accountNumber: '2000300040005000',
        balance: 15000.00,
        lastUpdated: DateTime.now().subtract(const Duration(hours: 2)),
        shortCode: 'BOA',
        bankIcon: Icons.account_balance,
      ),
      BankAccount(
        bankName: 'Telebirr',
        accountNumber: '3000400050006000',
        balance: 5000.00,
        lastUpdated: DateTime.now().subtract(const Duration(hours: 1)),
        shortCode: '127',
        bankIcon: Icons.phone_android,
      ),
    ];
  }
}