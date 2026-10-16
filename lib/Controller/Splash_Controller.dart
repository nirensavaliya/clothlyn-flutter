import 'dart:developer';

import 'package:clothlyn/Service/Force_Update.dart';
import 'package:clothlyn/View/Constant/Api_Constants.dart';
import 'package:clothlyn/View/Constant/Api_Service.dart';
import 'package:clothlyn/View/Utills/App_Routes.dart';
import 'package:get/get.dart';

import '../View/Common/Get_storage_data.dart';
import '../View/Constant/Screen_Protector_Service.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _start();
  }

  Future<void> _start() async {
    await Future.delayed(const Duration(minutes: 5));

    final apkUrl = await appReleaseApi();

    final ctx = Get.context;
    if (ctx != null) {
      final blocked = await ForceUpdate.checkAndBlockIfNeeded(
        ctx,
        apkUrl: apkUrl,
      );
      if (blocked) return;
    }

    await _goNext();
  }

  Future<void> _goNext() async {
    final token = GetStorageData.readString(GetStorageData.token);
    final userType = GetStorageData.readString(GetStorageData.userType);
    final isLoggedIn = GetStorageData.readString(GetStorageData.isOtpVerified);

    print('token-----${token}');
    print('userType-----${userType}');
    print('isLoggedIn-----${isLoggedIn}');

    if (token != null && isLoggedIn == "true") {
      if (userType == "admin") {
        await ScreenSecurityService.disable();
        Get.offAllNamed(AppRoutes.adminHomeScreen);
      } else {
        await ScreenSecurityService.enableForEmployee();
        Get.offAllNamed(AppRoutes.homeScreen);
      }

    } else {
      Get.offAllNamed(AppRoutes.loginScreen);
    }
  }

  Future<String?> appReleaseApi() async {
    try {
      final response = await ApiService().getRequest(ApiConstants.appRelease);
      if (response.statusCode != 200) return null;

      final body = response.data;
      final data = body is Map ? body['data'] : null;
      if (data is! Map) return null;

      final url = data['apkUrl']?.toString().trim() ?? '';
      print('url--------${url}');
      return url.isEmpty ? null : url;
    } catch (e) {
      log("app release API error: $e");
      return null;
    }
  }
}
