import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:screen_protector/screen_protector.dart';
import '../Common/Get_storage_data.dart';

class ScreenSecurityService {
  static Future<void> enableForEmployee() async {
    if (kIsWeb) return;

    if (Platform.isAndroid) {
      await ScreenProtector.protectDataLeakageOn();
    } else if (Platform.isIOS) {
      await ScreenProtector.preventScreenshotOn();
      await ScreenProtector.protectDataLeakageWithBlur();
    }
  }

  static Future<void> disable() async {
    if (kIsWeb) return;

    if (Platform.isAndroid) {
      await ScreenProtector.protectDataLeakageOff();
    } else if (Platform.isIOS) {
      await ScreenProtector.preventScreenshotOff();
      await ScreenProtector.protectDataLeakageWithBlurOff();
    }
  }

  static bool isEmployeeSession() {
    final userType = GetStorageData.readString(GetStorageData.userType);
    return userType == 'employee';
  }
}