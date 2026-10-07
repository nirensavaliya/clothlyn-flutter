import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:intl/intl.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../Model/Admin_Salary_Paid_Model.dart';
import '../View/Common/Get_storage_data.dart';
import '../View/Common/Toast.dart';
import '../View/Constant/Api_Constants.dart';
import '../View/Constant/Api_Service.dart';
import 'Admin_Salary_Master_Controller.dart';

class AdminSalaryPaidController extends GetxController{
  final ApiService _apiService = ApiService();
  final ScrollController scrollController = ScrollController();
  final TextEditingController paidController = TextEditingController();

  RxList<PaidSalaries> salaryPaid = <PaidSalaries>[].obs;
  RxBool isLoading = false.obs;
  RxBool isMoreLoading = false.obs;
  RxBool hasMore = true.obs;
  RxBool isAddingSalary = false.obs;
  RxBool isUpdateSalary = false.obs;
  RxBool isDeleteSalary = false.obs;
  RxBool isUpad = false.obs;
  /// salary | upad | bonus
  RxString paymentType = 'salary'.obs;
  RxBool isDownloadingDemo = false.obs;
  RxBool isImporting = false.obs;

  int currentPage = 1;
  static const int limit = 10;
  static const double loadMoreThreshold = 200;

  String? get _token => GetStorageData.readString(GetStorageData.token);

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
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
    await fetchSalaryPaid(isRefresh: true, token: token);
  }

  Future<void> loadNextPage() async {
    final token = _token;
    if (token == null || token.isEmpty) return;
    if (!hasMore.value || isMoreLoading.value || isLoading.value) return;
    await fetchSalaryPaid(isRefresh: false, token: token);
  }

  Future<void> fetchSalaryPaid({
    required bool isRefresh,
    required String token,
  }) async {
    if (isRefresh) {
      currentPage = 1;
      hasMore.value = true;
      salaryPaid.clear();
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
        ApiConstants.getAllSalaryPaid,
        queryParams: {
          // "search": searchText.value.isEmpty ? null : searchText.value,
          "page": currentPage,
          "limit": limit,
          "sortDirection": "asc"
        },
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final json = response.data;
        final list = json['data']?['paidSalaries'] as List?;
        final pagination = json['data']?['pagination'];

        if (list != null && list.isNotEmpty) {
          final List<PaidSalaries> fetched =
          list.map((e) => PaidSalaries.fromJson(e)).toList();

          salaryPaid.addAll(fetched);
        }

        final dataMap = json['data'];
        hasMore.value = _hasMorePages(
          pagination is Map ? Map<String, dynamic>.from(pagination) : null,
          dataMap is Map
              ? Map<String, dynamic>.from(dataMap)
              : (json is Map ? Map<String, dynamic>.from(json) : const {}),
          list?.length ?? 0,
        );
        currentPage++;
      } else {
        hasMore.value = false;
      }
    } on DioException catch (e) {
      hasMore.value = false;
      print("Error fetching employees: ${e.response?.data ?? e.message}");
    } catch (e) {
      hasMore.value = false;
      rethrow;
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  Future<void> _refreshSalaryMaster() async {
    if (Get.isRegistered<AdminSalaryMasterController>()) {
      await Get.find<AdminSalaryMasterController>().loadFirstPage();
    }
  }

  Future<bool> addSalaryPaid({
    required String employeeId,
    required String paid,
    required bool isUpad,
    String? paymentType,
  }) async {

    final token = _token;
    if (token == null || token.isEmpty) return false;

    final type = (paymentType ?? this.paymentType.value).trim().toLowerCase();
    final resolvedType = type.isEmpty
        ? (isUpad ? 'upad' : 'salary')
        : type;

    try {

      isAddingSalary.value = true;

      final payload = {
        "employeeId": employeeId,
        "paid": paid,
        "isUpad": resolvedType == 'upad',
        "paymentType": resolvedType,
      };

      final response = await _apiService.postRequest(
        ApiConstants.addSalaryPaid,
        data: payload,
        headers: {
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        await fetchSalaryPaid(isRefresh: true, token: token);
        await _refreshSalaryMaster();
      return true;
      } else {
        log("Failed to add salary: ${response.statusCode} ${response.data}");
        return false;
      }

    } on DioException catch (e) {
      log("DioException: ${e.response?.data ?? e.message}");
      return false;
    } catch (e) {
      log("Unknown error: $e");
      return false;
    } finally {
      isAddingSalary.value = false;
    }
  }

  Future<bool> editSalary({
    required String employeePassApiId,
    required String employeeId,
    required String paid,
    required bool isUpad,
    String? paymentType,
  }) async {
    final token = _token;
    if (token == null || token.isEmpty) return false;

    final type = (paymentType ?? this.paymentType.value).trim().toLowerCase();
    final resolvedType = type.isEmpty
        ? (isUpad ? 'upad' : 'salary')
        : type;

    try {
      isUpdateSalary.value = true;

      final response = await _apiService.patchRequest(
        "${ApiConstants.addSalaryPaid}/$employeePassApiId",
        data: {
          "employeeId": employeeId,
          "paid": paid,
          "isUpad": resolvedType == 'upad',
          "paymentType": resolvedType,
        },
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        await fetchSalaryPaid(isRefresh: true, token: token);
        await _refreshSalaryMaster();
        return true;
      } else {
        log("Error updating machine: ${response.statusCode} ${response.data}");
        return false;
      }

    } on DioException catch (e) {
      log("DioException: ${e.response?.data ?? e.message}");
      isUpdateSalary.value = false;
      return false;
    } finally {
      isUpdateSalary.value = false;
    }
  }

  Future<bool> deleteSalary(String id) async {
    final token = _token;
    if (token == null || token.isEmpty) return false;

    print('URLLll: ${ApiConstants.deleteSalaryPaid}/$id');
    try {
      isDeleteSalary.value = true;

      final response = await _apiService.deleteRequest(
        "${ApiConstants.deleteSalaryPaid}/$id",
        headers: {"Authorization": "Bearer $token"},
      );

      log("delete admin: ${response.statusCode} ${response.data}");

      if (response.statusCode == 200) {
        await fetchSalaryPaid(isRefresh: true, token: token);
        await _refreshSalaryMaster();
        return true;
      } else {
        log("Error delete admin: ${response.statusCode} ${response.data}");
        return false;
      }
    } on DioException catch (e) {
      log("DioException: ${e.response?.data ?? e.message}");
      return false;
    } finally {
      isDeleteSalary.value = false;
    }
  }

  /// GET /api/paid-salaries/import-demo — demo Excel for import
  Future<void> downloadImportDemoExcel() async {
    final token = _token;
    if (token == null || token.isEmpty) return;

    try {
      isDownloadingDemo.value = true;

      final response = await _apiService.getRequest(
        ApiConstants.salaryPaidImportDemo,
        headers: {"Authorization": "Bearer $token"},
        responseType: ResponseType.bytes,
      );

      if (response.statusCode == 200) {
        final year = DateFormat('yyyy').format(DateTime.now());
        final fileName = "Salary_Paid_Import_Demo_$year.xlsx";
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/$fileName');
        await tempFile.writeAsBytes(response.data);

        await MediaStore().saveFile(
          tempFilePath: tempFile.path,
          relativePath: fileName,
          dirType: DirType.download,
          dirName: DirName.download,
        );

        ToastWidget.showToastCustom(
          "Import demo Excel downloaded",
          color: Colors.green,
        );
      } else {
        ToastWidget.showToastCustom("Download Failed", color: Colors.red);
      }
    } catch (e) {
      log("Import demo download error: $e");
      ToastWidget.showToastCustom("Something went wrong", color: Colors.red);
    } finally {
      isDownloadingDemo.value = false;
    }
  }

  /// POST /api/paid-salaries/import — multipart Excel upload
  Future<bool> importSalaryPaidExcel(String filePath) async {
    final token = _token;
    if (token == null || token.isEmpty) return false;

    try {
      isImporting.value = true;

      final fileName = filePath.split(Platform.pathSeparator).last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
      });

      final response = await _apiService.postRequest(
        ApiConstants.salaryPaidImport,
        data: formData,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "multipart/form-data",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchSalaryPaid(isRefresh: true, token: token);
        await _refreshSalaryMaster();
        ToastWidget.showToastCustom(
          response.data is Map
              ? (response.data['message']?.toString() ?? 'Import successful')
              : 'Import successful',
          color: Colors.green,
        );
        return true;
      }

      ToastWidget.showToastCustom('Import failed', color: Colors.red);
      return false;
    } on DioException catch (e) {
      log("Import DioException: ${e.response?.data ?? e.message}");
      ToastWidget.showToastCustom(
        e.response?.data is Map
            ? (e.response?.data['message']?.toString() ?? 'Import failed')
            : 'Import failed',
        color: Colors.red,
      );
      return false;
    } catch (e) {
      log("Import error: $e");
      ToastWidget.showToastCustom('Import failed', color: Colors.red);
      return false;
    } finally {
      isImporting.value = false;
    }
  }

  /// Stop after the last page. Uses `pages` when present, otherwise total / limit.
  /// An empty page always stops so scroll cannot loop forever.
  bool _hasMorePages(
    Map<String, dynamic>? pagination,
    Map<String, dynamic> root,
    int fetchedCount,
  ) {
    if (fetchedCount <= 0) return false;

    final source = pagination ?? root;
    int? asInt(dynamic value) =>
        value is num ? value.toInt() : int.tryParse('$value');

    final int page = asInt(source['page']) ?? asInt(root['page']) ?? currentPage;
    final int? pagesField = asInt(source['pages']) ??
        asInt(root['pages']) ??
        asInt(source['totalPages']) ??
        asInt(root['totalPages']);
    if (pagesField != null && pagesField > 0) {
      return page < pagesField;
    }

    final int total = asInt(source['total']) ?? asInt(root['total']) ?? 0;
    final int pageLimit =
        asInt(source['limit']) ?? asInt(root['limit']) ?? limit;
    if (total > 0 && pageLimit > 0) {
      return page < (total / pageLimit).ceil();
    }
    return fetchedCount >= limit;
  }
}