import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import '../Model/Salary_Report_Model.dart';
import '../View/Common/Get_storage_data.dart';
import '../View/Common/Toast.dart';
import '../View/Constant/Api_Constants.dart';
import '../View/Constant/Api_Service.dart';
import '../View/Utills/Global.dart';

class SalaryReportController extends GetxController {
  final ApiService _apiService = ApiService();

  final nameCtrl = TextEditingController();
  final codeCtrl = TextEditingController();
  final roleCtrl = TextEditingController();

  RxList<SalaryData> salaryReport = <SalaryData>[].obs;
  Rx<SalaryReportModel?> salaryResponse = Rx<SalaryReportModel?>(null);
  RxList<SalaryData> filteredSalaryReport = <SalaryData>[].obs;

  RxBool isLoading = false.obs;
  RxBool isFilterLoading = false.obs;
  RxBool isMoreLoading = false.obs;
  RxBool hasMore = true.obs;
  int currentPage = 1;
  static const int limit = 25;

  RxBool isDownloading = false.obs;
  RxnString employeeSelected = RxnString();
  RxnString selectDNo = RxnString();
  RxnString selectLotNo = RxnString();
  RxnString selectPic = RxnString();

  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  String? get _token => GetStorageData.readString(GetStorageData.token);

  String? getUserId() {
    final loginDataString =
    GetStorageData.readString(GetStorageData.loginData);

    if (loginDataString == null || loginDataString.isEmpty) return null;

    final Map<String, dynamic> jsonData = jsonDecode(loginDataString);

    return jsonData['_id'];
  }

  Future<void> loadFirstPage() async {
    final token = _token;
    final userId = getUserId();

    if (token == null || token.isEmpty) return;
    // await fetchEmployees(isRefresh: true, token: token);
    await fetchProcessReports(isRefresh: true, token: token, userId: userId ?? '');
    filteredSalaryReport.value = salaryReport.toList();

  }

  Future<void> loadNextPage() async {
    final token = _token;
    final userId = getUserId();

    if (token == null || token.isEmpty) return;
    if (!hasMore.value || isMoreLoading.value || isLoading.value) return;
    await fetchProcessReports(isRefresh: false, token: token, userId: userId ?? '');
  }

