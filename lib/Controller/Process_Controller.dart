
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../Model/Process_List_Model.dart';
import '../View/Common/Get_storage_data.dart';
import '../View/Constant/Api_Constants.dart';
import '../View/Constant/Api_Service.dart';

class ProcessController extends GetxController{
  final ApiService _apiService = ApiService();
  RxList<ProcessRateModel> process = <ProcessRateModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool isAddingProcess = false.obs;
  RxBool isUpdatingProcess = false.obs;
  String? selectedProcessId;
  RxBool isDeletingProcess = false.obs;
  RxBool hasMore = true.obs;
  RxBool isMoreLoading = false.obs;
  int currentPage = 1;
  static const int limit = 25;
  static const double loadMoreThreshold = 200;

  String? get _token => GetStorageData.readString(GetStorageData.token);
  final TextEditingController employeeCodeController = TextEditingController();
  final TextEditingController processNameController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    fetchProcess();
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;

    final max = scrollController.position.maxScrollExtent;
    final current = scrollController.position.pixels;

    if (max - current < loadMoreThreshold) {
      loadNextPage();
    }
  }

  Future<void> loadNextPage() async {
    if (!hasMore.value || isMoreLoading.value || isLoading.value) return;
    await fetchProcess(isRefresh: false);
  }

  Future<void> fetchProcess({bool isRefresh = true}) async {
    final token = _token;
    if (token == null || token.isEmpty) return;

    if (isRefresh) {
      currentPage = 1;
      hasMore.value = true;
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
        ApiConstants.getAllProcess,
        queryParams: {
          "page": currentPage,
          "limit": limit,
        },
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final json = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : Map<String, dynamic>.from(response.data as Map);
        final dataRaw = json['data'];
        final fetched = dataRaw is List
            ? dataRaw
            .map((e) => ProcessRateModel.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList()
            : <ProcessRateModel>[];
        if (isRefresh) {
          process.assignAll(fetched);
        } else {
          process.addAll(fetched);
        }
        final pagination = json['pagination'];
        hasMore.value = _hasMorePages(
          pagination is Map ? Map<String, dynamic>.from(pagination) : null,
          json,
          fetched.length,
        );
        currentPage++;
      } else {
        hasMore.value = false;
        log("Error fetching process: ${response.statusCode}");
      }
    } on DioException catch (e) {
      hasMore.value = false;
      log("fetchProcess DioException: ${e.response?.data ?? e.message}");
    } catch (e) {
      hasMore.value = false;
      print("fetchProcess Unknown error: $e");
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
    _loadMoreIfListIsShort();
  }

  Future<bool> addProcess({
    required String processName,
    required String userId,
  }) async {
    final token = _token;
    if (token == null || token.isEmpty) return false;

    try {
      isAddingProcess.value = true;

      final response = await _apiService.postRequest(
        ApiConstants.addProcess,
        data: {
          "processName": processName,
          "userId": userId
        },
        headers: {"Authorization": "Bearer $token"},
      );

      log("add process: ${response.statusCode} ${response.data}");


      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchProcess();
        return true;
      } else {
        log("Failed to add process: ${response.statusCode} ${response.data}");
        return false;
      }
    } on DioException catch (e) {
      log("DioException: ${e.response?.data ?? e.message}");
      return false;
    } catch (e) {
      log("Unknown error: $e");
      return false;
    } finally {
      isAddingProcess.value = false;
    }
  }

  Future<bool> updateProcess({
    required String processName,
    required String userId,
  }) async {
    final token = _token;
    if (token == null || token.isEmpty) return false;

    try {
      isUpdatingProcess.value = true;

      final response = await _apiService.putRequest(
        "${ApiConstants.updateProcess}/$userId",
        data: {
          "processName": processName,
          "userId": userId
        },
        headers: {"Authorization": "Bearer $token"},
      );

      log("update process: ${response.statusCode} ${response.data}");

      if (response.statusCode == 200) {
        await fetchProcess();
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      log("updateProcess DioException: ${e.response?.data ?? e.message}");
      return false;
    } finally {
      isUpdatingProcess.value = false;
    }
  }

  Future<bool> deleteProcess(String id) async {
    final token = _token;
    if (token == null || token.isEmpty) return false;

    print('URLLll: ${ApiConstants.deleteProcess}/$id');
    try {
      isDeletingProcess.value = true;

      final response = await _apiService.deleteRequest(
        "${ApiConstants.deleteProcess}/$id",
        headers: {"Authorization": "Bearer $token"},
      );

      log("delete process: ${response.statusCode} ${response.data}");

      if (response.statusCode == 200) {
        await fetchProcess();
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      log("deleteProcess DioException: ${e.response?.data ?? e.message}");
      return false;
    } finally {
      isDeletingProcess.value = false;
    }
  }

  bool _hasMorePages(
      Map<String, dynamic>? pagination,
      Map<String, dynamic> root,
      int fetchedCount,
      ) {
    if (fetchedCount <= 0) return false;

    final source = pagination ?? root;
    if (source['hasPagination'] == false || root['hasPagination'] == false) {
      return false;
    }

    int? asInt(dynamic value) =>
        value is num ? value.toInt() : int.tryParse('$value');

    final int page = asInt(source['page']) ?? asInt(root['page']) ?? currentPage;
    final int? pagesField = asInt(source['pages']) ?? asInt(root['pages']);
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

  void _loadMoreIfListIsShort() {
    if (!hasMore.value) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;
      if (scrollController.position.maxScrollExtent < loadMoreThreshold) {
        loadNextPage();
      }
    });
  }

}