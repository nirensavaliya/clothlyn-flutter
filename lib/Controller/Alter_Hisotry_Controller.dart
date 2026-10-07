import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../Model/Alter_History_Model.dart';
import '../View/Common/Get_storage_data.dart';
import '../View/Constant/Api_Constants.dart';
import '../View/Constant/Api_Service.dart';

class AlterHistoryController extends GetxController{
  final ApiService _apiService = ApiService();

  TextEditingController searchHistoryController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  RxList<AlterHistoryData> alterHistory = <AlterHistoryData>[].obs;
  RxList<AlterHistoryData> filteredList = <AlterHistoryData>[].obs;

  RxBool isLoading = false.obs;
  RxInt totalCount = 0.obs;
  RxBool isSearching = false.obs;
  RxBool hasMore = true.obs;
  RxBool isMoreLoading = false.obs;
  int currentPage = 1;
  static const int limit = 25;
  static const double loadMoreThreshold = 200;

  String? get _token => GetStorageData.readString(GetStorageData.token);

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    getAlterHistory();
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
    await getAlterHistory(isRefresh: false);
  }

  Future<void> getAlterHistory({bool isRefresh = true}) async {

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
        "${ApiConstants.alterHistory}",
        queryParams: {
          "page": currentPage,
          "limit": limit,
        },
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final raw = response.data;
        final json = raw is Map<String, dynamic>
            ? raw
            : Map<String, dynamic>.from(raw as Map);
        final model = AlterHistoryResponseModel.fromJson(response.data);
        final fetched = model.data ?? [];
        final pagination = json['pagination'];

        if (isRefresh) {
          alterHistory.assignAll(fetched);
        } else {
          alterHistory.addAll(fetched);
        }

        if (searchHistoryController.text.trim().isEmpty) {
          filteredList.assignAll(alterHistory);
        } else {
          onSearch(searchHistoryController.text);
        }
        // alterHistory.value = model.data ?? [];
        // filteredList.value = alterHistory;
        // totalCount.value = model.total ?? 0;
        totalCount.value = model.total ?? totalCount.value;
        hasMore.value = _hasMorePages(
          pagination is Map ? Map<String, dynamic>.from(pagination) : null,
          json,
          fetched.length,
        );
        currentPage++;
        log("Total Count: ${totalCount.value}");
      }

    } catch (e) {
      log("getAlterHistory API error: $e");
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
    _loadMoreIfListIsShort();

  }


  void onSearch(String value) {
    if (value.isEmpty) {
      filteredList.value = alterHistory;
    } else {
      filteredList.value = alterHistory.where((item) {
        final lot = item.lotNo?.toLowerCase() ?? '';
        final count = item.alterPic?.toString() ?? '';

        return lot.contains(value.toLowerCase()) ||
            count.contains(value);
      }).toList();
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