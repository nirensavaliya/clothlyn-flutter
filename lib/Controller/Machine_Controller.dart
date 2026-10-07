import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../Model/Machine_Model.dart';
import '../View/Common/Get_storage_data.dart';
import '../View/Constant/Api_Constants.dart';
import '../View/Constant/Api_Service.dart';

class MachineController extends GetxController{
  final ApiService _apiService = ApiService();
  final ScrollController scrollController = ScrollController();
  final TextEditingController machineNameController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  RxList<MachineModel> machine = <MachineModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool isMoreLoading = false.obs;
  RxBool hasMore = true.obs;
  RxBool isAddMachine = false.obs;
  RxBool isUpdateMachine = false.obs;
  RxBool isDeleteMachine = false.obs;
  String? selectedMachineId;
  RxString searchText = "".obs;

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
    await fetchMachine(isRefresh: true, token: token);
  }

  Future<void> loadNextPage() async {
    final token = _token;
    if (token == null || token.isEmpty) return;
    if (!hasMore.value || isMoreLoading.value || isLoading.value) return;
    await fetchMachine(isRefresh: false, token: token);
  }

  void onSearch(String value) {
    searchText.value = value;
    loadFirstPage();
  }

  Future<void> fetchMachine({
    required bool isRefresh,
    required String token,
  }) async {
    if (isRefresh) {
      currentPage = 1;
      hasMore.value = true;
      machine.clear();
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
        ApiConstants.getAllMachine,
        queryParams: {
          "search": searchText.value.isEmpty ? null : searchText.value,
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
          final List<MachineModel> fetched =
          list.map((e) => MachineModel.fromJson(e as Map<String, dynamic>)).toList();
          machine.addAll(fetched);
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
      print("Error fetching employees: ${e.response?.data ?? e.message}");
    } catch (e) {
      hasMore.value = false;
      rethrow;
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  Future<bool> addMachine({
    required String machineName,
    required String userId,
  }) async {
    final token = _token;
    if (token == null || token.isEmpty) return false;

    try {
      isAddMachine.value = true;

      final response = await _apiService.postRequest(
        ApiConstants.addMachine,
        data: {
          "machineName": machineName,
          "userId": userId,
        },
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {

        final machineData = response.data['data'];
        await fetchMachine(isRefresh: true, token: token);
       /* if (machineData != null) {
          machine.insert(0, MachineModel.fromJson(machineData));
        }*/
        return true;
      } else {
        log("Failed to add machine: ${response.statusCode} ${response.data}");
        return false;
      }
    } on DioException catch (e) {
      log("addMachine DioException: ${e.response?.data ?? e.message}");
      return false;
    } catch (e) {
      log("addMachine Unknown error: $e");
      return false;
    } finally {
      isAddMachine.value = false;
    }
  }

  Future<bool> editMachine({
    required String machineId,
    required String machineName,
    required String userId,
  }) async {
    final token = _token;
    if (token == null || token.isEmpty) return false;

    try {
      isUpdateMachine.value = true;

      final response = await _apiService.patchRequest(
        "${ApiConstants.addMachine}/$machineId",
        data: {
          "machineName": machineName,
          "userId": userId,
        },
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        await fetchMachine(isRefresh: true, token: token);

      /*  final index = machine.indexWhere((e) => e.id == machineId);

        if (index != -1) {
          machine[index] = MachineModel.fromJson(response.data['data']);
          machine.refresh();
        }*/
        return true;
      } else {
        log("Error editMachine: ${response.statusCode} ${response.data}");
        return false;
      }

    } on DioException catch (e) {
      log("editMachine DioException: ${e.response?.data ?? e.message}");
      isUpdateMachine.value = false;
      return false;
    } finally {
      isUpdateMachine.value = false;
    }
  }

  Future<bool> deleteMachine(String id) async {
    final token = _token;
    if (token == null || token.isEmpty) return false;

    print('URLLll: ${ApiConstants.deleteAdmin}/$id');
    try {
      isDeleteMachine.value = true;

      final response = await _apiService.deleteRequest(
        "${ApiConstants.deleteMachine}/$id",
        headers: {"Authorization": "Bearer $token"},
      );

      log("delete machine: ${response.statusCode} ${response.data}");

      if (response.statusCode == 200) {
        await fetchMachine(isRefresh: true, token: token);
        return true;
      } else {
        log("Error delete machine: ${response.statusCode} ${response.data}");
        return false;
      }
    } on DioException catch (e) {
      log("deleteMachine DioException: ${e.response?.data ?? e.message}");
      isDeleteMachine.value = false;
      return false;
    } finally {
      isDeleteMachine.value = false;
    }
  }

}