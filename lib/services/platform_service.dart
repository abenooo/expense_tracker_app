import 'dart:io';
import 'package:flutter/foundation.dart';

class PlatformService {
  static bool get isIOSSimulator {
    return Platform.isIOS && !Platform.isAndroid && kDebugMode;
  }
}