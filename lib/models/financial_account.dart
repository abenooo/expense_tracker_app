import 'bank_type.dart';
import 'transaction.dart';

class FinancialAccount {
  final String bankType;
  final String accountNumber;
  final double balance;
  final List<Transaction> transactions;
  final DateTime? lastUpdated;

  FinancialAccount({
    required this.bankType,
    required this.accountNumber,
    required this.balance,
    required this.transactions,
    this.lastUpdated,
  });
}

