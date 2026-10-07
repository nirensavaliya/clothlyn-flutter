
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../Model/Employee_Response_Model.dart';
import '../Model/Upad_Model.dart';
import '../View/Common/Get_storage_data.dart';
import '../View/Common/Toast.dart';
import '../View/Constant/Api_Constants.dart';
import '../View/Constant/Api_Service.dart';
import '../View/Utills/Global.dart';

class AdminUpadController extends GetxController{
  final ApiService _apiService = ApiService();
  RxList<UpadData> uPad = <UpadData>[].obs;
  RxList<EmployeeData> employee = <EmployeeData>[].obs;

  final ScrollController scrollController = ScrollController();
  final TextEditingController upadAmountController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isEmployeeLoading = false.obs;
  RxBool isMoreLoading = false.obs;
  RxBool hasMore = true.obs;

  RxBool isAddUpad = false.obs;
  RxBool isUpdateUpad = false.obs;
  RxBool isDownloading = false.obs;


  int currentPage = 1;
  static const int limit = 1000;
  static const double loadMoreThreshold = 200;

  RxnString selected = RxnString();

  String? get _token => GetStorageData.readString(GetStorageData.token);

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    getEmployee();
    loadFirstPage();
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;

    final max = scrollController.position.maxScrollExtent;
    final current = scrollController.position.pixels;

