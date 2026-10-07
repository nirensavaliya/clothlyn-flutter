import 'dart:convert';
import 'dart:developer';

import 'package:clothlyn/Model/Admin_Model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Model/Employee_Model.dart';
import '../Model/company_model.dart';
import '../View/Common/Get_storage_data.dart';
import '../View/Common/Toast.dart';
import '../View/Constant/Api_Constants.dart';
import '../View/Constant/Api_Service.dart';
import '../View/Constant/App_Colors.dart';
import '../View/Constant/Screen_Protector_Service.dart';
import '../View/Utills/App_Routes.dart';
import '../View/Utills/Global.dart';
import 'Profile_Controller.dart';

class LoginController extends GetxController {
  static const String defaultClientCode = 'GI1001';

  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController employeeMobileNumberController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController employeeOtpController = TextEditingController();
  Rx<LoginViewState> currentView = LoginViewState.mobile.obs;

  RxBool isOtpSent = false.obs;
  RxBool isEmployeeView = false.obs;
  RxBool isEmployeeFlowCompleted = false.obs;
  RxBool isOtpSentForEmployeeFlow = false.obs;
  RxString getOtp = ''.obs;

  /// Other-tenant login: Client Code sheet (below Send OTP → "Other Client login")
  RxBool showOtherClientLogin = false.obs;
  /// Opened from Admin sheet → after Continue return to admin login
  RxBool otherClientFromAdmin = false.obs;
  /// Active tenant for OTP / login (Sitaram default = GI1001)
  RxString activeClientCode = defaultClientCode.obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  /// Form on FlipCard back ("Welcome Back, Admin") — separate from [formKey] to avoid duplicate GlobalKey
  final GlobalKey<FormState> adminFlipFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> clientCodeFormKey = GlobalKey<FormState>();
  final mobileFormKey = GlobalKey<FormState>();
  final otpFormKey = GlobalKey<FormState>();

  final employeeCodeController = TextEditingController();

  // final companies = ["Google", "Microsoft", "Amazon", "Infosys"].obs;
  RxString employeeCode = ''.obs;

