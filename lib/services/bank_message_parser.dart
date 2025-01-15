import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import '../models/bank_account.dart';
import 'package:intl/intl.dart';

class BankMessageParser {
  static final Map<String, Map<String, dynamic>> _bankCodes = {
    'CBE': {
      'name': 'Commercial Bank of Ethiopia',
      'icon': Icons.account_balance
    },
    'CBEBirr': {
      'name': 'CBE Birr',
      'icon': Icons.account_balance_wallet
    },
    'BOA': {
      'name': 'Bank of Abyssinia',
      'icon': Icons.account_balance
    },
    'Awash': {
      'name': 'Awash Bank',
      'icon': Icons.account_balance
    },
    '127': {
      'name': 'Telebirr',
      'icon': Icons.phone_android
    },
    'Dashen': {
      'name': 'Dashen Bank',
      'icon': Icons.account_balance
    },
    'Hibret': {
      'name': 'Hibret Bank',
      'icon': Icons.account_balance
    },
    'MPESA': {
      'name': 'M-PESA',
      'icon': Icons.phone_android
    },
  };

  static List<BankAccount> parseMessages(List<SmsMessage> messages) {
    Map<String, BankAccount> latestAccounts = {};

    for (var message in messages) {
      final account = _parseSingleMessage(message);
      if (account != null) {
        final key = _getAccountKey(account);
        if (!latestAccounts.containsKey(key) ||
            account.lastUpdated.isAfter(latestAccounts[key]!.lastUpdated)) {
          latestAccounts[key] = account;
        }
      }
    }

    // Filter out accounts with zero balance for CBE Bank
    return latestAccounts.values.where((account) => 
      account.bankName != 'Commercial Bank of Ethiopia' || account.balance != 0
    ).toList();
  }

  static String _getAccountKey(BankAccount account) {
    if (account.bankName == 'CBE Birr' || account.bankName == 'Telebirr') {
      return account.bankName;
    } else if (account.bankName == 'Commercial Bank of Ethiopia') {
      // Use the full account number as the key for CBE Bank accounts
      return '${account.bankName}_${account.accountNumber}';
    } else {
      return '${account.bankName}_${account.accountNumber}';
    }
  }

