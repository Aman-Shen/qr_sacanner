
import 'dart:async';

import 'package:flutter/services.dart';

class QRScanner {
  static const MethodChannel _channel = const MethodChannel('qr_scanner');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String?> scannerCodeResult() async{
    final String? strResult = await _channel.invokeMethod('scannerCodeResult');
    return strResult;
  }
}
