import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import '../models/bank_account.dart';
import 'bank_message_parser.dart';
import 'mock_bank_service.dart';
import 'platform_service.dart';

class BankService {
  final SmsQuery _query = SmsQuery();
  final MockBankService _mockService = MockBankService();
  
  Future<bool> requestSmsPermission() async {
    if (PlatformService.isIOSSimulator) {
      return true;
    }
    final permission = await Permission.sms.request();
    return permission.isGranted;
  }

  Future<List<BankAccount>> getBankAccounts() async {
    if (PlatformService.isIOSSimulator) {
      return _mockService.getMockAccounts();
    }

    if (!await requestSmsPermission()) {
      throw Exception('SMS permission denied');
    }

    final messages = await _query.querySms(
      kinds: [SmsQueryKind.inbox],
      count: 100,
    );

    final Map<String, BankAccount> latestAccounts = {};
    
    for (var message in messages) {
      final account = BankMessageParser.parseMessage(message);
      if (account != null) {
        final key = '${account.bankName}_${account.accountNumber}';
        if (!latestAccounts.containsKey(key) ||
            latestAccounts[key]!.lastUpdated.isBefore(account.lastUpdated)) {
          latestAccounts[key] = account;
        }
      }
    }

    return latestAccounts.values.toList();
  }
}