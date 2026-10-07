
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../Model/Admin_User_List_Model.dart';
import '../View/Common/Get_storage_data.dart';
import '../View/Constant/Api_Constants.dart';
import '../View/Constant/Api_Service.dart';

class AdminController extends GetxController{
  final ApiService _apiService = ApiService();
  RxList<AdminUserModel> adminUsers = <AdminUserModel>[].obs;

  final TextEditingController employeeCodeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  RxBool isLoading = false.obs;
  RxBool isAddingAdmin = false.obs;
  RxBool isUpdatingAdmin = false.obs;
  RxBool isMoreLoading = false.obs;
  RxBool hasMore = true.obs;
  String? selectedAdminId;
  RxBool isDeletingAdmin = false.obs;
  int currentPage = 1;
  static const int limit = 25;
  static const double loadMoreThreshold = 200;

  String? get _token => GetStorageData.readString(GetStorageData.token);

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    fetchAdminUsers();
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
    await fetchAdminUsers(isRefresh: false);
  }

  Future<void> fetchAdminUsers({bool isRefresh = true}) async {
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
        ApiConstants.getAllAdmin,
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
        final data = json['data'];
        final adminsRaw = data is Map ? data['admins'] : null;
        final fetched = adminsRaw is List
            ? adminsRaw
            .map((e) => AdminUserModel.fromJson(e as Map<String, dynamic>))
            .toList()
            : <AdminUserModel>[];
        if (isRefresh) {
          adminUsers.assignAll(fetched);
        } else {
          adminUsers.addAll(fetched);
        }
        final pagination = json['pagination'] ?? (data is Map ? data['pagination'] : null);
        hasMore.value = _hasMorePages(
          pagination is Map ? Map<String, dynamic>.from(pagination) : null,
          json,
          fetched.length,
        );
        currentPage++;
      } else {
        hasMore.value = false;
        log("Error fetching admin users: ${response.statusCode}");
      }
    } on DioException catch (e) {
      log("DioException: ${e.response?.data ?? e.message}");
    } catch (e) {
      print("Unknown error: $e");
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
    _loadMoreIfListIsShort();

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

  Future<bool> addAdmin({
    required String phoneNumber,
    required String username,
    required String password,
    required String clientCode,
    required String company,
    required String email,
    required String nickname,
  }) async {
    final token = _token;
    if (token == null || token.isEmpty) return false;

    try {
      isAddingAdmin.value = true;

      final response = await _apiService.postRequest(
        ApiConstants.addAdmin,
        data: {
          "phoneNumber": phoneNumber,
          "username": username,
          "password": password,
          "clientCode": clientCode,
          "company": company,
          "email": email,
          "nickname": nickname,
        },
        headers: {"Authorization": "Bearer $token"},
      );

      log("add admin: ${response.statusCode} ${response.data}");


      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchAdminUsers();
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
      isAddingAdmin.value = false;
    }
  }

  Future<bool> updateAdmin({
    required String id,
    required String phoneNumber,
    required String username,
    required String password,
    required String clientCode,
    required String company,
    required String email,
    required String nickname,
  }) async {
    final token = _token;
    if (token == null || token.isEmpty) return false;

    try {
      isUpdatingAdmin.value = true;

      final response = await _apiService.putRequest(
        "${ApiConstants.updateAdmin}/$id",
        data: {
          "phoneNumber": phoneNumber,
          "username": username,
          "password": password,
          "clientCode": clientCode,
          "company": company,
          "email": email,
          "nickname": nickname,
        },
        headers: {"Authorization": "Bearer $token"},
      );

      log("update admin: ${response.statusCode} ${response.data}");

      if (response.statusCode == 200) {
        await fetchAdminUsers();
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      log("updateAdmin DioException: ${e.response?.data ?? e.message}");
      return false;
    } finally {
      isUpdatingAdmin.value = false;
    }
  }

  Future<bool> deleteAdmin(String id) async {
    final token = _token;
    if (token == null || token.isEmpty) return false;

    print('URLLll: ${ApiConstants.deleteAdmin}/$id');
    try {
      isDeletingAdmin.value = true;

      final response = await _apiService.deleteRequest(
        "${ApiConstants.deleteAdmin}/$id",
        headers: {"Authorization": "Bearer $token"},
      );

      log("delete admin: ${response.statusCode} ${response.data}");

      if (response.statusCode == 200) {
        await fetchAdminUsers();
        return true;
      } else {
        log("Error delete admin: ${response.statusCode} ${response.data}");
        return false;
      }
    } on DioException catch (e) {
      log("delete DioException: ${e.response?.data ?? e.message}");
      return false;
    } finally {
      isDeletingAdmin.value = false;
    }
  }

}