  static BankAccount? _parseSingleMessage(SmsMessage message) {
    final sender = message.sender ?? '';
    final body = message.body ?? '';

    String? bankName;
    IconData? bankIcon;
    for (var entry in _bankCodes.entries) {
      if (sender.contains(entry.key) || body.contains(entry.key)) {
        bankName = entry.value['name'];
        bankIcon = entry.value['icon'];
        break;
      }
    }

    if (bankName == null) return null;

    String accountNumber = '';
    double balance = 0.0;
    DateTime? lastUpdated;

    if (bankName == 'Commercial Bank of Ethiopia') {
      if (body.contains('CBE Birr')) {
        bankName = 'CBE Birr';
        final balanceMatch = RegExp(r'CBE Birr account balance is ([-\d,.]+)').firstMatch(body);
        balance = _parseBalance(balanceMatch?.group(1));
        accountNumber = 'CBE Birr Account';
      } else {
        final accountMatch = RegExp(r'Account (\d+)').firstMatch(body);
        accountNumber = accountMatch?.group(1) ?? '';
        final balanceMatch = RegExp(r'Current Balance is ETB ([-\d,.]+)').firstMatch(body);
        balance = _parseBalance(balanceMatch?.group(1));
      }
      lastUpdated = message.date;
    } else if (bankName == 'Bank of Abyssinia') {
      final accountMatch = RegExp(r'your account (\d+\*\d+)').firstMatch(body);
      accountNumber = accountMatch?.group(1) ?? '';
      final balanceMatch = RegExp(r'available balance in the account is ETB ([-\d,.]+)').firstMatch(body);
      balance = _parseBalance(balanceMatch?.group(1));
      final dateMatch = RegExp(r'on (\d{2}/\d{2}/\d{4})').firstMatch(body);
      if (dateMatch != null) {
        lastUpdated = DateFormat('dd/MM/yyyy').parse(dateMatch.group(1)!);
      } else {
        lastUpdated = message.date;
      }
    } else if (bankName == 'Telebirr') {
      final customerIncentiveMatch = RegExp(r'Customer Incentive Account Balance is : ETB ([-\d,.]+)').firstMatch(body);
      final eMoneyMatch = RegExp(r'E-Money Account Balance is : ETB ([-\d,.]+)').firstMatch(body);
      final oldFormatMatch = RegExp(r'Your current balance is ETB ([-\d,.]+)').firstMatch(body);

      if (customerIncentiveMatch != null && eMoneyMatch != null) {
        double customerIncentiveBalance = _parseBalance(customerIncentiveMatch.group(1));
        double eMoneyBalance = _parseBalance(eMoneyMatch.group(1));
        balance = customerIncentiveBalance + eMoneyBalance;
      } else if (oldFormatMatch != null) {
        balance = _parseBalance(oldFormatMatch.group(1));
      }
      accountNumber = 'Telebirr Account';
      lastUpdated = message.date;
    } else if (bankName == 'Awash Bank') {
      final accountMatch = RegExp(r'Account (\d+\*+\d+)').firstMatch(body);
      accountNumber = accountMatch?.group(1) ?? '';
      final balanceMatch = RegExp(r'Your balance now is ETB ([-\d,.]+)').firstMatch(body);
      balance = _parseBalance(balanceMatch?.group(1));
      final dateMatch = RegExp(r'on (\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})').firstMatch(body);
      if (dateMatch != null) {
        lastUpdated = DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateMatch.group(1)!);
      }
    } else if (bankName == 'Hibret Bank') {
      final accountMatch = RegExp(r'Account No : (\d+)').firstMatch(body);
      accountNumber = accountMatch?.group(1) ?? '';
      final balanceMatch = RegExp(r'Available Balance ETB ([-\d,.]+)').firstMatch(body);
      balance = _parseBalance(balanceMatch?.group(1));
      lastUpdated = message.date;
    } else if (bankName == 'M-PESA') {
      final balanceMatch = RegExp(r'የM-PESA ቀሪ ሒሳብ ([-\d,.]+) ብር ነው').firstMatch(body);
      balance = _parseBalance(balanceMatch?.group(1));
      accountNumber = 'M-PESA Account';
      final dateMatch = RegExp(r'በ(\d{1,2}/\d{1,2}/\d{2}) በ(\d{1,2}:\d{2} [APM]{2})').firstMatch(body);
      if (dateMatch != null) {
        final date = dateMatch.group(1)!;
        final time = dateMatch.group(2)!;
        lastUpdated = DateFormat('dd/MM/yy hh:mm a').parse('$date $time');
      }
    } else if (bankName == 'Dashen Bank') {
      final accountMatch = RegExp(r'account (\d+\*+\d+)').firstMatch(body);
      accountNumber = accountMatch?.group(1) ?? '';
      final balanceMatch = RegExp(r'balance (?:is|:) (?:ETB|Birr)? ?([-\d,.]+)').firstMatch(body);
      balance = _parseBalance(balanceMatch?.group(1));
      lastUpdated = message.date;
    }

    print('Parsed account: $bankName, $accountNumber, $balance');
    print('Original message: ${message.body}');
    return BankAccount(
      bankName: bankName,
      accountNumber: accountNumber,
      balance: balance,
      lastUpdated: lastUpdated ?? DateTime.now(),
      shortCode: sender,
      bankIcon: bankIcon,
    );
  }

  static double _parseBalance(String? balanceString) {
    if (balanceString == null) return 0.0;
    final cleanedString = balanceString.replaceAll(RegExp(r'[^‌\d.-]'), '');
    return double.tryParse(cleanedString) ?? 0.0;
  }
}
