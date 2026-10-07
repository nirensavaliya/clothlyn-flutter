import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:image_picker/image_picker.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import '../Model/Employee_list_Model.dart';
import '../Model/Process_List_Model.dart';
import '../View/Common/Get_storage_data.dart';
import '../View/Common/Toast.dart';
import '../View/Constant/Api_Constants.dart';
import '../View/Constant/Api_Service.dart';

class EmployeeController extends GetxController {
  final ApiService _apiService = ApiService();

  RxList<EmployeeModel> employees = <EmployeeModel>[].obs;
  RxList<EmployeeModel> filteredList = <EmployeeModel>[].obs;
  TextEditingController searchController = TextEditingController();

  RxList<ProcessRateModel> process = <ProcessRateModel>[].obs;

  RxBool isLoading = false.obs;
  RxBool isDeleteDesignLoading = false.obs;
  RxBool isAddingAdmin = false.obs;
  RxBool isUpdatingAdmin = false.obs;
  RxBool isMoreLoading = false.obs;
  RxBool hasMore = true.obs;
  RxBool showActive = true.obs;
  RxString searchText = "".obs;

  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController employeeCodeController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController nickNameController = TextEditingController();
  TextEditingController processNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController aadhaarNumberController = TextEditingController();
  TextEditingController referenceNameController = TextEditingController();
  TextEditingController referenceMobileNumberController = TextEditingController();
  TextEditingController acNumberController = TextEditingController();
  TextEditingController acHolderNameController = TextEditingController();
  TextEditingController ifscCodeController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController bankBranchNameController = TextEditingController();
  RxList<String> selectedList = <String>[].obs;
  final MultiSelectController<String> machineController = MultiSelectController();
  final MultiSelectController<String> scanPermissionController = MultiSelectController();

  int currentPage = 1;
  static const int limit = 25  ;

  Rxn<File> aadhaarFrontImage = Rxn<File>();
  Rxn<File> aadhaarBackImage = Rxn<File>();
  RxnString selectedRole = RxnString();

  Future<void> pickImage(bool isFront) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (isFront) {
        aadhaarFrontImage.value = File(pickedFile.path);
      } else {
        aadhaarBackImage.value = File(pickedFile.path);
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadFirstPage();
    fetchProcess();
  }

  void toggle(int index) {
    showActive.value = index == 0;
  }

  List<DropdownItem<String>> get machineItems {
    return process.map((e) {
      return DropdownItem<String>(
        label: e.processName ?? "",
        value: e.userId.toString(),
      );
    }).toList();
  }

  String? get _token => GetStorageData.readString(GetStorageData.token);

  Future<void> loadFirstPage() async {
    final token = _token;
    if (token == null || token.isEmpty) return;
    await fetchEmployees(isRefresh: true, token: token);
  }

  Future<void> loadNextPage() async {
    final token = _token;
    if (token == null || token.isEmpty) return;
    if (!hasMore.value || isMoreLoading.value || isLoading.value) return;
    await fetchEmployees(isRefresh: false, token: token);
  }

  void onSearch(String value) {
    searchText.value = value;
    loadFirstPage();
  }

