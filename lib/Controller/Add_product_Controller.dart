import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../Model/Product_Model.dart';
import '../View/Common/Get_storage_data.dart';
import '../View/Common/Toast.dart';
import '../View/Constant/Api_Constants.dart';
import '../View/Constant/Api_Service.dart';
import '../View/Utills/Global.dart';

class AddProductController extends GetxController {

  final ApiService _apiService = ApiService();
  RxList<ProductItem> productReport = <ProductItem>[].obs;
  final ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();

  RxBool isAddingAdmin = false.obs;
  RxBool isUpdatingAdmin = false.obs;
  RxBool isDeleteDesignLoading = false.obs;
  RxBool isDownloading = false.obs;
  RxBool isBarcodePdfDownloading = false.obs;
  RxBool isLoading = false.obs;
  RxBool isProduct = false.obs;
  RxBool isMoreLoading = false.obs;
  RxBool hasMore = true.obs;
  RxnString selectedStatus = RxnString();
  /// Dynamic status options from GET /api/processes (label + API value)
  RxList<MapEntry<String, String>> statusOptions = <MapEntry<String, String>>[].obs;

  int currentPage = 1;
  static const int limit = 25;
  static const double loadMoreThreshold = 100;

  String? get _token => GetStorageData.readString(GetStorageData.token);

  final formKey = GlobalKey<FormState>();

