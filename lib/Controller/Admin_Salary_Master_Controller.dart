import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../Model/Salary_Master_Model.dart';
import '../Model/Salary_Master_View_Model.dart';
import '../View/Common/Get_storage_data.dart';
import '../View/Common/Toast.dart';
import '../View/Constant/Api_Constants.dart';
import '../View/Constant/Api_Service.dart';
import '../View/Utills/Global.dart';
import 'package:flutter/material.dart';

class AdminSalaryMasterController extends GetxController {
  final ApiService _apiService = ApiService();
  final ScrollController scrollController = ScrollController();
  final dateController = TextEditingController();
  final endDateController = TextEditingController();
  RxnString selected = RxnString();
  RxString employeeError = ''.obs;
  RxnString salaryMasterEmployeeSelected = RxnString();
  RxnString salaryMasterNickNameSelected = RxnString();
  Rxn<EmployeeSalaryData> salaryViewData = Rxn<EmployeeSalaryData>();
  RxList<SalaryData> salaryMaster = <SalaryData>[].obs;
  RxBool isLoading = false.obs;
  RxBool isSalaryViewLoading = false.obs;
  RxBool isMoreLoading = false.obs;
  RxBool hasMore = true.obs;

  int currentPage = 1;
  static const int limit = 25;
  static const double loadMoreThreshold = 200;
  RxBool isDownloading = false.obs;

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
    await fetchMachine(isRefresh: true, token: token);
  }

  Future<void> loadNextPage() async {
    final token = _token;
    if (token == null || token.isEmpty) return;
    if (!hasMore.value || isMoreLoading.value || isLoading.value) return;
    await fetchMachine(isRefresh: false, token: token);
  }

  Future<void> fetchMachine({
    required bool isRefresh,
    required String token,
  }) async {
    if (isRefresh) {
      currentPage = 1;
      hasMore.value = true;
      salaryMaster.clear();
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
        ApiConstants.salaryMaster,
        queryParams: {
          // "search": searchText.value.isEmpty ? null : searchText.value,
          "page": currentPage,
          "limit": limit,
          "sortDirection": "asc",
          "employeeCode": (salaryMasterEmployeeSelected.value?.isEmpty ?? true)
               ? null : salaryMasterEmployeeSelected.value,
          "nickName": (salaryMasterNickNameSelected.value?.isEmpty ?? true) ? null : salaryMasterNickNameSelected.value,
          "startDate": dateController.text.isEmpty ? null : convertToApiDate(dateController.text),
          "endDate": endDateController.text.isEmpty ? null : convertToApiDate(endDateController.text),
          // "employeeName": salaryMasterEmployeeSelected.value,
        },
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final json = response.data;
        final list = json['data'] as List?;
        final pagination = json['pagination'];

        if (list != null && list.isNotEmpty) {
          final List<SalaryData> fetched =
          list.map((e) => SalaryData.fromJson(e as Map<String, dynamic>)).toList();
          salaryMaster.addAll(fetched);
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
      print("Error fetching employees: ${e.response?.data ?? e.message}");
    } catch (e) {
      hasMore.value = false;
      rethrow;
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  Future<void> getSalaryMasterView(String id) async {

    final token = _token;
    if (token == null || token.isEmpty) return;

    try {

      isSalaryViewLoading.value = true;

      final response = await _apiService.getRequest(
        "${ApiConstants.salaryMasterView}/$id",
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = response.data;

        final model = SalaryMasterViewModel.fromJson(response.data);
        salaryViewData.value = model.data;

        print('status---${model.status}');

      }

    } catch (e) {
      print("Process API error: $e");
    } finally {
      isSalaryViewLoading.value = false;
    }
  }

  Future<void> downloadSalaryMasterExcel() async {
    final token = _token;
    if (token == null || token.isEmpty) return;

    try {
      isDownloading.value = true;

      final response = await _apiService.getRequest(
        ApiConstants.salaryMaster,
        queryParams: {
          "isExcel": true,
          "employeeCode": (salaryMasterEmployeeSelected.value?.isEmpty ?? true)
              ? null
              : salaryMasterEmployeeSelected.value,
          "nickName": (salaryMasterNickNameSelected.value?.isEmpty ?? true)
              ? null
              : salaryMasterNickNameSelected.value,
          "startDate": dateController.text.isEmpty
              ? null
              : convertToApiDate(dateController.text),
          "endDate": endDateController.text.isEmpty
              ? null
              : convertToApiDate(endDateController.text),
        },
        headers: {"Authorization": "Bearer $token"},
        responseType: ResponseType.bytes,
      );

      if (response.statusCode == 200) {
        final year = DateFormat('yyyy').format(DateTime.now());
        final fileName = "Salary_Master_$year.xlsx";
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/$fileName');
        await tempFile.writeAsBytes(response.data);

        await MediaStore().saveFile(
          tempFilePath: tempFile.path,
          relativePath: "Download/$fileName",
          dirType: DirType.download,
          dirName: DirName.download,
        );

        ToastWidget.showToastCustom(
          "Salary Master Excel downloaded",
          color: Colors.green,
        );
      } else {
        ToastWidget.showToastCustom("Download Failed", color: Colors.red);
      }
    } catch (e) {
      ToastWidget.showToastCustom("Something went wrong", color: Colors.red);
    } finally {
      isDownloading.value = false;
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