  final ApiService _apiService = ApiService();
  RxBool isLoading = false.obs;
  RxBool isLogin = false.obs;
  RxBool isRequestOTP = false.obs;
  final companies = <CompanyModel>[].obs;
  var selectedCompany = "".obs;
  RxBool showCompanyDropdown = false.obs;
  RxBool isLogoutLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final saved = GetStorageData.readString(GetStorageData.companyCode);
    if (saved is String && saved.trim().isNotEmpty) {
      activeClientCode.value = saved.trim();
    } else {
      activeClientCode.value = defaultClientCode;
      GetStorageData.saveString(GetStorageData.companyCode, defaultClientCode);
    }
  }

  String get _clientCodeForAuth =>
      activeClientCode.value.trim().isEmpty
          ? defaultClientCode
          : activeClientCode.value.trim();

  void sendOtp() {
    if (formKey.currentState!.validate()) {
      isOtpSent.value = true;
    }
  }

  // void verifyOtp() {
  //   if (formKey.currentState!.validate()) {
  //     Get.snackbar('Success', 'OTP Verified!');
  //     Get.toNamed(AppRoutes.homeScreen);
  //   }
  // }

  void openEmployeeView() {
    currentView.value = LoginViewState.employee;

    isEmployeeView.value = true;
    showOtherClientLogin.value = false;
    isEmployeeFlowCompleted.value = false;
    isOtpSentForEmployeeFlow.value = false;
    showCompanyDropdown.value = false;
    isOtpSent.value = false;
    employeeCodeController.clear();
    employeeCode.value = '';
    companies.clear();
  }

  void openCustomerView() {
    currentView.value = LoginViewState.mobile;

    isEmployeeView.value = false;
    isEmployeeFlowCompleted.value = false;
    isOtpSentForEmployeeFlow.value = false;
    showCompanyDropdown.value = false;
    isOtpSent.value = false;
    isRequestOTP.value = false;
    showOtherClientLogin.value = false;
  }

  void openOtherClientLogin({bool fromAdmin = false}) {
    otherClientFromAdmin.value = fromAdmin;
    showOtherClientLogin.value = true;
    isEmployeeView.value = false;
    isEmployeeFlowCompleted.value = false;
    isOtpSentForEmployeeFlow.value = false;
    isOtpSent.value = false;
    isRequestOTP.value = false;
    employeeCodeController.clear();
    employeeCode.value = '';
    currentView.value = LoginViewState.mobile;
  }

  void backToSitaramLogin() {
    final returnToAdmin = otherClientFromAdmin.value;
    showOtherClientLogin.value = false;
    otherClientFromAdmin.value = false;
    isEmployeeView.value = returnToAdmin;
    isEmployeeFlowCompleted.value = false;
    isOtpSentForEmployeeFlow.value = false;
    isOtpSent.value = false;
    isRequestOTP.value = false;
    employeeCodeController.clear();
    employeeCode.value = '';
    activeClientCode.value = defaultClientCode;
    GetStorageData.saveString(GetStorageData.companyCode, defaultClientCode);
    currentView.value =
        returnToAdmin ? LoginViewState.employee : LoginViewState.mobile;
  }

  /// From Client Code sheet → always land on user (employee) mobile login.
  void backToUserLoginFromClientCode() {
    otherClientFromAdmin.value = false;
    showOtherClientLogin.value = false;
    isEmployeeView.value = false;
    isEmployeeFlowCompleted.value = false;
    isOtpSentForEmployeeFlow.value = false;
    isOtpSent.value = false;
    isRequestOTP.value = false;
    employeeCodeController.clear();
    employeeCode.value = '';
    activeClientCode.value = defaultClientCode;
    GetStorageData.saveString(GetStorageData.companyCode, defaultClientCode);
    currentView.value = LoginViewState.mobile;
  }

  /// Verify client code (MD: multi-tenant), then return to mobile OTP sheet.
  Future<void> continueWithClientCode() async {
    if (!(clientCodeFormKey.currentState?.validate() ?? false)) return;
    disposeKeyboard(Get.context!);

    final code = employeeCodeController.text.trim();
    if (code.isEmpty) {
      ToastWidget.showToastCustom("Please enter client code", color: Colors.red);
      return;
    }

    try {
      isLoading.value = true;

      final response = await _apiService.getRequest(
        "${ApiConstants.getClientByCode}$code",
      );
      log("Verify client: ${ApiConstants.getClientByCode}$code");
      log("Status Code: ${response.statusCode}");
      log("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        activeClientCode.value = code;
        employeeCode.value = code;
        await GetStorageData.saveString(GetStorageData.companyCode, code);
        showOtherClientLogin.value = false;
        isOtpSent.value = false;
        if (otherClientFromAdmin.value) {
          isEmployeeView.value = true;
          currentView.value = LoginViewState.employee;
        }
        ToastWidget.showToastCustom(
          "Client verified",
          color: AppColors.greenColor,
        );
      } else {
        ToastWidget.showToastCustom(
          response.data?['message']?.toString() ?? "Invalid Client Code",
          color: Colors.red,
        );
      }
    } catch (e) {
      ToastWidget.showToastCustom(
        e.toString().isNotEmpty ? e.toString() : "Invalid Client Code",
        color: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  EmployeeLoginResponse? _loginResponse;
  EmployeeLoginResponse? get loginResponse => _loginResponse;
  set loginResponse(EmployeeLoginResponse? value) {
    _loginResponse = value;
    update();
  }

  Future<void> loadCompanies() async {
    final code = employeeCodeController.text.trim();

    if (code.isEmpty) {
      Get.snackbar(
        "Required",
        "Please enter employee code",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      showCompanyDropdown.value = false;
      companies.clear();

      final response = await _apiService.getRequest( "${ApiConstants.getClientByCode}$code");
      log("Calling API: ${ApiConstants.getClientByCode}$code");

      log("Status Code: ${response.statusCode}");
      log("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        final data = response.data;
        GetStorageData.saveString(GetStorageData.companyCode, code);
        showCompanyDropdown.value = true;

        if (data is List) {
          companies.assignAll(
            data.map((e) => CompanyModel.fromJson(e)).toList(),
          );
        } else if (data["data"] is List) {
          companies.assignAll(
            (data["data"] as List)
                .map((e) => CompanyModel.fromJson(e))
                .toList(),
          );
        }
        isEmployeeFlowCompleted.value = true;

        // if (companies.isNotEmpty) {
        //   showCompanyDropdown.value = true;
        // } else {
        //   ToastWidget.showToastCustom("No companies found");
        // }
      }
    } catch (e) {
      ToastWidget.showToastCustom(e.toString() ?? "Invalid Client Code");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendOtpForAdmin() async {
    final onAdminFlip = isEmployeeView.value && !isEmployeeFlowCompleted.value;
    if (onAdminFlip) {
      if (!(adminFlipFormKey.currentState?.validate() ?? false)) return;
    } else {
      if (!formKey.currentState!.validate()) return;
    }
    disposeKeyboard(Get.context!);

    final mobile = employeeMobileNumberController.text.trim();

    try {
      isRequestOTP.value = true;

      final response = await _apiService.postRequest(
        ApiConstants.requestOTP,
        data: {
            "phoneNumber": mobile,
            "clientCode": _clientCodeForAuth,
            // "country_code": "+91",
        },

      );

      log("OTP Response: ${response.data}");

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData["status"] == "success") {
          final otp = responseData["data"]?["otp"] ?? "";
          getOtp.value = otp;
          GetStorageData.saveString(GetStorageData.userType, 'admin');

          ToastWidget.showToastCustom(
            "OTP Sent Successfully: $otp",
            color: AppColors.greenColor
          );

          isOtpSentForEmployeeFlow.value = true;
          isEmployeeFlowCompleted.value = true;
        } else {
          ToastWidget.showToastCustom(responseData["message"]);
        }
      }
    } catch (e) {
      ToastWidget.showToastCustom(e.toString());
    } finally {
      isRequestOTP.value = false;
    }
  }

  Future<void> verifyOtp() async {
    final enteredOtp = employeeOtpController.text.trim();

    if (enteredOtp.isEmpty) {
      ToastWidget.showToastCustom("OTP required",color: Colors.red);
      return;
    }

    if (enteredOtp.length != 6) {
      ToastWidget.showToastCustom("Enter 6 digit OTP");
      return;
    }

    if (!RegExp(r'^[0-9]{6}$').hasMatch(enteredOtp)) {
      ToastWidget.showToastCustom("OTP must contain only digits");
      return;
    }

    if (enteredOtp != getOtp.value) {
      ToastWidget.showToastCustom("Invalid OTP. Please try again.");
      return;
    }

    try {
      isLogin.value = true;

      final response = await _apiService.postRequest(
        ApiConstants.login,
        data: {
          "phoneNumber": employeeMobileNumberController.text.trim(),
          "otp": enteredOtp,
          "clientCode": _clientCodeForAuth,
        },
      );
      log("ADMIN---LOGIN Response: ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        final savedClientCode = _clientCodeForAuth;
         GetStorageData.clearAll();
        final adminResponseModel = AdminModel.fromJson(response.data);
        // loginResponse = loginResponseModel;
        final data = adminResponseModel.data;
        // final data = response.data['data'];

        ToastWidget.showToastCustom("Login Successfully.",
            color: AppColors.greenColor
        );
        await GetStorageData.saveString(GetStorageData.token, data.token);
        await GetStorageData.saveString(GetStorageData.userId, data.id);
        await GetStorageData.saveString(GetStorageData.userType, data.accountRole);
        await GetStorageData.saveString(GetStorageData.loginData, jsonEncode(data.toJson()));
        await GetStorageData.saveString(GetStorageData.isOtpVerified, "true");
        await GetStorageData.saveString(GetStorageData.companyCode, savedClientCode);
         Get.offAllNamed(AppRoutes.adminHomeScreen);

      // if (data['accountRole'] == "admin") {
      //     Get.offAllNamed(AppRoutes.adminHomeScreen);
      //   } else {
      //     Get.offAllNamed(AppRoutes.homeScreen);
      //   }
      }else {
        ToastWidget.showToastCustom(
          response.data['message'] ?? "",
          color: Colors.red,
        );
      }

    } catch (e) {
      ToastWidget.showToastCustom("Login failed",color: Colors.red);
    } finally {
      isLogin.value = false;
    }
  }

  Future<void> sendOtpForEmployee() async {
    if (!formKey.currentState!.validate()) return;
    disposeKeyboard(Get.context!);
    final mobile = mobileNumberController.text.trim();

    try {
      isRequestOTP.value = true;

      final response = await _apiService.postRequest(
        ApiConstants.requestOTP,
        data: {
          "phoneNumber": mobile,
          "clientCode": _clientCodeForAuth,
          // "country_code": "+91",
        },

      );

      log("OTP Response: ${response.data}");

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData["status"] == "success") {
          final otp = responseData["data"]?["otp"] ?? "";
          getOtp.value = otp;
          GetStorageData.saveString(GetStorageData.userType, 'admin');

          ToastWidget.showToastCustom(
            "OTP Sent Successfully: $otp",
              color: AppColors.greenColor
          );

          isOtpSent.value = true;
        } else {
          ToastWidget.showToastCustom(responseData["message"]);
        }
      }
    } catch (e) {
      ToastWidget.showToastCustom(e.toString());
    } finally {
      isRequestOTP.value = false;
    }
  }

  Future<void> verifyOtpForEmployee() async {
    final enteredOtp = otpController.text.trim();

    if (enteredOtp.isEmpty) {
      ToastWidget.showToastCustom("OTP required",color: Colors.red);
      return;
    }

    if (enteredOtp.length != 6) {
      ToastWidget.showToastCustom("Enter 6 digit OTP");
      return;
    }

    if (!RegExp(r'^[0-9]{6}$').hasMatch(enteredOtp)) {
      ToastWidget.showToastCustom("OTP must contain only digits");
      return;
    }

    if (enteredOtp != getOtp.value) {
      ToastWidget.showToastCustom("Invalid OTP. Please try again.");
      return;
    }

    try {
      isLogin.value = true;

      final response = await _apiService.postRequest(
        ApiConstants.employeeLogin,
        data: {
          "phoneNumber": mobileNumberController.text.trim(),
          "otp": enteredOtp,
          "clientCode": _clientCodeForAuth,
        },
      );
      log("EMPLOYEE---LOGIN Response: ${response.data}");

      if (response.statusCode == 200) {
        final loginResponseModel = EmployeeLoginResponse.fromJson(response.data);
        // loginResponse = loginResponseModel;
        final data = loginResponseModel.data;

        ToastWidget.showToastCustom("Login Successfully.",
            color: AppColors.greenColor
        );
        await GetStorageData.saveString(GetStorageData.token, data.token);
        await GetStorageData.saveString(GetStorageData.userId, data.user.id);
        await GetStorageData.saveString(GetStorageData.userType, data.user.employeeRole);
        await GetStorageData.saveString(GetStorageData.loginData, jsonEncode(data.user.toJson()));
        await GetStorageData.saveString(GetStorageData.isOtpVerified, "true");
        await GetStorageData.saveString(
          GetStorageData.companyCode,
          _clientCodeForAuth,
        );
        await ScreenSecurityService.enableForEmployee();
        Get.offAllNamed(AppRoutes.homeScreen);

        /*if (data['accountRole'] == "admin") {
          Get.offAllNamed(AppRoutes.adminHomeScreen);
        } else {
          Get.offAllNamed(AppRoutes.homeScreen);
        }*/
      }

    } catch (e) {
      ToastWidget.showToastCustom("Login failed",color: Colors.red);
    } finally {
      isLogin.value = false;
    }
  }


  Future<void> logout() async {
    try {
      isLogoutLoading.value = true;

      final token = GetStorageData.readString(GetStorageData.token);

      if (token == null) {
        ToastWidget.showToastCustom("User not logged in");
        return;
      }

      final response = await _apiService.postRequest(
        ApiConstants.logOut,
        headers: {
          "Authorization": "Bearer $token",
          // "accept": "*/*",
        },
      );

      log("Logout Response: ${response.data}");

      if (response.statusCode == 200) {
        ToastWidget.showToastCustom(
          response.data['message'] ?? "Logout Successfully!",
            color: AppColors.greenColor
        );
        await GetStorageData.removeData(GetStorageData.loginData);
        await ScreenSecurityService.disable();
        GetStorageData.clearAll();
        await GetStorageData.saveString(GetStorageData.isOtpVerified, "false");
        Get.delete<UserProfileController>();

        Get.offAllNamed(AppRoutes.loginScreen);
      }

    } catch (e) {
      ToastWidget.showToastCustom(
        "Logout failed",
        color: Colors.red,
      );
      isLogoutLoading.value = false;
    }finally{
      isLogoutLoading.value = false;

    }
  }

}
