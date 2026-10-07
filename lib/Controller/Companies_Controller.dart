
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../Model/Companies_Model.dart';
import '../View/Common/Get_storage_data.dart';
import '../View/Constant/Api_Constants.dart';
import '../View/Constant/Api_Service.dart';

class CompaniesController extends GetxController{
  final ApiService _apiService = ApiService();
  RxList<CompanyModel> company = <CompanyModel>[].obs;
  final ScrollController scrollController = ScrollController();
  final TextEditingController cNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isMoreLoading = false.obs;
  RxBool hasMore = true.obs;
  RxBool isAddCompany = false.obs;
  RxBool isUpdateCompany = false.obs;
  RxBool isDeleteCompany = false.obs;
  RxString searchText = "".obs;

  int currentPage = 1;
  static const int limit = 10;
  static const double loadMoreThreshold = 200;

  String? get _token => GetStorageData.readString(GetStorageData.token);

  RxnString selected = RxnString();
  RxnString selectedCompany = RxnString();
  RxnString selectedDno = RxnString();

  void onSearch(String value) {
    searchText.value = value;
    loadFirstPage();
  }

  final List<String> filter = [
    "All",
    "Active",
    "Inactive",
  ];


  void clearFilters() {
    selectedCompany.value = null;
    selectedDno.value = null;
  }


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
    await fetchCompany(isRefresh: true, token: token);
  }

  Future<void> loadNextPage() async {
    final token = _token;
    if (token == null || token.isEmpty) return;
    if (!hasMore.value || isMoreLoading.value || isLoading.value) return;
    await fetchCompany(isRefresh: false, token: token);
  }

  Future<void> fetchCompany({
    required bool isRefresh,
    required String token,
  }) async {
    if (isRefresh) {
      currentPage = 1;
      hasMore.value = true;
      company.clear();
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
        ApiConstants.getAllCompany,
        queryParams: {
          "search": searchText.value.isEmpty ? null : searchText.value,
          "page": currentPage,
          "limit": limit,
          "sortDirection": "asc",
        },
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final json = response.data;
        // final list = json['data'] ?? [];
        // final pagination = json['data']?['pagination'];


        List list = json['data'] ?? [];

        if (list.isNotEmpty) {

          final fetched = list
              .map((e) => CompanyModel.fromJson(e))
              .toList();

          company.addAll(fetched);

          if (selectedCompany.value == null && company.isNotEmpty) {
            selectedCompany.value = company.first.id;
          }

          /// pagination handle
          if (fetched.length < limit) {
            hasMore.value = false;
          } else {
            currentPage++;
          }

        } else {
          hasMore.value = false;
        }
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

  Future<bool> addCompany({
    required String description,
    required String name,
  }) async {
    final token = _token;
    if (token == null || token.isEmpty) return false;

    try {
      isAddCompany.value = true;

      final response = await _apiService.postRequest(
        ApiConstants.addCompany,
        data: {
         "description": description,
          "name": name
        },
        headers: {"Authorization": "Bearer $token"},
      );

      log("add admin: ${response.statusCode} ${response.data}");


      if (response.statusCode == 200 || response.statusCode == 201) {
        // Optionally refresh admin list
        await loadFirstPage();
        return true;
      } else {
        log("Failed to add admin: ${response.statusCode} ${response.data}");
        return false;
      }
    } on DioException catch (e) {
      log("DioException: ${e.response?.data ?? e.message}");
      return false;
    } catch (e) {
      log("Unknown error: $e");
      return false;
    } finally {
      isAddCompany.value = false;
    }
  }

  Future<bool> updateCompany({
    required String description,
    required String name,
    required String id
  }) async {
    final token = _token;
    if (token == null || token.isEmpty) return false;

    try {
      isUpdateCompany.value = true;

      final response = await _apiService.patchRequest(
        "${ApiConstants.addCompany}/$id",
        data: {
          "description": description,
          "isActive": true,
          "name": name,
        },
        headers: {"Authorization": "Bearer $token"},
      );

      log("update admin: ${response.statusCode} ${response.data}");

      if (response.statusCode == 200) {
        await loadFirstPage();
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      log("DioException: ${e.response?.data ?? e.message}");
      return false;
    } finally {
      isUpdateCompany.value = false;
    }
  }

  Future<bool> deleteCompany(String id) async {
    final token = _token;
    if (token == null || token.isEmpty) return false;

    log('URLLll: ${ApiConstants.addCompany}/$id');
    try {
      isDeleteCompany.value = true;

      final response = await _apiService.deleteRequest(
        "${ApiConstants.addCompany}/$id",
        headers: {"Authorization": "Bearer $token"},
      );

      log("delete company: ${response.statusCode} ${response.data}");

      if (response.statusCode == 200) {
        await loadFirstPage();
        return true;
      } else {
        log("Error delete company: ${response.statusCode} ${response.data}");
        return false;
      }
    } on DioException catch (e) {
      log("DioException: ${e.response?.data ?? e.message}");
      return false;
    } finally {
      isDeleteCompany.value = false;
    }
  }

  Future<void> fetchBilling({
    required bool isRefresh,
    required String companyId,
    required String token,
  }) async {
    if (isRefresh) {
      currentPage = 1;
      hasMore.value = true;
      company.clear();
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
        ApiConstants.billing,
        queryParams: {
          "companyId": companyId,
          "page": currentPage,
          "limit": limit,
        },
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final json = response.data;
        // final list = json['data'] ?? [];
        // final pagination = json['data']?['pagination'];


        List list = json['data'] ?? [];

        if (list.isNotEmpty) {

          final fetched = list
              .map((e) => CompanyModel.fromJson(e))
              .toList();

          company.addAll(fetched);

          if (selectedCompany.value == null && company.isNotEmpty) {
            selectedCompany.value = company.first.id;
          }

          /// pagination handle
          if (fetched.length < limit) {
            hasMore.value = false;
          } else {
            currentPage++;
          }

        } else {
          hasMore.value = false;
        }
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

}