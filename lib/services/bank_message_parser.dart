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
      'name': 'Commercial Bank of Ethiopia Birr',
      'icon': Icons.account_balance
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
    'HibretBank': {
      'name': 'Hibret Bank',
      'icon': Icons.account_balance
    },
    'MPESA': {
      'name': 'M-PESA',
      'icon': Icons.phone_android
    },
  };

  static BankAccount? parseMessage(SmsMessage message) {
    final sender = message.sender ?? '';
    final body = message.body ?? '';
    
    String? bankName;
    IconData? bankIcon;
    for (var entry in _bankCodes.entries) {
      if (sender.contains(entry.key) || body.contains(entry.key)) {
        bankName = entry.value['name'];
        bankIcon = entry.value['icon'];
        // Special case for CBE and CBEBirr
        if (entry.key == 'CBEBirr' || (entry.key == 'CBE' && body.contains('CBE Birr'))) {
          bankName = 'Commercial Bank of Ethiopia Birr';
        } else if (entry.key == 'CBE') {
          bankName = 'Commercial Bank of Ethiopia';
        }
        break;
      }
    }
    
    if (bankName == null) return null;

    String accountNumber = '';
    double balance = 0.0;
    DateTime? lastUpdated;

    if (bankName == 'Awash Bank') {
      final accountMatch = RegExp(r'Account (\d+\*+\d+)').firstMatch(body);
      accountNumber = accountMatch?.group(1) ?? '';
      final balanceMatch = RegExp(r'Your balance now is ETB ([-\d,.]+)').firstMatch(body);
      balance = _parseBalance(balanceMatch?.group(1));
      final dateMatch = RegExp(r'on (\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})').firstMatch(body);
      if (dateMatch != null) {
        lastUpdated = DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateMatch.group(1)!);
      }
    } else if (bankName == 'Commercial Bank of Ethiopia') {
      final accountMatch = RegExp(r'Account (\d+\*+\d+)').firstMatch(body);
      accountNumber = accountMatch?.group(1) ?? '';
      final balanceMatch = RegExp(r'Current Balance is ETB ([-\d,.]+)').firstMatch(body);
      balance = _parseBalance(balanceMatch?.group(1));
      lastUpdated = message.date;
    } else if (bankName == 'Commercial Bank of Ethiopia Birr') {
      final balanceMatch = RegExp(r'CBE Birr account balance is ([-\d,.]+)').firstMatch(body);
      balance = _parseBalance(balanceMatch?.group(1));
      final accountMatch = RegExp(r'for (\d+)').firstMatch(body);
      accountNumber = accountMatch?.group(1) ?? 'CBE Birr Account';
      lastUpdated = message.date;
    } else if (bankName == 'Bank of Abyssinia') {
      final boaAccountMatch = RegExp(r'your account (\d+\*\d+)').firstMatch(body);
      final accountMatch = RegExp(r'account (\d+\*\d+)').firstMatch(body);
      accountNumber = accountMatch?.group(1) ?? boaAccountMatch?.group(1) ?? '';
      final balanceMatch = RegExp(r'available balance in the account is ETB ([-\d,.]+)').firstMatch(body);
      balance = _parseBalance(balanceMatch?.group(1));
      final dateMatch = RegExp(r'on (\d{2}/\d{2}/\d{4})').firstMatch(body);
      if (dateMatch != null) {
        lastUpdated = DateFormat('dd/MM/yyyy').parse(dateMatch.group(1)!);
      }
    } else if (bankName == 'Telebirr') {
      final customerIncentiveMatch = RegExp(r'Customer Incentive Account Balance is : ETB ([-\d,.]+)').firstMatch(body);
      final eMoneyMatch = RegExp(r'E-Money Account Balance is : ETB ([-\d,.]+)').firstMatch(body);
      final oldFormatMatch = RegExp(r'Your current balance is ETB ([-\d,.]+)').firstMatch(body);
      
      if (customerIncentiveMatch != null && eMoneyMatch != null) {
        double customerIncentiveBalance = _parseBalance(customerIncentiveMatch.group(1));
        double eMoneyBalance = _parseBalance(eMoneyMatch.group(1));
        balance = customerIncentiveBalance + eMoneyBalance;
        accountNumber = 'Telebirr Account';
      } else if (oldFormatMatch != null) {
        balance = _parseBalance(oldFormatMatch.group(1));
        final accountMatch = RegExp(r'telebirr account (\d+)').firstMatch(body);
        accountNumber = accountMatch?.group(1) ?? 'Telebirr Account';
      }
      lastUpdated = message.date;
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
    final cleanedString = balanceString.replaceAll(RegExp(r'[^\d.-]'), '');
    return double.tryParse(cleanedString) ?? 0.0;
  }
}