    if (max - current < loadMoreThreshold) {
      loadNextPage();
    }
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }

  Future<void> loadFirstPage() async {
    final token = _token;
    if (token == null || token.isEmpty) return;
    await fetchUpad(isRefresh: true, token: token);
  }

  Future<void> loadNextPage() async {
    final token = _token;
    if (token == null || token.isEmpty) return;
    if (!hasMore.value || isMoreLoading.value || isLoading.value) return;
    await fetchUpad(isRefresh: false, token: token);
  }

  Future<void> fetchUpad({
    required bool isRefresh,
    required String token,
  }) async {
    if (isRefresh) {
      currentPage = 1;
      hasMore.value = true;
      uPad.clear();
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
        ApiConstants.uPad,
        queryParams: {
          "page": currentPage,
          "limit": limit,
          "sortDirection": "asc"
        },
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final json = response.data;
        final list = json['data'] as List?;
        final pagination = json['pagination'];

        if (list != null && list.isNotEmpty) {
          final List<UpadData> fetched =
          list.map((e) => UpadData.fromJson(e as Map<String, dynamic>)).toList();
          uPad.addAll(fetched);
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
        log("Error fetching product: ${response.statusCode}");
        hasMore.value = false;
      }
    } on DioException catch (e) {
      hasMore.value = false;
      log("Error fetching product: ${e.response?.data ?? e.message}");
    } catch (e) {
      hasMore.value = false;
      rethrow;
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  Future<void> getEmployee() async {
    final token = _token;

    if (token == null || token.isEmpty) return;

    try {
      isEmployeeLoading.value = true;

      final response = await _apiService.getRequest(
        ApiConstants.employees,
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {

        final json = response.data;

        EmployeeResponse model = EmployeeResponse.fromJson(json);

        employee.value = model.data ?? [];

      } else {
        log("Product Report Error: ${response.statusCode}");
      }

    } on DioException catch (e) {

      log("Product Report Error: ${e.response?.data ?? e.message}");

    } catch (e) {

      log("Unexpected Error: $e");

    } finally {
      isEmployeeLoading.value = false;
    }
  }

  Future<bool> addUpad({
    required String uPadAmount,
    required String uPadId,
  }) async {
    final token = _token;
    if (token == null || token.isEmpty) return false;

    try {
      isAddUpad.value = true;

      final response = await _apiService.postRequest(
        ApiConstants.uPad,
        data: {
          "employeeId": uPadId,
          "upadAmount": uPadAmount,
        },
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {

        final machineData = response.data['data'];
        await loadFirstPage();
        /* if (machineData != null) {
          machine.insert(0, MachineModel.fromJson(machineData));
        }*/
        return true;
      } else {
        log("Failed to add upad: ${response.statusCode} ${response.data}");
        return false;
      }
    } on DioException catch (e) {
      log("DioException: ${e.response?.data ?? e.message}");
      return false;
    } catch (e) {
      log("Unknown error: $e");
      return false;
    } finally {
      isAddUpad.value = false;
    }
  }

  Future<bool> editUPad({
    required String id,
    required String upadId,
    required String uPadAmount,
  }) async {
    final token = _token;
    if (token == null || token.isEmpty) return false;

    try {
      isUpdateUpad.value = true;

      final response = await _apiService.putRequest(
        "${ApiConstants.uPad}/$id",
        data: {
          "employeeId": upadId,
          "upadAmount": uPadAmount,
        },
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        await fetchUpad(isRefresh: true, token: token);

        /*  final index = machine.indexWhere((e) => e.id == machineId);

        if (index != -1) {
          machine[index] = MachineModel.fromJson(response.data['data']);
          machine.refresh();
        }*/
        return true;
      } else {
        log("Error updating upad: ${response.statusCode} ${response.data}");
        return false;
      }

    } on DioException catch (e) {
      log("DioException: ${e.response?.data ?? e.message}");
      isUpdateUpad.value = false;
      return false;
    } finally {
      isUpdateUpad.value = false;
    }
  }

  Future<void> downloadSalaryExcel() async {

    final token = _token;
    if (token == null || token.isEmpty) return;

    try {
      isDownloading.value = true;

      final response = await _apiService.getRequest(
        ApiConstants.uPad,
        queryParams: {
          "page": currentPage,
          "limit": limit,
          "sortDirection": "asc"
        },
        headers: {
          "Authorization": "Bearer $token",
        },
        responseType: ResponseType.bytes,
      );

      if (response.statusCode == 200) {
        String year = DateFormat('yyyy').format(DateTime.now());

        String fileName = "UPad_Report$year.pdf";

        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/$fileName');
        await tempFile.writeAsBytes(response.data);

        final result = await MediaStore().saveFile(
          tempFilePath: tempFile.path,

          relativePath: "Download/$fileName",
          dirType: DirType.download,
          dirName: DirName.download,
        );

        log("Saved at: $result");

        ToastWidget.showToastCustom(
          "UPad Report downloaded in Download folder",
          color: Colors.green,
        );

      } else {
        ToastWidget.showToastCustom(
          "Download Failed",
          color: Colors.red,
        );
      }

    } catch (e) {
      ToastWidget.showToastCustom(
        "Something went wrong",
        color: Colors.red,
      );
    } finally {
      isDownloading.value = false;
    }
  }


  Future<void> downloadBill(String date) async {
    bool hasPermission = await requestStoragePermission();

    if (!hasPermission) {
      ToastWidget.showToastCustom(
        "Storage permission denied",
        color: Colors.red,
      );
      return;
    }
    final token = _token;
    if (token == null || token.isEmpty) return;

    try {
      isDownloading.value = true;

      final response = await _apiService.getRequest(
        ApiConstants.viewBillExcel,
        queryParams: {
          "page": date,
        },
        headers: {
          "Authorization": "Bearer $token",
        },
        responseType: ResponseType.bytes,
      );

      if (response.statusCode == 200) {
        String filePath = "/storage/emulated/0/Download/bill_$date.xlsx";
        File file = File(filePath);

        await file.writeAsBytes(response.data);

        ToastWidget.showToastCustom(
          "Bill downloaded in Download folder",
          color: Colors.green,
        );

      } else {
        ToastWidget.showToastCustom(
          "Download Failed",
          color: Colors.red,
        );
      }

    } catch (e) {
      ToastWidget.showToastCustom(
        "Something went wrong",
        color: Colors.red,
      );
    } finally {
      isDownloading.value = false;
    }
  }



}