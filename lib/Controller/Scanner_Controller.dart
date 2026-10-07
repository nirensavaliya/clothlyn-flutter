import 'dart:convert';

import 'package:clothlyn/View/Constant/App_Font.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../Model/Scann_Model.dart';
import '../View/Common/Get_storage_data.dart';
import '../View/Common/Toast.dart';
import '../View/Constant/Api_Constants.dart';
import '../View/Constant/Api_Service.dart';
import '../View/Constant/App_Colors.dart';
import '../View/Utills/Global.dart';
import '../View/Widget/Custom_TextField.dart';

class ScanUserController extends GetxController {
  final ApiService _apiService = ApiService();

  final lotNoController = TextEditingController();
  final colorController = TextEditingController();
  final sizeController = TextEditingController();
  final picController = TextEditingController();
  bool isScanned = false;
  MobileScannerController? scannerController;
  RxBool isLoading = false.obs;
  RxBool isFetchingDetails = false.obs;
  RxBool isUpdating = false.obs;
  RxList<ScannData> scanData = <ScannData>[].obs;
  Rxn<ScannData> selectedProcess = Rxn<ScannData>();
  String? scannedLookupKey;
  String? dashboardDataId;
  String? currentLotNo;
  String? currentDesignNumber;
  String? nextDesignProcess;
  String? currentDesignStatus;
  String? latestProcessRecordId;
  String? primaryEmployeeId;
  final RxnString selectedEmployeeId = RxnString();
  final List<Map<String, dynamic>> employees = [];

  void setSelectedProcess(ScannData process) {
    selectedProcess.value = process;
  }

  Future<void> initScanner() async {
    await disposeScannerSafely();
    scannerController = MobileScannerController(
      autoStart: true,
      facing: CameraFacing.back,
      detectionSpeed: DetectionSpeed.normal,
    );
  }

  String _extractLookupKey(String rawValue) {
    final value = rawValue.trim();
    if (value.startsWith('{') && value.endsWith('}')) {
      try {
        final parsed = jsonDecode(value);
        if (parsed is Map<String, dynamic>) {
          final key = parsed['lookupKey'] ??
              parsed['lotNo'] ??
              parsed['id'] ??
              parsed['_id'];
          if (key != null && key.toString().trim().isNotEmpty) {
            return key.toString().trim();
          }
        }
      } catch (_) {}
    }
    return value;
  }

  Future<void> loadUserFromScan(String scanValue) async {
    if (isScanned) return;
    if (selectedProcess.value == null) {
      ToastWidget.showToastCustom("Please select process first", color: Colors.red);
      return;
    }

    isScanned = true;
    scannedLookupKey = _extractLookupKey(scanValue);
    print('scannedLookupKey-----${scannedLookupKey}');
    await getDashboardByLookupKey(scannedLookupKey ?? "");
  }

  @override
  void onInit() {
    super.onInit();
    getScan();
  }

  String? get _token => GetStorageData.readString(GetStorageData.token);

