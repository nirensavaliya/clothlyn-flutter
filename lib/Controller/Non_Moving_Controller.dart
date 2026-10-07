import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../Model/Non_Moving_Model.dart';
import '../View/Common/Get_storage_data.dart';
import '../View/Common/Toast.dart';
import '../View/Constant/Api_Constants.dart';
import '../View/Constant/Api_Service.dart';
import '../View/Utills/Global.dart';

class NonMovingController extends GetxController{
  final ApiService _apiService = ApiService();
  final ScrollController scrollController = ScrollController();

  RxBool isLoading = false.obs;
  RxBool isMoreLoading = false.obs;
  RxBool hasMore = true.obs;
  RxList<NonMovingModel> nonMoving = <NonMovingModel>[].obs;

  int currentPage = 1;
  static const int limit = 25;
  static const double loadMoreThreshold = 200;

  RxBool isDownloading = false.obs;


  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    loadNonMoveFirstPage();
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;

    final max = scrollController.position.maxScrollExtent;
    final current = scrollController.position.pixels;

    if (max - current < loadMoreThreshold) {
      loadNonMoveNextPage();
    }
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }

  String? get _token => GetStorageData.readString(GetStorageData.token);


  Future<void> loadNonMoveFirstPage() async {
    final token = _token;
    if (token == null || token.isEmpty) return;
    await fetchNonMoving(isRefresh: true, token: token);

  }

  Future<void> loadNonMoveNextPage() async {
    final token = _token;
    if (token == null || token.isEmpty) return;
    if (!hasMore.value || isMoreLoading.value || isLoading.value) return;
    await fetchNonMoving(isRefresh: false, token: token);
  }


  Future<void> fetchNonMoving({
    required bool isRefresh,
    required String token,
  }) async {
    if (isRefresh) {
      currentPage = 1;
      hasMore.value = true;
      nonMoving.clear();
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
        ApiConstants.nonMovingItem,
        queryParams: {
          "page": currentPage,
          "limit": limit,
          "sortDirection": "asc"
        },
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final json = response.data;
        final list = json['data'] as List?;
        final pagination = json['pagination'];

        if (list != null && list.isNotEmpty) {
          final List<NonMovingModel> fetched =
          list.map((e) => NonMovingModel.fromJson(e as Map<String, dynamic>)).toList();
          nonMoving.addAll(fetched);

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
    _loadMoreIfListIsShort();
  }

  /// API sends total/page/limit, not `pages`. 5139 / 25 = 206 pages.
  bool _hasMorePages(
    Map<String, dynamic>? pagination,
    Map<String, dynamic> root,
    int fetchedCount,
  ) {
    final source = pagination ?? root;
    final int page = (source['page'] as num?)?.toInt() ??
        (root['page'] as num?)?.toInt() ??
        currentPage;
    final int? pagesField = (source['pages'] as num?)?.toInt() ??
        (root['pages'] as num?)?.toInt();
    if (pagesField != null && pagesField > 0) {
      return page < pagesField;
    }

    final int total = (source['total'] as num?)?.toInt() ??
        (root['total'] as num?)?.toInt() ??
        0;
    final int pageLimit = (source['limit'] as num?)?.toInt() ??
        (root['limit'] as num?)?.toInt() ??
        limit;
    if (total > 0 && pageLimit > 0) {
      return page < (total / pageLimit).ceil();
    }
    return fetchedCount >= limit;
  }

  /// If the first pages don't fill the screen, keep loading so scroll can start.
  void _loadMoreIfListIsShort() {
    if (!hasMore.value) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;
      if (scrollController.position.maxScrollExtent < loadMoreThreshold) {
        loadNonMoveNextPage();
      }
    });
  }

  Future<void> downloadNonMoveExcel() async {

    final token = _token;
    if (token == null || token.isEmpty) return;

    try {
      isDownloading.value = true;

      final response = await _apiService.getRequest(
        ApiConstants.nonMovingItem,
        queryParams: {
          "sortDirection": "asc",
          "isExcel": true,
        },
        headers: {
          "Authorization": "Bearer $token",
        },
        responseType: ResponseType.bytes,
      );

      if (response.statusCode == 200) {
        String year = DateFormat('yyyy').format(DateTime.now());
        String fileName = "Non_Moving_Item$year.xlsx";

        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/$fileName');
        await tempFile.writeAsBytes(response.data);

        final result = await MediaStore().saveFile(
          tempFilePath: tempFile.path,

          relativePath: "Download/$fileName",
          dirType: DirType.download,
          dirName: DirName.download,
        );

        print("Saved at: $result");

        ToastWidget.showToastCustom(
          "Non Moving downloaded in Download folder",
          color: Colors.green,
        );

      } else {
        ToastWidget.showToastCustom(
          "Download Failed",
          color: Colors.red,
        );
      }

    } catch (e) {
      ToastWidget.showToastCustom(
        "Something went wrong",
        color: Colors.red,
      );
    } finally {
      isDownloading.value = false;
    }
  }

  Future<void> downloadNonMovePdf() async {
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
        ApiConstants.nonMovingItem,
        queryParams: {
          "isPDF": true,
          "sortDirection": "asc",
        },
        headers: {
          "Authorization": "Bearer $token",
        },
        responseType: ResponseType.bytes,
      );

      if (response.statusCode == 200) {
        String year = DateFormat('yyyy').format(DateTime.now());
        String fileName = "Non_Moving_Item$year.pdf";


        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/$fileName');
        await tempFile.writeAsBytes(response.data);

        final result = await MediaStore().saveFile(
          tempFilePath: tempFile.path,

          relativePath: "Download/$fileName",
          dirType: DirType.download,
          dirName: DirName.download,
        );
        print("Saved at: $result");

        ToastWidget.showToastCustom(
          "PDF downloaded Successfully ",
          color: Colors.green,
        );

      } else {
        ToastWidget.showToastCustom(
          "Download Failed",
          color: Colors.red,
        );
      }

    } catch (e) {
      ToastWidget.showToastCustom(
        "Something went wrong",
        color: Colors.red,
      );
    } finally {
      isDownloading.value = false;
    }
  }


}