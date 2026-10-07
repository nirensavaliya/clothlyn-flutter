import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../Model/Design_Model.dart';
import '../View/Common/Get_storage_data.dart';
import '../View/Constant/Api_Constants.dart';
import '../View/Constant/Api_Service.dart';

class DesignController extends GetxController{
  final ApiService _apiService = ApiService();
  final ScrollController scrollController = ScrollController();

  RxList<DesignModel> design = <DesignModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool isMoreLoading = false.obs;
  RxBool hasMore = true.obs;
  RxBool isAddingDesign = false.obs;
  RxBool isUpdatingDesign = false.obs;
  String? selectedDesignId;

  RxList<Map<String, dynamic>> processList = <Map<String, dynamic>>[].obs;
  RxBool isProcessLoading = false.obs;
  RxBool isUpdateRatesLoading = false.obs;
  RxBool isDeleteDesignLoading = false.obs;

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
    await fetchDesign(isRefresh: true, token: token);
  }

  Future<void> loadNextPage() async {
    final token = _token;
    if (token == null || token.isEmpty) return;
    if (!hasMore.value || isMoreLoading.value || isLoading.value) return;
    await fetchDesign(isRefresh: false, token: token);
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
        ApiConstants.getAllDesign,
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

        if (pagination != null && pagination is Map) {
          final int page = pagination['page'] ?? currentPage;
          final int pages = pagination['pages'] ?? 1;
          hasMore.value = page < pages;
        } else {
          hasMore.value = (list?.length ?? 0) >= limit;
        }
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

  Future<bool> addDesign({
    required String designNumber,
    required String userId,
    required List<Map<String, dynamic>> processes,
    String description = "",
    String status = "active",
  }) async {
    final token = _token;
    if (token == null || token.isEmpty) return false;
    try {

      isAddingDesign.value = true;

      final body = {
        "designNumber": designNumber,
        "userId": userId,
        "processes": processes,
        "description": description,
        "status": status
      };

      final response = await _apiService.postRequest(
        ApiConstants.addDesign,
        data: body,
        headers: {"Authorization": "Bearer $token"},
      );

      log("add design: ${response.statusCode} ${response.data}");


      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchDesign(isRefresh: true, token: token);
        return true;
      } else {
        log("Failed to add design: ${response.statusCode} ${response.data}");
        return false;
      }

    } on DioException catch (e) {
      log("DioException: ${e.response?.data ?? e.message}");
      return false;

    }catch (e) {
      log("addDesign Unknown error: $e");
      return false;
    } finally {
      isAddingDesign.value = false;
    }
  }

  Future<bool> updateDesign({
    required String designId,
    required String designNumber,
    required String userId,
    required List<Map<String, dynamic>> processes,
    String description = "",
    String status = "active",
  }) async {

    final token = _token;
    if (token == null || token.isEmpty) return false;

    try {

      isUpdatingDesign.value = true;

      final body = {
        "designNumber": designNumber,
        "userId": userId,
        "description": description,
        "status": status,
        "processes": processes
      };

      final response = await _apiService.putRequest(
        "${ApiConstants.updateDesign}/$designId",
        data: body,
        headers: {"Authorization": "Bearer $token"},
      );

      log("update design: ${response.statusCode} ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchDesign(isRefresh: true, token: token);
        return true;
      } else {

        log("Failed to update design: ${response.statusCode} ${response.data}");
        return false;

      }

    } on DioException catch (e) {
      log("updateDesign DioException: ${e.response?.data ?? e.message}");
      return false;
    } catch (e) {
      log("updateDesign -Unknown error: $e");
      return false;
    } finally {
      isUpdatingDesign.value = false;
    }
  }

  Future<void> getProcessesByDesign(String designId) async {

    final token = _token;
    if (token == null || token.isEmpty) return;

    try {

      isProcessLoading.value = true;

      final response = await _apiService.getRequest(
        "${ApiConstants.getProcess}/$designId",
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        processList.value = List<Map<String, dynamic>>.from(data["data"]);
      }

    } catch (e) {
      log("getProcessesByDesign API error: $e");
    } finally {
      isProcessLoading.value = false;
    }
  }

  Future<bool> updateProcessRates({
    required String designId,
    required List<Map<String, dynamic>> processes,
  }) async {

    final token = _token;
    if (token == null || token.isEmpty) return false;

    try {
      isUpdateRatesLoading.value = true;

      final response = await _apiService.putRequest(
        "designs/$designId/processes/prices",
        data: {
          "processes": processes,
        },
        headers: {
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 200) {
        await fetchDesign(isRefresh: true, token: token);

        return true;
      }
      return false;
    } catch (e) {
      log("updateProcessRates Update rates error: $e");
      isUpdateRatesLoading.value = false;
      return false;
    }finally{
      isUpdateRatesLoading.value = false;
    }
  }

  Future<bool> deleteDesign(String designId) async {

    final token = _token;
    if (token == null || token.isEmpty) return false;

    try {
      isDeleteDesignLoading.value = true;

      final response = await _apiService.deleteRequest(
        "${ApiConstants.getAllDesign}/$designId",
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      log("delete design: ${response.statusCode} ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 204) {
        /// refresh list
        await fetchDesign(isRefresh: true, token: token);
        return true;
      }
      return false;
    } on DioException catch (e) {
      log("Delete design error: ${e.response?.data ?? e.message}");
      return false;
    } catch (e) {
      log("Unknown delete error: $e");
      isDeleteDesignLoading.value = false;
      return false;
    }finally{
      isDeleteDesignLoading.value = false;
    }
  }

}