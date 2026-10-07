import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Model/User_Model.dart';
import '../View/Common/Get_storage_data.dart';

class UserProfileController extends GetxController {
  RxBool isEditing = false.obs;
  final nameCtrl = TextEditingController(text: "Admin");
  final phoneCtrl = TextEditingController(text: "7575003800");
  final dobCtrl = TextEditingController(text: "January 1, 2001");
  final emailCtrl = TextEditingController(text: "admin@example.com");
  final addressCtrl = TextEditingController(text: "Admin Address");
   User? user;

  void onEditProfile() {
    isEditing.value = true;
  }

  void onCancel() {
    isEditing.value = false;
  }

  void onSave() {
    ///API call here
    print(nameCtrl.text);
    print(emailCtrl.text);
    print(addressCtrl.text);

    isEditing.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  void loadUserProfile() async {
    user = null;

    final loginDataString =
    await GetStorageData.readString(GetStorageData.loginData);
    final userType =
    await GetStorageData.readString(GetStorageData.userType);

    print("USER TYPE: $userType");

    if (loginDataString != null && loginDataString.isNotEmpty) {
      final Map<String, dynamic> jsonData =
      jsonDecode(loginDataString);

      if (userType == "admin") {
        loadAdminProfile(jsonData);
      } else if (userType == "employee") {
        loadEmployeeProfile(jsonData);
      } else {
        print("Unknown role: $userType");
      }

      update();
    } else {
      print("No user data found");
    }
  }

  void loadEmployeeProfile(Map<String, dynamic> jsonData) {
    user = User.fromJson(jsonData);

    nameCtrl.text = "${user?.name ?? ''}";
    phoneCtrl.text = user?.phoneNumber ?? '';
    emailCtrl.text = user?.email ?? '';
    addressCtrl.text = "Employee";

    print('email-----${jsonData['email']}');
    addressCtrl.text = "Employee";
    update();
  }

  void loadAdminProfile(Map<String, dynamic> jsonData) {
    user = User.fromJson(jsonData);

    nameCtrl.text = user?.name ?? 'Admin';
    phoneCtrl.text = user?.phoneNumber ?? '';
    emailCtrl.text = user?.email ?? '';
    print('email-----${jsonData['email']}');
    print('email-----${jsonData['username']}');
    addressCtrl.text = "admin";
    update();
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    addressCtrl.dispose();
    super.onClose();
  }
}
