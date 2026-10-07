
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;

import '../Model/Billing_Model.dart';
import '../Model/Challan_Model.dart';
import '../Model/View_Bill_Model.dart';
import '../Model/Companies_Model.dart';
import '../View/Common/Get_storage_data.dart';
import '../View/Common/Toast.dart';
import '../View/Constant/Api_Constants.dart';
import '../View/Constant/Api_Service.dart';
import '../View/Utills/Global.dart';

class CompanyReportController extends GetxController{
  final ApiService _apiService = ApiService();
  RxList<CompanyModel> company = <CompanyModel>[].obs;
  RxList<BillingDate> billingDates = <BillingDate>[].obs;
  final ScrollController scrollController = ScrollController();

  RxBool isLoading = false.obs;
  RxBool isBillLoading = false.obs;
  RxBool isMoreLoading = false.obs;
  RxBool hasMore = true.obs;

  int currentPage = 1;
  static const int limit = 25;
  static const double loadMoreThreshold = 200;
  RxnString selectedCompany = RxnString();
  RxList<ChallanReport> viewBill = <ChallanReport>[].obs;
  RxList<ChallanData> challan = <ChallanData>[].obs;
  RxBool isViewBillLoading = false.obs;
  RxBool isChallanLoading = false.obs;
  int index = 0;
  RxDouble grandTotal = 0.0.obs;
  RxBool isDownloading = false.obs;

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
          "page": currentPage,
          "limit": limit,
          "isActive": true
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

            getBillingDates(company.first.id!);

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
        log("Error fetching company: ${response.statusCode}");
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

  Future<void> getBillingDates(String companyId) async {
    final token = _token;
    if (token == null || token.isEmpty) return;

    try {
      if (currentPage == 1) {
        isBillLoading.value = true;
      } else {
        isMoreLoading.value = true;
      }

      final response = await _apiService.getRequest(
        ApiConstants.billing,
        queryParams: {
          "companyId": companyId,
          "page": currentPage,
          "limit": limit
        },
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {

        BillingDatesModel model = BillingDatesModel.fromJson(response.data);

        if (model.data != null && model.data!.isNotEmpty) {

          billingDates.addAll(model.data!);

          if (model.data!.length < limit) {
            hasMore.value = false;
          } else {
            currentPage++;
          }

        } else {
          hasMore.value = false;
        }
      }else{
        log("Error fetching billing data: ${response.statusCode}");
        hasMore.value = false;
      }
    } catch (e) {
      log("Billing Date Error: $e");
    } finally {
      isBillLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  void selectCompany(String companyId) {
    selectedCompany.value = companyId;

    billingDates.clear();
    currentPage = 1;
    hasMore.value = true;

    getBillingDates(companyId);
  }

  Future<void> getViewByDate(String date) async {
    final token = _token;
    if (token == null || token.isEmpty) return;

    try {

      isViewBillLoading.value = true;

      final response = await _apiService.getRequest(
        ApiConstants.viewBill,
        queryParams: {
          "date": date
        },
        headers: {
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 200) {

        ViewBillResponseModel model = ViewBillResponseModel.fromJson(response.data);
        viewBill.clear();

        if (model.data?.report != null) {
          viewBill.addAll(model.data!.report!);
        }
        grandTotal.value = model.data?.grandTotal?.toDouble() ?? 0.0;
      }else{
        log("Error fetching billing data by date: ${response.statusCode}");
      }

    } catch (e) {
      log("Challan API Error: $e");
    } finally {
      isViewBillLoading.value = false;
    }
  }

  Future<void> getChallanByDate(String date) async {
    final token = _token;
    if (token == null || token.isEmpty) return;

    try {

      isChallanLoading.value = true;

      final response = await _apiService.getRequest(
        ApiConstants.challan,
        queryParams: {
          "date": date
        },
        headers: {
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 200) {

        ChallanResponseModel model = ChallanResponseModel.fromJson(response.data);
        challan.clear();

        if (model.data != null) {
          challan.addAll(model.data!);
        }
      }else{
        log("Error fetching challan: ${response.statusCode}");
      }

    } catch (e) {
      log("getChallanByDate API Error: $e");
    } finally {
      isChallanLoading.value = false;
    }
  }

  Future<void> downloadBill(String date) async {
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
        ApiConstants.viewBillExcel,
        queryParams: {
          "date": date,
        },
        headers: {
          "Authorization": "Bearer $token",
        },
        responseType: ResponseType.bytes,
      );

      if (response.statusCode == 200) {

        String filePath = "/storage/emulated/0/Download/bill_$date.xlsx";

        File file = File(filePath);

        await file.writeAsBytes(response.data);

        ToastWidget.showToastCustom(
          "Bill downloaded in Download folder",
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

  Future<void> downloadChallan(String date) async {
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
        ApiConstants.challanBill,
        queryParams: {
          "date": date,
        },
        headers: {
          "Authorization": "Bearer $token",
        },
        responseType: ResponseType.bytes,
      );

      if (response.statusCode == 200) {

        String filePath = "/storage/emulated/0/Download/Challan_$date.xlsx";

        File file = File(filePath);

        await file.writeAsBytes(response.data);

        ToastWidget.showToastCustom(
          "Bill downloaded in Download folder",
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