
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../Model/Admin_Salary_Report_Model.dart';
import '../Model/Design_By_Number_Model.dart';
import '../Model/Design_Model.dart';
import '../Model/Employee_list_Model.dart';
import '../View/Common/Get_storage_data.dart';
import '../View/Common/Toast.dart';
import '../View/Constant/Api_Constants.dart';
import '../View/Constant/Api_Service.dart';

class AdminSalaryReportController extends GetxController {
  final ApiService _apiService = ApiService();
  RxList<EmployeeModel> employees = <EmployeeModel>[].obs;
  RxList<DesignModel> design = <DesignModel>[].obs;
  RxList<DesignProcessModel> process = <DesignProcessModel>[].obs;
  RxList<RcData> salaryReport = <RcData>[].obs;
  RxList<EmployeeModel> filteredEmployees = <EmployeeModel>[].obs;
  RxList<RcData> filteredSalaryReport = <RcData>[].obs;

  RxBool isLoading = false.obs;
  RxBool isMoreLoading = false.obs;
  RxBool hasMore = true.obs;

  RxBool isReportLoading = false.obs;
  RxBool isReportMoreLoading = false.obs;
  RxBool hasMoreReport = true.obs;

  RxBool isDownloading = false.obs;
  RxnString salaryMasterEmployeeSelected = RxnString();
  RxnString selectDNo = RxnString();
  RxnString selectStatus = RxnString();

  Rx<DateTimeRange?> selectedDateRange = Rx<DateTimeRange?>(null);
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  Map<String, List<EmployeeModel>> processEmployeeMap = {};

  int currentPage = 1;
  static const int limit = 25;