  Future<void> fetchEmployees({
    required bool isRefresh,
    required String token,
  }) async {
    if (isRefresh) {
      currentPage = 1;
      hasMore.value = true;
      employees.clear();
    }

    if (!hasMore.value) return;
    if (isLoading.value || isMoreLoading.value) return;

    try {
      if (currentPage == 1) {
        isLoading.value = true;
      } else {
        isMoreLoading.value = true;
      }

      final response = await _apiService.getRequest(
        ApiConstants.employees,
        queryParams: {
          "search": searchText.value.isEmpty ? null : searchText.value,
          "page": currentPage,
          "limit": limit,
          "sortDirection":"asc"
        },
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final json = response.data;
        final list = json['data'] as List?;
        final pagination = json['pagination'];

        if (list != null && list.isNotEmpty) {
          final List<EmployeeModel> fetched =
              list.map((e) => EmployeeModel.fromJson(e as Map<String, dynamic>)).toList();
          employees.addAll(fetched);
        }

        if (pagination != null && pagination is Map) {
          final int page = pagination['page'] ?? currentPage;
          final int pages = pagination['pages'] ?? 1;
          hasMore.value = page < pages;
        } else {
          hasMore.value = (list?.length ?? 0) >= limit;
        }
        currentPage++;
      } else {
        hasMore.value = false;
      }
    } on DioException catch (e) {
      hasMore.value = false;
      log("Error fetching employees: ${e.response?.data ?? e.message}");
    } catch (e) {
      hasMore.value = false;
      rethrow;
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }


  List<EmployeeModel> get filteredEmployees {
    return employees.where((e) {
      if (showActive.value) {
        return e.isActive;
      } else {
        return !e.isActive;
      }
    }).toList();
  }


  Future<void> toggleEmployeeStatus({
    required EmployeeModel employee,
    required bool value,
  }) async {
    final token = _token;
    if (token == null) return;

    final newStatus = value ? "active" : "inactive";

    try {
      final response = await _apiService.putRequest(
        "${ApiConstants.employees}/${employee.id}",
        data: {
          "status": newStatus,
        },
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final updatedJson = response.data['data'];

        final updatedEmployee = EmployeeModel.fromJson(updatedJson);

        int index = employees.indexWhere((e) => e.id == employee.id);

        if (index != -1) {
          employees[index].status = updatedEmployee.status;
          employees.refresh();
          ToastWidget.showToastCustom(
            "User Updated Successfully",
            color: Colors.green,
          );
        }
      }
    } catch (e) {
      log("Toggle error: $e");
    }
  }

  Future<bool> addEmployee() async {
    final token = _token;
    if (token == null) return false;

    try {
      isAddingAdmin.value = true;

      final selectedMachineIds =
      machineController.selectedItems
          .map((e) => e.value)
          .toList();

      final selectedScanIds =
      scanPermissionController.selectedItems
          .map((e) => e.value)
          .toList();

      log('selectedMachineIds----${selectedMachineIds}');
      log('selectedScanIds----${selectedScanIds}');

      FormData formData = FormData.fromMap({
        "employeeName": employeeCodeController.text,
        "firstName": firstNameController.text,
        "lastName": lastNameController.text,
        "nickname": nickNameController.text,
        "email": emailController.text,
        "mobileNumber": mobileNumberController.text,
        "adharNumber": aadhaarNumberController.text,

        "accountNumber": acNumberController.text,
        "accountHolderName": acHolderNameController.text,
        "ifscCode": ifscCodeController.text,
        "bankName": bankNameController.text,
        "bankBranchName": bankBranchNameController.text,

        "referenceName": referenceNameController.text,
        "referenceMobileNumber": referenceMobileNumberController.text,

        "employeeRole": ["employee"],
        "role": selectedMachineIds,
        "machine": [],
        "scanPermission": selectedScanIds,
        "adharCardFront": aadhaarFrontImage.value != null
            ? aadhaarFrontImage.value!.path.split('/').last
            : "",

        "adharCardBack": aadhaarBackImage.value != null
            ? aadhaarBackImage.value!.path.split('/').last
            : "",
      });

      log("=========== REQUEST DATA ===========");

      formData.fields.forEach((field) {
        log("${field.key} : ${field.value}");
      });

      formData.files.forEach((file) {
        log("FILE -> ${file.key} : ${file.value.filename}");
      });

      log('formData-------${formData}');

      final response = await _apiService.postRequest(
        ApiConstants.employees,
        data: formData,
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        loadFirstPage();
        return true;
      } else {
        ToastWidget.showToastCustom(
          "Failed to add employee",
          color: Colors.red,
        );
        return false;
      }
    } catch (e) {
      log("Add Employee Error: $e");
      ToastWidget.showToastCustom(
        e.toString(),
        color: Colors.red,
      );
      return false;
    } finally {
      isAddingAdmin.value = false;
    }
  }

  Future<String> convertToBase64(File file) async {
    List<int> imageBytes = await file.readAsBytes();
    return base64Encode(imageBytes);
  }

  Future<bool> updateEmployee(String employeeId) async {
    final token = _token;
    if (token == null) return false;

    try {
      isUpdatingAdmin.value = true;

      FormData formData = FormData.fromMap({
        "employeeName": employeeCodeController.text,
        "firstName": firstNameController.text,
        "lastName": lastNameController.text,
        "nickname": nickNameController.text,
        "email": emailController.text,
        "mobileNumber": mobileNumberController.text,
        "adharNumber": aadhaarNumberController.text,

        "accountNumber": acNumberController.text,
        "accountHolderName": acHolderNameController.text,
        "ifscCode": ifscCodeController.text,
        "bankName": bankNameController.text,
        "bankBranchName": bankBranchNameController.text,

        "referenceName": referenceNameController.text,
        "referenceMobileNumber": referenceMobileNumberController.text,

        "employeeRole": ["employee"],
        "role": ["68d386c8c29fd9522442aeb6"],
        "machine": [],
        "scanPermission": [],

        "adharCardFront": aadhaarFrontImage.value != null
            ? await MultipartFile.fromFile(
          aadhaarFrontImage.value!.path,
          filename: "front.jpg",
        )
            : "",

        "adharCardBack": aadhaarBackImage.value != null
            ? await MultipartFile.fromFile(
          aadhaarBackImage.value!.path,
          filename: "back.jpg",
        )
            : "",
      });

      final response = await _apiService.putRequest(
        "${ApiConstants.employees}/$employeeId",
        data: formData,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "multipart/form-data",
        },
      );

      if (response.statusCode == 200) {
        loadFirstPage();
        return true;
      } else {
        ToastWidget.showToastCustom(
          "Update failed",
          color: Colors.red,
        );
        return false;
      }
    } catch (e) {
      log("Update Employee Error: $e");
      ToastWidget.showToastCustom(
        e.toString(),
        color: Colors.red,
      );
      return false;
    } finally {
      isUpdatingAdmin.value = false;
    }
  }