  final dateController = TextEditingController();
  final lotNoController = TextEditingController();
  final dNoController = TextEditingController();
  final colorController = TextEditingController();
  final sizeController = TextEditingController();
  final layerController = TextEditingController();
  final masterController = TextEditingController();
  final picController = TextEditingController();
  RxString searchText = "".obs;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    loadStatusOptions();
    loadFirstPage();
  }

  /// Build Lots status filter from process master (dynamic).
  Future<void> loadStatusOptions() async {
    final token = _token;
    if (token == null || token.isEmpty) return;

    try {
      final response = await _apiService.getRequest(
        ApiConstants.getAllProcess,
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode != 200) return;

      final data = response.data['data'];
      if (data is! List) return;

      final options = <MapEntry<String, String>>[];

      for (final e in data) {
        if (e is! Map) continue;
        final name = (e['processName'] ?? '').toString().trim();
        if (name.isEmpty) continue;
        final key = name.toLowerCase();

        if (key == 'loading') {
          options.add(const MapEntry('Unloading', 'unloading'));
          options.add(const MapEntry('Loading', 'loading'));
        } else if (key == 'doracut' || key == 'dora cut') {
          options.add(const MapEntry('Doracut', 'doracut'));
          options.add(const MapEntry('Doracut Received', 'doracut received'));
        } else {
          final label = name
              .split(RegExp(r'\s+'))
              .map((w) => w.isEmpty
                  ? w
                  : '${w[0].toUpperCase()}${w.substring(1)}')
              .join(' ');
          options.add(MapEntry(label, key.replaceAll(' ', '')));
        }
      }

      options.add(const MapEntry('Complete', 'complete'));
      statusOptions.assignAll(options);
    } catch (_) {}
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;

    final max = scrollController.position.maxScrollExtent;
    final current = scrollController.position.pixels;

    if (max - current < loadMoreThreshold) {
      loadNextPage();
    }
  }

  void onSearch(String value) {
    searchText.value = value;
    loadFirstPage();
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

      final response = await _apiService.getRequest(
        ApiConstants.getAllProduct,
        queryParams: {
          // "search": searchText.value.isEmpty ? null : searchText.value,
          "page": currentPage,
          "limit": limit,
          if (selectedStatus.value != null &&
              selectedStatus.value!.isNotEmpty)
            "status": selectedStatus.value,
        },
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final json = response.data;

        final data = json['data'];
        final List list = data['records'] ?? [];
        final pagination = data['pagination'];

        if (list.isNotEmpty) {
          final fetched = list
              .map((e) => ProductItem.fromJson(e))
              .toList();

          productReport.addAll(fetched);

          /// ✅ Pagination (correct way)
          if (pagination != null) {
            final int page = pagination['page'] ?? currentPage;
            final int pages = pagination['pages'] ?? 1;
            hasMore.value = page < pages;
            currentPage++;
          } else {
            hasMore.value = fetched.length >= limit;
            currentPage++;
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


  /// ADD PRODUCT METHOD
  Future<bool> addProduct() async {
    final token = _token;
    if (token == null) return false;
    // if (!formKey.currentState!.validate()) {
    //   return;
    // }

    isAddingAdmin.value = true;

    try {
      /// API CALL (example payload)
      final payload = {
        "date": dateController.text,
        "lotNo": lotNoController.text,
        "designNumber": dNoController.text,
        "color": colorController.text,
        "size": sizeController.text,
        "layer": layerController.text,
        "master": masterController.text,
        "pic": picController.text,
      };
      final response = await _apiService.postRequest(
        ApiConstants.productLot,
        data: payload,
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        loadFirstPage();
        return true;
      } else {
        ToastWidget.showToastCustom(
          "Failed to add product",
          color: Colors.red,
        );
        return false;
      }
    }  catch (e) {
      print("Add Product Error: $e");
      ToastWidget.showToastCustom(
        e.toString(),
        color: Colors.red,
      );
      return false;
    } finally {
      isAddingAdmin.value = false;
    }
  }

  Future<bool> updateProduct({
    required String id,
    required String date,
    required String lotNo,
    required String dNo,
    required String color,
    required String size,
    required String layer,
    required String master,
    required String pic,
  }) async {
    final token = _token;
    if (token == null || token.isEmpty) return false;

    try {
      isUpdatingAdmin.value = true;

      final response = await _apiService.putRequest(
        "${ApiConstants.productLot}/$id",
        data: {
          "date": date,
          "lotNo": lotNo,
          "designNumber": dNo,
          "color": color,
          "size": size,
          "layer": layer,
          "master": master,
          "pic": pic,
        },
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        await loadFirstPage();
        return true;
      } else {
        log("Error updating product: ${response.statusCode} ${response.data}");
        return false;
      }

    } on DioException catch (e) {
      log("DioException: ${e.response?.data ?? e.message}");
      isUpdatingAdmin.value = false;
      return false;
    } finally {
      isUpdatingAdmin.value = false;
    }
  }

  Future<bool> deleteProduct(String id) async {

    final token = _token;
    if (token == null || token.isEmpty) return false;

    try {
      isDeleteDesignLoading.value = true;

      final response = await _apiService.deleteRequest(
        "${ApiConstants.productLot}/$id",
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      log("delete product: ${response.statusCode} ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 204) {
        /// refresh list
        await loadFirstPage();
        return true;
      }
      return false;
    } on DioException catch (e) {
      log("Delete product error: ${e.response?.data ?? e.message}");
      return false;
    } catch (e) {
      log("Unknown product error: $e");
      isDeleteDesignLoading.value = false;
      return false;
    }finally{
      isDeleteDesignLoading.value = false;
    }
  }

  Future<void> downloadProductExcel() async {
    bool hasPermission = await requestStoragePermission();
    if (!hasPermission) {
      ToastWidget.showToastCustom(
        "Storage permission denied",
        color: Colors.red,
      );
      return;
    }
    final token = _token;
    if (token == null || token.isEmpty) return;

    try {
      isDownloading.value = true;

      final response = await _apiService.getRequest(
        ApiConstants.getAllProduct,
        queryParams: {
          "isExcel": true,
        },
        headers: {
          "Authorization": "Bearer $token",
        },
        responseType: ResponseType.bytes,
      );

      if (response.statusCode == 200) {
        String year = DateFormat('yyyy').format(DateTime.now());
        String fileName = "Product_Report_$year.xlsx";

        final dir = await getApplicationDocumentsDirectory();
        final tempFile = File('${dir.path}/$fileName');
        await tempFile.writeAsBytes(response.data);

        final result = await MediaStore().saveFile(
          tempFilePath: tempFile.path,

          relativePath: fileName,
          dirType: DirType.download,
          dirName: DirName.download,
        );

        print("Saved at: $result");

        ToastWidget.showToastCustom(
          "Product Report downloaded in Downloads",
          color: Colors.green,
        );

      } else {
        ToastWidget.showToastCustom(
          "Download Failed",
          color: Colors.red,
        );
      }

    } catch (e) {
      print("Error: $e");

      ToastWidget.showToastCustom(
        "Something went wrong",
        color: Colors.red,
      );
    } finally {
      isDownloading.value = false;
    }
  }
  //
  // Future<void> downloadProductExcel() async {
  //   bool hasPermission = await requestStoragePermission();
  //
  //   if (!hasPermission) {
  //     ToastWidget.showToastCustom(
  //       "Storage permission denied",
  //       color: Colors.red,
  //     );
  //     return;
  //   }
  //
  //   final token = _token;
  //   if (token == null || token.isEmpty) return;
  //
  //   try {
  //     isDownloading.value = true;
  //
  //     final response = await _apiService.getRequest(
  //       ApiConstants.getAllProduct,
  //       queryParams: {
  //         "isExcel": true,
  //       },
  //       headers: {
  //         "Authorization": "Bearer $token",
  //       },
  //       responseType: ResponseType.bytes,
  //     );
  //
  //     if (response.statusCode == 200) {
  //       String year = DateFormat('yyyy').format(DateTime.now());
  //
  //       String filePath = "/storage/emulated/0/Download/Product_Report.$year.xlsx";
  //
  //       File file = File(filePath);
  //
  //       await file.writeAsBytes(response.data);
  //
  //       ToastWidget.showToastCustom(
  //         "Product Report downloaded in Download folder",
  //         color: Colors.green,
  //       );
  //
  //     } else {
  //       ToastWidget.showToastCustom(
  //         "Download Failed",
  //         color: Colors.red,
  //       );
  //     }
  //
  //   } catch (e) {
  //     ToastWidget.showToastCustom(
  //       "Something went wrong",
  //       color: Colors.red,
  //     );
  //   } finally {
  //     isDownloading.value = false;
  //   }
  // }


  RxnString selected = RxnString();

  @override
  void onClose() {
    dateController.dispose();
    lotNoController.dispose();
    dNoController.dispose();
    colorController.dispose();
    sizeController.dispose();
    layerController.dispose();
    masterController.dispose();
    picController.dispose();
    super.onClose();
  }
}