  Future<void> fetchProcessReports({
    required bool isRefresh,
    required String token,
    required String userId,
  }) async {
    if (isRefresh) {
      currentPage = 1;
      hasMore.value = true;
      salaryReport.clear();
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
        ApiConstants.salaryReport,
        queryParams: {
          "page": currentPage,
          "limit": limit,
          "userId": userId,
        },
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      print("PROCESS REPORT RESPONSE: ${response.data}");

      if (response.statusCode == 200) {
        final model = SalaryReportModel.fromJson(response.data);

        salaryResponse.value = model;
        final list = model.data;
        final pagination = model.pagination;

        if (list != null && list.isNotEmpty) {
          // final fetched = list
          //     .map((e) => SalaryData.fromJson(e))
          //     .toList();

          salaryReport.addAll(list);
        }

        if (pagination != null) {
          final int page = pagination.page ?? currentPage;
          final int totalPages = pagination.totalPages ?? 1;

          hasMore.value = page < totalPages;
        } else {
          hasMore.value = (list?.length ?? 0) >= limit;
        }

        currentPage++;
      } else {
        hasMore.value = false;
      }
    } catch (e) {
      hasMore.value = false;
      print("Error: $e");
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  Future<void> applyFilterApi() async {
    final token = _token;
    final userId = getUserId();

    if (token == null || token.isEmpty) return;

    try {
      isFilterLoading.value = true;

      final response = await _apiService.getRequest(
        ApiConstants.salaryReport,
        queryParams: {
          "page": 1,
          "limit": limit,
          "userId": userId,

          if (employeeSelected.value?.isNotEmpty ?? false)
            "employeeName": employeeSelected.value,

          if (selectLotNo.value?.isNotEmpty ?? false)
            "lotNo": selectLotNo.value,

          if (selectDNo.value?.isNotEmpty ?? false)
            "dNo": selectDNo.value,

          if (selectPic.value?.isNotEmpty ?? false)
            "pic": selectPic.value,

          if (startDateController.text.isNotEmpty)
            "startDate": startDateController.text,

          if (endDateController.text.isNotEmpty)
            "endDate": endDateController.text,
        },
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final model = SalaryReportModel.fromJson(response.data);

        salaryResponse.value = model;

        filteredSalaryReport.clear();
        filteredSalaryReport.assignAll(model.data ?? []);

        hasMore.value = false;
      } else {
        filteredSalaryReport.clear();
      }
    } catch (e) {
      print("Filter Error: $e");
    } finally {
      isFilterLoading.value = false;
    }
  }

  Future<void> downloadSalaryPdf() async {
    final pdf = pw.Document();

    final jostRegular = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Jost-Medium.ttf'),
    );

    final jostBold = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Jost-Bold.ttf'),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Text(
            'Salary Report',
            style: pw.TextStyle(
              font: jostBold,
              fontSize: 22,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 20),

          // pw.Table.fromTextArray(
          //   border: pw.TableBorder.all(),
          //   headerStyle: pw.TextStyle(
          //     font: jostBold,
          //     fontWeight: pw.FontWeight.bold,
          //   ),
          //   cellStyle: pw.TextStyle(
          //     font: jostRegular,
          //   ),
          //   headers: [
          //     "D.No",
          //     "Lot No",
          //     "Role",
          //     "Code",
          //     "Price",
          //     "Net Payable",
          //     "PIC",
          //   ],
          //   data: salaryData.map((item) {
          //     return [
          //       item["dNo"].toString(),
          //       item["lotNo"],
          //       item["role"],
          //       item["code"],
          //       "₹${item["price"]}",
          //       "₹${item["netPayable"]}",
          //       item["pic"],
          //     ];
          //   }).toList(),
          // ),
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/salary_report.pdf");
    await file.writeAsBytes(await pdf.save());

    await Printing.layoutPdf(
      usePrinterSettings: false,
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
    Get.snackbar("Success", "PDF downloaded successfully");
  }

  Future<void> downloadSalaryReport() async {
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
    final userId = getUserId();

    try {
      isDownloading.value = true;

      final response = await _apiService.getRequest(
        ApiConstants.salaryReport,
        queryParams: {
          "userId": userId,

          if (employeeSelected.value?.isNotEmpty ?? false)
            "employeeName": employeeSelected.value,

          if (selectLotNo.value?.isNotEmpty ?? false)
            "lotNo": selectLotNo.value,

          if (selectDNo.value?.isNotEmpty ?? false)
            "dNo": selectDNo.value,

          if (selectPic.value?.isNotEmpty ?? false)
            "pic": selectPic.value,

          if (startDateController.text.isNotEmpty)
            "startDate": startDateController.text,

          if (endDateController.text.isNotEmpty)
            "endDate": endDateController.text,
        },
        headers: {
          "Authorization": "Bearer $token",
        },
        responseType: ResponseType.bytes,
      );

      if (response.statusCode == 200) {
        String year = DateFormat('yyyy').format(DateTime.now());

        String filePath = "/storage/emulated/0/Download/bill_$year.pdf";
        File file = File(filePath);

        await file.writeAsBytes(response.data);

        ToastWidget.showToastCustom(
          "Salary report downloaded in Download folder",
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

  Future<void> downloadSalaryReportExcel() async {
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
    final userId = getUserId();

    try {
      isDownloading.value = true;

      final response = await _apiService.getRequest(
        ApiConstants.salaryReport,
        queryParams: {
          "userId": userId,

          if (employeeSelected.value?.isNotEmpty ?? false)
            "employeeName": employeeSelected.value,

          if (selectLotNo.value?.isNotEmpty ?? false)
            "lotNo": selectLotNo.value,

          if (selectDNo.value?.isNotEmpty ?? false)
            "dNo": selectDNo.value,

          if (selectPic.value?.isNotEmpty ?? false)
            "pic": selectPic.value,

          if (startDateController.text.isNotEmpty)
            "startDate": startDateController.text,

          if (endDateController.text.isNotEmpty)
            "endDate": endDateController.text,
          "isExcel": true
        },
        headers: {
          "Authorization": "Bearer $token",
        },
        responseType: ResponseType.bytes,
      );

      if (response.statusCode == 200) {
        String year = DateFormat('yyyy').format(DateTime.now());

        String filePath = "/storage/emulated/0/Download/bill_$year.xlsx";
        File file = File(filePath);

        await file.writeAsBytes(response.data);

        ToastWidget.showToastCustom(
          "Salary report downloaded in Download folder",
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


  @override
  void onInit() {
    loadFirstPage();
    super.onInit();
  }

  void clearFilter() {
    nameCtrl.clear();
    codeCtrl.clear();
    roleCtrl.clear();
    Get.back();
  }



}