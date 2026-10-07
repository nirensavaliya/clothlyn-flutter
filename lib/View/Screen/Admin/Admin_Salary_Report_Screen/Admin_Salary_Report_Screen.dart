import 'package:clothlyn/Controller/Admin_Salary_Report_Controller.dart';
import 'package:clothlyn/Model/Admin_Salary_Report_Model.dart';
import 'package:clothlyn/View/Widget/Custom_Spin_Loader.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../Constant/App_Colors.dart';
import '../../../Constant/App_Font.dart';
import '../../../Utills/Global.dart';
import '../../../Widget/Custom_Add_Salary_Paid_Dialog.dart';

class AdminSalaryReportScreen extends StatelessWidget {
  AdminSalaryReportScreen({super.key});

  final AdminSalaryReportController adminSalaryReportController =
      Get.put(AdminSalaryReportController());

  @override
  Widget build(BuildContext context) {
    return SalaryReportListBody(
      controller: adminSalaryReportController,
      onFilter: () => salaryMasterFilterDialog(context),
      onDownload: adminSalaryReportController.downloadSalaryExcel,
    );
  }

  void salaryMasterFilterDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.bgCream,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: 'Status',
                style: TextStyle(
                  fontFamily: FontFamily.hanKenMedium,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF616161),
                ),
              ),
            ),
            Gap(8),
            Obx(() {
              final uniqueStatuses = adminSalaryReportController.salaryReport
                  .map((e) => e.model ?? '')
                  .toSet()
                  .toList();

              return DropdownMenu<String>(
                width: double.infinity,
                hintText: 'Select status',
                initialSelection:
                    adminSalaryReportController.selectStatus.value,
                onSelected: (value) {
                  adminSalaryReportController.selectStatus.value = value;
                  adminSalaryReportController.filterEmployeesByStatus(value);
                },
                textStyle: TextStyle(
                  fontFamily: FontFamily.hanKenMedium,
                  fontSize: 15,
                  color: Colors.black,
                ),
                menuStyle: MenuStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  minimumSize: MaterialStateProperty.all(
                    const Size(500, 0),
                  ),
                  maximumSize: MaterialStateProperty.all(
                    const Size(300, 400),
                  ),
                ),
                inputDecorationTheme: InputDecorationTheme(
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.floatingBtnColor, width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: adminSalaryReportController
                                  .selectStatus.value !=
                              null
                          ? AppColors.floatingBtnColor
                          : Colors.grey,
                      width: 1.5,
                    ),
                  ),
                ),
                dropdownMenuEntries: uniqueStatuses.map((e) {
                  final isSelected =
                      e == adminSalaryReportController.selectStatus.value;

                  return DropdownMenuEntry<String>(
                    value: e ?? '',
                    label: e ?? '',
                    style: ButtonStyle(
                      textStyle: MaterialStateProperty.all(
                        TextStyle(
                          fontFamily: FontFamily.hanKenMedium,
                          fontSize: 15,
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => isSelected
                            ? AppColors.accentBrown
                            : Colors.transparent,
                      ),
                      foregroundColor: MaterialStateProperty.resolveWith(
                        (states) =>
                            isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
            Gap(15),
            RichText(
              text: TextSpan(
                text: 'Employee',
                style: TextStyle(
                  fontFamily: FontFamily.hanKenMedium,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF616161),
                ),
              ),
            ),
            Gap(8),
            Obx(() {
              return DropdownMenu<String>(
                width: double.infinity,
                hintText: 'Select employee',
                enabled:
                    adminSalaryReportController.filteredEmployees.isNotEmpty,
                initialSelection: adminSalaryReportController
                    .salaryMasterEmployeeSelected.value,
                onSelected: (value) {
                  adminSalaryReportController
                      .salaryMasterEmployeeSelected.value = value;
                },
                textStyle: TextStyle(
                  fontFamily: FontFamily.hanKenMedium,
                  fontSize: 15,
                  color: Colors.black,
                ),
                menuStyle: MenuStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  minimumSize: MaterialStateProperty.all(
                    const Size(500, 0),
                  ),
                  maximumSize: MaterialStateProperty.all(
                    const Size(300, 400),
                  ),
                ),
                inputDecorationTheme: InputDecorationTheme(
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.floatingBtnColor, width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: adminSalaryReportController
                                  .salaryMasterEmployeeSelected.value !=
                              null
                          ? AppColors.floatingBtnColor
                          : Colors.grey,
                      width: 1.5,
                    ),
                  ),
                ),
                dropdownMenuEntries:
                    adminSalaryReportController.filteredEmployees.map((e) {
                  final isSelected = e.employeeName ==
                      adminSalaryReportController
                          .salaryMasterEmployeeSelected.value;

                  return DropdownMenuEntry<String>(
                    value: '${e.id}' ?? '',
                    label: '${e.nickname}' ?? '',
                    style: ButtonStyle(
                      textStyle: MaterialStateProperty.all(
                        TextStyle(
                          fontFamily: FontFamily.hanKenMedium,
                          fontSize: 15,
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => isSelected
                            ? AppColors.accentBrown
                            : Colors.transparent,
                      ),
                      foregroundColor: MaterialStateProperty.resolveWith(
                        (states) =>
                            isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
            Gap(15),
            RichText(
              text: TextSpan(
                text: 'D.No.',
                style: TextStyle(
                  fontFamily: FontFamily.hanKenMedium,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF616161),
                ),
              ),
            ),
            Gap(8),
            Obx(
              () => DropdownMenu<String>(
                width: double.infinity,
                hintText: 'Select D.No',
                initialSelection: adminSalaryReportController.selectDNo.value,
                onSelected: (value) {
                  adminSalaryReportController.selectDNo.value = value;
                },
                textStyle: TextStyle(
                  fontFamily: FontFamily.hanKenMedium,
                  fontSize: 15,
                  color: Colors.black,
                ),
                menuStyle: MenuStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  minimumSize: MaterialStateProperty.all(
                    const Size(500, 0),
                  ),
                  maximumSize: MaterialStateProperty.all(
                    const Size(300, 400),
                  ),
                ),
                inputDecorationTheme: InputDecorationTheme(
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.floatingBtnColor, width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: adminSalaryReportController.selectDNo.value !=
                              null
                          ? AppColors.floatingBtnColor
                          : Colors.grey,
                      width: 1.5,
                    ),
                  ),
                ),
                dropdownMenuEntries: adminSalaryReportController.design.map((e) {
                  final isSelected = e.designNumber ==
                      adminSalaryReportController.selectDNo.value;

                  return DropdownMenuEntry<String>(
                    value: '${e.designNumber}' ?? '',
                    label: '${e.designNumber}' ?? '',
                    style: ButtonStyle(
                      textStyle: MaterialStateProperty.all(
                        TextStyle(
                          fontFamily: FontFamily.hanKenMedium,
                          fontSize: 15,
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => isSelected
                            ? AppColors.accentBrown
                            : Colors.transparent,
                      ),
                      foregroundColor: MaterialStateProperty.resolveWith(
                        (states) =>
                            isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Gap(15),
            Row(
              children: [
                Expanded(
                  child: dateField(
                    'Start Date',
                    context,
                    adminSalaryReportController.startDateController,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: dateField(
                    'End Date',
                    context,
                    adminSalaryReportController.endDateController,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              adminSalaryReportController.salaryMasterEmployeeSelected.value =
                  '';
              adminSalaryReportController.selectStatus.value = '';
              adminSalaryReportController.selectDNo.value = '';
              adminSalaryReportController.endDateController.text = '';
              adminSalaryReportController.startDateController.text = '';
              adminSalaryReportController.filteredSalaryReport.value =
                  adminSalaryReportController.salaryReport.toList();

              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              'Clear',
              style: TextStyle(
                fontFamily: FontFamily.hanKenMedium,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
          Obx(() {
            final isLoading =
                adminSalaryReportController.isEmployeeLoading.value;
            return Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          await adminSalaryReportController.fetchEmployeesByStatus(
                            status: adminSalaryReportController
                                    .selectStatus.value ??
                                '',
                            employeeId: adminSalaryReportController
                                .salaryMasterEmployeeSelected.value,
                            isRefresh: true,
                            dNo: adminSalaryReportController.selectDNo.value,
                          );
                          adminSalaryReportController.filteredSalaryReport
                              .value = adminSalaryReportController.salaryReport
                              .where((item) {
                            final statusMatch = item.model ==
                                adminSalaryReportController.selectStatus.value;
                            final employeeMatch = adminSalaryReportController
                                        .salaryMasterEmployeeSelected.value ==
                                    null ||
                                item.user?.id ==
                                    adminSalaryReportController
                                        .salaryMasterEmployeeSelected.value;
                            final dNoMatch = adminSalaryReportController
                                        .selectDNo.value ==
                                    null ||
                                item.dNo ==
                                    adminSalaryReportController.selectDNo.value;

                            return statusMatch && employeeMatch && dNoMatch;
                          }).toList();
                          Get.back();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.appBtnColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                  child: Text(
                    isLoading ? 'Applying...' : 'Apply',
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
                          backgroundColor: AppColors.appBtnColor,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const SizedBox(),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class SalaryReportListBody extends StatelessWidget {
  final AdminSalaryReportController controller;
  final VoidCallback onFilter;
  final VoidCallback onDownload;

  const SalaryReportListBody({
    super.key,
    required this.controller,
    required this.onFilter,
    required this.onDownload,
  });

  static const Color _navy = Color(0xFF1A2B4A);
  // static const Color _muted = Color(0xFF6B7280);
  static const Color _netPayGreen = Color(0xFF1B7A3D);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Salary Report',
                      style: TextStyle(
                        fontFamily: FontFamily.hanKenBold,
                        fontSize: 28,
                        color: _navy,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onFilter,
                    icon: const Icon(Icons.filter_alt_outlined, color: _navy),
                    tooltip: 'Filter',
                  ),
                  IconButton(
                    onPressed: onDownload,
                    icon: const Icon(Icons.file_download_outlined, color: _navy),
                    tooltip: 'Download',
                  ),
                ],
              ),
              Text(
                'Track employee production, pricing and net salary details.',
                style: TextStyle(
                  fontFamily: FontFamily.hanKenRegular,
                  fontSize: 14,
                  color: AppColors.textColor,
                ),
              ),
              const Gap(14),
              Obx(() {
                final list = controller.filteredSalaryReport;
                final totalNet = list.fold<double>(
                  0,
                  (sum, item) => sum + (item.netAmount ?? 0),
                );

                return Row(
                  children: [
                    Expanded(
                      child: _SummaryCard(
                        label: 'Records',
                        value: '${list.length}',
                        icon: Icons.receipt_long_outlined,
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                      child: _SummaryCard(
                        label: 'Total Net Pay',
                        value: totalNet.toStringAsFixed(2),
                        icon: Icons.payments_outlined,
                        valueColor: _netPayGreen,
                      ),
                    ),
                  ],
                );
              }),
              const Gap(14),
              Expanded(
                child: Obx(() {
                  if (controller.isReportLoading.value) {
                    return Center(
                      child: const CustomSpinLoader(),
                    );
                  }

                  if (controller.salaryReport.isEmpty ||
                      controller.filteredSalaryReport.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.assignment_outlined,
                            size: 48,
                            color: AppColors.hintTextColor.withValues(alpha: 0.5),
                          ),
                          const Gap(12),
                          Text(
                            'Salary Report Not Found.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: FontFamily.hanKenMedium,
                              color: AppColors.hintTextColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final list = controller.filteredSalaryReport;

                  return RefreshIndicator(
                    color: AppColors.accentBrown,
                    onRefresh: controller.loadSalaryFirstPage,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 140),
                      itemCount: list.length +
                          (controller.hasMoreReport.value ? 1 : 0),
                      itemBuilder: (_, index) {
                        if (index >= list.length) {
                          if (!controller.isReportMoreLoading.value &&
                              !controller.isReportLoading.value) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              controller.loadSalaryNextPage();
                            });
                          }
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Center(
                              child: CustomSpinLoader(size: 28, boxed: false),
                            ),
                          );
                        }

                        return SalaryReportCard(item: list[index]);
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        Obx(() {
          if (!controller.isDownloading.value) {
            return const SizedBox();
          }

          return Container(
            color: Colors.black.withValues(alpha: 0.3),
            child: Center(
              child: const CustomSpinLoader(size: 60),
            ),
          );
        }),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFCFC5B9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFE8DCC8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: AppColors.accentBrown),
          ),
          const Gap(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: FontFamily.hanKenRegular,
                    fontSize: 12,
                    color: AppColors.hintTextColor,
                  ),
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: FontFamily.hanKenBold,
                    fontSize: 16,
                    color: valueColor ?? const Color(0xFF1A2B4A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SalaryReportCard extends StatelessWidget {
  final RcData item;

  const SalaryReportCard({super.key, required this.item});

  // static const Color _borderBrown = Color(0xFF6A5C44);
  static const Color _netPayGreen = Color(0xFF1B7A3D);
  static const Color _pillBg = Color(0xFFEEE8DF);
  static const Color _statBg = Color(0xFFF7F4F0);

  String get _employeeName {
    final first = (item.user?.firstName ?? '').trim();
    final nick = (item.user?.nickname ?? '').trim();
    if (first.isNotEmpty) return first;
    if (nick.isNotEmpty) return nick;
    return '-';
  }

  String get _employeeCode {
    final code = (item.user?.employeeName ?? '').trim();
    return code.isEmpty ? '-' : code;
  }

  String get _detailLine {
    final parts = <String>[
      if ((item.dNo ?? '').trim().isNotEmpty) item.dNo!.trim(),
      if ((item.lotNo ?? '').trim().isNotEmpty) 'Lot ${item.lotNo!.trim()}',
      if ((item.role ?? '').trim().isNotEmpty) item.role!.trim(),
    ];
    return parts.isEmpty ? '-' : parts.join('   ·   ');
  }

  @override
  Widget build(BuildContext context) {
    final date = apiToUiDate(item.createdAt.toString());
    final process = (item.model ?? '-').trim().toUpperCase();
    final netPay = (item.netAmount ?? 0).toStringAsFixed(3);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.ringOuterColor, width: 1.7),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: _employeeName,
                          style: TextStyle(
                            fontFamily: FontFamily.hanKenBold,
                            fontSize: 16,
                            color: AppColors.textColor,
                          ),
                        ),
                        TextSpan(
                          text: '  ·  $_employeeCode',
                          style: TextStyle(
                            fontFamily: FontFamily.hanKenMedium,
                            fontSize: 14,
                            color: AppColors.textColor,
                          ),
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _pillBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    process.isEmpty ? '-' : process,
                    style: TextStyle(
                      fontFamily: FontFamily.hanKenBold,
                      fontSize: 12,
                      letterSpacing: 0.3,
                      color: AppColors.ringOuterColor,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(10),
            Text(
              _detailLine,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: FontFamily.hanKenMedium,
                fontSize: 14,
                color: AppColors.textColor,
              ),
            ),
            const Gap(10),
            const Divider(height: 2, color: Color(0xFFF1EEEA)),
            const Gap(10),
            Row(
              children: [
                Expanded(
                  child: _statChip(
                    label: 'Price',
                    value: '${item.price ?? 0}',
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: _statChip(
                    label: 'RC Pic',
                    value: '${item.rcPic ?? 0}',
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: _statChip(
                    label: 'Alter',
                    value: '${item.alter ?? 0}',
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: _statChip(
                    label: 'Reject',
                    value: '${item.reject ?? 0}',
                  ),
                ),
              ],
            ),
            const Gap(10),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: AppColors.textColor,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '$date  ·  Pcs ${item.pic ?? '-'}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: FontFamily.hanKenRegular,
                      fontSize: 13,
                      color: AppColors.textColor,
                    ),
                  ),
                ),
                Text(
                  '₹ $netPay',
                  style: TextStyle(
                    fontFamily: FontFamily.hanKenBold,
                    fontSize: 15,
                    color: _netPayGreen,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statChip({required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: _statBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: FontFamily.hanKenRegular,
              fontSize: 11,
              color: AppColors.hintTextColor,
            ),
          ),
          const Gap(2),
          Text(
            value,
            style: TextStyle(
              fontFamily: FontFamily.hanKenSemiBold,
              fontSize: 13,
              color: AppColors.textColor,
            ),
          ),
        ],
      ),
    );
  }
}