  Future<void> fetchProcess() async {
    final token = _token;
    if (token == null || token.isEmpty) return;

    try {
      // isLoading.value = true;

      final response = await _apiService.getRequest(
        ApiConstants.getAllProcess,
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final json = response.data;
        final dataRaw = json['data'];


        if (json['data'] != null && json['data'] is List) {
          final processList = List<Map<String, dynamic>>.from(json['data']);

          process.value = processList
              .map((e) => ProcessRateModel.fromJson(e))
              .toList();
        } else {
          process.clear();
        }
      } else {
        log("Error fetching process: ${response.statusCode}");
      }
    } on DioException catch (e) {
      log("DioException: ${e.response?.data ?? e.message}");
    } catch (e) {
      log("fetchProcess Unknown error: $e");
    } finally {
      // isLoading.value = false;
    }
  }

  Future<bool> deleteEmployee(String id) async {

    final token = _token;
    if (token == null || token.isEmpty) return false;

    try {
      isDeleteDesignLoading.value = true;

      final response = await _apiService.deleteRequest(
        "${ApiConstants.employees}/$id",
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      log("delete employee: ${response.statusCode} ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 204) {
        /// refresh list
        await loadFirstPage();
        return true;
      }
      return false;
    } on DioException catch (e) {
      log("Delete employee error: ${e.response?.data ?? e.message}");
      return false;
    } catch (e) {
      log("deleteEmployee error: $e");
      isDeleteDesignLoading.value = false;
      return false;
    }finally{
      isDeleteDesignLoading.value = false;
    }
  }


}
