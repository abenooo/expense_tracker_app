import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import '../models/bank_type.dart';
import '../models/transaction_type.dart';
import '../models/transaction.dart';
import '../models/financial_account.dart';

class SmsParserService {
  final SmsQuery _query = SmsQuery();

  Future<List<FinancialAccount>> parseAllFinancialSms() async {
    // Use mock data instead of querying actual SMS messages
    final List<SmsMessage> mockMessages = _generateMockSmsMessages();

    final Map<String, List<Transaction>> accountTransactions = {};
    final Map<String, double> accountBalances = {};
    
    for (var message in mockMessages) {
      final transaction = _parseTransaction(message);
      if (transaction != null) {
        final accountKey = '${transaction.bankType}-${transaction.accountNumber}';
        accountTransactions.putIfAbsent(accountKey, () => []);
        accountTransactions[accountKey]!.add(transaction);
        
        // Update the account balance
        accountBalances[accountKey] = (accountBalances[accountKey] ?? 0) + 
          (transaction.type == TransactionType.deposit ? transaction.amount : -transaction.amount);
      }
    }

    return accountTransactions.entries.map((entry) {
      final accountKey = entry.key;
      final transactions = entry.value;
      final firstTx = transactions.first;
      return FinancialAccount(
        bankType: firstTx.bankType,
        accountNumber: firstTx.accountNumber,
        balance: accountBalances[accountKey] ?? 0,
        transactions: transactions,
        lastUpdated: transactions.map((t) => t.date).reduce((a, b) => a.isAfter(b) ? a : b),
      );
    }).toList();
  }

  List<SmsMessage> _generateMockSmsMessages() {
    return [
      SmsMessage.fromJson({
        'id': 1,
        'address': 'CBEBirr',
        'body': 'You have received ETB 1,000.00 from 0911234567. Your new balance is ETB 5,000.00.',
        'date': DateTime.now().subtract(Duration(days: 1)).millisecondsSinceEpoch,
      }),
      SmsMessage.fromJson({
        'id': 2,
        'address': 'BOA',
        'body': 'Your Acc No *1234 is credited by ETB 2,500.00 on 05/07/23. Available balance is ETB 7,500.00.',
        'date': DateTime.now().subtract(Duration(days: 2)).millisecondsSinceEpoch,
      }),
      SmsMessage.fromJson({
        'id': 3,
        'address': 'CBE',
        'body': 'Your Acc No *5678 is debited by ETB 500.00 on 04/07/23. Available balance is ETB 4,500.00.',
        'date': DateTime.now().subtract(Duration(days: 3)).millisecondsSinceEpoch,
      }),
      SmsMessage.fromJson({
        'id': 4,
        'address': 'Dashen Bank',
        'body': 'Your account *9012 has been credited with ETB 3,000.00. Your new balance is ETB 8,000.00.',
        'date': DateTime.now().subtract(Duration(days: 4)).millisecondsSinceEpoch,
      }),
      SmsMessage.fromJson({
        'id': 5,
        'address': 'HibretBank',
        'body': 'ETB 1,500.00 has been deposited to your account *3456. Your current balance is ETB 6,500.00.',
        'date': DateTime.now().subtract(Duration(days: 5)).millisecondsSinceEpoch,
      }),
      SmsMessage.fromJson({
        'id': 6,
        'address': '127',
        'body': 'You have sent ETB 200.00 to 0922345678. Your TeleBirr balance is ETB 800.00.',
        'date': DateTime.now().subtract(Duration(days: 6)).millisecondsSinceEpoch,
      }),
    ];
  }

  Transaction? _parseTransaction(SmsMessage message) {
    // CBE Pattern: "Your Acc No *1234 is credited by ETB 1,000.00 on 01/01/24"
    if (message.address == 'CBE') {
      final match = RegExp(r'Acc No \*(\d+).*(credited|debited).* ETB ([\d,]+\.\d{2})').firstMatch(message.body ?? '');
      if (match != null) {
        return Transaction(
          amount: double.parse(match.group(3)!.replaceAll(',', '')),
          type: match.group(2) == 'credited' ? TransactionType.deposit : TransactionType.withdrawal,
          date: message.date ?? DateTime.now(),
          description: message.body ?? '',
          bankType: BankType.cbe,
          accountNumber: match.group(1)!,
        );
      }
    }
    
    // CBEBirr Pattern
    if (message.address == 'CBEBirr') {
      final match = RegExp(r'(received|sent) ETB ([\d,]+\.\d{2})').firstMatch(message.body ?? '');
      if (match != null) {
        return Transaction(
          amount: double.parse(match.group(2)!.replaceAll(',', '')),
          type: match.group(1) == 'received' ? TransactionType.deposit : TransactionType.withdrawal,
          date: message.date ?? DateTime.now(),
          description: message.body ?? '',
          bankType: BankType.cbeBirr,
          accountNumber: 'WALLET',
        );
      }
    }

    // BOA Pattern
    if (message.address == 'BOA') {
      final match = RegExp(r'Acc No \*(\d+).*(credited|debited).* ETB ([\d,]+\.\d{2})').firstMatch(message.body ?? '');
      if (match != null) {
        return Transaction(
          amount: double.parse(match.group(3)!.replaceAll(',', '')),
          type: match.group(2) == 'credited' ? TransactionType.deposit : TransactionType.withdrawal,
          date: message.date ?? DateTime.now(),
          description: message.body ?? '',
          bankType: BankType.boa,
          accountNumber: match.group(1)!,
        );
      }
    }

    // Dashen Bank Pattern
    if (message.address == 'Dashen Bank') {
      final match = RegExp(r'account \*(\d+).*(credited|debited).* ETB ([\d,]+\.\d{2})').firstMatch(message.body ?? '');
      if (match != null) {
        return Transaction(
          amount: double.parse(match.group(3)!.replaceAll(',', '')),
          type: match.group(2) == 'credited' ? TransactionType.deposit : TransactionType.withdrawal,
          date: message.date ?? DateTime.now(),
          description: message.body ?? '',
          bankType: BankType.dashen,
          accountNumber: match.group(1)!,
        );
      }
    }

    // Hibret Bank Pattern
    if (message.address == 'HibretBank') {
      final match = RegExp(r'ETB ([\d,]+\.\d{2}).*(deposited|withdrawn).*account \*(\d+)').firstMatch(message.body ?? '');
      if (match != null) {
        return Transaction(
          amount: double.parse(match.group(1)!.replaceAll(',', '')),
          type: match.group(2) == 'deposited' ? TransactionType.deposit : TransactionType.withdrawal,
          date: message.date ?? DateTime.now(),
          description: message.body ?? '',
          bankType: BankType.hibret,
          accountNumber: match.group(3)!,
        );
      }
    }

    // 127 Pattern (TeleBirr)
    if (message.address == '127') {
      final match = RegExp(r'(sent|received) ETB ([\d,]+\.\d{2})').firstMatch(message.body ?? '');
      if (match != null) {
        return Transaction(
          amount: double.parse(match.group(2)!.replaceAll(',', '')),
          type: match.group(1) == 'received' ? TransactionType.deposit : TransactionType.withdrawal,
          date: message.date ?? DateTime.now(),
          description: message.body ?? '',
          bankType: BankType.telebirr,
          accountNumber: 'WALLET',
        );
      }
    }

    return null;
  }
}

