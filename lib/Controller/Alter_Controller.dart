
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../Model/Alter_Edit_Model.dart';
import '../Model/Alter_Model.dart';
import '../View/Common/Get_storage_data.dart';
import '../View/Constant/Api_Constants.dart';
import '../View/Constant/Api_Service.dart';

class AlterController extends GetxController{
  final ApiService _apiService = ApiService();
  TextEditingController searchController = TextEditingController();
  TextEditingController alterValueController = TextEditingController();
  RxList<AlterData> alter = <AlterData>[].obs;
  RxList<ScanData> alterEdit = <ScanData>[].obs;
  RxList<AlterData> filteredList = <AlterData>[].obs;
  RxString selectedLot = ''.obs;
  RxBool isSearching = false.obs;

  RxBool isLoading = false.obs;
  RxBool isMoreLoading = false.obs;
  RxBool hasMore = true.obs;
  RxInt totalCount = 0.obs;
  RxBool isEditLoading = false.obs;
  RxBool isUpdateLoading = false.obs;
  final formKey = GlobalKey<FormState>();

  final ScrollController scrollController = ScrollController();

  int currentPage = 1;
  static const int limit = 25;
  static const double loadMoreThreshold = 200;

  String? get _token => GetStorageData.readString(GetStorageData.token);

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    getAlter();
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
    await getAlter(isRefresh: false);
  }

  Future<void> getAlter({bool isRefresh = true}) async {

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
        ApiConstants.alter,
        queryParams: {
          "page": currentPage,
          "limit": limit,
        },
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final raw = response.data;
        final json = raw is Map<String, dynamic>
            ? raw
            : Map<String, dynamic>.from(raw as Map);
        final model = AlterResponseModel.fromJson(json);
        final fetched = model.data ?? [];
        final pagination = json['pagination'];

        if (isRefresh) {
          alter.assignAll(fetched);
        } else {
          alter.addAll(fetched);
        }

        if (searchController.text.trim().isEmpty) {
          filteredList.assignAll(alter);
        } else {
          onSearch(searchController.text);
        }

        totalCount.value = model.total ?? totalCount.value;

        hasMore.value = _hasMorePages(
          pagination is Map ? Map<String, dynamic>.from(pagination) : null,
          json,
          fetched.length,
        );
        currentPage++;

        log("Total Count: ${totalCount.value}");
      } else {
        hasMore.value = false;
      }

    } catch (e) {
      hasMore.value = false;
      log("Process API error: $e");
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
    _loadMoreIfListIsShort();
  }

  /// Stop on the last page. Uses `pages` when the API sends it.
  /// An empty page always stops so scroll cannot loop forever.
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

  Future<void> getAlterEditLot(String id) async {

    final token = _token;
    if (token == null || token.isEmpty) return;

    try {

      isEditLoading.value = true;

      final response = await _apiService.getRequest(
        "${ApiConstants.alterEditLot}/$id",
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final model = AlterEditResponseModel.fromJson(response.data);

        alterEdit.value = model.data ?? [];

      }

    } catch (e) {
      log("Process API error: $e");
    } finally {
      isEditLoading.value = false;
    }
  }

  Future<bool> updateAlter({
    required String alter,
    required String id,
  }) async {

    final token = _token;
    if (token == null || token.isEmpty) return false;

    try {

      isUpdateLoading.value = true;

      final body = {
        "alter": alter,
      };

      final response = await _apiService.putRequest(
        "${ApiConstants.alterEditLot}/$id",
        data: body,
        headers: {"Authorization": "Bearer $token"},
      );

      log("update alter: ${response.statusCode} ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        await getAlter();
        return true;
      } else {

        log("Failed to update alter: ${response.statusCode} ${response.data}");
        return false;

      }

    } on DioException catch (e) {
      log("DioException: ${e.response?.data ?? e.message}");
      return false;
    } catch (e) {
      log("Unknown error: $e");
      return false;
    } finally {
      isUpdateLoading.value = false;
    }
  }


  void onSearch(String value) {
    if (value.isEmpty) {
      filteredList.value = alter;
    } else {
      filteredList.value = alter.where((item) {
        final lot = item.lotNo?.toLowerCase() ?? '';
        final count = item.alterCount?.toString() ?? '';

        return lot.contains(value.toLowerCase()) ||
            count.contains(value);
      }).toList();
    }
  }

}