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

    return BankMessageParser.parseMessages(messages);
  }
}