  Future<void> openEditDialog() async {
    await Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.bgCream,
        insetPadding: const EdgeInsets.all(24),
        scrollable: true,
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              Text(
                "Edit item Details",
                style: TextStyle(
                  color: AppColors.accentBrown,
                    fontFamily: FontFamily.hanKenBold,
                    fontSize: 18),
              ),
              const Spacer(),
              InkWell(
                onTap: () => Get.back(),
                child: const Icon(Icons.close),
              )
            ],
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _field("Lot No", lotNoController)),
                    SizedBox(width: 10,),
                    Expanded(child: _field("Color", colorController)),

                  ],
                ),
                _field("Size", sizeController),
                _field("Pic", picController,isNumber: true),
                Obx(() {
                  final bool isEmployeeListEmpty = employees.isEmpty;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: isEmployeeListEmpty
                          ? () {
                        ToastWidget.showToastCustom(
                          "No employees found",
                          color: Colors.red,
                        );
                      }
                          : null,
                      child: AbsorbPointer(
                        absorbing: isEmployeeListEmpty,
                        child: DropdownMenu<String>(
                          width: double.infinity,
                          hintText: "Select employee code",
                          initialSelection: selectedEmployeeId.value,
                          onSelected: (value) {
                            selectedEmployeeId.value = value;
                            primaryEmployeeId = value;
                          },
                          textStyle: TextStyle(
                            fontFamily: FontFamily.hanKenMedium,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                          menuStyle: MenuStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.white),
                            maximumSize: MaterialStateProperty.all(
                              const Size(300, 400),
                            ),
                          ),
                          inputDecorationTheme: InputDecorationTheme(
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  const BorderSide(color:  AppColors.floatingBtnColor, width: 1.5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: selectedEmployeeId.value != null
                                    ?  AppColors.floatingBtnColor
                                    : Colors.grey,
                                width: 1.5,
                              ),
                            ),
                          ),
                          dropdownMenuEntries: employees.map((employee) {
                            final id = (employee['_id'] ?? employee['id'] ?? '').toString();
                            final employeeName = (employee['employeeName'] ?? '').toString();
                            final firstName = (employee['firstName'] ?? '').toString();
                            final lastName = (employee['lastName'] ?? '').toString();
                            final fullName = "$employeeName $firstName $lastName".trim();

                            return DropdownMenuEntry<String>(
                              value: id,
                              label: fullName.isEmpty ? "Unknown Employee" : fullName,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Get.back(),
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.transparent,
              padding:
              const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child:  Text("Cancel",style: TextStyle(
              fontFamily: FontFamily.hanKenBold,
              fontSize: 15,
              color: Colors.black,
            ),),
          ),

          Obx(() {
            final isLoading = isUpdating.value;
            return  Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async{
                    disposeKeyboard(Get.context!);
                    await saveData();
                   },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.floatingBtnColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                  child:  Text(
                    isLoading ? "Updating..." : "Update",
                    style: TextStyle(
                      fontFamily: FontFamily.hanKenBold,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),

                isLoading
                    ? const Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(
                    minHeight: 3,
                    backgroundColor: AppColors.accentBrown,
                    valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : const SizedBox(),
              ],
            );
          }
          ),

       /*   Obx(() => ElevatedButton(
            onPressed: isUpdating.value ? null : saveData,
            child: Text(isUpdating.value ? "Updating..." : "Update"),
          ),
          ),*/
        ],
      ),
      barrierDismissible: false,
    );
    resetScan();
  }

  Widget _field(String label, TextEditingController controller,
      {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CommonTextField(
        readOnly: true,
        controller: controller,
        textInputType: isNumber ? TextInputType.number : TextInputType.text,
        title: label,
        isTitle: true,
      )

      // TextField(
      //   controller: controller,
      //   keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      //   decoration: InputDecoration(
      //     labelText: label,
      //     border: OutlineInputBorder(
      //       borderRadius: BorderRadius.circular(10),
      //     ),
      //   ),
      // ),
    );
  }

  Future<void> getDashboardByLookupKey(String lookupKey) async {
    final token = _token;
    if (token == null || token.isEmpty || lookupKey.isEmpty) {
      resetScan();
      return;
    }

    try {
      isFetchingDetails.value = true;

      final response = await _apiService.getRequest(
        "${ApiConstants.getDashboardByLookupKey}/$lookupKey",
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final raw = response.data;
        final data = raw is Map<String, dynamic> ? raw['data'] : null;
        final item = data is Map<String, dynamic> ? data : <String, dynamic>{};

        dashboardDataId = (item['_id'] ?? item['id'])?.toString();
        currentLotNo = (item['lotNo'] ?? "").toString();
        currentDesignNumber = (item['dNo'] ?? "").toString();
        lotNoController.text = currentLotNo ?? "";
        colorController.text = (item['colour'] ?? item['color'] ?? "").toString();
        sizeController.text = (item['size'] ?? "").toString();
        picController.text = (item['pic'] ?? "").toString();

        await _loadProcessContext();
        final isAllowed = _validateProcessSelection();
        if (!isAllowed) {
          final selected = selectedProcess.value?.processName ?? "-";
          final current = currentDesignStatus ?? "-";
          ToastWidget.showToastCustom(
            "Selected process '$selected' is not allowed. Current status is '$current'.",
            color: Colors.red,
          );
          resetScan();
          return;
        }

        await _loadEmployeesForSelectedProcess();
        ToastWidget.showToastCustom(
          "Scan successful for ${selectedProcess.value?.processName ?? 'process'}",
          color: Colors.green,
        );
        await openEditDialog();
      } else {
        ToastWidget.showToastCustom("Failed to load item details",color: Colors.red);
        resetScan();
      }
    } catch (e) {
      print('Error------FAILED TO LOAD ITEM DETAILS---${e}');
      resetScan();
    } finally {
      isFetchingDetails.value = false;
    }
  }

  String _normalizeProcessName(String? value) {
    return (value ?? '')
        .trim()
        .toLowerCase()
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  bool _processMatches(String? selected, String? expected) {
    final s = _normalizeProcessName(selected);
    final e = _normalizeProcessName(expected);
    if (s.isEmpty || e.isEmpty) return false;
    if (s == e) return true;

    final aliases = <String, List<String>>{
      'loading': ['thread'],
      'thread': ['loading'],
      'doracut': ['dora cut', 'single doracut', 'single dora cut'],
      'bill scan': ['bil scan', 'billscan', 'bill scans'],
      'bil scan': ['bill scan', 'billscan', 'bill scans'],
      'billscan': ['bill scan', 'bil scan', 'bill scans'],
      'bill scan multiple': ['bil scan multiple', 'bill scan multi', 'bill scans multiple'],
    };

    final selectedAliases = aliases[s] ?? const <String>[];
    final expectedAliases = aliases[e] ?? const <String>[];

    return selectedAliases.contains(e) || expectedAliases.contains(s);
  }

  Future<void> _loadProcessContext() async {
    currentDesignStatus = null;
    nextDesignProcess = null;

    final token = _token;
    final lotNo = currentLotNo;
    final dNo = currentDesignNumber;
    if (token == null || token.isEmpty || lotNo == null || lotNo.isEmpty) return;

    try {
      final statusResponse = await _apiService.getRequest(
        "designs/by-number/$lotNo/status",
        headers: {"Authorization": "Bearer $token"},
      );
      if (statusResponse.statusCode == 200) {
        final raw = statusResponse.data;
        final data = raw is Map<String, dynamic> ? raw['data'] : null;
        final map = data is Map<String, dynamic> ? data : <String, dynamic>{};
        currentDesignStatus = (map['status'] ?? map['currentStatus'] ?? "").toString();
        nextDesignProcess = (map['nextDesigneProcess'] ?? map['nextDesignProcess'] ?? "").toString();
      }
    } catch (_) {}

    if (dNo != null && dNo.isNotEmpty) {
      try {
        final designResponse = await _apiService.getRequest(
          "designs/by-number/$dNo",
          headers: {"Authorization": "Bearer $token"},
        );
        if (designResponse.statusCode == 200) {
          final raw = designResponse.data;
          final data = raw is Map<String, dynamic> ? raw['data'] : null;
          final design = data is Map<String, dynamic> ? data : <String, dynamic>{};

          if ((nextDesignProcess == null || nextDesignProcess!.isEmpty) &&
              design['nextDesigneProcess'] != null) {
            nextDesignProcess = design['nextDesigneProcess'].toString();
          }
        }
      } catch (_) {}
    }
  }

  bool _validateProcessSelection() {
    final selectedName = selectedProcess.value?.processName;
    if (selectedName == null || selectedName.trim().isEmpty) return false;

    if (currentDesignStatus != null && currentDesignStatus!.trim().isNotEmpty) {
      return _processMatches(selectedName, currentDesignStatus);
    }
    return true;
  }

  Future<void> _loadEmployeesForSelectedProcess() async {
    employees.clear();
    primaryEmployeeId = null;
    selectedEmployeeId.value = null;

    final token = _token;
    final processName = selectedProcess.value?.processName;
    if (token == null || token.isEmpty || processName == null) return;

    final normalized = _normalizeProcessName(processName);
    final endpoints = <Map<String, dynamic>>[];

    if (normalized == 'loading' || normalized == 'thread' || normalized == 'rc') {
      endpoints.add({"machineName": processName});
    } else {
      final processForQuery = normalized
          .replaceAll('single doracut', 'doracut')
          .replaceAll('single dora cut', 'doracut')
          .replaceAll('dora cut', 'doracut')
          .replaceAll('bil scan', 'billscan')
          .replaceAll('bill scan', 'billscan');
      endpoints.add({"processName": processForQuery});
    }

    for (final query in endpoints) {
      try {
        final response = await _apiService.getRequest(
          ApiConstants.employees,
          queryParams: query,
          headers: {"Authorization": "Bearer $token"},
        );

        if (response.statusCode == 200) {
          final raw = response.data;
          final data = raw is Map<String, dynamic> ? raw['data'] : null;
          final list = data is List
              ? data
              : (data is Map<String, dynamic> && data['records'] is List)
                  ? data['records'] as List
                  : <dynamic>[];

          for (final e in list) {
            if (e is Map<String, dynamic>) {
              employees.add(e);
            }
          }
        }
      } catch (_) {}
    }

    if (employees.isNotEmpty) {
      final first = employees.first;
      primaryEmployeeId = (first['_id'] ?? first['id'])?.toString();
      selectedEmployeeId.value = primaryEmployeeId;
    }
  }

  String _getProcessEndpoint(String? processName) {
    final key = (processName ?? '').trim().toLowerCase();

    switch (key) {
      case 'single doracut':
      case 'single dora cut':
      case 'doracut':
      case 'dora cut':
        return 'doracut-process';
      case 'bulk doracut':
      case 'doracut bulk':
        return 'doracut-process/bulk';
      case 'bill scan':
      case 'bil scan':
      case 'billscan':
        return 'bill-scans';
      case 'bil scan multiple':
      case 'bill scan multiple':
      case 'billscan multiple':
      case 'bill scans multiple':
        return 'bill-scans/multiple';
      default:
        // gaj battan, press, logo, packing, checking, rc, loading, …
        return ApiConstants.scanProcess;
    }
  }

  String _statusForProcess(String? processName) {
    final key = _normalizeProcessName(processName);
    switch (key) {
      case 'loading':
      case 'thread':
        return 'loading';
      case 'checking':
        return 'checking';
      case 'press':
        return 'press';
      case 'packing':
        return 'packing';
      case 'logo':
        return 'logo';
      case 'single doracut':
      case 'single dora cut':
      case 'doracut':
      case 'dora cut':
      case 'bulk doracut':
      case 'doracut bulk':
        return 'doracut';
      case 'bill scan':
      case 'bil scan':
      case 'billscan':
      case 'bil scan multiple':
      case 'bill scan multiple':
      case 'billscan multiple':
      case 'bill scans multiple':
        return 'billscan';
      case 'rc':
        return 'rc';
      default:
        return key;
    }
  }

  Future<void> _syncDesignStatus(String processName) async {
    final token = _token;
    if (token == null || token.isEmpty) return;
    final lotNo = lotNoController.text.trim();
    if (lotNo.isEmpty) return;

    final status = _statusForProcess(processName);
    final userId = GetStorageData.readString(GetStorageData.userId)?.toString();
    final next = nextDesignProcess;

    await _apiService.putRequest(
      "designs/by-number/$lotNo/status",
      data: {
        "status": status,
        "nextDesigneProcess": next,
        "userId": userId,
        "single": status == "rc" ? primaryEmployeeId : null,
        "fatlock": status == "rc" ? primaryEmployeeId : null,
        "kansai": status == "rc" ? primaryEmployeeId : null,
        "schand_ProcessId": latestProcessRecordId,
        if (status == 'loading') "employee": primaryEmployeeId,
      },
      headers: {"Authorization": "Bearer $token"},
    );
  }

  Future<void> saveData() async {
    final token = _token;
    if (token == null || token.isEmpty || selectedProcess.value == null) return;

    try {
      isUpdating.value = true;
      final processName = selectedProcess.value?.processName;
      final endpoint = _getProcessEndpoint(processName);
      final status = _statusForProcess(processName);

      final scannedByName = employees.isNotEmpty
          ? (() {
              final selected = employees.firstWhere(
                (e) => (e['_id'] ?? e['id'])?.toString() == selectedEmployeeId.value,
                orElse: () => employees.first,
              );
              final employeeName = (selected['employeeName'] ?? '').toString();
              final firstName = (selected['firstName'] ?? '').toString();
              final lastName = (selected['lastName'] ?? '').toString();
              return "$employeeName $firstName $lastName".trim();
            })()
          : '';

      final isMachineProcess =
          status == 'rc' || status == 'loading' || status == 'thread';

      final payload = <String, dynamic>{
        "processId": selectedProcess.value?.id,
        "processName": processName,
        "lookupKey": scannedLookupKey,
        "dashboardDataId": dashboardDataId,
        "lotNo": lotNoController.text.trim(),
        "color": colorController.text.trim(),
        "size": sizeController.text.trim(),
        "pic": picController.text.trim(),
        "dNo": currentDesignNumber,
        "price": 0,
        "alter": "0",
        "reject": "0",
        "employeeId": selectedEmployeeId.value ?? primaryEmployeeId,
        "status": status,
        "scannedByName": scannedByName,
        "machineEmployees": primaryEmployeeId == null
            ? []
            : [
                {
                  "employeeId": primaryEmployeeId,
                  "baseRate": 0,
                }
              ],
        if (isMachineProcess) ...{
          "single": primaryEmployeeId,
          "kansai": primaryEmployeeId,
          "fatlock": primaryEmployeeId,
        },
      };

      print('payload-----${payload}');

      final response = await _apiService.postRequest(
        endpoint,
        data: payload,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final raw = response.data;
        final data = raw is Map<String, dynamic> ? raw['data'] : null;
        final message = raw is Map<String, dynamic> ? raw['message']?.toString() : null;
        if (data is Map<String, dynamic>) {
          latestProcessRecordId = (data['_id'] ?? data['id'])?.toString();
        }
        await _syncDesignStatus(processName ?? '');
        Get.back();
        resetScan();
        ToastWidget.showToastCustom(
          message != null && message.isNotEmpty
              ? message
              : "${processName ?? 'Process'} updated successfully",
          color: Colors.green,
        );
      } else {
        ToastWidget.showToastCustom("Failed to update ${processName ?? 'process'}",color: Colors.red);
        resetScan();
      }
    } catch (e) {
      print('Error------FAILED TO UPDATE RC PROCESS---${e}');
      var errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.replaceFirst('Exception: ', '');
      }
      ToastWidget.showToastCustom(errorMessage, color: Colors.red);
      resetScan();
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> clearAndCloseScanner() async {
    await scannerController?.stop();
  }

  Future<void> disposeScannerSafely() async {
    final current = scannerController;
    if (current == null) return;

    scannerController = null;
    await Future.delayed(const Duration(milliseconds: 180));
    try {
      await current.stop();
    } catch (_) {}
    await current.dispose();
  }

  Future<void> stopScanner() async {
    await scannerController?.stop();
  }

  Future<void> getScan() async {

    final token = _token;
    if (token == null || token.isEmpty) return;

    try {

      isLoading.value = true;

      final response = await _apiService.getRequest(
        "${ApiConstants.getProcess}",
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final model = ScanProcessModel.fromJson(response.data);

        scanData.assignAll(model.data);


      }

    } catch (e) {
      print("Process API error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void resetScan() {
    isScanned = false;
  }

  @override
  void onClose() {
    lotNoController.dispose();
    colorController.dispose();
    sizeController.dispose();
    picController.dispose();
    scannerController?.dispose();
    super.onClose();
  }

  @override
  void dispose() {
    scannerController?.dispose();
    super.dispose();
  }

}
