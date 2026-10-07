import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../Model/Admin_Salary_Report_Model.dart';
import '../Model/Design_Model.dart';
import '../Model/Employee_list_Model.dart';
import '../View/Common/Get_storage_data.dart';
import '../View/Constant/Api_Constants.dart';
import '../View/Constant/Api_Service.dart';

class AdminHomeController extends GetxController {
  final ApiService _apiService = ApiService();

  RxList<EmployeeModel> employees = <EmployeeModel>[].obs;
  RxList<DesignModel> design = <DesignModel>[].obs;
  RxList<RcData> salaryReport = <RcData>[].obs;

  RxBool isLoading = false.obs;
  RxBool isDesign = false.obs;
  RxBool isReport = false.obs;
  RxBool isPics = false.obs;
  RxInt totalEmployees = 0.obs;
  RxInt totalDesigns = 0.obs;
  RxInt totalRecords = 0.obs;
  RxInt totalPicInSystem = 0.obs;

  RxInt selectedIndex = 0.obs;
  RxInt selectedBottomIndex = 0.obs;
  RxBool isMemberExpanded = false.obs;
  RxBool isAlterExpanded = false.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
  void toggleMember() {
    isMemberExpanded.value = !isMemberExpanded.value;
  }

  void toggleAlter() {
    isAlterExpanded.value = !isAlterExpanded.value;
  }

  void changeTab(int index) {
    selectedBottomIndex.value = index;
  }

  String getTitle(int i) {
    switch (i) {
      case 0: return 'Product';
      case 1: return 'Scan';
      default: return 'Salary Report';
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchEmployees();
    fetchProcessReport();
    fetchDesign();
    fetchDashboardStats();
  }

  String? get _token => GetStorageData.readString(GetStorageData.token);

  Future<void> fetchEmployees() async {
    employees.clear();
    isLoading.value = true;

    try {
      final response = await _apiService.getRequest(
        ApiConstants.employees,
        queryParams: {
          "limit": 1000,
        },
        headers: {"Authorization": "Bearer $_token"},
      );

      if (response.statusCode == 200) {
        final json = response.data;
        final list = json['data'] as List?;
        final pagination = json['pagination'];

        if (pagination != null) {
          totalEmployees.value = pagination['total'] ?? 0;
        }

        if (list != null && list.isNotEmpty) {
          final List<EmployeeModel> fetched =
          list.map((e) => EmployeeModel.fromJson(e as Map<String, dynamic>)).toList();

          employees.value = fetched;
        }
      } else {
        print("API Error: ${response.statusCode}");
      }
    } on DioException catch (e) {
      print("Error fetching employees: ${e.response?.data ?? e.message}");
    } catch (e) {
      print("Unexpected Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDesign() async {
    design.clear();
    // isDesign.value = true;

    // try {
      final response = await _apiService.getRequest(
        ApiConstants.getAllDesign,
        queryParams: {
          "limit": 10000,
        },
        headers: {"Authorization": "Bearer $_token"},
      );

      if (response.statusCode == 200) {
        final designResponse = DesignListModel.fromJson(response.data);
        design.value = designResponse.data ?? [];

        totalDesigns.value =
            designResponse.pagination?.totalItems ?? 0;

      } else {
        print("API Error: ${response.statusCode}");
      }
    // } on DioException catch (e) {
    //   print("Error fetching design: ${e.response?.data ?? e.message}");
    // } catch (e) {
    //   print("Unexpected Error: $e");
    // } finally {
    //   // isDesign.value = false;
    // }
  }


  Future<void> fetchProcessReport() async {
    salaryReport.clear();
    isReport.value = true;

    try {
      final response = await _apiService.getRequest(
        ApiConstants.processReport,
        queryParams: {
          "limit": 10000,
        },
        headers: {"Authorization": "Bearer $_token"},
      );

      if (response.statusCode == 200) {
        final json = response.data;

        final list = json['data'] as List?;
        final pagination = json['pagination'];

        if (pagination != null) {
          totalRecords.value = pagination['total'] ?? 0;
          print("TOTAL RECORDS: ${totalRecords.value}");
        }

        if (list != null && list.isNotEmpty) {
          final List<RcData> fetched = list
              .map((e) => RcData.fromJson(e as Map<String, dynamic>))
              .toList();

          salaryReport.value = fetched;

        }
      } else {
        print("API Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isReport.value = false;
    }
  }

  Future<void> fetchDashboardStats() async {
    isPics.value = true;

    try {
      final response = await _apiService.getRequest(
       ApiConstants.dashBoardSearch,
        queryParams: {
          "page": 1,
          "limit": 25,
        },
        headers: {"Authorization": "Bearer $_token"},
      );

      if (response.statusCode == 200) {
        final json = response.data;

        final stats = json['data']['dashboardStats'];

        if (stats != null) {
          totalPicInSystem.value = stats['totalPicInSystem'] ?? 0;

          print("TOTAL PIC IN SYSTEM: ${totalPicInSystem.value}");
        }
      } else {
        print("API Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Dashboard Error: $e");
      isPics.value = false;
    }finally {
      isPics.value = false;
    }
  }

}