  int  currentEmployeePage = 1;
  static const int employeeLimit = 25;
  RxBool hasMoreEmployees = true.obs;
  RxBool isEmployeeLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadFirstPage();
    loadSalaryFirstPage();
  }

  String? get _token => GetStorageData.readString(GetStorageData.token);

  Future<void> loadFirstPage() async {
    final token = _token;
    if (token == null || token.isEmpty) return;
    // await fetchEmployees(isRefresh: true, token: token);
    await fetchDesign(isRefresh: true, token: token);
  }

  Future<void> loadNextPage() async {
    final token = _token;
    if (token == null || token.isEmpty) return;
    if (!hasMore.value || isMoreLoading.value || isLoading.value) return;
    await fetchEmployees(isRefresh: false, token: token);
  }

  Future<void> loadSalaryFirstPage() async {
    final token = _token;
    if (token == null || token.isEmpty) return;
    await fetchProcessReport(isRefresh: true, token: token);
    filteredSalaryReport.value = salaryReport.toList();

  }

  Future<void> loadSalaryNextPage() async {
    final token = _token;
    if (token == null || token.isEmpty) return;
    if (!hasMoreReport.value || isReportMoreLoading.value || isReportLoading.value) return;
    await fetchProcessReport(isRefresh: false, token: token);
  }


  void filterEmployeesByStatus(String? status) {
    if (status == null || status.isEmpty) {
      filteredEmployees.value = [];
      salaryMasterEmployeeSelected.value = null;
      return;
    }

    final employeesForStatus = salaryReport
        .where((e) => e.model == status)
        .map((e) => EmployeeModel(
      id: e.user?.id ?? '',
      employeeName:  e.user?.employeeName ?? '',
      firstName:  e.user?.firstName ?? '',
      lastName:  e.user?.lastName ?? '',
      nickname:  e.user?.nickname ?? '',
      email:  e.user?.email ?? '',
      adharNumber: '',
      mobileNumber:  e.user?.mobileNumber ?? '',
      referenceName: '',
      referenceMobileNumber: '',
      accountNumber: '',
      accountHolderName: '',
      ifscCode: '',
      bankName: '',
      bankBranchName: '',
      userId: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      status:  '', role: [], scanPermission: [], employeeRole: [], machine: [], processNames: [], scanPermissionNames: [], machineNames: [],
      adharCardFront: '', adharCardBack: '',
    ))
        .toList();

    final uniqueEmployees = <String, EmployeeModel>{};
    for (var e in employeesForStatus) {
      uniqueEmployees[e.id] = e;
    }

    filteredEmployees.value = uniqueEmployees.values.toList();

    salaryMasterEmployeeSelected.value = null;

    log("Selected Status: $status");
    log("Filtered Employees: ${filteredEmployees.length}");
  }

  void buildProcessEmployeeMap() {
    processEmployeeMap.clear();

    for (var proc in process) {
      processEmployeeMap[proc.processName ?? ""] = employees;
    }

    filteredEmployees.value = employees;
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
          "limit": limit,
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

        hasMore.value = _hasMorePages(
          pagination is Map ? Map<String, dynamic>.from(pagination) : null,
          json is Map ? Map<String, dynamic>.from(json) : const {},
          list?.length ?? 0,
        );
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

  Future<void> fetchDesign({
    required bool isRefresh,
    required String token,
  }) async {
    if (isRefresh) {
      currentPage = 1;
      hasMore.value = true;
      design.clear();
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
        ApiConstants.salaryReportNew,
        queryParams: {
          "page": currentPage,
          "limit": limit,
        },
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final json = response.data;
        final list = json['data'] as List?;
        final pagination = json['pagination'];

        if (list != null && list.isNotEmpty) {
          final List<DesignModel> fetched =
          list.map((e) => DesignModel.fromJson(e as Map<String, dynamic>)).toList();
          design.addAll(fetched);
        }

        hasMore.value = _hasMorePages(
          pagination is Map ? Map<String, dynamic>.from(pagination) : null,
          json is Map ? Map<String, dynamic>.from(json) : const {},
          list?.length ?? 0,
        );
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

  Future<void> fetchProcessReport({
    required bool isRefresh,
    required String token,
  }) async {
    if (isRefresh) {
      currentPage = 1;
      hasMoreReport.value = true;
      design.clear();
    }

    if (!hasMoreReport.value) return;
    if (isReportLoading.value || isReportMoreLoading.value) return;

    try {
      if (currentPage == 1) {
        isReportLoading.value = true;
      } else {
        isReportMoreLoading.value = true;
      }

      final response = await _apiService.getRequest(
        ApiConstants.processReport,
        queryParams: {
          "page": currentPage,
          "limit": limit,
        },
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final json = response.data;
        final list = json['data'] as List?;
        final pagination = json['pagination'];

        if (list != null && list.isNotEmpty) {
          final List<RcData> fetched =
          list.map((e) => RcData.fromJson(e as Map<String, dynamic>)).toList();
          final showAllLoaded =
              filteredSalaryReport.length == salaryReport.length;
          salaryReport.addAll(fetched);
          if (showAllLoaded) {
            filteredSalaryReport.addAll(fetched);
          }
          String dNo = fetched.first.dNo ?? "";

          if (dNo.isNotEmpty) {
            fetchDesignByDNo(
              dNo: dNo,
              token: token,
            );
          }
        }

        hasMoreReport.value = _hasMorePages(
          pagination is Map ? Map<String, dynamic>.from(pagination) : null,
          json is Map ? Map<String, dynamic>.from(json) : const {},
          list?.length ?? 0,
        );
        currentPage++;
      } else {
        hasMoreReport.value = false;
      }
    } on DioException catch (e) {
      hasMoreReport.value = false;
      log("Error fetching employees: ${e.response?.data ?? e.message}");
    } catch (e) {
      hasMoreReport.value = false;
      rethrow;
    } finally {
      isReportLoading.value = false;
      isReportMoreLoading.value = false;
    }
  }

  Future<void> fetchDesignByDNo({
    required String dNo,
    required String token,
  }) async {

    try {

      final response = await _apiService.getRequest(
        "${ApiConstants.designByNumber}/$dNo",
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];

        final design = DesignByNumberModel.fromJson(data);

        process.clear();

        if (design.processes != null) {
          process.addAll(design.processes!);
          buildProcessEmployeeMap();
        }

        log("Design Data: $data");
      }

    } on DioException catch (e) {
      log("Design API Error: ${e.response?.data ?? e.message}");

    }
  }

  Future<void> downloadSalaryExcel() async {
    final token = _token;
    if (token == null || token.isEmpty) return;

    try {
      isDownloading.value = true;

      final response = await _apiService.getRequest(
        ApiConstants.salaryReportNew,
        queryParams: {
          "isExcel": true,
          if (selectStatus.value != null && selectStatus.value!.isNotEmpty)
            "status": selectStatus.value,
          if (salaryMasterEmployeeSelected.value != null &&
              salaryMasterEmployeeSelected.value!.isNotEmpty)
            "employeeId": salaryMasterEmployeeSelected.value,
          if (selectDNo.value != null && selectDNo.value!.isNotEmpty)
            "dNo": selectDNo.value,
          if (startDateController.text.isNotEmpty)
            "startDate": startDateController.text,
          if (endDateController.text.isNotEmpty)
            "endDate": endDateController.text,
        },
        headers: {
          "Authorization": "Bearer $token",
        },
        responseType: ResponseType.bytes,
      );

      if (response.statusCode == 200) {
        String year = DateFormat('yyyy').format(DateTime.now());

        String fileName = "Salary_Excel_Report$year.xlsx";

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
          "Salary Report downloaded in Download folder",
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

  Future<void> fetchEmployeesByStatus({
    required String status,
    bool isRefresh = false,
    String? employeeId,
    String? dNo,
    String? startDate,
  }) async {
    final token = _token;
    if (token == null || token.isEmpty) return;

    if (isEmployeeLoading.value) return;
    if (!hasMoreEmployees.value && !isRefresh) return;

    if (isRefresh) {
      currentEmployeePage = 1;
      hasMoreEmployees.value = true;
      filteredEmployees.clear();
    }

    try {
      isEmployeeLoading.value = true;

      final response = await _apiService.getRequest(
        ApiConstants.processReport,
        queryParams: {
          "status": status,
          "page": currentEmployeePage,
          "limit": employeeLimit,
          if (employeeId != null) "employeeId": employeeId,
          if (dNo != null) "dNo": dNo,
          if (startDate != null) "startDate": startDate,
        },
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List?;
        final pagination = response.data['pagination'];

        if (data != null && data.isNotEmpty) {
          final List<EmployeeModel> employeesPage = data
              .map((e) => RcData.fromJson(e))
              .map((e) => EmployeeModel(
            id: e.user?.id ?? '',
            employeeName: e.user?.employeeName ?? '',
            firstName: e.user?.firstName ?? '',
            lastName: e.user?.lastName ?? '',
            nickname: e.user?.nickname ?? '',
            email: e.user?.email ?? '',
            adharNumber: '',
            mobileNumber: e.user?.mobileNumber ?? '',
            referenceName: '',
            referenceMobileNumber: '',
            accountNumber: '',
            accountHolderName: '',
            ifscCode: '',
            bankName: '',
            bankBranchName: '',
            userId: '',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            status: '', role: [], scanPermission: [], employeeRole: [], machine: [], processNames: [], scanPermissionNames: [], machineNames: [], adharCardFront: '', adharCardBack: ''
          ))
              .toList();

          final unique = <String, EmployeeModel>{};
          for (var emp in [...filteredEmployees, ...employeesPage]) {
            unique[emp.id] = emp;
          }

          filteredEmployees.value = unique.values.toList();
        }

        hasMoreEmployees.value = _hasMorePages(
          pagination is Map ? Map<String, dynamic>.from(pagination) : null,
          response.data is Map
              ? Map<String, dynamic>.from(response.data)
              : const {},
          data?.length ?? 0,
        );
        if (hasMoreEmployees.value) {
          currentEmployeePage++;
        }
      }

      salaryMasterEmployeeSelected.value = null;
    } catch (e) {
      log("Error fetching filtered employees: $e");
    } finally {
      isEmployeeLoading.value = false;
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