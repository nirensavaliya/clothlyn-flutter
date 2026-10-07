
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../Model/Product_List_Model.dart';
import '../Model/Product_Report_Model.dart';
import '../View/Common/Get_storage_data.dart';
import '../View/Constant/Api_Constants.dart';
import '../View/Constant/Api_Service.dart';

class ProductReportController extends GetxController{

  final ApiService _apiService = ApiService();
  RxList<DesignData> productReport = <DesignData>[].obs;
  RxList<Report> product = <Report>[].obs;
  RxList<ProcessColumn> processColumns = <ProcessColumn>[].obs;

  final ScrollController scrollController = ScrollController();

  RxBool isLoading = false.obs;
  RxBool isProduct = false.obs;
  RxBool isMoreLoading = false.obs;
  RxBool hasMore = true.obs;
  RxnString selectedD = RxnString();

  int currentPage = 1;
  static const int limit = 1000;
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
    await fetchProduct(isRefresh: true, token: token);
  }

  Future<void> loadNextPage() async {
    final token = _token;
    if (token == null || token.isEmpty) return;
    if (!hasMore.value || isMoreLoading.value || isLoading.value) return;
    await fetchProduct(isRefresh: false, token: token);
  }

  Future<void> fetchProduct({
    required bool isRefresh,
    required String token,
  }) async {
    if (isRefresh) {
      currentPage = 1;
      hasMore.value = true;
      productReport.clear();
    }

    if (!hasMore.value) return;
    if (isLoading.value || isMoreLoading.value) return;

    try {
      if (currentPage == 1) {
        isLoading.value = true;
      } else {
        isMoreLoading.value = true;
      }

      // Use lightweight design numbers API (not designs?limit=1000)
      final response = await _apiService.getRequest(
        ApiConstants.designNumbers,
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final json = response.data;
        final raw = json is Map ? (json['data'] ?? json) : json;

        List list = [];
        if (raw is List) {
          list = raw;
        } else if (raw is Map && raw['records'] is List) {
          list = raw['records'] as List;
        }

        if (list.isNotEmpty) {
          final fetched = <DesignData>[];
          for (final e in list) {
            if (e is String) {
              fetched.add(DesignData(designNumber: e));
            } else if (e is Map<String, dynamic>) {
              fetched.add(DesignData.fromJson(e));
            } else if (e is Map) {
              fetched.add(DesignData.fromJson(Map<String, dynamic>.from(e)));
            }
          }

          productReport.assignAll(fetched);
          hasMore.value = false;

          if (fetched.isNotEmpty) {
            String? designNumber = fetched.first.designNumber;
            if (designNumber != null && designNumber.isNotEmpty) {
              selectedD.value = designNumber;
              await getProductReport(designNumber);
            }
          }
        } else {
          hasMore.value = false;
        }
      } else {
        log("Error fetching product: ${response.statusCode}");
        hasMore.value = false;
      }
    } on DioException catch (e) {
      hasMore.value = false;
      print("Error fetching product: ${e.response?.data ?? e.message}");
    } catch (e) {
      hasMore.value = false;
      rethrow;
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  Future<void> getProductReport(String designNumber) async {
    final token = _token;

    if (token == null || token.isEmpty) return;

    try {
      isProduct.value = true;

      final response = await _apiService.getRequest(
        "${ApiConstants.getProductReport}/$designNumber",
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final json = response.data;
        ProductReportModel model = ProductReportModel.fromJson(json);
        processColumns.value = model.data?.processColumns ?? [];
        product.value = model.data?.report ?? [];

      } else {
        log("Product Report Error: ${response.statusCode}");
      }

    } on DioException catch (e) {

      log("Product Report Error: ${e.response?.data ?? e.message}");

    } catch (e) {

      log("Unexpected Error: $e");

    } finally {
      isProduct.value = false;
    }
  }

}
